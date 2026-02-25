// lib/API_key.dart
//
// ⚠️  SECURITY NOTE
// This file no longer contains any hardcoded secrets.
// The Spoonacular API key is injected at compile-time via `--dart-define`.
//
// ─── How to build / run the app ──────────────────────────────────────────────
//
//   flutter run \
//     --dart-define=SPOONACULAR_API_KEY=YOUR_KEY_HERE
//
//   flutter build apk \
//     --dart-define=SPOONACULAR_API_KEY=YOUR_KEY_HERE
//
// ─── Recommended: use a dart-define file (Flutter ≥ 3.7) ────────────────────
//
//   1. Create "dart_defines/local.env" (already git-ignored):
//
//        SPOONACULAR_API_KEY=your_actual_key_here
//
//   2. Run with:
//
//        flutter run --dart-define-from-file=dart_defines/local.env
//
// See also: .env.example for all required variables.
// ─────────────────────────────────────────────────────────────────────────────

class ApiKey {
  /// Spoonacular API key — injected via `--dart-define=SPOONACULAR_API_KEY=…`
  ///
  /// If the key is missing the app will throw an [AssertionError] in debug mode
  /// and show a clear error message so the developer knows what is wrong.
  static const String spoonacularApiKey = String.fromEnvironment(
    'SPOONACULAR_API_KEY',
    defaultValue: '',
  );

  /// Call this once in [main] (before [runApp]) to validate required keys.
  static void validate() {
    assert(
      spoonacularApiKey.isNotEmpty,
      '\n\n'
      '╔══════════════════════════════════════════════════════════════╗\n'
      '║  MISSING REQUIRED API KEY                                    ║\n'
      '║                                                              ║\n'
      '║  SPOONACULAR_API_KEY is not set.                             ║\n'
      '║                                                              ║\n'
      '║  Run the app with:                                           ║\n'
      '║    flutter run --dart-define=SPOONACULAR_API_KEY=<your_key>  ║\n'
      '║                                                              ║\n'
      '║  Or use a define file (Flutter ≥ 3.7):                       ║\n'
      '║    flutter run --dart-define-from-file=dart_defines/local.env║\n'
      '╚══════════════════════════════════════════════════════════════╝\n',
    );
  }
}
