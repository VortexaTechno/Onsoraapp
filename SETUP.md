# Onsora — Flutter source

Rebranded version of the (build-fixed) Koki Chat project.

- App name: **Onsora**
- Android package / applicationId: `com.onsora.app`
- API base URL: `https://onsora.egyptiantechs.com/api`
- Font: Tajawal (bundled in `assets/fonts/`, applied app-wide)
- Launcher icons: Android adaptive icon set included in `res/mipmap-*`

## Required toolchain (already validated)

| Tool       | Version                                   |
|------------|-------------------------------------------|
| Flutter    | 3.47.6 stable (`flutter --version` line 1)|
| Dart       | 3.13.5                                    |
| JDK        | Temurin 17 (17.0.20.1+1 tested)           |
| Gradle     | 8.14 (via `android/gradle/wrapper`)       |
| AGP        | 8.11.1                                    |
| Kotlin     | 2.2.20                                    |
| NDK        | 28.2.13676358 (used by agora)             |
| CMake      | 3.22.1                                    |
| compileSdk | 36 / build-tools 36.0.0                   |

## Build

```bash
flutter pub get
flutter build apk --release            # installable APK
flutter build appbundle --release      # Play Store AAB
```

## Firebase (already configured)

`android/app/google-services.json` is the real Onsora project config:

- project: `onsora-75754` — project number `918600481228`
- package: `com.onsora.app`
- mobilesdk_app_id: `1:918600481228:android:5eaa4079fe51b64f7fc569`

No Firebase console changes needed — this file matches the app, so
Google Sign-In / Phone auth / FCM work out of the box.

## Signing — INCLUDED, ready to upload

The release keystore and credentials are ALREADY in this source:

- `android/app/banince-release.jks` (RSA 2048, alias `banince`)
- `android/key.properties` (relative `storeFile` -> works on any machine after
  extracting the zip)

`flutter build appbundle --release` is signed with this key and the AAB is
directly uploadable to Google Play. `flutter build apk --release` gives the
installable APK with the same signature.

> Keep this keystore and its password private — it is the app's identity.
> Losing it means the app can never be updated on Play.

## Play Store listing assets

- `assets/play_store/play_store_512.png` — 512x512 store icon
- `assets/play_store/1024.png` — square app icon

Upload these in Play Console together with the AAB.

## Already-applied build fixes (do not revert)

- `flutter_sim_country_code` vendored into `third_party/` and pinned via
  `dependency_overrides`; its old `PluginRegistry.Registrar` API was removed.
  Local path plugins: `agora_rtc_engine`, `svgaplayer_flutter`, `share`,
  `simple_timer` (see `pubspec.yaml`).
- `gradle.projectsEvaluated` forces Java/Kotlin 17 in `android/build.gradle`.
- Java 17 + `coreLibraryDesugaringEnabled` (desugar_jdk_libs 2.1.5).
- `uses-material-design: true` in the pubspec.
- ProGuard: `-dontwarn org.slf4j.**` (+ binders), FlutterActivity keep rule,
  Agora/Firebase/Facebook keeps.

## Config locations (change with care)

- API host: `lib/core/network/api_constance.dart` and `lib/core/utils/app_constance.dart`
  (or override at build time: `--dart-define=API_BASE_URL=...` / `--dart-define=SERVER_URL=...`).
- Agora App ID: `lib/core/utils/app_constance.dart` (`APP_ID`).
- Pusher key/cluster: `PusherInit()` in `lib/core/utils/helper.dart`
  (key `c2551b0bf90af1b5e449`, cluster `mt1`).