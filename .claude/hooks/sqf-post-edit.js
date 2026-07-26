#!/usr/bin/env node
/*
 * PostToolUse hook for .sqf files. Runs on Windows, macOS and Linux.
 *
 * Reads the hook payload as JSON on stdin and reports two things:
 *
 *   1. Syntax — parses the file with @bi-tools/sqf-parser. Catches unbalanced
 *      brackets and malformed structures, which otherwise only surface in-game
 *      as "Generic error in expression". Skipped silently if the parser is not
 *      installed (npm install -g @bi-tools/sqf-parser).
 *
 *   2. Registration — an .sqf under client/, server/ or shared/ that is not
 *      referenced in init.sqf / initServer.sqf never loads, and fails silently.
 *
 * Never blocks and always exits 0: it reports, it does not veto.
 */

'use strict'

const fs = require('fs')
const path = require('path')
const { loadParser, checkSyntax, checkRegistration } = require('../tools/sqf-lib')

function readStdin() {
  return new Promise((resolve) => {
    let data = ''
    process.stdin.setEncoding('utf8')
    process.stdin.on('data', (chunk) => (data += chunk))
    process.stdin.on('end', () => resolve(data))
    process.stdin.on('error', () => resolve(''))
  })
}

async function main() {
  // Strip a leading BOM: some shells (PowerShell among them) prepend one when
  // piping text into a native command's stdin, which would break JSON.parse.
  const raw = (await readStdin()).replace(/^﻿/, '')
  if (!raw.trim()) return

  let payload
  try {
    payload = JSON.parse(raw)
  } catch (_) {
    return
  }

  const file =
    (payload.tool_input && payload.tool_input.file_path) ||
    (payload.tool_response && payload.tool_response.filePath)

  if (!file || !file.endsWith('.sqf')) return

  const full = path.resolve(file)
  if (!fs.existsSync(full)) return

  const messages = []

  const parser = loadParser()
  if (parser) {
    const problem = await checkSyntax(parser, full)
    if (problem) messages.push('SQF syntax error: ' + problem)
  }

  const unregistered = checkRegistration(full)
  if (unregistered) messages.push(unregistered)

  if (messages.length === 0) return

  const message = messages.join(' | ')
  process.stdout.write(
    JSON.stringify({
      systemMessage: message,
      hookSpecificOutput: {
        hookEventName: 'PostToolUse',
        additionalContext: message,
      },
    })
  )
}

main().catch(() => {
  /* a reporting hook must never break the edit it is reporting on */
})
