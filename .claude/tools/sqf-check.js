#!/usr/bin/env node
/*
 * SQF syntax checker for arma.warfare.
 *
 *   node .claude/tools/sqf-check.js                 # check every .sqf in the mission
 *   node .claude/tools/sqf-check.js path/to/a.sqf   # check specific files
 *
 * Exits 1 if any file fails to parse, 0 otherwise. Requires the parser:
 *   npm install -g @bi-tools/sqf-parser
 *
 * This only catches SYNTAX errors (missing semicolons, unbalanced brackets,
 * malformed control structures). It does not know Arma's commands, so it will
 * not catch a misspelled command name, a wrong argument count, or a locality
 * mistake. Loading the mission in the Eden editor is still the real test.
 */

'use strict'

const fs = require('fs')
const path = require('path')
const { execFileSync } = require('child_process')

const REPO_ROOT = path.resolve(__dirname, '..', '..')
const SKIP_DIRS = new Set(['.git', '.claude', 'node_modules', 'missions', 'KPGUI'])

function loadParser() {
  const PKG = path.join('@bi-tools', 'sqf-parser')
  const nodeDir = path.dirname(process.execPath)

  const candidates = [
    PKG,                                                    // local install / NODE_PATH
    path.join(nodeDir, 'node_modules', PKG),                // global, Windows layout
    path.join(nodeDir, '..', 'lib', 'node_modules', PKG),   // global, POSIX layout
  ]

  for (const candidate of candidates) {
    try {
      return require(candidate)
    } catch (_) {
      /* try the next one */
    }
  }

  // Last resort: ask npm. Needs a shell on Windows, where npm is a .cmd.
  try {
    const npm = process.platform === 'win32' ? 'npm.cmd' : 'npm'
    const globalRoot = execFileSync(npm, ['root', '-g'], {
      encoding: 'utf8',
      shell: process.platform === 'win32',
    }).trim()
    return require(path.join(globalRoot, PKG))
  } catch (_) {
    return null
  }
}

function collect(dir, out) {
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    if (entry.isDirectory()) {
      if (SKIP_DIRS.has(entry.name)) continue
      collect(path.join(dir, entry.name), out)
    } else if (entry.name.endsWith('.sqf')) {
      out.push(path.join(dir, entry.name))
    }
  }
  return out
}

function lineOf(source, offset) {
  if (offset == null) return null
  return source.slice(0, offset).split('\n').length
}

async function main() {
  const parser = loadParser()
  if (!parser) {
    console.error('sqf-check: @bi-tools/sqf-parser not found. Install it with:')
    console.error('  npm install -g @bi-tools/sqf-parser')
    process.exit(2)
  }

  const args = process.argv.slice(2)
  const files = args.length
    ? args.map((f) => path.resolve(f)).filter((f) => f.endsWith('.sqf') && fs.existsSync(f))
    : collect(REPO_ROOT, [])

  let failed = 0
  for (const file of files) {
    // The tokenizer rejects a UTF-8 BOM as an unexpected character, so strip it.
    const source = fs.readFileSync(file, 'utf8').replace(/^﻿/, '')
    try {
      // parseSqf is async — it must be awaited or every file trivially "passes".
      await parser.parseSqf(source)
    } catch (err) {
      failed++
      const offset = err.token && err.token.position ? err.token.position.from : null
      const line = lineOf(source, offset)
      const where = path.relative(REPO_ROOT, file) + (line ? ':' + line : '')
      // Diagnostics go to stdout, not stderr: the hook that consumes this runs
      // under PowerShell, where redirecting a native command's stderr turns each
      // line into a terminating error.
      console.log(`${where}  ${err.message}`)
    }
  }

  if (failed > 0) {
    console.log(`sqf-check: ${failed} of ${files.length} file(s) failed to parse.`)
    process.exit(1)
  }

  if (!args.length) console.log(`sqf-check: ${files.length} file(s) OK.`)
  process.exit(0)
}

main().catch((err) => {
  console.error('sqf-check: ' + err.message)
  process.exit(2)
})
