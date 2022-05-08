# swap_shop

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

Downloads/Installations needed:
[Visual Studio Code](https://code.visualstudio.com/)

[Flutter](https://docs.flutter.dev/get-started/install?gclid=EAIaIQobChMI07Sx2tTw9gIVytPtCh2qEggXEAAYASAAEgIe9PD_BwE&gclsrc=aw.ds)

[Android Studio](https://developer.android.com/studio)

[Firebase](https://firebase.google.com/)

[How to install and set up Flutter on VS Code and set up with Android Studio](https://www.youtube.com/watch?v=tun0HUHaDuE)

[How to set up Firebase](https://www.youtube.com/watch?v=QZ_53nSPgPg)

=======
[How to install and set up Flutter on VS Code and set up with Android Studio](https://www.youtube.com/watch?v=tun0HUHaDuE)


A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## Architecture Description

Swap Shop's architecture consists of both front-end and back-end applications, which can all be installed on a PC (see "Getting Started").

### Firebase
Firebase is a platform developed by Google for creating mobile and web applications. Swap Shop makes use of the back-end platform as it is:
 -cloud-based
 -allows for viewing, adding, editing, and deletion of data.
 -allows for us to manage indexes and monitor usage.
 -uses Firebase Authentication and Cloud Firestore Security Rules to handle serverless authentication, authorization, and data validation
 -keeps your data private and secure
 -very low maintenance
Swap Shop application is integrated with Firebase via VS Code.

### Android Studio
Android Studio is the official integrated development environment for Google's Android operating system, built on JetBrains' IntelliJ IDEA software and designed specifically for Android development. Flutter makes use of the Android SDK, and sets the environment variable to the SDK path for the flutter installation to recognise it, allowing for the front-end developemnt of the Swap Shop application.

### VS Code
Visual Studio Code, also commonly referred to as VS Code, is a source-code editor made by Microsoft for Windows, Linux and macOS. Swap Shop uses VS Code as an editor to run,edit and make the application with the Flutter development kit.

### Flutter
Flutter is an open-source UI software development kit created by Google. It is used to develop cross platform applications for Android, iOS, Linux, macOS, Windows, Google Fuchsia, and the web from a single codebase. Swap Shop makes use of the development kit alongside Android Studio and VS Code for the front-end development of the application. We make use of the Dart as the programming language as it is stable and creates high-performance applications as it is an object-oriented language.  


## Project Description

In an effort to avoid waste and grow communities, many people have begun operating swap shops, where people swap food, clothes, furniture, etc. In this project we will be designing and implementing an app to facilitate this process for a community. Among other features, users will be able to:

•	Create a profile in which they will use to sign in to use the application

•	Create a listing in which they will be able take a picture and add a description of the item they wish to swap, which may include food, clothes, etc.

•	Browse through listed items (which will include a sort, filter, and search feature in later stages)

•	Contact people who have listed an item they wish to swap, which will be via a chat system

•	Keep track of what will be traded during a swap

•	Organise to meet once a swap has been agreed upon such as a pickup/drop off service or delivery (with measures in place to avoid scams and other dangers)

•	Use a rating system to rate products/users

•	Use a trade window whereby they will be allowed to compare trades, add to trades, make listing private, etc. 

•	Be able to report other users 

## How to Intsall and Run Project

Go to "Code", select "Download ZIP file"


Extract files, open Visual Studio Code (if you have not downloaded and set it up check out "Getting Started") and Open Folders

Open "SubZero-Inc-main" and select emulator and click "Run and Debug"

## CircleCI Badge

[![CircleCI](https://circleci.com/gh/Naturekhosa/SubZero-Inc/tree/BrowseListings.svg?style=svg)](https://circleci.com/gh/Naturekhosa/SubZero-Inc/tree/BrowseListings)
=======
Extract files, open Visual Studio Code (if you have not downloaded and set it up check out "Get Started") and Open Folders
Open "SubZero-Inc-main" and select emulator and click "Run and Debug"

## Badge

[![CircleCI](https://dl.circleci.com/insights-snapshot/gh/Naturekhosa/SubZero-Inc/BrowseListings/Build Error/badge.svg?window=30d)](https://app.circleci.com/insights/github/Naturekhosa/SubZero-Inc/workflows/Build Error/overview?branch=BrowseListings&reporting-window=last-30-days&insights-snapshot=true) 

