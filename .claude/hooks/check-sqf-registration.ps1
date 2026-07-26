# PostToolUse hook: warn when an .sqf under client/, server/ or shared/ is not
# registered in init.sqf / initServer.sqf. An unregistered script never loads and
# fails silently, so this is the repo's most expensive silent mistake.
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

    $rel = $full.Substring($root.Length).TrimStart('\')

    # Only scripts in the three loadable trees need registration.
    if ($rel -notmatch '^(client|server|shared)\\') { exit 0 }

    $initFiles = @('init.sqf', 'initServer.sqf') |
        ForEach-Object { Join-Path $root $_ } |
        Where-Object { Test-Path $_ }

    $needle = $rel  # e.g. client\ui\my_script.sqf
    foreach ($init in $initFiles) {
        $text = Get-Content $init -Raw
        if ($text -and $text.Contains($needle)) { exit 0 }
    }

    $where = if ($rel -like 'server\*') {
        'initServer.sqf'
    } elseif ($rel -like 'client\*') {
        'init.sqf'
    } else {
        'BOTH init.sqf and initServer.sqf'
    }

    $msg = "$rel is not registered in $where - it will never load. Add: [] call compileFinal preprocessFileLineNumbers ""$rel"";"

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
