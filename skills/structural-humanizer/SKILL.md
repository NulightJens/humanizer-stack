---
name: structural-humanizer
description: >-
  Remove the discourse-level (structural) signs of AI writing that survive surface
  editing: stated lessons and moral-of-the-story closers, tidy single-track arcs,
  embodied-emotion performance ("chest tightened"), vague allusions instead of named
  references, unbroken linear structure, and shape convergence across pieces. Grounded
  in the StoryScope study (Russell et al. 2026): narrative structure alone detects AI
  text at 93.2% F1, and professional stylistic rewriting moved detection only 1.6
  points. Use as the SECOND pass after the humanizer skill (which handles words and
  phrasing) whenever writing or revising LinkedIn posts, course lessons, blog posts,
  essays, newsletters, or emails that must read as human. Triggers: "humanize",
  "de-slop", "AI tells", "make this sound human", "structural pass", "deep humanize".
---

# structural-humanizer

Read this first. The `humanizer` skill fixes words: "delve", em dashes, rule of three,
negative parallelism. This skill fixes what survives that pass: the structure. The two
are different jobs, run in sequence. Surface pass first, structural pass second.

**Why this layer matters more.** StoryScope (Russell et al. 2026, arXiv:2604.03136)
classified 61,608 stories from humans and 5 LLMs using only discourse-level features,
with all style features withheld: 93.2% detection accuracy. Then they ran AI text
through LAMP, a professional span-level rewriting framework that removes cliche,
purple prose, and redundant exposition (functionally, a surface humanizer). Detection
dropped 1.6 points. Meanwhile the surface layer is decaying on its own: GPT 5.4
already slashed em-dash usage, and fine-tuning drops stylistic detection from 97% to
3%. The durable fingerprint is structural, and fixing it requires structural rewrites,
not word swaps. Full findings with numbers: [references/storyscope-findings.md](references/storyscope-findings.md).

## The trap (same trap as unslop-ui)

Do not replace one default with another. If every piece now opens mid-scene, names
three feelings, and ends unresolved, that is a new detectable cluster. The study's
deepest finding is convergence: all five AI models occupy one tight region of
structural space while humans are dispersed and rare. Rarity IS the human signal.

So: **pick 1-2 structural interventions per piece, vary them across pieces, and be
able to say why this piece got this shape.** Never apply the whole menu at once.

## The six audits

Run these one at a time (aspect-based checking found 95% of issues in the study's own
pipeline vs 68% for one mega-pass). Numbers are human vs AI rates from the study.

### 1. Theme explicitness (the biggest tell)
AI states its lesson. Narrator explains the theme 77% of the time vs 52% for humans;
themes are moralized ~20% harder; everything ties back to one central point.
In content: the takeaway sentence, "What this means for you", the thesis restated at
every section end, every example dutifully interpreted.
**Fix:** state the point once, where it lands hardest. Cut every restatement. Let at
least one example sit uninterpreted. Trust the reader.

### 2. Structural tidiness
AI writes single-track: unbroken causal chain, no subplots (79% vs 57%), everything
resolved, protagonist-choice endings. Humans digress, loop, and leave threads open
(thematically parallel tangents: 42% vs 21%; ambivalent endings far more common).
**Fix options:** one tangent that only obliquely relates; one question raised and
explicitly not answered; stop before the resolution.

### 3. Emotion mode (inverts "show don't tell")
The single largest gap in the study: AI performs emotion through the body and
atmosphere 81% of the time vs 38% for humans ("chest tightened", "breath caught",
"the lamplight dimmed"). Humans just name it: explicit emotion labels 29% vs 8%.
**Fix:** say the feeling plainly ("honestly, it scared me", "I was pissed"). Reserve
embodied detail for the one moment that earns it. Yes, this contradicts classic
writing advice. Classic writing advice is now a machine signature.

### 4. Reference specificity
Humans name real things: specific texts, people, brands, places, prices (explicit
named references 47% vs 24%). AI stays at vague allusion (72% vs 50%) and avoids
naming real brands or works.
**Fix:** "a popular productivity book" becomes "Deep Work". "An expert" gets a name.
"Recently" gets a date. Add the price, the version number, the city.

