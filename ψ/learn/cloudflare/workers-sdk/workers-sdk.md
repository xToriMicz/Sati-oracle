# workers-sdk Learning Index

## Source
- **Origin**: ./origin/
- **GitHub**: https://github.com/cloudflare/workers-sdk

## Explorations

### 2026-03-25 1036 (fast)
- [2026-03-25/1036_OVERVIEW](2026-03-25/1036_OVERVIEW.md)

**Key insights**:
- KV eventually consistent — OK for sessions/tokens, not for counters
- D1 no explicit transactions — use db.batch() for atomic multi-statement
- Secret management via wrangler secret + .dev.vars (gitignored)
- R2 no per-object ACL — Workers auth proxy required
- Token encryption AES-256-GCM pattern matches what we built
