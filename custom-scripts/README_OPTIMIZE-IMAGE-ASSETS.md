# Expo Asset Optimization Scripts

This directory contains scripts to optimize images and assets for your Expo app using Sharp.

## Setup

Make sure you have Sharp installed in your project:

```bash
npm install sharp commander
# or
yarn add sharp commander
```

## Scripts

### 1. `optimize-expo-assets.js` (Recommended for Expo)

A comprehensive script designed for Expo apps with features for responsive image generation and multiple format support.

#### Usage

```bash
node custom-scripts/optimize-expo-assets.js -i <input-dir> [options]
```

#### Options

- `-i, --input <path>` **(required)** - Input directory containing assets
- `-q, --quality <number>` - JPEG/WebP quality (1-100, default: 80)
- `-w, --width <number>` - Maximum width in pixels (default: 1024)
- `-o, --output <path>` - Output directory (default: overwrite originals)
- `-s, --sizes` - Generate multiple sizes for responsive images (1x, 2x, 3x)
- `-f, --format <types>` - Output formats comma-separated (default: webp,jpeg)
  - Options: `webp`, `jpeg`, `png`
- `--no-overwrite` - Prevent overwriting original files

#### Examples

**Basic optimization (overwrite originals):**
```bash
node custom-scripts/optimize-expo-assets.js -i assets
```

**Optimize with quality setting:**
```bash
node custom-scripts/optimize-expo-assets.js -i assets -q 75
```

**Generate responsive sizes (1x, 2x, 3x) with multiple formats:**
```bash
node custom-scripts/optimize-expo-assets.js -i assets -s -f webp,jpeg
```

**Output to separate directory:**
```bash
node custom-scripts/optimize-expo-assets.js -i assets -o optimized-assets
```

**High quality PNG conversion with safe output:**
```bash
node custom-scripts/optimize-expo-assets.js -i assets -q 90 -f png --no-overwrite
```

**For Expo Splash Screen (adaptive icon):**
```bash
node custom-scripts/optimize-expo-assets.js -i assets/splash -w 2048 -q 85 -f png
```

### 2. `raffle-image-optimizer.js`

Simpler script for basic image optimization.

#### Usage

```bash
node custom-scripts/raffle-image-optimizer.js -i <input-dir> [options]
```

#### Options

- `-i, --input <path>` **(required)** - Input directory containing assets
- `-q, --quality <number>` - Image quality (1-100, default: 80)
- `-w, --width <number>` - Maximum width in pixels (default: 1024)
- `-o, --output <path>` - Output directory

## Integration with package.json

Add these scripts to your `package.json`:

```json
{
  "scripts": {
    "optimize:assets": "node custom-scripts/optimize-expo-assets.js -i assets",
    "optimize:assets:responsive": "node custom-scripts/optimize-expo-assets.js -i assets -s -f webp,jpeg",
    "optimize:assets:safe": "node custom-scripts/optimize-expo-assets.js -i assets --no-overwrite -o optimized-assets",
    "optimize:splash": "node custom-scripts/optimize-expo-assets.js -i assets/splash -w 2048 -q 85",
    "optimize:icons": "node custom-scripts/optimize-expo-assets.js -i assets/icons -w 512"
  }
}
```

Then run:
```bash
npm run optimize:assets
npm run optimize:assets:responsive
npm run optimize:responsive:safe
```

## Optimization Tips for Expo

1. **Splash Screen**: Use `-w 2048` for high-res splash images (1440x2560 on Android, 1125x2436 on iOS)
   ```bash
   npm run optimize:splash
   ```

2. **Adaptive Icons**: Keep at 512x512px or larger
   ```bash
   npm run optimize:icons
   ```

3. **Responsive Images**: Generate multiple sizes for better performance
   ```bash
   npm run optimize:assets:responsive
   ```

4. **WebP for Web**: Use WebP format for better compression
   ```bash
   node custom-scripts/optimize-expo-assets.js -i assets -f webp
   ```

5. **Safe Mode**: Always test with `--no-overwrite` first
   ```bash
   npm run optimize:assets:safe
   ```

## Best Practices

- Always backup your assets before optimization
- Test on actual devices after optimization
- Use `--no-overwrite` for the first run to compare results
- For Splash screens, maintain aspect ratio (usually 1:1.78 on Android, 1:2.165 on iOS)
- WebP provides better compression but check browser/app support
- PNG works best for graphics, JPEG for photos
- Start with quality 80-85 and adjust based on visual results

## File Size Reference

Expected compression ratios (approximate):
- PNG → WebP: 25-35% reduction
- JPEG → WebP: 15-25% reduction
- Original → Optimized: 40-60% reduction (depending on initial quality)

## Troubleshooting

**"Sharp: pre-built binaries not found"**
```bash
npm rebuild sharp
```

**"ENOSPC: no space left on device"**
Output directory might be on same disk. Use `-o` to specify different location.

**Images look blurry**
Increase quality: `-q 90` or `-q 95`

**Unsupported image format**
Script supports: `.jpg`, `.jpeg`, `.png`, `.webp`
