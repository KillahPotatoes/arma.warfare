# PostToolUse hook for .sqf files. Runs two checks and reports both:
#
#   1. Syntax — parses the file with .claude/tools/sqf-check.js. Catches missing
#      semicolons and unbalanced brackets, which otherwise only surface in-game
#      as "Generic error in expression". Skipped silently if node is unavailable.
#
#   2. Registration — an .sqf under client/, server/ or shared/ that is not
#      referenced in init.sqf / initServer.sqf never loads, and fails silently.
#
# Reads the hook payload as JSON on stdin. Never blocks; only reports.

$ErrorActionPreference = 'Stop'

try {
    $raw = [Console]::In.ReadToEnd()
    if ([string]::IsNullOrWhiteSpace($raw)) { exit 0 }

    $payload = $raw | ConvertFrom-Json
    $file = $payload.tool_input.file_path
    if (-not $file) { $file = $payload.tool_response.filePath }
    if (-not $file) { exit 0 }
    if ($file -notlike '*.sqf') { exit 0 }

    $root = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path.TrimEnd('\')
    $full = [System.IO.Path]::GetFullPath($file)
    if (-not $full.StartsWith($root, [StringComparison]::OrdinalIgnoreCase)) { exit 0 }
    if (-not (Test-Path $full)) { exit 0 }

    $rel = $full.Substring($root.Length).TrimStart('\')
    $messages = @()

    # --- 1. Syntax ------------------------------------------------------------
    $node = Get-Command node -ErrorAction SilentlyContinue
    $checker = Join-Path $root '.claude\tools\sqf-check.js'
    if ($node -and (Test-Path $checker)) {
        # No 2>&1 here: in PowerShell 5.1 redirecting a native command's stderr
        # raises NativeCommandError, which $ErrorActionPreference='Stop' turns
        # into a terminating error. sqf-check.js prints diagnostics on stdout.
        $output = & $node.Source $checker $full
        if ($LASTEXITCODE -eq 1) {
            $detail = ($output | Where-Object { $_ -notmatch '^\s*$' -and $_ -notmatch 'file\(s\) failed to parse' }) -join '; '
            $messages += "SQF syntax error in ${rel}: $detail"
        }
    }

    # --- 2. Registration ------------------------------------------------------
    if ($rel -match '^(client|server|shared)\\') {
        $registered = $false
        foreach ($name in @('init.sqf', 'initServer.sqf')) {
            $init = Join-Path $root $name
            if (Test-Path $init) {
                $text = Get-Content $init -Raw
                if ($text -and $text.Contains($rel)) { $registered = $true; break }
            }
        }

        if (-not $registered) {
            $where = if ($rel -like 'server\*') {
                'initServer.sqf'
            } elseif ($rel -like 'client\*') {
                'init.sqf'
            } else {
                'BOTH init.sqf and initServer.sqf'
            }
            $messages += "$rel is not registered in $where - it will never load. Add: [] call compileFinal preprocessFileLineNumbers ""$rel"";"
        }
    }

    if ($messages.Count -eq 0) { exit 0 }

    $msg = $messages -join ' | '
    $out = @{
        systemMessage = $msg
        hookSpecificOutput = @{
            hookEventName = 'PostToolUse'
            additionalContext = $msg
        }
    }
    $out | ConvertTo-Json -Compress -Depth 5
    exit 0
}
catch {
    exit 0
}
