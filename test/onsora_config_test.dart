import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Static config verification for the Onsora rebrand.
/// Run: flutter test test/onsora_config_test.dart
void main() {
  final root = Directory.current.path;

  String read(String rel) => File('$root/$rel').readAsStringSync();

  group('Onsora branding / package', () {
    test('gradle: namespace + applicationId = com.onsora.app', () {
      final g = read('android/app/build.gradle');
      expect(g, contains('namespace "com.onsora.app"'));
      expect(g, contains('applicationId "com.onsora.app"'));
    });

    test('AndroidManifest label = Onsora', () {
      final m = read('android/app/src/main/AndroidManifest.xml');
      expect(m, contains('android:label="Onsora"'));
    });

    test('debug/profile manifests use com.onsora.app', () {
      expect(read('android/app/src/debug/AndroidManifest.xml'), contains('com.onsora.app'));
      expect(read('android/app/src/profile/AndroidManifest.xml'), contains('com.onsora.app'));
    });

    test('MainActivity declares com.onsora.app', () {
      final k = read('android/app/src/main/kotlin/com/onsora/app/MainActivity.kt');
      expect(k, contains('package com.onsora.app'));
      expect(k, contains('FlutterActivity'));
    });

    test('strings.xml app_name = Onsora', () {
      expect(read('android/app/src/main/res/values/strings.xml'), contains('>Onsora<'));
    });

    test('language assets APP_NAME = Onsora', () {
      expect(jsonDecode(read('assets/language/ar.json'))['APP_NAME'], 'Onsora');
      expect(jsonDecode(read('assets/language/en.json'))['APP_NAME'], 'Onsora');
    });
  });

  group('Firebase', () {
    test('google-services.json matches com.onsora.app / onsora-75754', () {
      final j = jsonDecode(read('android/app/google-services.json'));
      expect(j['project_info']['project_id'], 'onsora-75754');
      final client = (j['client'] as List).first as Map<String, dynamic>;
      expect(client['client_info']['android_client_info']['package_name'], 'com.onsora.app');
      expect(client['client_info']['mobilesdk_app_id'], '1:918600481228:android:5eaa4079fe51b64f7fc569');
    });
  });

  group('Pusher', () {
    test('helper.dart uses the Onsora apiKey + cluster', () {
      final h = read('lib/core/utils/helper.dart');
      expect(h, contains('c2551b0bf90af1b5e449'));
      expect(h, contains('"mt1"'));
    });
  });

  group('Agora', () {
    test('APP_ID is the Onsora Agora App ID (32 hex)', () {
      final a = read('lib/core/utils/app_constance.dart');
      expect(a, contains("'c81cc8b91d414fa58bff773ae7590825'"));
    });
  });

  group('Backend domain', () {
    test('app_constance / api_constance point at onsora.egyptiantechs.com', () {
      expect(read('lib/core/utils/app_constance.dart'), contains('onsora.egyptiantechs.com'));
      expect(read('lib/core/network/api_constance.dart'), contains('onsora.egyptiantechs.com'));
    });
  });

  group('Signing included', () {
    test('keystore + key.properties exist (so release is uploadable)', () {
      expect(File('$root/android/app/banince-release.jks').existsSync(), isTrue);
      expect(File('$root/android/key.properties').existsSync(), isTrue);
    });
  });

  group('Fonts & icons', () {
    test('Tajawal fonts wired in pubspec + present on disk', () {
      final p = read('pubspec.yaml');
      expect(p, contains('assets/fonts/Tajawal-Regular.ttf'));
      expect(p, contains('family: Tajawal'));
      expect(File('$root/assets/fonts/Tajawal-Regular.ttf').existsSync(), isTrue);
      expect(File('$root/assets/fonts/Tajawal-Bold.ttf').existsSync(), isTrue);
    });

    test('adaptive launcher icons present', () {
      expect(File('$root/android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml').existsSync(), isTrue);
      expect(File('$root/android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png').existsSync(), isTrue);
      expect(File('$root/android/app/src/main/res/mipmap-xxxhdpi/ic_launcher_adaptive_fore.png').existsSync(), isTrue);
    });
  });
}