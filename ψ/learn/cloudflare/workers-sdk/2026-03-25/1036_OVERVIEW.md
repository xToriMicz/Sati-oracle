# Cloudflare Workers SDK — Security & Performance Overview

> สรุปสำหรับทีม xToriMicz ที่ build facebook-toolkit บน Cloudflare Workers

## 1. Project Overview

workers-sdk เป็น monorepo ของ Cloudflare มี 25+ packages:
- **wrangler** — CLI หลักสำหรับ develop, test, deploy Workers
- **miniflare** — Local runtime simulator สำหรับ dev
- **kv-asset-handler** — จัดการ static assets ใน KV
- **create-cloudflare** — CLI สร้าง project ใหม่ (C3)
- **vite-plugin-cloudflare** — Vite integration

## 2. Security Patterns

### Secret Management (wrangler secret)
```typescript
// packages/wrangler/src/secret/index.ts
type SecretBindingUpload = {
  type: "secret_text";
  name: string;
  text: string;  // plaintext ส่งผ่าน API แต่ Cloudflare encrypt at rest
};
```

**กฎสำคัญ:**
- `wrangler secret put KEY` → encrypt + store ที่ Cloudflare edge
- Secret ไม่ถูกเก็บใน wrangler.toml (ใช้ env binding)
- ใน dev mode: ใช้ `.dev.vars` file (gitignored)
- Inheritance: secret จาก parent environment สืบทอดได้

**สำหรับ facebook-toolkit:**
- `FB_APP_SECRET` → `wrangler secret put FB_APP_SECRET` ✅ (ทำแล้ว)
- `TOKEN_ENCRYPTION_KEY` → ควรเป็น wrangler secret ด้วย ✅
- ห้ามใส่ secret ใน wrangler.toml หรือ code

### Auth Patterns (wrangler auth)
```typescript
// packages/wrangler/src/user/user.ts
// OAuth flow: browser → token → store in ~/.wrangler/config/default.toml
// Token refresh: automatic with refresh_token
```

### Token Storage
- Wrangler เก็บ token ที่ `~/.wrangler/config/default.toml`
- ไม่ encrypt (plaintext) — rely on filesystem permissions
- สำหรับ CI: ใช้ `CLOUDFLARE_API_TOKEN` env var

## 3. KV / D1 / R2 Patterns

### KV (Key-Value)
```typescript
// Bindings in wrangler.toml
[[kv_namespaces]]
binding = "KV"
id = "xxx"
```

**Race Conditions:**
- KV เป็น eventually consistent — write แล้ว read ทันทีอาจได้ค่าเก่า
- **แก้สำหรับ facebook-toolkit:** session ใช้ KV OK (TTL 30 days, ไม่ต้อง strong consistency)
- page_token ใช้ KV per-user OK (write ตอน login, read ตอน post — ไม่ race)

**Best Practices:**
- ใช้ `expirationTtl` ทุก key (ไม่ปล่อยค้างตลอดไป)
- Key naming convention: `u:{fb_id}:page_id` ✅ (ทำแล้ว)
- Batch operations: `KV.list()` + `KV.delete()` สำหรับ cleanup

### D1 (SQLite)
```typescript
// Parameterized queries (SAFE)
db.prepare("SELECT * FROM users WHERE fb_user_id = ?").bind(userId)

// String concat (UNSAFE — SQL injection!)
db.prepare(`SELECT * FROM users WHERE fb_user_id = '${userId}'`)
```

**Transaction Isolation:**
- D1 ไม่มี explicit transactions (single-statement atomicity only)
- **แก้:** ถ้าต้อง atomic multi-statement → ใช้ `db.batch([stmt1, stmt2])`
- facebook-toolkit: auth callback save user + pages → ควรใช้ batch

**Migration:**
- ไม่มี built-in migration tool ใน D1
- ใช้ `wrangler d1 execute DB_NAME --command "ALTER TABLE..."`
- ควรเก็บ migration history (เราทำ manual ตอนนี้)

### R2 (Object Storage)
```typescript
// Upload
await ASSETS.put(key, arrayBuffer, { httpMetadata: { contentType } });

// Download
const obj = await ASSETS.get(key);
if (!obj) return new Response("Not Found", { status: 404 });
return new Response(obj.body, { headers: { "Content-Type": obj.httpMetadata?.contentType } });
```

**Security:**
- R2 ไม่มี per-object ACL — ทุกคนที่มี key เข้าถึงได้
- **แก้:** ใช้ Workers as auth proxy (เราทำแล้ว — `/img/*` route)
- File naming: `uploads/{timestamp}-{sanitized-name}` ✅

## 4. Performance Patterns

### Edge Caching
```typescript
// Cache API (Workers)
const cache = caches.default;
const cached = await cache.match(request);
if (cached) return cached;
const response = await fetch(origin);
await cache.put(request, response.clone());
return response;
```

**สำหรับ facebook-toolkit:**
- Static assets: `Cache-Control: public, max-age=31536000` ✅
- API: `Cache-Control: private, max-age=0` ✅
- Engagement data: KV cache 5 min (kvCache helper) ✅
- ควรเพิ่ม: ETag สำหรับ /api/posts (conditional requests)

### Bundling
- Wrangler ใช้ esbuild bundle Workers
- Tree-shaking automatic
- Target: esnext (Workers runtime)
- ขนาด limit: 10MB compressed (Workers), 25MB (Pages)

### Connection Pooling
- Workers ไม่มี persistent connections (stateless)
- ทุก request = fresh execution context
- D1/KV/R2 = Cloudflare manages connections
- External API (Facebook Graph): ไม่มี keep-alive ข้าม requests

## 5. Deployment Patterns

### wrangler deploy
```bash
wrangler deploy  # bundle + upload + activate
```

**สิ่งที่เกิด:**
1. esbuild bundle source code
2. Upload bundle + assets to Cloudflare API
3. Create new version
4. Route traffic to new version (instant, no downtime)

**Pre-deploy checks ที่ควรทำ:**
- Build pass (TypeScript check)
- Branch = main (เราเพิ่ม deploy script แล้ว)
- No secrets in code (grep check)
- deploy-verify.sh หลัง deploy

### Gradual Rollout
- Workers Versions API รองรับ percentage rollout
- `wrangler versions deploy --percentage 10` → 10% traffic
- ยังไม่ได้ใช้ — ควรใช้เมื่อ App Review ผ่านแล้ว (multi-user)

## 6. Key Takeaways สำหรับ facebook-toolkit

### ทำแล้ว ✅
- Parameterized queries (SQL injection safe)
- Secret ใน wrangler secret
- Per-user KV keys
- R2 auth proxy
- Cache headers
- Token encryption (AES-256-GCM)
- Deploy script (main only)

### ควรเพิ่ม
1. **D1 batch operations** — auth callback ควร batch save user + pages
2. **ETag caching** — /api/posts conditional requests
3. **Gradual rollout** — เมื่อเปิด public
4. **Rate limit ที่ edge** — ใช้ Cloudflare Rate Limiting rules (ไม่ใช่แค่ KV counter)
5. **WAF rules** — bot protection whitelist สำหรับ FB crawler
6. **Error monitoring** — wrangler tail + structured logging

---

*Learned from: cloudflare/workers-sdk monorepo*
*Applied to: xToriMicz/facebook-toolkit*
