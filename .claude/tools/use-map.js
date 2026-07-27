#!/usr/bin/env node
/*
 * Switch the mission to a chosen map and link it into the Arma profile so it
 * can be launched.
 *
 *   node .claude/tools/use-map.js                # list maps and show current state
 *   node .claude/tools/use-map.js altis          # switch to Altis
 *   node .claude/tools/use-map.js altis --sp     # link into missions/ (Eden) instead of mpmissions/
 *   node .claude/tools/use-map.js altis --launch # switch, then start Arma 3
 *
 * What it does:
 *   1. syntax-checks every .sqf (refuses to switch if the mission is broken)
 *   2. copies missions/<map>/mission.sqm over the root mission.sqm
 *   3. links the repo into the Arma profile as arma.warfare.<WorldClass>
 *
 * The root mission.sqm is a scratch working copy — it is gitignored precisely
 * so it can be swapped per map like this.
 *
 * Override the profile location with ARMA3_PROFILE_DIR if it is not in the
 * default place (OneDrive-redirected Documents, a Proton prefix, etc).
 */

'use strict'

const fs = require('fs')
const os = require('os')
const path = require('path')
const { spawn, spawnSync } = require('child_process')

const { REPO_ROOT, loadParser, checkSyntax } = require('./sqf-lib')

const MISSIONS_DIR = path.join(REPO_ROOT, 'missions')
const WORLDS_FILE = path.join(__dirname, 'map-worlds.json')
const MISSION_PREFIX = 'arma.warfare'
const SKIP_DIRS = new Set(['.git', '.claude', 'node_modules', 'missions', 'KPGUI'])

function listMaps() {
  return fs
    .readdirSync(MISSIONS_DIR, { withFileTypes: true })
    .filter((e) => e.isDirectory() && fs.existsSync(path.join(MISSIONS_DIR, e.name, 'mission.sqm')))
    .map((e) => e.name)
    .sort((a, b) => a.toLowerCase().localeCompare(b.toLowerCase()))
}

/**
 * Resolve a map folder to its Arma world class.
 *  - "small.Enoch"  -> Enoch      (the folder already says so; certain)
 *  - a table entry  -> that value
 *  - anything else  -> the folder name, flagged as a guess
 */
function resolveWorld(map) {
  if (map.includes('.')) {
    return { world: map.slice(map.lastIndexOf('.') + 1), source: 'folder suffix', mod: null }
  }

  let table = {}
  try {
    table = JSON.parse(fs.readFileSync(WORLDS_FILE, 'utf8'))
  } catch (_) {
    /* fall through to the guess */
  }

  const entry = table[map]
  if (entry && entry.world) {
    return {
      world: entry.world,
      source: entry.confirmed === false ? 'map-worlds.json (unconfirmed)' : 'map-worlds.json',
      mod: entry.mod || null,
    }
  }

  return { world: map, source: 'guessed from folder name', mod: null }
}

function profileDir() {
  const candidates = [
    process.env.ARMA3_PROFILE_DIR,
    path.join(os.homedir(), 'Documents', 'Arma 3'),
    path.join(os.homedir(), 'OneDrive', 'Documents', 'Arma 3'),
  ].filter(Boolean)

  for (const dir of candidates) {
    if (fs.existsSync(dir)) return dir
  }
  return null
}

function collectSqf(dir, out) {
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    if (entry.isDirectory()) {
      if (SKIP_DIRS.has(entry.name)) continue
      collectSqf(path.join(dir, entry.name), out)
    } else if (entry.name.endsWith('.sqf')) {
      out.push(path.join(dir, entry.name))
    }
  }
  return out
}

async function syntaxGate() {
  const parser = loadParser()
  if (!parser) {
    console.log('!  @bi-tools/sqf-parser not installed — skipping the syntax check.')
    console.log('   npm install -g @bi-tools/sqf-parser')
    return true
  }

  const problems = []
  for (const file of collectSqf(REPO_ROOT, [])) {
    const problem = await checkSyntax(parser, file)
    if (problem) problems.push(problem)
  }

  if (problems.length === 0) return true

  console.log(`x  ${problems.length} file(s) failed to parse — fix before testing:\n`)
  for (const p of problems) console.log('   ' + p)
  return false
}

/** Create a junction (Windows) or directory symlink (POSIX). No admin needed. */
function ensureLink(linkPath) {
  if (fs.existsSync(linkPath)) {
    let target = null
    try {
      target = fs.readlinkSync(linkPath)
    } catch (_) {
      /* a real directory, not a link */
    }
    if (target && path.resolve(target) === path.resolve(REPO_ROOT)) return 'already linked'
    return target ? 'points elsewhere: ' + target : 'exists as a real directory — not touching it'
  }

  fs.mkdirSync(path.dirname(linkPath), { recursive: true })
  fs.symlinkSync(REPO_ROOT, linkPath, process.platform === 'win32' ? 'junction' : 'dir')
  return 'created'
}

