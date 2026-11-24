# Dina International - OpenCart Flutter App

This project is a Flutter application for **Dina International**, built to integrate with an OpenCart backend.

## Overview
This application provides a mobile shopping experience, featuring capabilities such as:
- Browsing categories and catalogs.
- Product search and details.
- Cart and checkout processes.
- User account management (registration, login, profile).
- Order history and tracking.



## Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (Flutter version 3.38.0)
- Android Studio or VS Code with Flutter plugins installed.
- Valid iOS/Android development environments.

### Run Instructions
1. Fetch project dependencies:
   ```bash
   flutter pub get
   ```
2. Run the application (using the `ocbuilder` flavor):
   ```bash
   flutter run --flavor ocbuilder
   ```

## Project Structure
- `lib/`: Contains the main source code for the application.
    - `network_manager/`: API client and networking logic.
    - `screens/`: UI screens and BLoC components.
    - `models/`: Data models used across the app.
    - `constants/`: Global constants and configurations.

