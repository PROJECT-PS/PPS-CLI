# Changelog

This document records user-visible PPS CLI changes. Versions follow [Semantic Versioning](https://semver.org/).

## [v0.2.0] - 2026-07-19

### Added

- Once-per-24-hour release checks and update notices during command execution
- Platform-specific, SHA-256-verified self-update through `pps update`
- Deferred executable replacement on Windows to account for file locking

### Changed

- Network errors and timeouts are silently ignored without affecting user commands
- Failed checks are recorded to prevent another attempt for 24 hours
- Update checks and self-update are disabled in development profiles
- Installation, distribution, and supported-version documentation now reflects released behavior

## [v0.1.0] - 2026-07-19

### Added

- Release targets for AMD64 and ARM64 on Windows, macOS, and Linux
- Problem repository creation, validation, invocation, deployment, and submission commands
- Secure platform-aware authentication storage
- Direct installers and package-manager metadata
