import os

run_id = os.environ['RUN_ID']
repo = os.environ['REPO']
sha = os.environ['SHA'][:7]
branch = os.environ['BRANCH']

readme = f"""# Flutter Multi-Platform App

This Flutter app builds for 6 platforms automatically via GitHub Actions.

## 🌐 Live Web Demo

**[View Web App](https://{repo.split('/')[0]}.github.io/{repo.split('/')[1]}/)**

The web version is automatically deployed to GitHub Pages on every push to main.

## Download Builds

| Platform | Status | Download |
|----------|--------|----------|
| Android | ✅ Built | [Download APK](https://github.com/{repo}/actions/runs/{run_id}/artifacts/android-apk) |
| iOS | ✅ Built | [Download App](https://github.com/{repo}/actions/runs/{run_id}/artifacts/ios-app) |
| Web | ✅ Deployed | [Live on GitHub Pages](https://{repo.split('/')[0]}.github.io/{repo.split('/')[1]}/) |
| Linux | ✅ Built | [Download](https://github.com/{repo}/actions/runs/{run_id}/artifacts/linux) |
| Windows | ✅ Built | [Download](https://github.com/{repo}/actions/runs/{run_id}/artifacts/windows) |
| macOS | ✅ Built | [Download](https://github.com/{repo}/actions/runs/{run_id}/artifacts/macos) |

## Build Details

- **Workflow Run:** [#{run_id}](https://github.com/{repo}/actions/runs/{run_id})
- **Commit:** {sha}
- **Branch:** {branch}
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

### Deployment

- **Web**: Automatically deployed to GitHub Pages (`gh-pages` branch)
- **Other platforms**: Available as downloadable artifacts (14 days retention)

After each successful build, this README is updated with download links to the artifacts.
"""

with open('README.md', 'w') as f:
    f.write(readme)