function findGameExe() {
  const guesses = [
    'C:/Program Files (x86)/Steam/steamapps/common/Arma 3/arma3_x64.exe',
    'C:/Program Files/Steam/steamapps/common/Arma 3/arma3_x64.exe',
  ]
  return guesses.find((p) => fs.existsSync(p)) || null
}

function currentMap() {
  const root = path.join(REPO_ROOT, 'mission.sqm')
  if (!fs.existsSync(root)) return null
  const rootBuf = fs.readFileSync(root)
  for (const map of listMaps()) {
    const candidate = path.join(MISSIONS_DIR, map, 'mission.sqm')
    try {
      if (rootBuf.equals(fs.readFileSync(candidate))) return map
    } catch (_) {
      /* ignore */
    }
  }
  return null
}

async function main() {
  const args = process.argv.slice(2)
  const flags = new Set(args.filter((a) => a.startsWith('--')))
  const map = args.find((a) => !a.startsWith('--'))
  const maps = listMaps()

  if (!map) {
    const active = currentMap()
    console.log('Maps available under missions/:\n')
    for (const m of maps) {
      const { world, mod } = resolveWorld(m)
      const marker = m === active ? '*' : ' '
      console.log(`  ${marker} ${m.padEnd(24)} -> .${world}${mod ? '   [' + mod + ']' : ''}`)
    }
    console.log(active ? `\n* = currently in the root mission.sqm` : '\nRoot mission.sqm matches no map folder.')
    console.log('\nUsage: node .claude/tools/use-map.js <map> [--sp] [--launch]')
    return
  }

  if (!maps.includes(map)) {
    const near = maps.filter((m) => m.toLowerCase().includes(map.toLowerCase()))
    console.log(`x  Unknown map "${map}".`)
    if (near.length) console.log('   Did you mean: ' + near.join(', '))
    else console.log('   Available: ' + maps.join(', '))
    process.exitCode = 1
    return
  }

  if (!(await syntaxGate())) {
    process.exitCode = 1
    return
  }

  // 1. Swap the layout in.
  const src = path.join(MISSIONS_DIR, map, 'mission.sqm')
  const dest = path.join(REPO_ROOT, 'mission.sqm')
  fs.copyFileSync(src, dest)
  console.log(`ok  mission.sqm  <- missions/${map}/mission.sqm`)

  // 2. Link it into the Arma profile.
  const { world, source, mod } = resolveWorld(map)
  const profile = profileDir()
  const folder = `${MISSION_PREFIX}.${world}`

  if (!profile) {
    console.log('!  Arma 3 profile directory not found.')
    console.log('   Set ARMA3_PROFILE_DIR to it, then re-run. Expected something like:')
    console.log('   ' + path.join(os.homedir(), 'Documents', 'Arma 3'))
    return
  }

  const subdir = flags.has('--sp') ? 'missions' : 'mpmissions'
  const linkPath = path.join(profile, subdir, folder)
  const status = ensureLink(linkPath)
  console.log(`ok  ${subdir}/${folder}  (${status})`)
  console.log(`    world class "${world}" — ${source}`)
  if (mod) console.log(`    needs mod: ${mod}`)

  if (source.startsWith('guessed') || source.includes('unconfirmed')) {
    console.log('    if the mission does not appear in-game, the world class is wrong;')
    console.log('    correct it in .claude/tools/map-worlds.json')
  }

  // 3. Launch, or explain how.
  if (flags.has('--launch')) {
    const exe = findGameExe()
    if (!exe) {
      console.log('!  Could not find arma3_x64.exe — launch from Steam instead.')
      return
    }
    console.log('\n-> launching Arma 3 with -showScriptErrors')
    spawn(exe, ['-showScriptErrors', '-noPause', '-world=empty'], { detached: true, stdio: 'ignore' }).unref()
  } else {
    console.log('\nNext: launch Arma 3 (add -showScriptErrors), then')
    console.log(flags.has('--sp')
      ? '  Editor -> load the scenario -> Play'
      : '  Multiplayer -> Host Server -> LAN -> "SC 12 arma.warfare"')
    console.log('RPT log: %LOCALAPPDATA%\\Arma 3\\')
  }
}

main().catch((err) => {
  console.error('use-map: ' + err.message)
  process.exit(2)
})
