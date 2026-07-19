# Command guide

[한국어](commands.md)

Invalid input prints contextual command help. Add `--json` to API-oriented commands for machine-readable output.

## Version and updates

```sh
pps --version
pps -v
pps --json -v
pps update
```

`pps --version` is a stable, network-free single-line installed-version check. `pps -v` also reports the latest GitHub Release and update status. This explicit lookup can use the network for up to two seconds. If it fails, the current version still succeeds while the latest version and status are shown as `unknown`.

Release builds check for a new release at most once every 24 hours when a command runs and suggest `pps update` when one exists. The request stops after two seconds; both successful and failed attempts delay the next check for 24 hours. Notices go to stderr and do not change `--json` stdout.

`pps update` downloads the platform archive and `checksums.txt`, verifies SHA-256, and replaces the current executable. Checks and updates are disabled in the development profile.

## Authentication

```sh
pps auth
pps auth status
pps auth logout
```

## Problem repositories

```sh
pps create
pps problem 1
pps clone 1
pps clone nickname/two-sum
pps list problem
pps search two sum
```

`pps create` presents numbered choices for template, owner, GitHub repository visibility, and post-deployment problem visibility. Supplying the corresponding flags skips those prompts.

Problem `#1` is the public **a + b** example: print the sum of two integers (1 second, 128 MiB, sample `1 2` → `3`). `pps problem 1` lets you choose a statement when multiple languages are available. Clone offers HTTPS, SSH, and GitHub CLI transports. Repositories cloned by PPS store their problem ID in `.git/pps.json`, allowing later commands to infer it.

## Git synchronization

```sh
pps pull
pps commit -m "add edge cases"
pps push
pps sync -m "refresh tests"
```

## Validation and deployment

```sh
pps invocate
pps deploy
pps list invocate
pps list deploy
pps detail invocate 456
```

Remote invocation and deployment run `pps sync` by default. Use `--no-sync` to skip it. Deploy detail is not exposed because PPS has no direct deploy-detail API.

## Local invocation

```sh
pps run .
pps run --docker
```

Native local invocation has no security sandbox; only run trusted repositories. Docker mode uses the network-disabled PPS CLI runner container.

In a terminal, choose native or Docker execution from a numbered menu. Pass `--docker` or `--docker=false` to skip the prompt.

## Submissions

```sh
pps submit 1 solution.cpp
pps edu_submit 10 solution.py
pps contest_submit 20 Main.java
pps list submit 1
```

General submission offers all eight supported languages and preselects the language inferred from the file extension. Education submission can select a visible course problem when lecture/problem IDs are omitted. Contest submission can select a current contest problem when its index is omitted. Existing full-ID syntax and `--language` remain available for automation.

All three submission-list commands expose the same 11 result filters as the web UI. Education and contest lists also provide dynamic problem filters; explicit flags skip these menus.

Use `pps <command> --help` as the authoritative reference for current flags and syntax.
