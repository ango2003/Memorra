# Project Title
Memorra

## Description
A mobile-first application that helps the user create reminders for important dates and create gift lists to organize gift ideas for friends and family.

## Installation

    Install Required Software:
        Install Visual Studio Code:(https://code.visualstudio.com/download)
        Install Flutter: https://docs.flutter.dev/install 
            If using Visual Studio Code and open the terminal, click quick start up when accessing the link, and follow up to step 4 of “Install and set up Flutter.”
            It is recommended you choose a safe place to keep the Flutter SDK.
        Make sure that you have installed Git for your operating system: https://git-scm.com/install/windows

    Set up Flutter:
        Open Visual Studio Code and navigate to Memorra Folder and the flutter_frontend directory: cd flutter_frontend
        Verify that flutter has been installed properly: flutter doctor
        Resolve any issues that may arise(e.g. Missing Android SDK)
            Android Licenses may need to be accepted: flutter doctor --android-licenses

    Clone Repository:
        In Visual Studio Code, press CTRL+SHIFT+P to open Command Palette.
        Type git clone, and select Git:Clone and provide Memorra URL.
        Enter Memorra Repository: https://github.com/ango2003/Memorra.git
        If prompted, log into Github 
        Select the local directory to store Memorra.

    Install Project Dependencies:
        Run in the Visual Studio Code terminal: flutter pub get.

    Running Memorra:
        Physical mobile device(Android)
            Enter Developer Mode on mobile device
            Enable USB Debugging
            Connect Device to Computer
            Allow USB Debugging prompt on phone by granting permission.
            On Visual Studio Code: CTRL + SHIFT + P ⇒ Flutter: Select Device
            Select connected device
            Move to the flutter_frontend depository, then type flutter run in terminal

        Android Emulator
            Install Android Studio(https://developer.android.com/studio)
                Ensure Android SDK, Android SDK Platform Tools, and Android Virtual Device Manager are selected
            Navigate to settings > Languages & Frameworks > Android SDK, and verify that at least one recent Android SDK is installed( e.g. Android 16.0(“Baklava”))
            Create an Android Virtual Device, open device manager > Add a new device > Create Virtual Device
            Select preferred phone, click next, then finish
            After installation, Open visual studio code, click devices on bottom right(Right next to bell)
            Select preferred phone, Start mobile emulator cold boot
            After phone boots up, navigate to flutter_frontend dependency: cd flutter_frontend

            Run app: flutter run

        iOS Emulator(macOS only)
            Install Xcode(https://apps.apple.com/us/app/xcode/id497799835?mt=12)
            Open Terminal and run: xcode-select –install
            Run: sudo gem install cocoapods
            Verify: pod –version
            Open Xcode, go to Xcode > Open Developer Tool > Simulator
            Verify Flutter detects simulator: flutter devices
            Run app from flutter_frontend directory: flutter run

## Features

## Tech Stack
- Flutter
- Firebase Authentication
- Firestore Firebase
- Firebase Cloud Messaging

## Credits
Created by: Aaron Ngo, Caden Cash, Asher Wise