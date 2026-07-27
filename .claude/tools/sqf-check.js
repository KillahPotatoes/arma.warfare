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
 * This only catches SYNTAX errors (unbalanced brackets, malformed control
 * structures). It does not know Arma's commands, so it will not catch a
 * misspelled command name, a wrong argument count, or a locality mistake, and
 * it does not flag every missing semicolon. Note also that a reported line
 * number is where the parser gave up, which may be the start of the enclosing
 * statement rather than the typo itself. Loading the mission in the Eden editor
 * is still the real test.
 */

'use strict'

const fs = require('fs')
const path = require('path')
const { REPO_ROOT, loadParser, checkSyntax } = require('./sqf-lib')

const SKIP_DIRS = new Set(['.git', '.claude', 'node_modules', 'missions', 'KPGUI'])

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
    const problem = await checkSyntax(parser, file)
    if (problem) {
      failed++
      // Diagnostics go to stdout so shells that treat stderr specially do not
      // turn a lint finding into a spurious command failure.
      console.log(problem)
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
