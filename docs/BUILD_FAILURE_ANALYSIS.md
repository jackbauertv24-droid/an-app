# Build Failure Analysis - GitHub Actions CI

**Date:** March 13, 2026  
**Status:** Resolved  
**Total Failed Builds:** 19  
**Resolution:** Reverted to commit before AI Chat integration

---

## Executive Summary

The CI pipeline experienced 19 consecutive build failures caused by:
1. **Root Cause:** `package:http` v1.6.0 uses web-only `dart:js_interop` library
2. **Cascading Issue:** 8 debugging attempts without identifying the core problem
3. **Final Failure:** Update to non-existent `flutter-action@v3` broke entire CI

---

## Failure Timeline

| Time (UTC) | Commit | Message | Root Cause |
|------------|--------|---------|------------|
| 02:14:39 | Initial | Initial Flutter app with GitHub Actions CI | Cancelled |
| 02:21:31 | Initial | Add multi-platform builds | Cancelled |
| 02:25:20 | Cancelled | Fix CI: create platform folders before building | Cancelled |
| 02:28:25 | Failure | Fix CI: create all platform folders before building | Missing platform dirs |
| 02:34:43 | Failure | Fix Android build: remove existing folders | Missing platform dirs |
| 03:13:23 | ccb3c1a | Add README generation with artifact download links | Workflow configuration |
| 07:05:52 | 57a3390 | **Add AI Chat with Cloudflare AI Gateway** | ⚠️ **Introduced http v1.6.0** |
| 07:09:38 | de0e167 | Fix tests for new home page navigation | dart:js_interop |
| 08:39:33 | 67dceb1 | Fix CORS issue for web AI chat using corsproxy.io | dart:js_interop |
| 08:58:43 | 03c0a48 | Fix FlutterSecureStorage for test environments | dart:js_interop |
| 09:04:19 | 6743c56 | Replace FlutterSecureStorage with in-memory storage | dart:js_interop |
| 09:09:20 | d29c700 | Temporarily disable tests to verify builds work | Workflow issues |
| 09:14:16 | cce014c | Allow tests to fail without breaking build | Still marked failed |
| 09:20:07 | ba00bee | Re-enable tests without \|\| true | dart:js_interop |
| 09:24:42 | f1fb017 | Skip tests temporarily to fix builds | Workflow issues |
| 09:28:55 | d472088 | Remove flutter create steps | Broke platform gen |
| 09:33:07 | dca80c4 | Restore original workflow with tests optional | dart:js_interop |
| 09:44:34 | d1ba4c3 | Remove test steps from workflow - no tests currently | Workflow issues |
| 09:49:22 | 2a7d6b1 | **Update flutter-action to v3** | ❌ **v3 doesn't exist** |

---

## Root Cause Analysis

### Primary Issue: `dart:js_interop` Platform Incompatibility

**Dependency Chain:**
```
test/widget_test.dart
  → package:an_app (your app)
    → package:http v1.6.0 (introduced by AI Chat feature)
      → dart:js_interop (WEB ONLY!)
      → package:web v1.1.1
        → dart:js_interop_unsafe (WEB ONLY!)
```

**Error Message:**
```
Error: Dart library 'dart:js_interop' is not available on this platform.
Context: The unavailable library 'dart:js_interop' is imported through these packages:
    /Users/runner/work/an-app/an-app/test/widget_test.dart 
    => package:an_app 
    => package:http 
    => dart:js_interop
```

**Why This Breaks:**
- `dart:js_interop` is ONLY available on web platforms (Chrome, Safari, etc.)
- Tests run on iOS, Android, macOS, Windows, Linux - NONE support this library
- The `http` package version 1.6.0 changed to use browser-specific APIs by default

### Secondary Issue: Invalid GitHub Action Version

**Error:**
```
Unable to resolve action `subosito/flutter-action@v3`, unable to find version `v3`
```

**Impact:** ALL 6 platforms failed instantly in "Set up job" step before any build could start.

