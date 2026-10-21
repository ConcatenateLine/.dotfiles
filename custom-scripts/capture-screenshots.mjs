#!/usr/bin/env node
/**
 * capture-screenshots.mjs — headless UI captures for local web apps.
 *
 * Drives the SYSTEM Firefox over WebDriver BiDi (puppeteer-core), so no browser
 * download is needed. Logs in once, then writes one PNG per requested view.
 *
 * Usage:
 *   node capture-screenshots.mjs \
 *     --url http://localhost:5173 \
 *     --email admin@example.com --password secret \
 *     --out ./shots \
 *     --shot "login=/login" \
 *     --shot "people=/dashboard:table tbody tr"
 *
 * Advanced views (typing into the page before the capture) use a JSON spec:
 *   node capture-screenshots.mjs --url http://localhost:5173 --out ./shots \
 *     --spec ./spec.json
 *
 * Spec file shape:
 *   { "shots": [
 *       { "name": "places", "path": "/users/new", "wait": ".gm-style",
 *         "type": [ { "selector": "input[placeholder^='Search an address']",
 *                     "text": "Calle de Alcala" } ] }
 *   ] }
 */

import fs from 'node:fs';
import path from 'node:path';
import os from 'node:os';
import puppeteer from 'puppeteer-core';

const argv = process.argv.slice(2);

function parseArgs(args) {
  const out = { shot: [], interact: [], width: 1440, height: 900, delay: 1200 };
  for (let i = 0; i < args.length; i++) {
    const a = args[i];
    const next = () => args[++i];
    switch (a) {
      case '--url': out.url = next(); break;
      case '--login-url': out.loginUrl = next(); break;
      case '--email': out.email = next(); break;
      case '--password': out.password = next(); break;
      case '--email-selector': out.emailSelector = next(); break;
      case '--password-selector': out.passwordSelector = next(); break;
      case '--submit-selector': out.submitSelector = next(); break;
      case '--out': out.out = next(); break;
      case '--width': out.width = Number(next()); break;
      case '--height': out.height = Number(next()); break;
      case '--delay': out.delay = Number(next()); break;
      case '--firefox': out.firefox = next(); break;
      case '--profile': out.profile = next(); break;
      case '--shot': out.shot.push(next()); break;
      case '--spec': out.spec = next(); break;
      case '--full-page': out.fullPage = true; break;
      case '--keep-open': out.keepOpen = true; break;
      case '--help': case '-h': out.help = true; break;
      default:
        if (a.startsWith('--')) throw new Error(`unknown flag: ${a}`);
    }
  }
  return out;
}

const opts = parseArgs(argv);

if (opts.help || !opts.url || !opts.out) {
  console.log('Usage: capture-screenshots.mjs --url <base> --out <dir> [--shot name=path[:wait]] [--spec file.json]');
  process.exit(opts.help ? 0 : 1);
}

const base = opts.url.replace(/\/$/, '');
const outDir = path.resolve(opts.out);
fs.mkdirSync(outDir, { recursive: true });

/** "people=/dashboard:table tbody tr" -> { name, path, wait } */
function parseShot(spec) {
  const idx = spec.indexOf('=');
  if (idx === -1) throw new Error(`bad --shot (expected name=path): ${spec}`);
  const name = spec.slice(0, idx);
  const rest = spec.slice(idx + 1);
  const colon = rest.indexOf(':');
  const shotPath = colon === -1 ? rest : rest.slice(0, colon);
  const wait = colon === -1 ? null : rest.slice(colon + 1);
  return { name, path: shotPath, wait };
}

let shots = opts.shot.map(parseShot);

if (opts.spec) {
  const spec = JSON.parse(fs.readFileSync(opts.spec, 'utf8'));
  const fileShots = (spec.shots ?? []).map((s) => ({
    name: s.name,
    path: s.path,
    wait: s.wait ?? null,
    type: s.type ?? [],
    delay: s.delay,
    fullPage: s.fullPage,
  }));
  shots = shots.length ? [...shots, ...fileShots] : fileShots;
}

if (!shots.length) throw new Error('no shots requested');

const browser = await puppeteer.launch({
  browser: 'firefox',
  executablePath: opts.firefox ?? '/usr/bin/firefox',
  headless: true,
  protocol: 'webDriverBiDi',
  userDataDir: opts.profile ?? path.join(os.homedir(), '.mozilla', 'pptr-profile'),
  firefoxUserPrefs: {
    'webgl.force-enabled': true,
    'webgl.disabled': false,
    'gfx.webrender.software': true,
  },
});

const page = await browser.newPage();
await page.setViewport({ width: opts.width, height: opts.height });

const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

/** Wait until the map tiles have painted, so captures are not half-drawn. */
async function settleMap(ms = 2500) {
  try {
    await page.waitForFunction(
      () => {
        const el = document.querySelector('.gm-style');
        if (!el) return true;
        return el.querySelectorAll('img').length > 0;
      },
      { timeout: 12000 },
    );
  } catch {
    /* map absent — nothing to wait for */
  }
  await sleep(ms);
}

async function login() {
  if (!opts.email || !opts.password) return false;
  const loginUrl = opts.loginUrl ? new URL(opts.loginUrl, base).href : `${base}/login`;
  await page.goto(loginUrl, { waitUntil: 'networkidle', timeout: 45000 });
  const emailSel = opts.emailSelector ?? 'input[type=email]';
  const passSel = opts.passwordSelector ?? 'input[type=password]';
  const submitSel = opts.submitSelector ?? 'button[type=submit]';
  await page.waitForSelector(emailSel, { timeout: 15000 });
  await page.type(emailSel, opts.email);
  await page.type(passSel, opts.password);
  await Promise.all([
    page.waitForNavigation({ waitUntil: 'networkidle', timeout: 45000 }).catch(() => {}),
    page.click(submitSel),
  ]);
  await sleep(800);
  console.log(`login: ${page.url()}`);
  return true;
}

const results = [];

try {
  await login();

  for (const shot of shots) {
    const url = new URL(shot.path, base).href;
    await page.goto(url, { waitUntil: 'networkidle', timeout: 45000 });
    if (shot.wait) await page.waitForSelector(shot.wait, { timeout: 20000 }).catch(() => {});
    for (const step of shot.type ?? []) {
      await page.waitForSelector(step.selector, { timeout: 15000 });
      await page.type(step.selector, step.text);
      if (step.waitFor) {
        await page.waitForSelector(step.waitFor, { timeout: 15000 }).catch(() => {});
      }
      await sleep(step.settle ?? 1800);
    }
    await settleMap();
    await sleep(shot.delay ?? opts.delay);

    const file = path.join(outDir, `${shot.name}.png`);
    await page.screenshot({ path: file, fullPage: shot.fullPage ?? opts.fullPage ?? false });

    const buf = fs.readFileSync(file);
    results.push({
      name: shot.name,
      path: file,
      kb: Math.round(buf.length / 1024),
      width: buf.readUInt32BE(16),
      height: buf.readUInt32BE(20),
    });
    console.log(`captured ${shot.name.padEnd(24)} ${file}  ${Math.round(buf.length / 1024)}KB`);
  }
} finally {
  if (!opts.keepOpen) await browser.close();
}

console.log('\n' + JSON.stringify(results, null, 2));
