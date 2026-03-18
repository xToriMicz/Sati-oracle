#!/bin/bash
# ============================================================
# Parami API Tests — Sati Oracle (สติ)
# "ทดสอบก่อนไว้ใจ — Test before trust"
#
# Usage: BASE_URL=http://localhost:3000 ./api-tests.sh
# ============================================================

BASE_URL="${BASE_URL:-http://localhost:3000}"
PASS=0
FAIL=0
TOTAL=0

# --- Helpers ---

assert_status() {
  local name="$1" method="$2" endpoint="$3" expected="$4"
  shift 4
  TOTAL=$((TOTAL + 1))

  status=$(curl -s -o /dev/null -w "%{http_code}" -X "$method" "$@" "${BASE_URL}${endpoint}")

  if [ "$status" = "$expected" ]; then
    echo "  ✓ ${name} (${status})"
    PASS=$((PASS + 1))
  else
    echo "  ✗ ${name} — expected ${expected}, got ${status}"
    FAIL=$((FAIL + 1))
  fi
}

assert_json_field() {
  local name="$1" method="$2" endpoint="$3" field="$4"
  TOTAL=$((TOTAL + 1))

  response=$(curl -s -X "$method" "${BASE_URL}${endpoint}")
  value=$(echo "$response" | grep -o "\"${field}\"" | head -1)

  if [ -n "$value" ]; then
    echo "  ✓ ${name} — field '${field}' present"
    PASS=$((PASS + 1))
  else
    echo "  ✗ ${name} — field '${field}' missing"
    FAIL=$((FAIL + 1))
  fi
}

assert_response_time() {
  local name="$1" method="$2" endpoint="$3" max_ms="$4"
  TOTAL=$((TOTAL + 1))

  time_total=$(curl -s -o /dev/null -w "%{time_total}" -X "$method" "${BASE_URL}${endpoint}")
  ms=$(echo "$time_total * 1000" | bc | cut -d. -f1)

  if [ "$ms" -le "$max_ms" ] 2>/dev/null; then
    echo "  ✓ ${name} — ${ms}ms (≤${max_ms}ms)"
    PASS=$((PASS + 1))
  else
    echo "  ✗ ${name} — ${ms}ms (>${max_ms}ms)"
    FAIL=$((FAIL + 1))
  fi
}

# ============================================================
# 1. Health & Root
# ============================================================
echo ""
echo "=== Health & Root ==="

assert_status "GET /health returns 200" \
  GET "/health" "200"

assert_status "GET / returns 200" \
  GET "/" "200"

assert_json_field "GET /health has status field" \
  GET "/health" "status"

assert_response_time "GET /health responds within 500ms" \
  GET "/health" 500

# ============================================================
# 2. API Endpoints — CRUD
# ============================================================
echo ""
echo "=== API CRUD ==="

assert_status "GET /api/items returns 200" \
  GET "/api/items" "200"

assert_status "POST /api/items with valid body returns 201" \
  POST "/api/items" "201" \
  -H "Content-Type: application/json" \
  -d '{"name":"test-item","value":"sati"}'

assert_status "POST /api/items without body returns 400" \
  POST "/api/items" "400"

assert_status "GET /api/items/:id returns 200" \
  GET "/api/items/1" "200"

assert_status "GET /api/items/:id with bad id returns 404" \
  GET "/api/items/999999" "404"

assert_status "PUT /api/items/:id returns 200" \
  PUT "/api/items/1" "200" \
  -H "Content-Type: application/json" \
  -d '{"name":"updated-item"}'

assert_status "DELETE /api/items/:id returns 200 or 204" \
  DELETE "/api/items/1" "204"

# ============================================================
# 3. Authentication
# ============================================================
echo ""
echo "=== Authentication ==="

assert_status "Protected route without token returns 401" \
  GET "/api/protected" "401"

assert_status "Protected route with invalid token returns 401" \
  GET "/api/protected" "401" \
  -H "Authorization: Bearer invalid-token"

# ============================================================
# 4. Error Handling
# ============================================================
echo ""
echo "=== Error Handling ==="

assert_status "Unknown route returns 404" \
  GET "/api/nonexistent-route-xyz" "404"

assert_status "Malformed JSON returns 400" \
  POST "/api/items" "400" \
  -H "Content-Type: application/json" \
  -d '{bad json}'

# ============================================================
# 5. Headers & Security
# ============================================================
echo ""
echo "=== Headers & Security ==="

TOTAL=$((TOTAL + 1))
headers=$(curl -s -I "${BASE_URL}/")
if echo "$headers" | grep -qi "x-frame-options\|content-security-policy"; then
  echo "  ✓ Security headers present"
  PASS=$((PASS + 1))
else
  echo "  ✗ Security headers missing (X-Frame-Options / CSP)"
  FAIL=$((FAIL + 1))
fi

TOTAL=$((TOTAL + 1))
if echo "$headers" | grep -qi "x-powered-by"; then
  echo "  ✗ X-Powered-By header exposed (should be removed)"
  FAIL=$((FAIL + 1))
else
  echo "  ✓ X-Powered-By header hidden"
  PASS=$((PASS + 1))
fi

# ============================================================
# 6. Response Time
# ============================================================
echo ""
echo "=== Performance ==="

assert_response_time "GET / responds within 1000ms" \
  GET "/" 1000

assert_response_time "GET /api/items responds within 500ms" \
  GET "/api/items" 500

# ============================================================
# Summary
# ============================================================
echo ""
echo "============================================"
echo "  Results: ${PASS}/${TOTAL} passed, ${FAIL} failed"
echo "============================================"
echo ""

if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
