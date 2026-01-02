# Soroban

A macOS application for the traditional Japanese abacus (soroban). This app provides an interactive digital soroban with a retro Mac OS aesthetic.

## Features

- Interactive 13-rod soroban abacus
- Heaven beads (blue) representing 5 units each
- Earth beads (silver) representing 1 unit each
- Real-time calculation display
- Clean, minimalist retro Mac OS design
- Fixed window size for consistent experience

## Usage

### Installation

1. Open the `Soroban.dmg` file
2. Drag `Soroban.app` to your Applications folder
3. Launch Soroban from Applications

### How to Use

- Click heaven beads (blue) to add or remove 5 units
- Click earth beads (silver) to add or remove 1 unit
- Clicking an earth bead activates all beads up to that position
- The total value is displayed at the top
- Use the Clear button to reset all beads

## Building

To build the project:

```bash
xcodebuild -project Soroban.xcodeproj -scheme Soroban -configuration Release build
```

The built app will be in `~/Library/Developer/Xcode/DerivedData/Soroban-*/Build/Products/Release/Soroban.app`

## Requirements

- macOS 15.4 or later
- Xcode 16.4 or later (for building)

## License

Copyright 2026
