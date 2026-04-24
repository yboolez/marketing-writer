#!/usr/bin/env bash
# export.sh — convert marketing-writer HTML to PDF / long-image
# Primarily for mobile-shareable formats (HTML is hard to share on phones).
#
# Usage:
#   export.sh <html-file>                 # default: both (PDF + 长图)
#   export.sh <html-file> pdf
#   export.sh <html-file> long [width]    # default width 1080
#   export.sh <html-file> both [width]
#
# Requires Google Chrome / Chromium installed. Outputs sit beside the HTML.
#
# Generated HTML must include export-mode support (body.export-long class
# handler). marketing-writer's default template includes it.

set -e

HTML="${1:?"Usage: export.sh <html-file> [pdf|long|both] [width]"}"
FORMAT="${2:-both}"
WIDTH="${3:-1080}"

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

if [ -z "$CHROME" ]; then
    echo "❌ Chrome / Chromium not found. Install Google Chrome first." >&2
    exit 1
fi

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
            # fallback: older headless
            "$CHROME" --headless --disable-gpu \
                --print-to-pdf-no-header \
                --print-to-pdf="$out" \
                "file://$ABS_HTML?export=pdf" > /dev/null 2>&1
        }
    if [ -f "$out" ]; then
        echo "  ✓ $(du -h "$out" | cut -f1) → $out"
    else
        echo "  ❌ PDF export failed"
        return 1
    fi
}

trim_bottom_blank() {
    # Optional: use Python + Pillow to trim trailing blank area.
    # Skips silently if PIL isn't installed.
    local f="$1"
    python3 - "$f" 2>/dev/null <<'PY' || true
import sys
try:
    from PIL import Image, ImageChops
except ImportError:
    sys.exit(0)
f = sys.argv[1]
img = Image.open(f).convert("RGB")
# Sample bottom-right pixel as the "blank" reference color
bg = Image.new("RGB", img.size, img.getpixel((img.width - 1, img.height - 1)))
diff = ImageChops.difference(img, bg)
bbox = diff.getbbox()
if bbox and bbox[3] < img.height - 40:
    img.crop((0, 0, img.width, bbox[3] + 40)).save(f)
    print("[trimmed to %dpx]" % (bbox[3] + 40))
PY
}

export_long_image() {
    local out="${BASE}.png"
    local n
    n=$(count_slides)
    # Per-slide estimate: at width W, content-driven height roughly W * 1.0.
    # For 1080w that's ~1080/slide. Over-allocate to avoid clipping, then trim.
    local slide_h=$(( WIDTH * 11 / 10 ))
    local total_h=$(( n * slide_h + 400 ))

    echo "→ 长图: $(basename "$out") (${WIDTH} × ${total_h} pre-trim, ${n} slides)"
    "$CHROME" --headless=new --disable-gpu --no-sandbox \
        --window-size="${WIDTH},${total_h}" \
        --hide-scrollbars \
        --force-device-scale-factor=1 \
        --screenshot="$out" \
        "file://$ABS_HTML?export=long" > /dev/null 2>&1 || {
            "$CHROME" --headless --disable-gpu \
                --window-size="${WIDTH},${total_h}" \
                --hide-scrollbars \
                --screenshot="$out" \
                "file://$ABS_HTML?export=long" > /dev/null 2>&1
        }
    if [ -f "$out" ]; then
        local trim_info
        trim_info=$(trim_bottom_blank "$out")
        echo "  ✓ $(du -h "$out" | cut -f1) → $out ${trim_info}"
    else
        echo "  ❌ 长图 export failed"
        return 1
    fi
}

echo "📄 Exporting $(basename "$HTML")"
echo "───────────────────────────────────"

case "$FORMAT" in
    pdf) export_pdf ;;
    long|longimage|img|image) export_long_image ;;
    both|all|"") export_pdf; export_long_image ;;
    *) echo "❌ Unknown format: $FORMAT (use: pdf | long | both)"; exit 1 ;;
esac

echo "───────────────────────────────────"
echo "Done. Output beside: $ABS_HTML"
