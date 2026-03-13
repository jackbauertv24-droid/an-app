# Flutter Multi-Platform App

This Flutter app builds for 6 platforms automatically via GitHub Actions.

## Platforms

| Platform | Status | Download |
|----------|--------|----------|
| Android | - | - |
| iOS | - | - |
| Web | - | - |
| Linux | - | - |
| Windows | - | - |
| macOS | - | - |

## Build Details

- **Workflow Run:** View on GitHub Actions
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

After each successful build, the README is updated with download links to the artifacts.
