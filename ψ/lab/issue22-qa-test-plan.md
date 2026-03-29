# Issue #22 QA Test Plan — project.sh + Project Tab

## Test Categories

### A. Happy Path — ทุก command ทำงานปกติ

| # | Test | Command | Expected |
|---|------|---------|----------|
| A1 | Create project | `project.sh create "Test Feature" facebook-toolkit sati` | PRJ-xxx created, ACTIVE 0%, entry in projects.jsonl |
| A2 | Join project | `project.sh join PRJ-xxx jingjing "frontend UI"` | Worker added, projects.jsonl updated |
| A3 | Update progress | `project.sh progress PRJ-xxx 50` | Progress = 50% |
| A4 | Worker status | `project.sh worker-status PRJ-xxx sati working` | Worker status = working |
| A5 | Log activity | `project.sh log PRJ-xxx sati "implement" "API done"` | Activity log entry added |
| A6 | List projects | `project.sh list` | Shows all projects |
| A7 | Get project | `project.sh get PRJ-xxx` | Shows project detail |
| A8 | Close project | `project.sh close PRJ-xxx "Feature complete"` | Status=CLOSED, progress=100% |

### B. Full Lifecycle — สร้างจนปิด

| # | Test | Steps |
|---|------|-------|
| B1 | Full flow | create → join → progress(25,50,75) → worker-status(done) → log(qa-pass) → close |
| B2 | With QA fail | create → work → qa-fail → fix → qa-pass → close |
| B3 | With DevOps | create → work → devops-ack → hard-qa-pass → deployed → close |

### C. Edge Cases

| # | Test | Command | Expected |
|---|------|---------|----------|
| C1 | Duplicate join | `project.sh join PRJ-xxx sati "task"` (already joined) | Error or update existing worker |
| C2 | Progress > 100 | `project.sh progress PRJ-xxx 150` | Error: max 100 |
| C3 | Progress < 0 | `project.sh progress PRJ-xxx -10` | Error: min 0 |
| C4 | Progress non-number | `project.sh progress PRJ-xxx abc` | Error: must be number |
| C5 | Close closed project | `project.sh close PRJ-xxx "again"` (already closed) | Error or no-op |
| C6 | Join closed project | `project.sh join PRJ-xxx sati "late"` (closed) | Error: project closed |
| C7 | Invalid PRJ ID | `project.sh get PRJ-999999` | Error: not found |
| C8 | Missing args | `project.sh create` (no title) | Usage help |
| C9 | Empty title | `project.sh create "" repo agent` | Error: title required |
| C10 | Special chars | `project.sh create "งาน 'test' & <script>" repo agent` | Title sanitized, no injection |

### D. Parallel / Concurrency

| # | Test | Scenario | Expected |
|---|------|----------|----------|
| D1 | 2 agents progress | sati progress 50, jingjing progress 60 (near-simultaneous) | Last write wins, no corruption |
| D2 | 2 agents join | sati join + jingjing join same PRJ simultaneously | Both added, no duplicate |
| D3 | Log while close | agent logs while another closes | Close wins, log may fail gracefully |

### E. Data Format — projects.jsonl

| # | Check |
|---|-------|
| E1 | Each line is valid JSON |
| E2 | Has required fields: project_id, title, repo, status, progress, workers, logs, created_at |
| E3 | Dedup: last entry per project_id wins |
| E4 | Nothing is Deleted: closed projects still in file |
| E5 | Timestamps are ISO format |
| E6 | Worker has: name, role, status |
| E7 | Log has: timestamp, agent, action, detail |

### F. Security

| # | Check |
|---|-------|
| F1 | No command injection via title/detail fields |
| F2 | No path traversal in project IDs |
| F3 | File permissions correct on projects.jsonl |
| F4 | Git push doesn't include secrets |
