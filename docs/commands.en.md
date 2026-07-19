# Command guide

[한국어](commands.md)

Invalid input prints contextual command help. Add `--json` to API-oriented commands for machine-readable output.

## Version and updates

```sh
pps --version
pps update
```

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
pps create --name two-sum --template stdio
pps clone 107
pps clone nickname/two-sum
pps list problem
pps search two sum
```

Repositories cloned by PPS store their problem ID in `.git/pps.json`, allowing later commands to infer it.

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

Native local invocation has no security sandbox; only run trusted repositories. Docker mode uses a network-disabled PPS toolchain container.

## Submissions

```sh
pps submit 107 solution.cpp --language cpp17
pps edu_submit 10 3 107 solution.py --language py3
pps contest_submit 20 0 Main.java --language java8
pps list submit 107
```

Use `pps <command> --help` as the authoritative reference for current flags and syntax.
