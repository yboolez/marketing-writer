#!/usr/bin/env bash
# export.sh — convert deck-writer HTML to mobile-shareable formats.
# Philosophy: smaller files over higher DPI. Rely on auto-fit + right
# canvas size to make every slide look "reviewed" (no overflow, no
# weird whitespace), then ship at DPR=1 for compact output.
#
# Usage:
#   export.sh <html>                # default: PDF + long image
#   export.sh <html> pdf
#   export.sh <html> long [width]   # single stitched PNG
#   export.sh <html> moments        # WeChat 朋友圈: 9 images @ 750×1334 (9:16)
#   export.sh <html> xhs            # 小红书: up to 18 images @ 900×1200 (3:4)
#   export.sh <html> all            # all four above
#
# Requires Chrome/Chromium. Generated HTML must support these query params:
#   ?slide=N         — show only slide N
#   ?social=moments  — activate mobile-vertical layout + larger fonts
#   ?social=xhs      — same, for Xiaohongshu 3:4

set -e

HTML="${1:?"Usage: export.sh <html-file> [pdf|long|moments|xhs|all] [width]"}"
FORMAT="${2:-pdf-long}"
WIDTH="${3:-1440}"

[ ! -f "$HTML" ] && { echo "❌ File not found: $HTML" >&2; exit 1; }

ABS_HTML="$(cd "$(dirname "$HTML")" && pwd)/$(basename "$HTML")"
HTML_BASE="${ABS_HTML%.*}"                   # 不带扩展名的完整路径
HTML_NAME="$(basename "$HTML_BASE")"          # 仅文件名（不含路径和扩展名）
OUT_DIR="$(dirname "$ABS_HTML")"              # HTML 同目录就是输出目录
BASE="${OUT_DIR}/${HTML_NAME}"                # 产物前缀（PDF / 长图）

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

chrome_shot() {
    # Args: WIDTH HEIGHT OUT_PATH URL
    local w="$1" h="$2" out="$3" url="$4"
    "$CHROME" --headless=new --disable-gpu --no-sandbox \
        --window-size="${w},${h}" \
        --force-device-scale-factor=1 \
        --hide-scrollbars \
        --virtual-time-budget=3000 \
        --screenshot="$out" \
        "$url" > /dev/null 2>&1 || {
            "$CHROME" --headless --disable-gpu \
                --window-size="${w},${h}" \
                --hide-scrollbars \
                --screenshot="$out" \
                "$url" > /dev/null 2>&1
        }
}

optimize_pngs() {
    local dir="$1"
    python3 - "$dir" 2>/dev/null <<'PY' || true
import sys, os, glob
try:
    from PIL import Image
except ImportError:
    sys.exit()
d = sys.argv[1]
for f in sorted(glob.glob(os.path.join(d, '*.png'))):
    try:
        Image.open(f).convert('RGB').save(f, optimize=True)
    except Exception: pass
PY
}

export_pdf() {
    local out="${BASE}.pdf"
    echo "→ PDF"
    "$CHROME" --headless=new --disable-gpu --no-sandbox \
        --no-pdf-header-footer --print-to-pdf-no-header \
        --hide-scrollbars --print-to-pdf="$out" \
        "file://$ABS_HTML?export=pdf" > /dev/null 2>&1 || {
            "$CHROME" --headless --disable-gpu \
                --print-to-pdf-no-header --print-to-pdf="$out" \
                "file://$ABS_HTML?export=pdf" > /dev/null 2>&1
        }
    [ -f "$out" ] && echo "  ✓ $(du -h "$out" | cut -f1) → $(basename "$out")"
}

export_long_image() {
    local out="${BASE}.png"
    local n slide_h tmpdir
    n=$(count_slides)
    slide_h=$(( WIDTH * 9 / 16 ))
    tmpdir=$(mktemp -d -t mw-long)

    echo "→ 长图 (loop + stitch, ${n} slides @ ${WIDTH}×${slide_h})"
    for i in $(seq 0 $((n-1))); do
        chrome_shot "$WIDTH" "$slide_h" \
            "$tmpdir/slide-$(printf '%02d' "$i").png" \
            "file://$ABS_HTML?slide=$i"
        printf "  · %02d/%02d\r" "$((i+1))" "$n"
    done
    echo ""

    python3 - "$tmpdir" "$out" <<'PY'
import sys, os, glob
try: from PIL import Image
except ImportError: print("  ❌ Pillow not installed"); sys.exit(1)
tmpdir, out = sys.argv[1], sys.argv[2]
files = sorted(glob.glob(os.path.join(tmpdir, 'slide-*.png')))
imgs = [Image.open(f).convert('RGB') for f in files]
w = imgs[0].width; total_h = sum(i.height for i in imgs)
canvas = Image.new('RGB', (w, total_h))
y = 0
for img in imgs:
    canvas.paste(img, (0, y)); y += img.height
canvas.save(out, optimize=True)
print(f"  ✓ {os.path.getsize(out)/1024/1024:.1f}M → {os.path.basename(out)} ({w}×{total_h})")
PY
    rm -rf "$tmpdir"
}

export_social() {
    local platform="$1"
    local cap_w cap_h max_n outdir n frames

    case "$platform" in
        moments)  cap_w=1080; cap_h=1920; max_n=9  ;;   # 9:16 朋友圈（1080w 行业标准）
        xhs)      cap_w=1080; cap_h=1440; max_n=18 ;;   # 3:4  小红书（1080w 行业标准）
        *) echo "❌ Unknown social: $platform"; return 1 ;;
    esac

    n=$(count_slides)
    frames=$(( n < max_n ? n : max_n ))
    outdir="${OUT_DIR}/${platform}"
    rm -rf "$outdir"; mkdir -p "$outdir"

    echo "→ 社交媒体 · ${platform} · ${frames} 张 @ ${cap_w}×${cap_h}"
    [ "$n" -gt "$max_n" ] && echo "  ℹ deck 共 $n 页，只取前 $max_n 页（${platform} 上限）"

    for i in $(seq 0 $((frames-1))); do
        chrome_shot "$cap_w" "$cap_h" \
            "$outdir/$(printf '%02d' "$((i+1))").png" \
            "file://$ABS_HTML?slide=${i}&social=${platform}"
        printf "  · %02d.png\r" "$((i+1))"
    done
    echo ""
    optimize_pngs "$outdir"

    local total_sz
    total_sz=$(du -sh "$outdir" | cut -f1)
    echo "  ✓ ${frames} 张 → ${outdir}/ (${total_sz} total)"
}

echo "📄 Exporting $(basename "$HTML")"
echo "───────────────────────────────────"

case "$FORMAT" in
    pdf)      export_pdf ;;
    long|longimage|img)      export_long_image ;;
    moments|friend|wechat)   export_social moments ;;
    xhs|xiaohongshu|red)     export_social xhs ;;
    pdf-long|pdflong|both|"") export_pdf; export_long_image ;;
    all) export_pdf; export_long_image; export_social moments; export_social xhs ;;
    *) echo "❌ Unknown format: $FORMAT"; exit 1 ;;
esac

echo "───────────────────────────────────"
echo "Done."
