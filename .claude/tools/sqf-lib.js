/*
 * Shared helpers for the SQF tooling in .claude/.
 *
 * Used by tools/sqf-check.js (the CLI) and hooks/sqf-post-edit.js (the
 * PostToolUse hook) so the parser lookup and the registration rule live in
 * exactly one place.
 */

'use strict'

const fs = require('fs')
const path = require('path')
const { execFileSync } = require('child_process')

const REPO_ROOT = path.resolve(__dirname, '..', '..')
const LOADABLE_DIRS = ['client', 'server', 'shared']
const INIT_FILES = ['init.sqf', 'initServer.sqf']

/**
 * Locate @bi-tools/sqf-parser, whether it is installed locally or globally,
 * on Windows or POSIX. Returns null when it cannot be found.
 */
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

/** Read a .sqf, stripping the UTF-8 BOM that the tokenizer rejects. */
function readSource(file) {
  return fs.readFileSync(file, 'utf8').replace(/^﻿/, '')
}

function lineOf(source, offset) {
  if (offset == null) return null
  return source.slice(0, offset).split('\n').length
}

/**
 * Parse one file. Resolves to null when it is valid, or to a
 * "relative/path.sqf:LINE  message" string when it is not.
 */
async function checkSyntax(parser, file) {
  const source = readSource(file)
  try {
    // parseSqf is async — it must be awaited or every file trivially "passes".
    await parser.parseSqf(source)
    return null
  } catch (err) {
    const offset = err.token && err.token.position ? err.token.position.from : null
    const line = lineOf(source, offset)
    return toRelative(file) + (line ? ':' + line : '') + '  ' + err.message
  }
}

/** Repo-relative path using backslashes, matching how init files spell them. */
function toRelative(file) {
  return path.relative(REPO_ROOT, path.resolve(file)).split(path.sep).join('\\')
}

/**
 * A script under client/, server/ or shared/ does nothing until it is
 * registered in an init file. Returns a warning string, or null when fine.
 */
function checkRegistration(file) {
  const rel = toRelative(file)
  const top = rel.split('\\')[0]
  if (!LOADABLE_DIRS.includes(top)) return null

  for (const name of INIT_FILES) {
    const init = path.join(REPO_ROOT, name)
    if (!fs.existsSync(init)) continue
    if (fs.readFileSync(init, 'utf8').includes(rel)) return null
  }

  const where =
    top === 'server' ? 'initServer.sqf'
    : top === 'client' ? 'init.sqf'
    : 'BOTH init.sqf and initServer.sqf'

  return `${rel} is not registered in ${where} - it will never load. ` +
    `Add: [] call compileFinal preprocessFileLineNumbers "${rel}";`
}

module.exports = {
  REPO_ROOT,
  loadParser,
  readSource,
  checkSyntax,
  checkRegistration,
  toRelative,
}