**Why:** The `subosito/flutter-action` action only has `v1`, `v2`, and specific SHA versions. **Version `v3` does not exist.**

---

## Failure Categories

| Category | Count | First Occurrence |
|----------|-------|-----------------|
| `dart:js_interop` Platform Errors | 8 | 03c0a48 (08:58) |
| Invalid Action Version | 1 | 2a7d6b1 (09:49) |
| Build/Platform Folder Issues | 4 | Early commits (02:14-02:34) |
| Test Configuration Issues | 6 | 57a3390 (07:05) |

---

## The Debugging Spiral

After AI Chat was introduced, 8 consecutive commits attempted to fix the tests without identifying the root cause:

| Commit | Attempt | Why It Failed |
|--------|---------|---------------|
| de0e167 | Fix tests for navigation | Didn't address http package |
| 67dceb1 | Fix CORS with proxy | Wrong problem entirely |
| 03c0a48 | Fix FlutterSecureStorage | Storage wasn't the issue |
| 6743c56 | Replace with in-memory | Still imports http |
| d29c700 | Disable tests | Workflow still broken |
| cce014c | Allow tests to fail | Build still marked failed |
| ba00bee | Re-enable tests | Same js_interop error |
| f1fb017 | Skip tests | Other workflow issues |

**Key Lesson:** The team was debugging symptoms (test failures) rather than the root cause (dependency incompatibility).

---

## Resolution

### Phase 1: Temporary Fix
**Action Taken:** Reverted repository to commit `e20731d` (before AI Chat integration)

**Result:** ✅ All 8 jobs passed - confirmed root cause was AI Chat implementation

### Phase 2: Permanent Fix
**Action Taken:** Re-implemented AI Chat using `package:dio` instead of `package:http`

**Changes Made:**
1. Replaced `http: ^1.1.0` with `dio: ^5.9.2` in `pubspec.yaml`
2. Added `flutter_secure_storage: ^9.0.0` for token persistence
3. Re-created `lib/services/cloudflare_ai_service.dart` using Dio API
4. Updated `lib/main.dart` to use Dio for both Cat Facts and AI Chat
5. Added `libsecret-1-dev` to Linux build dependencies

**Result:** ✅ All 8 jobs pass
- build-android (5m4s)
- build-web (1m12s)
- build-windows (2m55s)
- build-macos (3m4s)
- build-linux (1m52s)
- build-ios (2m11s)
- deploy-web (12s)
- generate-readme (4s)

---

## Recommended Fixes for Future AI Chat Integration

### ✅ IMPLEMENTED: Option 4 - Use `package:dio` (Best Solution)

**Why dio was chosen:**
- ✅ **True cross-platform support** - verified on pub.dev: Android, iOS, Linux, macOS, **Web**, Windows
- ✅ **Platform-specific adapters** - uses `dio_web_adapter` for web, `IOHttpClientAdapter` for native
- ✅ **No dart:js_interop issues** - web-specific code is isolated and never loads on other platforms
- ✅ **Actively maintained** - 8.2k likes, 2.68M downloads, published 11 days ago
- ✅ **Better API** - interceptors, transformers, better error handling

**Implementation:**
```yaml
# pubspec.yaml
dependencies:
  dio: ^5.9.2
  flutter_secure_storage: ^9.0.0
```

```dart
// lib/services/cloudflare_ai_service.dart
import 'package:dio/dio.dart';

class CloudflareAiService {
  final Dio _dio = Dio();
  
  CloudflareAiService() {
    _dio.options.baseUrl = 'https://gateway.ai.cloudflare.com/v1/...';
    _dio.options.connectTimeout = const Duration(seconds: 30);
  }
  
  Future<String> chat(String message) async {
    final response = await _dio.post('', data: {...});
    return response.data['choices'][0]['message']['content'];
  }
}
```

**Build Results:** All 6 platforms ✅ PASS

---

### Other Options (Not Implemented)

