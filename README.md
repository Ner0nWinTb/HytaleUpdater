![GitHub release (latest by date)](https://img.shields.io/github/v/release/Ner0nWinTb/HytaleUpdater?color=green&label=Latest%20Version)
![GitHub All releases](https://img.shields.io/github/downloads/Ner0nWinTb/HytaleUpdater/total?color=blue&label=Downloads)
![GitHub license](https://img.shields.io/github/license/Ner0nWinTb/HytaleUpdater?color=orange)


# HytaleUpdater Beta

A simple, automated tool to update the game using **Butler**.
This package includes everything you need to download and apply the latest patches safely.

<img width="642" height="453" alt="image" src="https://github.com/user-attachments/assets/6a17ddde-a90e-4231-b1dd-8082f5c1d8d2" />




## 🚀 Features

### 🌟 New in v2.3
* **💾 Smart Backup System:** Switch between **Stable** (Online) and **Pre-Release** (Offline) versions in seconds! The script creates a local mirror of your game files, so you never have to redownload the full game when swapping versions.
* **☕ Auto Java-Fix (Local Server Patch):** Automatically downloads and applies a **modified `HytaleServer.jar`** for the Pre-Release build. This patched file bypasses authentication checks, allowing the local server to start correctly for Singleplayer.
* **🛡️ Robust Error Handling:** Rewritten logic ensures the script won't crash on special characters in links or file paths.

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

## ⚠️ Note
This is a community-made tool. It is not officially affiliated with the game developers.

## 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
