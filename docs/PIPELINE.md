# The pipeline

Two passes, in order. They do different jobs and neither substitutes for the other.

```
draft
  |
  v
[ pass 1: humanizer ]          words, phrasing, punctuation, copy tells
  |                            scanner: skills/humanizer/scripts/copy_scan.py
  v
[ pass 2: structural-humanizer ]  discourse shape, arc, emotion mode, reference
  |                               scanner: skills/structural-humanizer/scripts/structural_scan.py
  v
[ voice layer (optional, yours) ]  house style, register, personal rules
  |
  v
publish
```

## Why this order

Pass 1 is cheap and mechanical. Running it first clears the noise so the structural
audit is reading the actual skeleton instead of tripping over vocabulary.

Pass 2 requires rewriting at the section level: moving material, cutting codas,
deleting restatements. Doing that after a word-level pass means you are not polishing
sentences you are about to delete.

The voice layer goes last because it is additive. Passes 1 and 2 remove signal that
should not be there. A voice layer adds signal that should.

## What each layer owns

| Layer | Owns | Does not own |
|---|---|---|
| `humanizer` | Vocabulary, punctuation, negative parallelism, rule of three, hype copy, sycophancy | Structure, arc, what gets resolved |
| `structural-humanizer` | Stated lessons, tidiness, emotion mode, reference specificity, reader address, shape convergence | Word choice, punctuation, house style |
| voice layer | Register, rhythm, personal rules, banned constructions | Anything the first two passes handle |

Keeping these separate matters. When one skill tries to do all three jobs it does the
structural work badly, because structural work needs the skeleton extracted first and
audited on its own.

## Running pass 2 properly

The structural skill has one instruction people skip: **audit the outline, not the
prose.**

1. Extract the skeleton. Beats in order, where the lesson is stated and how often, time
   structure, what resolves, tangent count, emotion moments and their mode, named
   against vague references.
2. Run the six audits against that skeleton, one at a time.
3. Choose one or two interventions. Genre-appropriate, and different from last time.
4. Rewrite structurally.
5. Scan.
6. Check the trap: if the fix looks like yesterday's fix, vary it.

Structural tells hide from prose-level reading. That is the whole reason they survive
a surface pass.

## Model fingerprints

Worth knowing what drafted the text, because each model converges differently.

- **Claude.** Flat event escalation (uniform intensity), the epilogue habit (a wrap-up
  coda after the natural ending), reverent quiet endings. Cut the coda and end earlier.
- **GPT.** Distant retrospective framing ("years later, I realize"), social and gossip
  mechanics.
- **Gemini.** The tidiest endings of the five. Kill the bow on top.

## Hooking the scanners

Both scanners support `--strict`, but they mean different things by it. `copy_scan.py`
exits 1 on any hit. `structural_scan.py` exits 1 only when a category reaches its
threshold (2 hits per document for embodied emotion, stated lesson, tidy closer, or
vague allusion), because a single embodied-emotion line is a choice and four are a habit.
Its paragraph-uniformity and number-density metrics are informational and never affect
the exit code.

```bash
python3 skills/humanizer/scripts/copy_scan.py --strict content/**/*.md \
  && python3 skills/structural-humanizer/scripts/structural_scan.py --strict content/**/*.md
```

Installed rather than cloned? The scanners ship inside their skills, so use
`~/.claude/skills/humanizer/scripts/copy_scan.py` and
`~/.claude/skills/structural-humanizer/scripts/structural_scan.py`.

Use this as a gate on outward-facing content only. Applied to internal docs it will fire
constantly on text that nobody needs to be human.
