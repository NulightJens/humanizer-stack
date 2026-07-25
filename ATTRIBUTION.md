# Attribution and licensing

This repository packages material from several upstream sources. Each is listed
below with its license and what was taken. If you redistribute this work, these
obligations travel with it.

## Required copyright notices

The MIT License requires the copyright notice to travel with the code, so the
notices themselves are reproduced here rather than only linked:

```
Copyright (c) 2025 Siqi Chen (blader/humanizer)
Copyright (c) 2026 Carter Johnson (jcarterjohnson/vibecoded-design-tells)
Copyright (c) 2026 Jens Heitmann (NulightJens/humanizer-stack)
```

Each is MIT-licensed; the full text is in [LICENSE](LICENSE), which is the same
MIT text those projects use. `skills/humanizer/scripts/copy_scan.py` also carries
its upstream notice in its own docstring.

## Fork note

This repository is a fork of
[NulightJens/humanizer-stack](https://github.com/NulightJens/humanizer-stack) (MIT).
The two-pass design, the `structural-humanizer` skill, `storyscope-findings.md`, and
`genre-calibration.md` are that project's work. This fork rebased pass 1 onto blader
2.9.1, relocated `copy_scan.py` into the humanizer skill, fixed scanner defects, and
added tests. See [CHANGES.md](CHANGES.md).

## Summary

| Component | Upstream | License | Obligation |
|---|---|---|---|
| `skills/humanizer/SKILL.md` | [blader/humanizer](https://github.com/blader/humanizer) | MIT | Keep copyright and license notice |
| ...its underlying pattern catalog | [Wikipedia:Signs of AI writing](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing) | CC BY-SA 4.0 | Attribute and share alike |
| `skills/humanizer/references/copy-tells.md` | [jcarterjohnson/vibecoded-design-tells](https://github.com/jcarterjohnson/vibecoded-design-tells) | MIT | Keep copyright and license notice |
| `skills/humanizer/scripts/copy_scan.py` | same as above (`devibe_scan.py`) | MIT | Keep copyright and license notice |
| `skills/structural-humanizer/**` | [NulightJens/humanizer-stack](https://github.com/NulightJens/humanizer-stack) | MIT | Keep copyright and license notice; cite the paper below |
| StoryScope findings | Russell et al. 2026, arXiv:2604.03136 | academic citation | Cite, do not relicense |

## 1. humanizer (MIT, plus CC BY-SA upstream)

`skills/humanizer/SKILL.md` originates from the `humanizer` skill by
[@blader](https://github.com/blader/humanizer), released under the MIT License.
It tracks upstream **2.9.1** (the frontmatter records the version it was rebased
from). Local additions: the pass-1-of-2 scope note, the plain-emotion paragraph in
PERSONALITY AND SOUL, the public-facing-copy section, and the pipeline handoff.

That skill is in turn built from
[Wikipedia:Signs of AI writing](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing),
maintained by WikiProject AI Cleanup. Wikipedia text is licensed
**CC BY-SA 4.0**, which is a share-alike license.

**What this means in practice.** The pattern catalog (the vocabulary lists, the
named tells, the example rewrites) traces back to CC BY-SA material. Individual
facts and word lists are not themselves copyrightable, but the selection and
arrangement can be. This repository therefore attributes Wikipedia explicitly and
takes the position that any redistribution of `skills/humanizer/SKILL.md` should
preserve both this notice and the CC BY-SA attribution to WikiProject AI Cleanup.

If you intend to relicense that file under terms incompatible with CC BY-SA,
get your own legal read first. The rest of this repository is unaffected.

## 2. Copy tells (MIT)

`skills/humanizer/references/copy-tells.md` is condensed from section 11b of
`references/tells.md` in the `unslop-ui` skill, installed from
[jcarterjohnson/vibecoded-design-tells](https://github.com/jcarterjohnson/vibecoded-design-tells)
(MIT).

`skills/humanizer/scripts/copy_scan.py` is a port of the four copy rules (`copy-em-dash`,
`copy-antithesis`, `hype-copy`, `copy-servile`) from that repo's `devibe_scan.py`,
narrowed to prose files and given a standalone CLI.

The tell rankings come from that project's Reddit analysis: roughly 3.2M posts
across 47 subreddits (2020 to 2026), narrowed to 46,971 on-topic posts and 3,033
comments from 125 canonical threads. The harvested Reddit text itself belongs to
its original authors and is **not** redistributed here. Only the derived findings
are included.

## 3. structural-humanizer (original work)

`skills/structural-humanizer/**` is original work from the upstream repository
(NulightJens/humanizer-stack, MIT), modified here as recorded in CHANGES.md.
It is grounded in, but does not reproduce, the following paper:

> Russell, J., Rajendhran, S., Pham, N., Iyyer, M., and Wieting, J. (2026).
> *StoryScope: Investigating idiosyncrasies in AI fiction.* arXiv:2604.03136v4.
> University of Maryland and Google DeepMind.
> Code and data: https://github.com/jenna-russell/storyscope

`references/storyscope-findings.md` is a distillation: feature rates, headline
numbers, and robustness results restated in our own words and translated for
nonfiction content work. It reports findings, which are facts, and does not copy
the paper's prose. The paper is cited, not relicensed.

The transfer caveat is stated in the skill itself and repeated here: StoryScope
studied roughly 5,000-word fiction. Applying it to short nonfiction is an
inference, not a result the paper establishes.

## 4. Wikipedia notice (CC BY-SA 4.0)

Portions of `skills/humanizer/SKILL.md` derive from
"Wikipedia:Signs of AI writing", available under the
[Creative Commons Attribution-ShareAlike 4.0 License](https://creativecommons.org/licenses/by-sa/4.0/).
Maintained by WikiProject AI Cleanup contributors.
