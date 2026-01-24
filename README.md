![GitHub release (latest by date)](https://img.shields.io/github/v/release/Ner0nWinTb/HytaleUpdater?color=green&label=Latest%20Version)
![GitHub All releases](https://img.shields.io/github/downloads/Ner0nWinTb/HytaleUpdater/total?color=blue&label=Downloads)
![GitHub license](https://img.shields.io/github/license/Ner0nWinTb/HytaleUpdater?color=orange)


# HytaleUpdater Beta

A simple, automated tool to update the game using **Butler**.
This package includes everything you need to download and apply the latest patches safely.

<img width="654" height="434" alt="image" src="https://github.com/user-attachments/assets/edbd8424-ade4-44e8-8f27-8ca8741640e5" />







## 🚀 Features

### ✨ New in v2.5

* 🚀 **Support for Update 2 (Jan 24):** Updated repository links to the latest stable patch. The menu now displays exact file sizes `(71.1MB)` to ensure transparency before downloading.
* 🛡️ **Smart Safety System:** Added a new logic layer that checks for a backup before updating. If you select **Option [1]** and no backup exists, the script will prompt you to create one—ensuring you can instantly revert if the new version breaks Multiplayer compatibility.
* ☕ **Auto Java-Fix (Day-One Patch):** Automatically downloads and installs a patched `HytaleServer.jar` when installing Update 2. This enables immediate **Singleplayer** access while waiting for a new Online-Fix.
* 💾 **UserData Manager:** Renamed from "Save Manager" to clearly indicate it handles all user data (Worlds, Avatars, Settings). Added checks to prevent overwriting data during version swaps.
* ⚠️ **Pre-Release Cleanup:** Officially dropped support for the experimental "Pre-Release" build to prevent file corruption. The updater now strictly enforces the Stable Release path.

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
