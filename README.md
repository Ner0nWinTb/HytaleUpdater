![GitHub release (latest by date)](https://img.shields.io/github/v/release/Ner0nWinTb/HytaleUpdater?color=green&label=Latest%20Version)
![GitHub All releases](https://img.shields.io/github/downloads/Ner0nWinTb/HytaleUpdater/total?color=blue&label=Downloads)
![GitHub license](https://img.shields.io/github/license/Ner0nWinTb/HytaleUpdater?color=orange)


# HytaleUpdater Beta

A simple, automated tool to update the game using **Butler**.
This package includes everything you need to download and apply the latest patches safely.

<img width="656" height="445" alt="image" src="https://github.com/user-attachments/assets/d0272fd2-86d3-4da6-8be1-160b8a475024" />





## 🚀 Features

### 🌟 New in v2.4

* **💾 Save Manager (Import / Export):** Added a dedicated menu (Option `[3]`) to backup your `Client\UserData`. This ensures your **Worlds, Avatars, and Settings** remain safe when switching between Stable and Pre-Release versions or reinstalling the game.
* **🔇 Silent Backup & Auto-Cleanup:** The Backup and Restore processes now run quietly in the background (no console spam) and automatically delete temporary files after a successful restore to save disk space.
* **🔧 Critical Logic Fixes:** Fixed a bug where navigating the menus could cause the script to crash on certain systems (rewritten `if` statements to safer `goto` logic).

### ⚡ Core Capabilities
* **All-in-One Patcher:** Includes `butler.exe` to handle efficient delta-patching directly from the official servers.
* **Integrated Online-Fix:** Built-in menu to download and install the latest Online-Fix for multiplayer support (Stable version only).
* **🔄 Built-in Updater:** Includes a dedicated menu option to update the script itself from GitHub, ensuring you always have the latest fixes and links.
* **Access Denied Prevention:** Automatically cleans up temporary staging directories (`butler_staging_area`) to prevent permission errors during updates.

## 📋 Prerequisites
1. You must have the **Hytale** game installed. (Crack Supported🏴‍☠️)
2. Ensure the game and launcher are **closed** before updating.

## 🛠️ How to Use
1. Download the [latest release](https://github.com/Ner0nWinTb/HytaleUpdater/releases/latest) `.zip` package.
2. Extract **all files** (the script and `butler.exe`) into your main **Hytale** folder (where the Launcher is located).
3. Run `HytaleUpdater.bat`.
4. Follow the instructions on the screen.

## ⭐ Star History

<a href="https://www.star-history.com/#Ner0nWinTb/HytaleUpdater&type=date&legend=top-left">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=Ner0nWinTb/HytaleUpdater&type=date&theme=dark&legend=top-left" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=Ner0nWinTb/HytaleUpdater&type=date&legend=top-left" />
   <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=Ner0nWinTb/HytaleUpdater&type=date&legend=top-left" />
 </picture>
</a>

## ⚠️ Note
This is a community-made tool. It is not officially affiliated with the game developers.

## 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
