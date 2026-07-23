# Command guide

[한국어](commands.md)

Invalid input prints contextual command help. Add `--json` to supported API-oriented commands for machine-readable output. Only `pps auth` and `pps create` ask setup questions. `pps polygon` asks for y/n only before replacing a populated destination; use `--force` for explicitly approved automation. Other commands use arguments, options, or documented defaults.

The [Korean workbook](commands.md) includes a complete first-problem tutorial covering the repository layout, `config.json`, generators, reference and intentionally wrong solutions, local/Docker testing, remote validation, deployment, and submissions.

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
pps create --local --name two-sum
pps problem 1
pps clone 1
pps clone nickname/two-sum
pps remote 1
pps remote nickname/two-sum --ssh
pps list problem
pps search two sum
```

Remote `pps create` presents numbered choices for omitted settings and requires PPS authentication plus a linked GitHub account. Supplying `--name`, `--description`, `--template`, `--account-id`, `--private`, and `--public-solvable` makes those settings explicit.

`pps create --local --name two-sum` works without authentication. It creates `<current-directory>/two-sum`, initializes a local Git repository on `main`, and records an empty initial commit. It does not create a PPS or GitHub repository. Only `--name` is accepted with `--local`; add a Git remote later if needed.

Problem `#1` is the public **a + b** example: print the sum of two integers (1 second, 128 MiB, sample `1 2` → `3`). `pps problem 1` prints all statements; use `--statement English` for one exact label. Clone uses HTTPS by default; select SSH with `--ssh` or the GitHub CLI with `--gh`. Repositories cloned by PPS cache their problem ID, owner, remote, and branch in `.pps/repository.json`; the cache is excluded through `.git/info/exclude`, and legacy `.git/pps.json` data is migrated automatically.

Use `pps remote <problem-id|nickname/repository>` inside an existing local Git repository to connect it without cloning again. HTTPS and the remote name `origin` are the defaults. `--ssh` selects SSH, `--name pps` preserves an existing origin by using another name, and `--force` explicitly replaces a conflicting URL. The command is idempotent when the URL already matches and always records `.pps/repository.json`. It never fetches, pulls, pushes, or changes working-tree files, so review and reconcile any existing remote history before synchronization. Public problems can be resolved without authentication; private problems require an authenticated account with access. Add `--json` for structured results.

### Polygon import

```sh
pps polygon ./polygon-package ./two-sum
pps polygon ./polygon-package.zip ./two-sum
```

This authentication-free command maps `problem.xml`, TeX statements, programs, generated tests, manual tests, and subtasks into a statically validated PPS package. A populated destination requires y/n confirmation; `n` leaves it unchanged and `--force` performs a pre-approved replacement. Conversion stages all data before replacing the destination.

See the [Polygon conversion guide](polygon.en.md) for the complete TeX command coverage, image and custom-command handling, encodings, ZIP safety rules, warnings, and post-import checks.

## Git synchronization

```sh
pps remote 1
pps repo info
pps repo status
pps pull
pps commit -m "add edge cases"
pps push
pps sync -m "refresh tests"
```

`pps remote` connects both the Git remote and PPS problem metadata. `pps repo info` reads that cache or safely rediscovers it from Git remotes. `pps repo status` fetches and reports one of `clean`, `server_ahead`, `local_ahead`, `diverged`, or `conflicted`, with file lists and conflict paths available through `--json`. Its temporary-index merge preview never changes the real branch, index, commits, or working tree.

`pps sync` runs stage → commit → pull (`--no-rebase`) → push, so overlapping local and server changes produce standard three-way conflicts. It does not merge remote history merely by connecting a remote; inspect `pps repo status` before the first synchronization.

Read or update the Papyrus description, GitHub visibility, and post-deployment public-submission setting:

```sh
pps --json repo settings
pps repo settings --description "Graph problem"
pps repo settings --private=true --public-solvable=false
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

`pps run` never requires PPS authentication and never prompts for an execution mode. Native mode is the default; pass `--docker` explicitly for the runner container. Use `--keep-work` to preserve generated inputs, outputs, and build files for debugging.

When native execution needs `testlib.h` and no existing copy can be found, PPS CLI automatically downloads the public PPS-ASSETS repository into the profile config directory. Use `--testlib-dir` or `PPS_TESTLIB_DIR` to override it. The Docker image publishes both Linux AMD64 and ARM64 variants, so Docker selects the matching image on Intel/AMD systems and Apple Silicon.

## Submissions

```sh
pps submit 1 solution.cpp
pps edu_submit 10 solution.py --lecture-id 3 --problem-id 1
pps contest_submit 20 Main.java --problem-index 0
pps list submit 1
pps list submit 1 --result ac
```

Submission never opens a language or problem menu. General submission infers `c11`, `cpp17`, `py3`, or `java8` from common extensions; use `--language` to override it or handle an unknown extension. Education submission requires `--lecture-id` and `--problem-id`. Contest submission requires the zero-based `--problem-index` (`0` is problem A).

All submission-list commands accept textual, case-insensitive `--result` values and map them to the API internally. Numeric result codes are intentionally neither shown nor accepted.

| Value | Meaning |
| --- | --- |
| `all` | All results |
| `ac` | Accepted |
| `wrong` | Every non-accepted result |
| `wa` | Wrong answer |
| `partial` | Partial score |
| `tle` | Time limit exceeded |
| `mle` | Memory limit exceeded |
| `re` | Runtime error |
| `segfault` | Segmentation fault |
| `ce` | Compile error |
| `ole` | Output limit exceeded |

Education lists use optional `--lecture-id` and `--problem-id` filters. Contest lists use optional `--problem-index`. Omitting these filters means all problems and does not open a menu.

Use `pps <command> --help` as the authoritative reference for current flags and syntax.
