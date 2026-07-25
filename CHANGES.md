# Changes in this fork

Fork of [NulightJens/humanizer-stack](https://github.com/NulightJens/humanizer-stack)
at `13f5c02`. The two-pass design and the `structural-humanizer` skill are upstream's
work. Everything below is what this fork changed and why.

## Plumbing

**`copy_scan.py` moved into the skill that calls it.** It lived in the repo's
`scripts/`, but `install.sh` only installs `skills/*`, so after installation the
humanizer skill's instruction to run `scripts/copy_scan.py` pointed at nothing. It now
sits at `skills/humanizer/scripts/copy_scan.py` and both skills reference their scanner
by a path relative to their own SKILL.md.

**`Bash` added to the humanizer skill's `allowed-tools`.** The skill tells the model to
run a Python scanner, and the tool list did not permit running anything.

**`install.sh` falls back to copying** when `ln -s` is refused (Git Bash on Windows
without symlink privileges), instead of aborting under `set -e`.

## Scanner fixes

**Em dashes in markdown prose are no longer skipped.** The suppression regex was
inherited from a web-source scanner and exempted any line starting with `#`, `>`, `*`,
or `|`, so em dashes in headings, blockquotes, `*` bullets, and table cells were never
flagged. Code is still out of scope, now handled properly: fenced blocks are tracked
statefully, indented code blocks are detected only when opened after a blank line (so a
list continuation still counts as prose), and inline code spans are blanked before
matching.

**All hits on a line are reported.** Both scanners stopped at the first matching pattern
per rule per line, so `Supercharge, unleash, and effortlessly` counted once. Overlapping
matches are still deduplicated.

**En dashes are flagged with em dashes.** Upstream blader 2.9.1 bans both; the scanner
only looked for `—`.

**`tidy_closer` line numbers are exact.** The old code reconstructed the last two
paragraphs as a string and back-computed an offset, which drifted whenever the file had
trailing blank lines (a closer on line 6 was reported as line 8). Paragraphs are now
grouped while keeping each line's real number.

## Pass 1 rebased onto blader 2.9.1

The bundled `humanizer` skill was a fork of upstream 2.1.1. Upstream is at 2.9.1 and had
added, among other things:

- **"Never invent facts"** as a task rule, plus a fabrication check in the output loop.
  This matters because the old copy's own worked examples rewrote vague claims into
  invented specifics (a 2024 *New York Times* interview, a 2019 Chinese Academy of
  Sciences survey, a 2022 drainage project), teaching exactly the behavior the rule
  forbids. Upstream has since rewritten those examples to stay inside the source.
- **Voice calibration** from a user-supplied writing sample, which outranks the style
  rules, including the em-dash ban.
- Nine more patterns (aphorism formulas, manufactured punchlines, persuasive authority
  tropes, signposting, fragmented headers, hyphenated pairs, passive voice, diff-anchored
  writing, conversational rhetorical openers).
- A **false-positive** section and a list of human-writing signals to preserve.
- **Invocation modes** (pasted text, file, embedded).

This fork tracks 2.9.1 and re-applies the stack's own additions on top: the pass-1-of-2
scope note, the plain-emotion paragraph in PERSONALITY AND SOUL, the public-facing-copy
section, and the pipeline handoff. The frontmatter records the upstream version it was
rebased from, so the next sync is a diff rather than an archaeology exercise.

## Documentation accuracy

**The research framing is stated precisely.** Upstream's README implied style is a weak
signal. In the paper, style-only features score 85.8% macro-F1 and text-based baselines
reach 99.8-99.9%; the actual finding is that structure is *durable under rewriting*, not
that style is weak. The LAMP result now carries its scope (278 Gemini stories, Gemini as
its own rewriter) and its before/after numbers (95.5% to 93.9%).

**The em-dash ranking carries its own source's caveat.** One of the five auditors on the
upstream Reddit study argued the 7.1% figure is inflated by incidental punctuation rather
than actual complaints. That tension is now recorded where the number is used.

**`--strict` is documented correctly.** `PIPELINE.md` claimed both scanners exit 1 on any
hit; the structural scanner exits 1 only at its 2-hit-per-category threshold.

**Upstream copyright notices are reproduced.** `ATTRIBUTION.md` said the MIT obligation
was "keep copyright and license notice," but no upstream notice appeared anywhere in the
repo. The notices for Siqi Chen, Carter Johnson, and Jens Heitmann are now in
`ATTRIBUTION.md`, and `copy_scan.py` carries its upstream notice in its docstring.

## Added

**`tests/run_tests.sh`** — 16 fixture assertions covering every behavior above:
markdown-prose scanning, code exclusion, multi-hit lines, en dashes, `copy-ignore`,
exact closer line numbers, tail scoping, and both `--strict` contracts. Run it after
editing any rule.
