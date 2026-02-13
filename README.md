# 💖 Pixel Valentine

A retro-themed, pixel-art Flutter application designed as a digital Valentine's Day proposal. This app creates an immersive invitation experience, featuring a gamified proposal, a countdown timer to the big date, and a shared bucket list for future plans.

> **Target Date:** February 14, 2026  
> **Theme:** 90s OS / Gameboy / Pixel Art  
> **Style:** Pastel Pink & Mint Green

---

## 🎮 Features

### 1. **The Proposal ("Level 1")**

* **Gamified Interaction:** A "Will you be my Valentines?" screen.
* **Runaway "No" Button:** The "No" button locks and plays an error sound if clicked, preventing rejection in a playful way.
* **Explosive Acceptance:** Clicking "Yes" triggers a pixel-flower confetti explosion and a success fanfare.

### 2. **The Countdown ("Mission Status")**

* **System-Time Sync:** Automatically calculates the remaining days, hours, and minutes until **Feb 14, 2026** based on the user's local device time.
* **Retro UI:** The timer is encased in a floating, 3D-beveled "Pixel Window" (Mission_Status.exe) with a monochrome LCD display style.
* **Dynamic Background:** Falling pixel-art flowers with a frosted glass overlay.

### 3. **The Reveal ("Level Cleared")**

* **Unlockable Content:** Once the timer hits zero (or if the date has passed), the app unlocks the Bouquet Screen.
* **Animated Bouquet:** A high-quality pixel art bouquet GIF with an elastic "pop" entrance.
* **Future Plans Board:** A scrollable "Bucket List" section where the user can add/edit up to 5 future goals (e.g., "Buy a house," "Travel to Japan").

### 4. **Aesthetic & Polish**

* **CRT Overlay:** A global scanline effect applied to all screens to mimic old monitors.
* **Sound Effects:** 8-bit SFX for clicks, errors, and success events.
* **Custom Typography:** Uses **Jersey 10** (Google Fonts) for that authentic arcade text feel.
* **Mechanical UI:** Custom-built buttons with 3D depression states and shadows.

---

## 🛠️ Tech Stack

* **Framework:** Flutter (Dart)
* **State Management:** `ValueNotifier` (Simple & efficient)
* **Persistence:** `shared_preferences` (For saving the "Accepted" state and "Future Plans")
* **Audio:** `audioplayers`
* **Fonts:** `google_fonts`

---

## 📂 Project Structure

```text
lib/
├── core/
│   ├── models/       # Enums (AppPhase)
│   ├── services/     # Logic (Date, Sound, Storage)
│   └── ui/           # Reusable Widgets (PixelButton, CrtOverlay, PixelWindow)
├── features/
│   ├── bouquet/      # The final reveal screen
│   ├── countdown/    # The timer screen
│   ├── notes/        # Future Plans board logic
│   └── proposal/     # The "Yes/No" screen
├── app.dart          # Theme & Routing
└── main.dart         # Entry point
```

---

## 🚀 Setup & Installation

1. **Prerequisites:**

* Flutter SDK installed.
* An IDE (VS Code or Android Studio).

1. **Clone/Download:**
Download the project files.
2. **Install Dependencies:**

```bash
flutter pub get
```

1. **Asset Setup:**
Ensure your `assets/` folder is structured exactly like this:

```text
assets/
├── bouquet_looped.gif            # The main bouquet animation
├── sounds/
│   ├── click.mp3          # UI interaction sound
│   ├── error.mp3          # "No" button locked sound
│   └── success.mp3        # "Yes" button fanfare
└── flowers/
    ├── 1.png through 12.png  # Individual flower sprites
```

1. **Run the App:**

```bash
flutter run
```

---

## 🎨 Asset Credits

* **Font:** [Jersey 10](https://fonts.google.com/specimen/Jersey+10) via Google Fonts.
* **Audio:** freesoundcommunity (Pixabay).
* **Graphics:** Custom Pixel Art assets.

---

## 🕹️ Controls (Debug)

* **Debug Button:** Located at the bottom right of the Proposal screen (icon: 🐞).
* *Action:* Forces the app to skip the countdown and unlock the Bouquet screen immediately for testing animations.
