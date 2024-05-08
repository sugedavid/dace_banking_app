# DACE

Banking Flutter project.

## Getting Started

This project is a Flutter application.

A few resources on Flutter:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

To get started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Project set up

The project is configured with Firebase. To run it include a `firebase_options.dart` file at the root of the project. This file contains the firebase configuration.

## Running the project

To run it on Visual Studio Code, create a `launch.json` file:

```
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "banking_app",
            "request": "launch",
            "type": "dart"
        },
        {
            "name": "banking_app (profile mode)",
            "request": "launch",
            "type": "dart",
            "flutterMode": "profile"
        },
        {
            "name": "banking_app (release mode)",
            "request": "launch",
            "type": "dart",
            "flutterMode": "release"
        }
    ]
}
```