### Option 1: Pin `http` Package Version
```yaml
# pubspec.yaml
dependencies:
  http: ^1.5.0  # Pin to version before js_interop changes
```

### Option 2: Use `package:web` Conditionally
```dart
// lib/services/http_client.dart
export 'http_client_web.dart' if (dart.library.io) 'http_client_io.dart';
```

### Option 3: Use `package:universal_io`
⚠️ **NOT RECOMMENDED** - Despite claims, `universal_io` does NOT list web support on pub.dev

### Option 5: Exclude Tests on Non-Web Platforms
```yaml
# .github/workflows/build.yml
jobs:
  build-web:
    - name: Run tests
      run: flutter test --platform chrome
```

### Option 2: Use Conditional Imports
```dart
// Use conditional imports to avoid web-specific code in tests
import 'package:http/http.dart' as http;
// Only import on web platforms
```

### Option 3: Exclude Tests from Non-Web Platforms
```yaml
# .github/workflows/build.yml
- name: Run tests
  if: matrix.platform == 'web'
  run: flutter test
```

### Option 4: Use `http` Client Conditionally
```dart
// Create a custom client that works cross-platform
class CrossPlatformClient extends http.BaseClient {
  // Implementation that avoids js_interop
}
```

---

## Lessons Learned

### 1. Pin Dependency Versions
Don't allow automatic major version upgrades for critical packages. Use exact versions or narrow ranges:
```yaml
# Good
http: 1.5.0
# Risky
http: ^1.0.0
```

### 2. Verify GitHub Action Versions Exist
Before updating actions, verify the version exists:
```bash
# Check available versions
curl -s https://api.github.com/repos/subosito/flutter-action/tags | jq '.[].name'
```

### 3. Verify Package Platform Support on pub.dev
**CRITICAL:** Always check the "Platform" section on pub.dev before adding dependencies:
- ✅ `dio`: Shows Android, iOS, Linux, macOS, **web**, Windows
- ❌ `universal_io`: Shows Android, iOS, Linux, macOS, Windows (**no web**)
- ⚠️ `http` v1.6.0+: Shows all platforms but uses web-only `dart:js_interop`

### 4. Understand Package Architecture
Some packages use platform-specific code internally:
- **Good:** `dio` - separate adapters per platform, isolated web code
- **Bad:** `http` v1.6.0+ - always imports `package:web` → `dart:js_interop`

### 5. Test Dependencies on All Platforms Early
Add platform-specific dependency validation:
```bash
flutter pub get
flutter analyze
flutter test --platform chrome  # Web
flutter test --platform linux   # Desktop
```

### 6. Read Package Changelogs
The `http` 1.6.0 changelog documented breaking changes. Always review:
- CHANGELOG.md
- Migration guides
- Breaking changes section

### 7. Debug Systematically
When tests fail across all platforms:
1. Check dependency tree: `flutter pub deps`
2. Review recent package updates
3. Check package compatibility matrices
4. Isolate the failing import
5. **Verify platform support on pub.dev**

### 8. Native Dependencies Require System Packages
Some Flutter plugins need system libraries:
- `flutter_secure_storage` needs `libsecret-1-dev` on Linux
- Add to workflow: `sudo apt-get install libsecret-1-dev`

---

## Commands Used for Analysis

```bash
# List recent workflow runs
gh run list --limit 30

# View specific run details
gh run view <RUN_ID>

# View failed step logs
gh run view <RUN_ID> --log-failed

# Get job details
gh run view <RUN_ID> --json jobs

# Check available action versions
curl -s https://api.github.com/repos/subosito/flutter-action/tags
```

---

## References

- [dart:js_interop documentation](https://api.dart.dev/stable/dart-js_interop/dart-js_interop-library.html)
- [http package changelog](https://pub.dev/packages/http/changelog)
- [subosito/flutter-action releases](https://github.com/subosito/flutter-action/releases)
- [Flutter platform-specific code](https://docs.flutter.dev/platform-integration/platform-channels)
