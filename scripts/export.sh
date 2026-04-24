#!/usr/bin/env bash
# export.sh — convert marketing-writer HTML to PDF / long-image.
# Primarily for mobile-shareable formats (HTML is hard to share on phones).
#
# Approach: "fixed canvas" — every slide renders at a consistent
# presentation aspect (default 1920×1080, 16:9 widescreen). PDF maps each
# slide to one @page. 长图 loops ?slide=N, captures each slide at canvas
# resolution, then PIL stitches them into a single tall PNG.
#
# Usage:
#   export.sh <html>                    # both PDF + 长图 (default width 1920)
#   export.sh <html> pdf
#   export.sh <html> long [width]       # default 1920 so fonts stay readable
#   export.sh <html> both [width]
#
# Requires Google Chrome / Chromium. Outputs sit beside the HTML.
# Generated HTML must support `?slide=N` query param (marketing-writer
# default template includes it).

set -e

HTML="${1:?"Usage: export.sh <html-file> [pdf|long|both] [width]"}"
FORMAT="${2:-both}"
# Canvas width in CSS px. 1440 matches typical laptop Chrome window, so
# long-image fonts/layout look the same proportion as presentation.
# Output is rendered at DPR=2 (hi-DPI) so final pixels are 2× this.
WIDTH="${3:-1440}"

[ ! -f "$HTML" ] && { echo "❌ File not found: $HTML" >&2; exit 1; }

ABS_HTML="$(cd "$(dirname "$HTML")" && pwd)/$(basename "$HTML")"
BASE="${ABS_HTML%.*}"

# Locate Chrome / Chromium
CHROME=""
for candidate in \
    "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
    "/Applications/Google Chrome Canary.app/Contents/MacOS/Google Chrome Canary" \
    "/Applications/Chromium.app/Contents/MacOS/Chromium" \
    "$(command -v google-chrome 2>/dev/null)" \
    "$(command -v chromium 2>/dev/null)" \
    "$(command -v chromium-browser 2>/dev/null)"; do
    [ -n "$candidate" ] && [ -x "$candidate" ] && { CHROME="$candidate"; break; }
done
[ -z "$CHROME" ] && { echo "❌ Chrome / Chromium not found." >&2; exit 1; }

count_slides() {
    grep -c '<section class="slide' "$ABS_HTML" 2>/dev/null || echo 14
}

export_pdf() {
    local out="${BASE}.pdf"
    echo "→ PDF: $(basename "$out")"
    "$CHROME" --headless=new --disable-gpu --no-sandbox \
        --no-pdf-header-footer \
        --print-to-pdf-no-header \
        --hide-scrollbars \
        --print-to-pdf="$out" \
        "file://$ABS_HTML?export=pdf" > /dev/null 2>&1 || {
            "$CHROME" --headless --disable-gpu \
                --print-to-pdf-no-header \
                --print-to-pdf="$out" \
                "file://$ABS_HTML?export=pdf" > /dev/null 2>&1
        }
    [ -f "$out" ] && echo "  ✓ $(du -h "$out" | cut -f1) → $out" || {
        echo "  ❌ PDF export failed"; return 1;
    }
}

export_long_image() {
    local out="${BASE}.png"
    local n slide_h tmpdir
    n=$(count_slides)
    # Each slide captured at WIDTH × (WIDTH × 9/16) — 16:9 aspect.
    slide_h=$(( WIDTH * 9 / 16 ))
    tmpdir=$(mktemp -d -t mw-export)

    echo "→ 长图 (loop + stitch)"
    echo "  画布: ${WIDTH} × ${slide_h} per slide · ${n} slides"
    echo "  总尺寸: ${WIDTH} × $(( n * slide_h ))"

    # Phase 1: capture each slide individually via ?slide=N
    for i in $(seq 0 $((n-1))); do
        local frame
        frame="$tmpdir/slide-$(printf '%02d' "$i").png"
        "$CHROME" --headless=new --disable-gpu --no-sandbox \
            --window-size="${WIDTH},${slide_h}" \
            --force-device-scale-factor=2 \
            --hide-scrollbars \
            --virtual-time-budget=3000 \
            --screenshot="$frame" \
            "file://$ABS_HTML?slide=$i" > /dev/null 2>&1 || {
                "$CHROME" --headless --disable-gpu \
                    --window-size="${WIDTH},${slide_h}" \
                    --hide-scrollbars \
                    --screenshot="$frame" \
                    "file://$ABS_HTML?slide=$i" > /dev/null 2>&1
            }
        [ -f "$frame" ] || { echo "  ❌ slide $i capture failed"; rm -rf "$tmpdir"; return 1; }
        printf "  · slide %02d captured\r" "$i"
    done
    echo ""

    # Phase 2: PIL stitch
    python3 - "$tmpdir" "$out" <<'PY'
import sys, os, glob
try:
    from PIL import Image
except ImportError:
    print("  ❌ Pillow not installed. Run: pip3 install Pillow")
    sys.exit(1)

tmpdir, out = sys.argv[1], sys.argv[2]
files = sorted(glob.glob(os.path.join(tmpdir, 'slide-*.png')))
if not files:
    print("  ❌ No frames to stitch"); sys.exit(1)

imgs = [Image.open(f).convert('RGB') for f in files]
w = imgs[0].width
total_h = sum(img.height for img in imgs)
canvas = Image.new('RGB', (w, total_h))
y = 0
for img in imgs:
    canvas.paste(img, (0, y))
    y += img.height
canvas.save(out, optimize=True)
sz = os.path.getsize(out) / 1024 / 1024
print(f"  ✓ {sz:.1f}M → {out} ({w}×{total_h})")
PY

    rm -rf "$tmpdir"
}

echo "📄 Exporting $(basename "$HTML")"
echo "───────────────────────────────────"

case "$FORMAT" in
    pdf) export_pdf ;;
    long|longimage|img|image) export_long_image ;;
    both|all|"") export_pdf; export_long_image ;;
    *) echo "❌ Unknown format: $FORMAT"; exit 1 ;;
esac

echo "───────────────────────────────────"
echo "Done."
