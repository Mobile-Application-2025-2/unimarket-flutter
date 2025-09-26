# Unimarket - Flutter group 43

| Nombre              |              |
| ------------------- | ------------ |
| Daniel Felipe Ortiz | df.ortizv1   |
| Julian Rolon        | j.rolont     |
| Javier Barrera      | js.barrerat1 |

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## To work with flutter

Each developer has to run the following commands:
```sh
dart pub global activate flutterfire_cli
flutterfire configure --project=<PROJECT_NAME>
flutter pub get
```

## Setup Firebase

Install de CLI of firebase.

```sh
npm i -g firebase-tools
```

Login with your Google account:

```sh
firebase login
```

Install FlutterFire:

```sh
dart pub global activate flutterfire_cli
```

> [!note]
> Each time you add a new service or product in your Firebase app you need to run `flutterfire configure` again.
> ```sh
> flutter pub add PLUGIN_NAME
> flutterfire configure
> flutter run
> ```
