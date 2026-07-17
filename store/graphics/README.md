# Play Store graphics

Generated from `assets/icon/ermine_icon.svg` (via the pre-rasterised
`assets/icon/ermine_logo.png`) and the brand palette.

| File | Size | Format | Play Console field |
|------|------|--------|--------------------|
| `icon_512.png` | 512×512 | 32-bit PNG | High-res app icon |
| `feature_graphic_1024x500.png` | 1024×500 | 24-bit PNG (no alpha) | Feature graphic |

Brand palette: paper `#F5F6F4`, ink `#14161A`, highlighter `#F2C230`,
onHighlighter `#412402`. Wordmark = Space Grotesk 700; tagline = Inter;
feature line = IBM Plex Mono (all bundled in `assets/fonts/`).

## Regenerating

Rendered with `sharp` (Node), which is installed only in the untracked
`node_modules/` — it is **not** a committed dependency (same approach as the
launcher-icon/splash pipeline). Fonts are resolved through a fontconfig file
pointing at `assets/fonts/`. The generator script used is
`gen_graphics.js` (kept in the session scratchpad, not committed); re-run it
with `FONTCONFIG_FILE` set to a conf whose `<dir>` is `assets/fonts` and
`NODE_PATH` pointed at the project `node_modules`.
