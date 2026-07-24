# Changelog

This document records user-visible PPS CLI changes. Versions follow [Semantic Versioning](https://semver.org/).

## [v0.8.0] - 2026-07-25

### Added

- `pps --json run` now returns the same solution-by-test-case detail schema as remote invocation in both native and Docker modes, including input, expected output, user output, checker output, verdict, execution time, and memory.

### Changed

- Failed local runs still emit every detail collected so far together with the error in JSON, allowing clients such as PPS Code to display the failing cases.

## [v0.7.0] - 2026-07-24

### Added

- `pps repo status` classifies local work against GitHub as `clean`, `server_ahead`, `local_ahead`, `diverged`, or `conflicted`, with JSON change lists, ahead counts, and conflict paths
- `pps repo info` reads or rediscovers the connection cached in `.pps/repository.json`
- `pps repo settings` reads and updates the Papyrus repository description, GitHub visibility, and post-deployment public-submission setting

### Changed

- `pps clone` and `pps remote` now cache connections in `.pps/repository.json`, with automatic migration from legacy `.git/pps.json`
- Missing or stale caches are safely reconstructed from Git remotes, while `.pps` and `.pps-code` are automatically added to the repository-local Git exclude list
- `pps sync` now commits the local snapshot before pulling, allowing Git to produce standard three-way conflict data before the final push
- The original Papyrus problem type `twostep` is accepted verbatim while remaining runtime-compatible with legacy `two_step` packages

### Fixed

- Git porcelain entries beginning with a space no longer lose the first filename character, which previously reported `config.json` as `onfig.json`

## [v0.6.0] - 2026-07-21

### Added

- `pps remote` for connecting an existing Git repository with the same problem ID or `nickname/repository` reference accepted by `pps clone`
- HTTPS/SSH selection, named remotes, explicit `--force` conflict replacement, JSON results, and automatic `.git/pps.json` metadata

### Changed

- The macOS/Linux direct installer now targets the standard PATH location `/usr/local/bin` and requests `sudo` only when needed
- The Windows installer now refreshes the current PowerShell PATH so `pps` is immediately available

## [v0.5.0] - 2026-07-20

### Added

- Authentication-free `pps polygon <source> <destination>` conversion from Polygon directories or ZIP archives
- Polygon TeX-to-Markdown support for formulas, sections, samples, nested lists, code, links, images, tables, epigraphs, and `defs.toml` custom commands
- UTF-8/UTF-16 and Windows/East Asian legacy encoding normalization plus ZIP traversal, special-file, and expansion-bomb defenses
- Detailed Korean and English Polygon conversion guides through post-import `pps run` validation

### Changed

- Populated destinations require y/n confirmation, while `n` preserves all data and automation can opt into `--force`
- Manual tests become split-capable Python generators that emit the original bytes exactly
- Conversion and PPS static validation complete in staging before replacement, with restoration on final replacement failure

## [v0.4.0] - 2026-07-20

### Added

- `pps create --local` for an authentication-free local Git package with an initial empty commit
- A complete PPS CLI workbook covering problem authoring, local testing, remote validation/deployment, and submissions

### Changed

- Commands other than `pps auth` and `pps create` now use options and defaults without selection menus
- Submission-list `--result` filters now use names such as `all`, `ac`, `wa`, and `tle` instead of internal numbers
- Per-command help now explains non-interactive defaults, options, and copyable examples
- Authentication-free behavior for `pps run` and `pps create --local` is documented and tested

## [v0.3.1] - 2026-07-20

### Added

- Automatic per-profile PPS-ASSETS cache when native execution needs `testlib.h`
- Linux AMD64 and ARM64 support for the PPS CLI runner Docker image

## [v0.3.0] - 2026-07-20

### Added

- Web-equivalent menus for creation, submission, result filters, and dynamic education/contest problem selection
- Current/latest/update-status reporting through `pps -v`

### Changed

- User examples now consistently use public problem `#1`, **a + b**
- `pps --version` remains a network-free, single-line version output

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
