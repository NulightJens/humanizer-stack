# Copy tells: the words that read as machine-made

Surface tells that appear in public-facing copy specifically: landing pages, marketing
sites, product UI, emails, and social posts. These sit alongside the main `humanizer`
patterns and are worth a separate pass because copy has its own failure modes that
long-form prose does not.

Rankings come from the `unslop-text` companion study in the vibecoded-design-tells
dataset: roughly 3.2M Reddit posts scanned across 47 AI and SaaS subreddits (2020 to
2026), narrowed to 46,971 on-topic posts and 3,033 comments from 125 canonical
"why does all this read as AI" threads. Percentages are cite-share among the most-read
complaint posts.

## The mechanical four (a scanner can catch these)

Run `scripts/copy_scan.py` (inside this skill) to flag them:
`python3 ~/.claude/skills/humanizer/scripts/copy_scan.py <file>`.

### 1. The em dash (7.1%, the most-cited writing tell)

On visible copy the em dash reads as "a machine wrote this." It ranks above every
vocabulary word in the dataset.

**Caveat from the source itself.** Four of that project's five auditors independently
confirmed the em dash as the most-cited tell in their chunks; the fifth argued the count
is inflated because most em-dash occurrences were the poster's own incidental
punctuation rather than a complaint about em dashes. The upstream synthesis kept it at #1
and flagged the tension. Treat it as a strong signal, not a settled ranking, and note
that the en dash rides along with it (§14 of `SKILL.md` bans both).

**Fix:** use a comma, a period, or parentheses. Do not simply substitute a colon,
because readers flag that too as the same reflex wearing a different hat.

**Exception:** an em dash inside code, a code comment, or a technical spec is not
user-facing copy. The scanner suppresses those.

### 2. "It's not just X, it's Y" (2.8%)

The negate-then-assert cadence, including the "not only X but Y" variant. This is the
clearest single sentence-level AI accent.

**Fix:** state the thing plainly. If Y is the real claim, lead with Y and drop X
entirely. The negation is almost always there to inflate a thin point.

### 3. Hype vocabulary

"Transform your X", "Supercharge", "Unleash", "Effortlessly", "unlock your potential",
"dive in" and "deep dive", "delve", "elevate your X", "in today's fast-paced world",
"game-changer", "revolutionary", "world-class", "cutting-edge", "best-in-class",
"take it to the next level", "Your X, reimagined".

**Fix:** write what the thing literally does. "Supercharge your workflow" says nothing.
"Cuts the export step from four clicks to one" says something checkable.

### 4. Sycophancy and signposting

Openers: "Great question!", "I hope this helps."
Closers: "In conclusion", "In summary."

**Fix:** start on the actual point and end on the actual point. A wrap-up paragraph
that restates what the reader just read is the written form of the stated-lesson tell
that `structural-humanizer` audit 1 covers.

## The cadence tells (only a human catches these)

About half the writing tells in the study are invisible to regex. Check these by eye:

- **Uniform sentence rhythm.** Every sentence landing at roughly the same length. Real
  writing varies hard, with a two-word sentence next to a forty-word one.
- **Formulaic shape.** Each section built to the same template: claim, three supports,
  mini-conclusion. See audit 6 in `structural-humanizer` for the structural version of
  this problem.
- **Polished but empty.** Copy that survives every mechanical check and still tells the
  reader nothing specific. This is the residue left when hype vocabulary is removed but
  nothing concrete replaces it.

## The one rule

Write what the thing does, in plain words a person would actually say, with a reason
behind the claim. Copy that passes every scanner and still says nothing has not been
de-slopped. It has been sanded.

## Relationship to the other passes

| Layer | Skill | Catches |
|---|---|---|
| Words and phrasing | `humanizer` | Vocabulary, punctuation, negative parallelism, rule of three |
| Copy specifically | this file | Em dash, antithesis cadence, hype vocab, sycophancy |
| Discourse structure | `structural-humanizer` | Stated lessons, tidy arcs, embodied emotion, vague reference |

Copy tells belong to pass 1 because they are word-level and mechanically checkable.
Structure is a separate job. A page can pass every check here and still be detectable
from its shape alone.

## Source

Extracted from section 11b of `references/tells.md` in the `unslop-ui` skill, which is
installed from [vibecoded-design-tells](https://github.com/jcarterjohnson/vibecoded-design-tells)
by jcarterjohnson (MIT). The scanner rules in `scripts/copy_scan.py` are ported from
that repo's `devibe_scan.py`, narrowed to the four copy rules and adapted for prose
files rather than web source.
