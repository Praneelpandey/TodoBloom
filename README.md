# Todo Bloom

A polished, native SwiftUI to-do app targeting iOS 17+. Tasks are stored locally on the device.

## Install on an iPhone without Xcode

The workflow builds, signs, and uploads the app to **TestFlight**. GitHub Actions cannot install to an iPhone over the USB cable; once Apple processes the upload, install it through the TestFlight app on your iPhone.

### One-time Apple setup

1. In Apple Developer, register a unique bundle ID (for example, `com.yourname.TodoBloom`) and create an **App Store distribution provisioning profile** for it.
2. Create an App Store distribution certificate (`.p12`) and download the profile (`.mobileprovision`).
3. In App Store Connect, create the Todo Bloom app record with exactly the same bundle ID. Create an App Store Connect API key with a Developer or App Manager role and download its `.p8` key.

### Repository configuration

Create a GitHub repository, push this project, then set these **Actions variables**:

| Variable | Value |
| --- | --- |
| `APPLE_TEAM_ID` | Your 10-character Apple Developer Team ID |
| `BUNDLE_IDENTIFIER` | The bundle ID registered above |

Set these **Actions secrets** (base64 encode files as one line):

| Secret | Value |
| --- | --- |
| `IOS_DISTRIBUTION_CERTIFICATE_BASE64` | Your `.p12` distribution certificate, base64 encoded |
| `IOS_DISTRIBUTION_CERTIFICATE_PASSWORD` | Password used when exporting the `.p12` |
| `IOS_KEYCHAIN_PASSWORD` | A new, long random password for the temporary CI keychain |
| `IOS_APPSTORE_PROFILE_BASE64` | Your `.mobileprovision`, base64 encoded |
| `APPSTORE_CONNECT_KEY_ID` | API key ID from App Store Connect |
| `APPSTORE_CONNECT_ISSUER_ID` | API issuer ID from App Store Connect |
| `APPSTORE_CONNECT_PRIVATE_KEY_BASE64` | The API `.p8` file, base64 encoded |

Never commit any of these files or values. GitHub encrypts Actions secrets and makes them available only where the workflow explicitly references them.

### Deliver a build

Open **Actions → Build and deliver iOS app → Run workflow**, enable **Upload this signed build to TestFlight**, and run it from `main`. Once App Store Connect finishes processing, add your Apple ID as an internal TestFlight tester (if needed), then install **TestFlight** on the iPhone and accept the invitation.

The regular push and pull-request workflow only performs an unsigned compile check. The TestFlight job runs only when manually requested and requires the repository’s `production` environment secrets.
