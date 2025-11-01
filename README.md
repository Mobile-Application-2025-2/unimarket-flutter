# Unimarket - Flutter group 43

| Nombre|  |
|---|---|
|Daniel Felipe Ortiz| df.ortizv1 |
| Julian Rolon | j.rolont |
| Javier Barrera | js.barrerat1 |

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
> $ flutter pub add PLUGIN_NAME
> $ flutterfire configure
> $ flutter run
> ```
> 
> Please see the [FlutterFire documentation](https://firebase.google.com/docs/flutter/setup?platform=android) if you have any trouble.
