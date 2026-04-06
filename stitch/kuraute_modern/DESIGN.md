# Design System Strategy: Nepal-Modern

## 1. Overview & Creative North Star
The creative North Star for this design system is **"The Living Mandala."** 

Unlike generic gaming interfaces that rely on heavy neon glows and aggressive "gamer" aesthetics, this system draws inspiration from the modern Nepali identity—vibrant, communal, and deeply layered. We aim for an **"Organic Editorial"** look: combining the high-energy pulse of a social game with the sophisticated structural integrity of a premium lifestyle app. 

We break the "template" look by rejecting rigid, boxy layouts in favor of **intentional asymmetry** and **overlapping depth**. Content should feel like it is floating on a series of curated surfaces, utilizing high-contrast typography scales and tactile, rounded geometry to create a sense of suspense and play.

---

## 2. Color & Surface Architecture

### The Palette
We utilize a core of **Crimson (`primary`)** and **Gold (`secondary`)**, balanced by a sophisticated "Off-White" environment to ensure the game feels premium rather than toy-like.

*   **Primary (Crimson):** `#ca0033` – Use for high-action CTAs and critical game states.
*   **Secondary (Gold):** `#776300` – Use for progression, rewards, and "winning" moments.
*   **Tertiary (Indigo-Slate):** `#565abb` – Used as a "suspense" color for social interactions or hidden elements.

### The "No-Line" Rule
**Borders are strictly prohibited for sectioning.** To define space, designers must use background color shifts. A `surface-container-low` section sitting on a `surface` background provides enough contrast to signify a boundary without the visual "noise" of a 1px line.

### Surface Hierarchy & Nesting
Treat the UI as a physical stack of fine materials.
*   **Level 0 (Base):** `surface` (`#fefdf1`).
*   **Level 1 (Sectioning):** `surface-container-low` (`#fbfaed`).
*   **Level 2 (Active Cards):** `surface-container-highest` (`#e9e9da`).
*   **Level 3 (Floating Modals):** `surface-lowest` (`#ffffff`) with a high blur shadow.

### The "Glass & Gradient" Rule
To add "soul," use **Radial Gradients** on hero backgrounds, transitioning from `primary` (#ca0033) to `primary-container` (#ff757b). For floating social overlays, apply **Glassmorphism**: use `surface-variant` at 60% opacity with a `20px` backdrop-blur to allow the game's energy to bleed through the UI.

---

## 3. Typography
The typography strategy pairs the geometric precision of **Plus Jakarta Sans** (English) with the soulful clarity of **Manrope** and Devanagari equivalents like **Mukta**.

*   **Display (Plus Jakarta Sans):** Set at `3.5rem` with tight tracking. This is our "Voice." It should feel loud and energetic.
*   **Headlines:** Used for game headers. The scale shift between `headline-lg` (`2rem`) and `body-md` (`0.875rem`) creates the "Editorial" tension that makes the app feel high-end.
*   **Body (Manrope / Mukta):** Prioritizes legibility during high-speed social play. Manrope’s modern proportions ensure that English and Devanagari script sit harmoniously on the same line without jarring x-height shifts.

---

## 4. Elevation & Depth

### The Layering Principle
Depth is achieved through **Tonal Layering**. Instead of using shadows to define every button, place a `surface-container-lowest` card on a `surface-container-high` background. This creates a "soft lift" that feels mobile-native and modern.

### Ambient Shadows
When an element must float (e.g., a "New Message" toast or a "Play Now" button):
*   **Shadow Blur:** `32px` to `48px`.
*   **Opacity:** `4%` to `8%`.
*   **Color:** Use a tinted shadow (`#600013` at 5% alpha) rather than pure black to keep the Crimson energy alive even in the shadows.

### The "Ghost Border" Fallback
If accessibility requires a container edge, use the **Ghost Border**: `outline-variant` at **15% opacity**. This provides a hint of structure without breaking the organic flow of the "Living Mandala" concept.

---

## 5. Components

### Buttons (Tactile & High-Energy)
*   **Primary:** `primary` background with `on-primary` text. **Radius:** `full` (pill-shaped) or `xl` (`3rem`). Add a subtle inner-glow (top-down white gradient at 10%) to give it a "pressable" tactile feel.
*   **Secondary:** `secondary-container` background. No border.

### Cards & Social Feeds
*   **Rule:** Forbid divider lines.
*   **Spacing:** Use `spacing-6` (`1.5rem`) to separate content blocks. 
*   **Treatment:** Use a slight `surface-container` shift to group related social posts. Use `rounded-lg` (`2rem`) for all card containers to maintain the playful, soft-modern vibe.

### Input Fields
*   **Style:** Minimalist. No bottom line. Instead, use a `surface-container-highest` fill with `rounded-md` corners. 
*   **Focus State:** The background should shift to `primary-container` at 20% opacity, with the cursor in `primary` (Crimson).

### Chips (Game Tags)
*   **Style:** Small, high-contrast pills. Use `tertiary-container` for social tags to differentiate them from game-mechanic tags (which use `primary-container`).

---

## 6. Dark Mode: "Temple Night"
The dark mode proposal shifts the `surface` to **Deep Charcoal (`#0d0f08`)**. 
*   **Primary colors** remain vibrant but are "dimmed" slightly to avoid eye strain (use `primary-dim` and `secondary-dim`).
*   **Surface layering** is inverted: the deeper the layer, the darker the grey, creating a "pit" effect that enhances the suspense of the game.

---

## 7. Do’s and Don’ts

### Do
*   **Do** use asymmetrical margins. If the left margin is `spacing-4`, try the right margin at `spacing-8` for hero elements to create a bespoke, non-generic feel.
*   **Do** use the Gold (`secondary`) sparingly as a "reward" color—it should feel earned.
*   **Do** ensure Mukta (Devanagari) line-heights are 1.5x the font size to prevent character clipping.

### Don’t
*   **Don’t** use pure black (`#000000`) for shadows or text; use `on-surface-variant` for a softer, more premium contrast.
*   **Don’t** use 16px (standard) corners if 24px (`rounded-md`) or 32px (`rounded-lg`) fits; lean into the "Hyper-Rounded" playful aesthetic.
*   **Don’t** use standard "Slide-in" transitions. Use "Spring" physics with a slight scale-up (0.95 to 1.0) to make the UI feel alive.