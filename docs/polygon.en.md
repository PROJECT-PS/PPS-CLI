# Converting Polygon packages to PPS

[한국어](polygon.md)

`pps polygon` converts a Polygon problem package into a local PPS package. It requires neither PPS authentication nor network access, and accepts both extracted directories and `.zip` archives.

```sh
pps polygon ./polygon-package ./two-sum
pps polygon ./polygon-package.zip ./two-sum
```

The source package is never modified. The destination receives `config.json` and the standard `statement/`, `solution/`, `generator/`, `checker/`, `validator/`, and `interactor/` directories.

## Input requirements

Use a Polygon package containing `problem.xml`, TeX statements, source files, and every manual test referenced by the descriptor. A ZIP may contain one wrapper directory; PPS searches for exactly one `problem.xml`. Zero or multiple descriptors are rejected.

## Existing destinations

An absent destination or empty directory is used directly. A file or non-empty directory triggers this confirmation:

```text
Destination ... already contains data. Delete all existing data and continue? [y/n]
```

- `y`/`yes` replaces all existing data.
- `n`/`no` or an empty answer leaves the destination unchanged.
- Any other answer fails safely.

Conversion and PPS validation finish in a sibling staging directory before replacement. A failed conversion leaves the old destination untouched, and a failed final rename restores it. Use `--force` only when replacement has already been approved:

```sh
pps polygon package.zip ./two-sum --force
pps --json polygon package.zip ./two-sum --force
```

JSON mode requires `--force` for a populated destination because it cannot ask for confirmation.

## Mapping

| Polygon | PPS |
| --- | --- |
| Names, problem type, limits | `config.json` metadata |
| `application/x-tex` statements | UTF-8 `statement/*.md` |
| Checker, validators, interactor | Matching PPS source directories |
| Main solution | The unique `MCS` solution |
| Solution tags | `AC`, `WA`, `TLE`, `MLE`, and `FAIL` targets |
| Executables and test commands | Generators and `genscript` entries |
| Manual tests | Byte-preserving Python generators |
| Groups and dependencies | PPS subtasks |

If Polygon has no runnable main solution, the first accepted solution becomes MCS and PPS reports a warning. Required programs in languages that PPS cannot run cause an actionable error. Limits and scores outside PPS ranges are adjusted with warnings.

If Polygon has no sample, the first test is marked as the PPS example. When it has more than PPS' limit of 20 samples, only the first 20 remain examples; every remaining case stays in `genscript` as a normal test.

When a subtask problem contains ungrouped samples or tests, PPS assigns them to the alphabetically first subtask and warns because PPS requires every generated subtask test to name a group. Review and adjust those `subtask_group` values when the intended membership differs.

Manual tests are embedded as Python byte literals. This preserves CRLF, non-UTF-8 bytes, and other platform-specific data exactly. Large generated sources are split automatically.

## TeX to Markdown

The converter covers the commands documented by Polygon's [Statements TeX manual](https://polygon.codeforces.com/docs/statements-tex-manual):

- inline/display MathJax formulas;
- problem sections such as input, output, interaction, examples, scoring, and notes;
- emphasis, monospace, underline, strikeout, text sizes, and verbatim text;
- nested lists and source-code blocks;
- URLs, links, epigraphs, quotes, dashes, centers, and line breaks;
- `tabular` tables including rules, `multicolumn`, and `multirow`;
- PNG/JPEG/GIF/SVG/WebP images embedded as self-contained data URLs and also copied next to the generated statement;
- `example`, `examplewide`, `examplethree`, `\exmp`, and `\exmpfile`;
- `defs.toml` common and language-specific custom commands with default arguments.

Sample input and output are retained as fenced text blocks instead of being discarded. Unsupported project-specific commands keep their readable arguments where possible and are listed as warnings for manual review.

## Encoding and ZIP behavior

Generated JSON and Markdown use UTF-8 without a BOM, LF newlines, and Unicode NFC. Input detection supports UTF-8, BOM-marked UTF-16, XML/statement charset declarations, and fallbacks for EUC-KR/CP949, Windows-1251, Shift_JIS, GB18030/Big5, and Windows-1252. Program sources, images, and manual tests are copied as bytes rather than re-encoded.

ZIP extraction rejects path traversal, symlinks, special files, duplicate output paths, more than 100,000 entries, and expanded data above 8 GiB. Legacy CP437 ZIP names are supported.

## Validate the result

Successful conversion means the structure and `config.json` passed PPS static validation. Compile and exercise the imported programs next:

```sh
cd ./two-sum
pps run .
pps run . --keep-work   # retain generated files when debugging
pps run . --docker      # isolate untrusted package code
```

The result is not automatically initialized as a Git repository. After review:

```sh
git init -b main
git add -A
git commit -m "import Polygon package"
```

To connect an existing PPS problem, run `pps remote <problem-id|owner/name>` inside the converted Git repository. It records the remote and PPS problem metadata but does not merge remote history. Review the branches and existing commits before using `pps sync`, `pps invocate`, and `pps deploy`.
