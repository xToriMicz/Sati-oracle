# Frontend Manual Test Checklist — Sati Oracle (สติ)

> "ตรวจด้วยตา ทดสอบด้วยมือ — Inspect with eyes, test with hands"

## How to Use

- [ ] = not tested
- [x] = passed
- [!] = failed (add note)

---

## 1. Navigation

- [ ] Logo links to home page
- [ ] All nav links navigate to correct pages
- [ ] Active page is visually highlighted in nav
- [ ] Mobile hamburger menu opens/closes
- [ ] Back/forward browser buttons work correctly
- [ ] 404 page displays for invalid routes

## 2. Layout & Responsive

- [ ] Desktop (1920px) — layout correct, no overflow
- [ ] Laptop (1366px) — layout adjusts properly
- [ ] Tablet (768px) — columns stack appropriately
- [ ] Mobile (375px) — single column, readable text
- [ ] No horizontal scrollbar at any breakpoint
- [ ] Images scale without distortion
- [ ] Touch targets ≥ 44x44px on mobile

## 3. Forms

- [ ] Required fields show validation on empty submit
- [ ] Email fields reject invalid format
- [ ] Password fields have visibility toggle
- [ ] Form submits successfully with valid data
- [ ] Success/error messages display clearly
- [ ] Submit button shows loading state
- [ ] Double-submit prevented
- [ ] Form preserves input on validation error
- [ ] Tab order follows logical sequence

## 4. Authentication

- [ ] Login form works with valid credentials
- [ ] Login shows error for invalid credentials
- [ ] Logout clears session and redirects
- [ ] Protected pages redirect to login when unauthenticated
- [ ] Session persists on page refresh
- [ ] Password reset flow works end-to-end

## 5. Data Display

- [ ] Lists load and display data correctly
- [ ] Empty state shown when no data
- [ ] Loading spinner/skeleton shows during fetch
- [ ] Error state shown on API failure
- [ ] Pagination works (if applicable)
- [ ] Search/filter updates results correctly
- [ ] Sort order changes correctly

## 6. CRUD Operations

- [ ] Create — new item appears in list after creation
- [ ] Read — detail view shows all fields
- [ ] Update — changes persist after save
- [ ] Delete — confirmation dialog appears
- [ ] Delete — item removed from list after confirm
- [ ] Optimistic updates revert on failure

## 7. Interactions

- [ ] Buttons have hover/active/focus states
- [ ] Modals open/close correctly
- [ ] Modals close on overlay click and Escape key
- [ ] Tooltips appear on hover
- [ ] Dropdown menus open/close correctly
- [ ] Toast/snackbar notifications appear and auto-dismiss
- [ ] Copy-to-clipboard works (if applicable)

## 8. Media

- [ ] Images load with alt text
- [ ] Broken images show fallback
- [ ] Videos play correctly (if applicable)
- [ ] Icons render at correct size
- [ ] Favicon displays in browser tab

## 9. Cross-Browser

| Browser         | Version | Status |
|-----------------|---------|--------|
| Chrome          | latest  | [ ]    |
| Firefox         | latest  | [ ]    |
| Safari          | latest  | [ ]    |
| Edge            | latest  | [ ]    |
| Safari (iOS)    | latest  | [ ]    |
| Chrome (Android)| latest  | [ ]    |

## 10. Dark Mode (if applicable)

- [ ] Toggle switches between light/dark
- [ ] All text readable in both modes
- [ ] No invisible elements in either mode
- [ ] Preference persists on refresh

## 11. Error States

- [ ] Network error shows retry option
- [ ] API timeout shows appropriate message
- [ ] JavaScript error does not crash entire app
- [ ] Console has no uncaught errors in normal flow

## 12. Performance (Perceived)

- [ ] First meaningful paint < 2 seconds
- [ ] No visible layout shift after load
- [ ] Scrolling is smooth (60fps)
- [ ] Route transitions feel instant or show progress

---

## Test Notes

| Date | Tester | Browser | Notes |
|------|--------|---------|-------|
|      |        |         |       |
