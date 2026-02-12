# My Portfolio App

A Flutter-based portfolio application designed to showcase skills and projects, featuring an admin interface for dynamic content management.

## Features

- **Hero Editor**: Easily update the hero section text and imagery.
- **Skills Editor**: Add, remove, and modify skills with details.
- **Admin Dashboard**: Secure interface for managing portfolio content.
- **Firebase Integration**:
     - **Firestore**: Real-time data storage for portfolio content.
     - **Authentication**: Secure login for admin access.
- **Responsive Design**: Built with Flutter to work across web and mobile.

## Tech Stack

- **Frontend**: Flutter (Dart)
- **State Management**: GetX
- **Backend**: Firebase (Firestore, Auth)
- **Fonts**: Google Fonts

## Getting Started

Follow these steps to set up the project locally.

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed.
- A Firebase project set up.

### Installation

1. **Clone the repository:**

      ```bash
      git clone https://github.com/yourusername/my_portfolio_app.git
      cd my_portfolio_app
      ```

2. **Install dependencies:**

      ```bash
      flutter pub get
      ```

3. **Firebase Setup:**
      - Configure your Firebase project.
      - Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) files if targeting mobile.
      - For web, ensure your firebase configuration is set up in `lib/firebase_options.dart` (using `flutterfire configure`).

4. **Run the app:**

      ```bash
      flutter run
      ```
