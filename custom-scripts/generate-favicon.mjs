import { mkdir, writeFile } from "node:fs/promises";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";
import pngToIco from "png-to-ico";
import sharp from "sharp";

/**
 * Regenerate the favicon set:
 *
 *   npm run favicon
 *
 * The mark is defined once, here, and rasterised with sharp. Edit the geometry
 * or the colour tokens below and re-run; `public/favicon.svg` is written from
 * the same source so the vector and the ICO cannot drift.
 *
 * Theme tokens match src/styles.css: dark navy background with the orange
 * primary and pink accent used by the terminal header.
 */

const OUT_DIR = resolve(dirname(fileURLToPath(import.meta.url)), "..", "public");

const COLORS = {
  bg: "#0e0d1d",
  border: "#3d3f5d",
  primary: "#ee9748",
  accent: "#f072b3",
};

/** Terminal prompt mark (`>_`) on a rounded tile. viewBox is fixed; size sets the intrinsic pixel size. */
const makeSvg = (size) => `<svg xmlns="http://www.w3.org/2000/svg" width="${size}" height="${size}" viewBox="0 0 32 32">
  <rect width="32" height="32" rx="7" fill="${COLORS.bg}"/>
  <rect x="0.5" y="0.5" width="31" height="31" rx="6.5" fill="none" stroke="${COLORS.border}"/>
  <path d="M9 10 L16 16 L9 22" fill="none" stroke="${COLORS.primary}" stroke-width="3.5" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M18 22 H24" fill="none" stroke="${COLORS.accent}" stroke-width="3.5" stroke-linecap="round"/>
</svg>
`;

const renderPng = (size) => sharp(Buffer.from(makeSvg(size))).png().toBuffer();

async function main() {
  await mkdir(OUT_DIR, { recursive: true });

  await writeFile(resolve(OUT_DIR, "favicon.svg"), makeSvg(32));
  await writeFile(resolve(OUT_DIR, "apple-touch-icon.png"), await renderPng(180));

  const ico = await pngToIco(await Promise.all([16, 32, 48].map(renderPng)));
  if (ico.length === 0) throw new Error("png-to-ico produced an empty buffer");
  await writeFile(resolve(OUT_DIR, "favicon.ico"), ico);

  console.log("wrote public/favicon.svg, public/favicon.ico, public/apple-touch-icon.png");
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