### 5. Reader engagement
Humans acknowledge the reader (direct address 28% vs 7%; fourth-wall permeability 67%
vs 39%). "AI writes as though no one is watching." Content marketing already uses
"you" constantly, so the transferable move is acknowledging the writing itself:
"I know how this sounds", "skip this section if you already run ads", "you're
probably skimming, so here's the number". Use sparingly; it is a spice.

### 6. Shape convergence
Does this piece have the same skeleton as your last three? Same opener type, same
arc, same closer? That is the cluster forming. Compare against recent pieces and
break the pattern before publishing.

## Workflow

1. **Extract the skeleton first.** Outline the piece: beats in order, where the
   lesson is stated (and how many times), time structure (linear or not), what gets
   resolved, tangent count, emotion moments and their mode, named vs vague
   references. Audit the outline, not the prose. (This is the study's own method:
   structural tells hide from prose-level reading.)
2. **Run the six audits** against the skeleton, one at a time.
3. **Choose 1-2 interventions** from the menu below. Deliberate, genre-appropriate
   (see [references/genre-calibration.md](references/genre-calibration.md)), different
   from the last piece.
4. **Rewrite structurally.** Move sections, cut codas, delete restatements. Do not
   just polish sentences; that is the other skill's job.
5. **Scan:** run `scripts/structural_scan.py`, which ships inside this skill; resolve
   the path against this SKILL.md's own directory
   (`~/.claude/skills/structural-humanizer/scripts/structural_scan.py` for a user-level
   install, `.claude/skills/...` for a project-level one). It catches the
   pattern-matchable slice (embodied-emotion cliches, takeaway markers, vague
   allusions, uniformity), not the judgment-level audits.
6. **Re-check for the trap.** If the fix looks like the fix you applied yesterday,
   vary it.

## Intervention menu (rotate, never all at once)

- **Outcome first.** Open at the end state, then rewind. Payoff lands mid-piece, not
  in the close.
- **Cold open mid-scene.** Start inside the story, loop back for context later.
- **Delayed reveal.** Withhold the number/name/result the piece is built on until
  two-thirds through.
- **Recontextualization callback.** Make an earlier detail mean something new:
  "Remember the $80/month from the top? That was the cheap part."
- **The oblique tangent.** One paragraph that parallels the theme without serving it.
  Do not tie it back explicitly.
- **The open thread.** Name a question you cannot answer yet and leave it standing.
- **Genuine ambivalence.** End with both feelings intact instead of a resolved lesson.
- **The named thing.** Swap every vague allusion for a real, checkable specific.
- **Plain emotion.** Replace body-performance with the stated feeling.
- **Acknowledged reader.** One moment that admits someone is reading this.
- **End hot.** Stop at the spike instead of the quiet coda (see Claude fingerprint).

## Model fingerprints (know what drafted the text)

Most drafts here come from Claude, whose fingerprint is the most distinctive of all
five models. If the draft is Claude: **flat event escalation** (uniform intensity
throughout; fix by varying stakes and energy across the piece), **the epilogue habit**
(a wrap-up coda after the natural ending; cut it and end earlier), **reverent, quiet
endings** (occasionally end on the spike or unresolved). GPT drafts over-index on
distant retrospective framing ("years later, I realize") and social/gossip mechanics.
Gemini produces the tidiest endings; kill the bow on top.

## What this skill does not do

It does not fix vocabulary or punctuation (run `humanizer`). It does not impose a
voice (that is `jens-blog-writer` / `solo-scale-writer` / the Nick Saraev templates).
It does not make text undetectable; nothing does. And one honest caveat: StoryScope
studied ~5,000-word fiction. The transfer to short nonfiction is an inference, but the
core pattern (over-explanation, tidiness, linearity, convergence to one default shape)
is exactly what independent analyses of nonfiction AI slop keep finding, and the
short-text subset that transfers cleanly is audits 1, 3, 4, and 6.

## References

- [references/storyscope-findings.md](references/storyscope-findings.md) - the study
  distilled: all 30 core features with rates, fingerprints, robustness results, caveats.
- [references/genre-calibration.md](references/genre-calibration.md) - which audits
  and interventions apply per genre (LinkedIn / course lesson / blog / email).
- [scripts/structural_scan.py](scripts/structural_scan.py) - deterministic scanner for
  the grep-able tells. Designed to later run as a hook.
