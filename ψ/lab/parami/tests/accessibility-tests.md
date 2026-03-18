# Accessibility Tests — WCAG 2.1 AA Checklist

> Sati Oracle (สติ) — "ทุกคนต้องเข้าถึงได้ — Everyone must have access"

## Target: WCAG 2.1 Level AA

---

## 1. Perceivable

### 1.1 Text Alternatives

- [ ] All `<img>` have meaningful `alt` text
- [ ] Decorative images use `alt=""` or CSS background
- [ ] Icon buttons have `aria-label` or visually hidden text
- [ ] SVG icons have `role="img"` and `aria-label`
- [ ] Complex images have extended description

### 1.2 Time-Based Media

- [ ] Videos have captions
- [ ] Audio content has transcript
- [ ] Auto-playing media can be paused

### 1.3 Adaptable

- [ ] Content follows logical reading order in DOM
- [ ] Headings use proper hierarchy (h1 → h2 → h3)
- [ ] Lists use `<ul>`, `<ol>`, `<dl>` appropriately
- [ ] Tables have `<th>` with scope attributes
- [ ] Form inputs have associated `<label>`
- [ ] Landmark roles used (`<nav>`, `<main>`, `<aside>`, `<footer>`)
- [ ] Page has exactly one `<main>` element
- [ ] Content is meaningful without CSS

### 1.4 Distinguishable

- [ ] Text color contrast ≥ 4.5:1 (normal text)
- [ ] Text color contrast ≥ 3:1 (large text ≥ 18pt / 14pt bold)
- [ ] UI component contrast ≥ 3:1 against background
- [ ] Focus indicator contrast ≥ 3:1
- [ ] Text can be resized to 200% without loss of content
- [ ] No information conveyed by color alone
- [ ] No content lost when zoomed to 400%
- [ ] Text spacing can be overridden without breaking layout

---

## 2. Operable

### 2.1 Keyboard Accessible

- [ ] All interactive elements reachable by Tab
- [ ] Tab order is logical (left→right, top→bottom)
- [ ] Focus is visible on all interactive elements
- [ ] No keyboard traps (can always Tab/Escape out)
- [ ] Skip-to-content link present and functional
- [ ] Custom widgets support expected key patterns (Enter, Space, Arrow keys)
- [ ] Modal focus is trapped within modal when open
- [ ] Focus returns to trigger element when modal closes

### 2.2 Enough Time

- [ ] Session timeout gives warning before expiry
- [ ] User can extend or disable timeouts
- [ ] Auto-updating content can be paused

### 2.3 Seizures and Physical Reactions

- [ ] No content flashes more than 3 times per second
- [ ] Animations respect `prefers-reduced-motion`

### 2.4 Navigable

- [ ] Page has descriptive `<title>`
- [ ] Focus order matches visual order
- [ ] Link text is descriptive (no "click here")
- [ ] Multiple ways to find pages (nav, search, sitemap)
- [ ] Headings and labels describe their sections
- [ ] Section headings organize content

### 2.5 Input Modalities

- [ ] Touch targets ≥ 44x44 CSS pixels
- [ ] Drag operations have alternative input
- [ ] Actions triggered on up-event (not down-event)

---

## 3. Understandable

### 3.1 Readable

- [ ] Page `lang` attribute set correctly (`<html lang="th">` or `lang="en"`)
- [ ] Language changes marked with `lang` attribute on elements
- [ ] Text is readable and not overly complex

### 3.2 Predictable

- [ ] Navigation is consistent across pages
- [ ] Components behave consistently across pages
- [ ] No unexpected context changes on focus or input
- [ ] Form submission requires explicit action (button click)

### 3.3 Input Assistance

- [ ] Error messages identify the field with the error
- [ ] Error messages suggest how to fix the problem
- [ ] Required fields are marked before submission
- [ ] Labels clearly describe expected input
- [ ] Important submissions have confirmation or undo

---

## 4. Robust

### 4.1 Compatible

- [ ] HTML validates (no duplicate IDs)
- [ ] All elements have complete start/end tags
- [ ] ARIA roles and properties are valid
- [ ] `aria-describedby` and `aria-labelledby` point to existing IDs
- [ ] Dynamic content changes announced via `aria-live`
- [ ] Status messages use `role="status"` or `role="alert"`

---

## Tools for Testing

| Tool                    | Purpose                        |
|-------------------------|--------------------------------|
| axe DevTools (browser)  | Automated WCAG scan            |
| Lighthouse (Chrome)     | Accessibility score            |
| WAVE                    | Visual accessibility report    |
| NVDA / VoiceOver        | Screen reader testing          |
| Keyboard only           | Navigate without mouse         |
| Colour Contrast Checker | Verify contrast ratios         |
| HTML Validator (W3C)    | Markup validation              |

---

## Test Results

| Date | Tester | Tool Used | Score/Issues | Notes |
|------|--------|-----------|--------------|-------|
|      |        |           |              |       |
