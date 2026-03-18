# Performance Tests — Lighthouse Targets

> Sati Oracle (สติ) — "เร็วและมั่นคง — Fast and stable"

## Lighthouse Score Targets

| Category        | Target | Minimum | Notes                            |
|-----------------|--------|---------|----------------------------------|
| Performance     | 95+    | **90**  | Core metric — must not regress   |
| Accessibility   | 100    | **100** | Non-negotiable                   |
| Best Practices  | 100    | 95      |                                  |
| SEO             | 100    | **90**  | Must meet for public pages       |

---

## Core Web Vitals Targets

| Metric | Full Name                  | Target    | Maximum   |
|--------|----------------------------|-----------|-----------|
| LCP    | Largest Contentful Paint   | ≤ 1.5s    | ≤ 2.5s    |
| INP    | Interaction to Next Paint  | ≤ 100ms   | ≤ 200ms   |
| CLS    | Cumulative Layout Shift    | ≤ 0.05    | ≤ 0.1     |
| FCP    | First Contentful Paint     | ≤ 1.0s    | ≤ 1.8s    |
| TTFB   | Time to First Byte         | ≤ 200ms   | ≤ 600ms   |

---

## Pages to Test

Test each page on both **mobile** and **desktop**:

| Page               | Path         | Mobile Perf | Desktop Perf | A11y | SEO |
|--------------------|--------------|-------------|--------------|------|-----|
| Home               | `/`          |             |              |      |     |
| Login              | `/login`     |             |              |      |     |
| Dashboard          | `/dashboard` |             |              |      |     |
| List View          | `/items`     |             |              |      |     |
| Detail View        | `/items/:id` |             |              |      |     |
| Settings           | `/settings`  |             |              |      |     |

---

## How to Run

### CLI (CI/CD)

```bash
# Install
npm install -g lighthouse

# Run single page
lighthouse http://localhost:3000 \
  --output=json \
  --output-path=./report.json \
  --chrome-flags="--headless --no-sandbox"

# Check scores (example with jq)
cat report.json | jq '{
  performance: .categories.performance.score * 100,
  accessibility: .categories.accessibility.score * 100,
  bestPractices: .categories["best-practices"].score * 100,
  seo: .categories.seo.score * 100
}'
```

### CI Gate Script

```bash
#!/bin/bash
# lighthouse-gate.sh — Fail CI if scores below target

PERF_MIN=90
A11Y_MIN=100
SEO_MIN=90

URL="${1:-http://localhost:3000}"
REPORT=$(lighthouse "$URL" --output=json --chrome-flags="--headless --no-sandbox" 2>/dev/null)

perf=$(echo "$REPORT" | jq '.categories.performance.score * 100 | floor')
a11y=$(echo "$REPORT" | jq '.categories.accessibility.score * 100 | floor')
seo=$(echo "$REPORT" | jq '.categories.seo.score * 100 | floor')

echo "Performance:   ${perf}/100 (min: ${PERF_MIN})"
echo "Accessibility: ${a11y}/100 (min: ${A11Y_MIN})"
echo "SEO:           ${seo}/100 (min: ${SEO_MIN})"

FAILED=0
[ "$perf" -lt "$PERF_MIN" ] && echo "✗ Performance below ${PERF_MIN}" && FAILED=1
[ "$a11y" -lt "$A11Y_MIN" ] && echo "✗ Accessibility below ${A11Y_MIN}" && FAILED=1
[ "$seo" -lt "$SEO_MIN" ] && echo "✗ SEO below ${SEO_MIN}" && FAILED=1

exit $FAILED
```

---

## Bundle Size Budget

| Asset Type   | Target    | Maximum   |
|-------------|-----------|-----------|
| JavaScript  | ≤ 150 KB  | ≤ 250 KB  |
| CSS         | ≤ 30 KB   | ≤ 50 KB   |
| Images      | ≤ 200 KB  | ≤ 500 KB  |
| Fonts       | ≤ 100 KB  | ≤ 150 KB  |
| Total page  | ≤ 500 KB  | ≤ 1 MB    |

*All sizes gzipped.*

---

## Performance Checklist

### Loading

- [ ] Images use modern formats (WebP/AVIF) with fallback
- [ ] Images are lazy-loaded below the fold
- [ ] Critical CSS is inlined
- [ ] JavaScript is code-split by route
- [ ] Fonts use `font-display: swap`
- [ ] Resources use preconnect/preload for critical assets
- [ ] Gzip/Brotli compression enabled on server
- [ ] HTTP/2 or HTTP/3 enabled

### Rendering

- [ ] No layout shifts from dynamic content
- [ ] No render-blocking scripts in `<head>`
- [ ] Animations use `transform`/`opacity` only (GPU composited)
- [ ] Lists use virtualization for 100+ items
- [ ] No forced synchronous layouts in scroll handlers

### Caching

- [ ] Static assets have cache headers (1 year for hashed files)
- [ ] API responses use appropriate Cache-Control
- [ ] Service worker caches critical assets (if PWA)

### Server

- [ ] TTFB ≤ 200ms on CDN-served pages
- [ ] API responses ≤ 300ms p95
- [ ] Database queries ≤ 100ms p95
- [ ] No N+1 query patterns

---

## Test Results

| Date | Tester | Page | Device | Perf | A11y | BP | SEO | Notes |
|------|--------|------|--------|------|------|----|-----|-------|
|      |        |      |        |      |      |    |     |       |
