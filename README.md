# Flutter Multi-Platform App

This Flutter app builds for 6 platforms automatically via GitHub Actions.

## Download Builds

| Platform | Status | Download |
|----------|--------|----------|
| Android | ✅ Built | [Download APK](https://github.com/${REPO}/actions/runs/${RUN_ID}/artifacts/android-apk) |
| iOS | ✅ Built | [Download App](https://github.com/${REPO}/actions/runs/${RUN_ID}/artifacts/ios-app) |
| Web | ✅ Built | [Download](https://github.com/${REPO}/actions/runs/${RUN_ID}/artifacts/web) |
| Linux | ✅ Built | [Download](https://github.com/${REPO}/actions/runs/${RUN_ID}/artifacts/linux) |
| Windows | ✅ Built | [Download](https://github.com/${REPO}/actions/runs/${RUN_ID}/artifacts/windows) |
| macOS | ✅ Built | [Download](https://github.com/${REPO}/actions/runs/${RUN_ID}/artifacts/macos) |

## Build Details

- **Workflow Run:** [#${RUN_ID}](https://github.com/${REPO}/actions/runs/${RUN_ID})
- **Commit:** ${SHA:0:7}
- **Branch:** ${BRANCH}
- **Artifacts Retention:** 14 days

## How to Build Locally

```bash
# Install Flutter: https://flutter.dev/docs/get-started/install

# Get dependencies
flutter pub get

# Create platforms (if not exists)
flutter create --platforms=android,ios,web,linux,windows,macos .

# Build for specific platform
flutter build apk --release        # Android
flutter build ios --release        # iOS
flutter build web --release        # Web
flutter build linux --release      # Linux
flutter build windows --release    # Windows
flutter build macos --release      # macOS
```

## CI/CD

This project uses GitHub Actions to build all platforms automatically on every push to main/master branch.

After each successful build, this README is updated with download links to the artifacts.
