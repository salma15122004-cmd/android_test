# Bright Steps

A Flutter app that supports children's speech therapy. This repository
contains the onboarding and authentication flow: splash, onboarding, sign in,
sign up and password reset.

## Getting started

```
flutter pub get
flutter run
```

Run the checks:

```
flutter analyze
flutter test
```

## Project structure

```
lib/
  main.dart                 App entry point
  constants/                Colors and asset paths
  screens/                  One file per screen
  widgets/                  Reusable UI components
  services/                 Backend contract, mock backend, local storage
  utils/                    Validators and shared screen helpers
test/                       Unit and widget tests
```

## Password reset flow

```
Login -> ForgotPasswordScreen -> VerifyCodeScreen
      -> CreateNewPasswordScreen -> PasswordResetSuccessScreen -> Login
```

## Connecting the backend

Screens never talk to the network directly. They call the `AuthService`
interface in `lib/services/auth_service.dart`.

1. Create a class that `implements AuthService` and calls your API.
2. Throw `AuthException('message for the user')` for expected failures
   (wrong password, invalid code, unknown email). The message is shown to the
   user as is. Any other exception shows a generic error.
3. In `lib/services/service_locator.dart`, replace `MockAuthService()` with
   your implementation.

Until then `MockAuthService` is used. It accepts any sign in and sign up, and
the only valid verification code is `1234`. The code is also printed to the
debug console when it is requested.

## Onboarding

Release builds show the onboarding only on the first launch. Debug builds
always show it so it is easy to test (see `lib/screens/splash_screen.dart`).
