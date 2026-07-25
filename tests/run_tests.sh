#!/usr/bin/env bash
# run_tests.sh - fixture assertions for both scanners.
#
#   ./tests/run_tests.sh            run every check
#
# Each check runs a scanner over a fixture and compares the result to an expected
# value. Edit a rule, run this, and you find out immediately whether the rule still
# does what the docs claim.

set -uo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
COPY="$REPO/skills/humanizer/scripts/copy_scan.py"
STRUCT="$REPO/skills/structural-humanizer/scripts/structural_scan.py"
PY="${PYTHON:-}"
if [[ -z "$PY" ]]; then
  if command -v python3 > /dev/null 2>&1; then PY=python3; else PY=python; fi
fi
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

pass=0
fail=0

check() { # check <name> <expected> <actual>
  if [[ "$2" == "$3" ]]; then
    printf '  ok   %s\n' "$1"
    pass=$((pass + 1))
  else
    printf '  FAIL %s (expected %s, got %s)\n' "$1" "$2" "$3"
    fail=$((fail + 1))
  fi
}

count_hits() { # count_hits <rule-id> <file>
  "$PY" "$COPY" --json "$2" | "$PY" -c \
    "import json,sys; d=json.load(sys.stdin); print(sum(1 for h in d['hits'] if h['id']=='$1'))"
}

struct_count() { # struct_count <category> <file>
  "$PY" "$STRUCT" --json "$2" | "$PY" -c \
    "import json,sys; d=json.load(sys.stdin); print(len(next(iter(d.values()))['$1']))"
}

struct_lines() { # struct_lines <category> <file>
  "$PY" "$STRUCT" --json "$2" | "$PY" -c \
    "import json,sys; d=json.load(sys.stdin); print(','.join(str(h['line']) for h in next(iter(d.values()))['$1']))"
}

echo "copy_scan.py"

# Markdown prose is copy: headings, blockquotes, bullets, and table cells count.
cat > "$TMP/copy_markdown.md" <<'EOF'
# Heading with a word—dash

* Star bullet—dash
- Dash bullet—dash

> Blockquote—dash

| cell—one | plain |

Body prose—dash.
EOF
check "em dash found in headings, quotes, bullets, tables, body" 6 \
  "$(count_hits copy-em-dash "$TMP/copy_markdown.md")"

# Code is not copy.
cat > "$TMP/copy_code.md" <<'EOF'
`inline—dash` stays quiet.

```
fenced—dash stays quiet
```

    indented—dash stays quiet

// comment—dash stays quiet
EOF
check "em dash ignored in code and comments" 0 \
  "$(count_hits copy-em-dash "$TMP/copy_code.md")"

# Every hit on a line is reported, not just the first.
printf 'Supercharge, unleash, and effortlessly, all in one line.\n' > "$TMP/copy_multi.md"
check "all hype hits on one line reported" 3 \
  "$(count_hits hype-copy "$TMP/copy_multi.md")"

# En dashes ride along with em dashes.
printf 'An en dash–case in plain prose.\n' > "$TMP/copy_endash.md"
check "en dash found" 1 "$(count_hits copy-em-dash "$TMP/copy_endash.md")"

# copy-ignore still suppresses.
printf 'Body prose—dash. copy-ignore\n' > "$TMP/copy_ignore.md"
check "copy-ignore suppresses the line" 0 "$(count_hits copy-em-dash "$TMP/copy_ignore.md")"

# The other two rules still fire.
printf "It's not just a tool, it's a revolution. In conclusion, thanks.\n" > "$TMP/copy_rules.md"
check "antithesis found" 1 "$(count_hits copy-antithesis "$TMP/copy_rules.md")"
check "servile found" 1 "$(count_hits copy-servile "$TMP/copy_rules.md")"

# --strict exits 1 on any hit.
"$PY" "$COPY" --strict "$TMP/copy_endash.md" > /dev/null 2>&1
check "copy --strict exits 1 on a hit" 1 "$?"
"$PY" "$COPY" --strict "$TMP/copy_code.md" > /dev/null 2>&1
check "copy --strict exits 0 when clean" 0 "$?"

echo "structural_scan.py"

# tidy_closer reports the real line number and ignores trailing blank lines.
printf 'Para one.\n\nPara two.\n\nUltimately we won.\n\n\n' > "$TMP/struct_tail.md"
check "tidy closer line number is exact" "5" \
  "$(struct_lines tidy_closer "$TMP/struct_tail.md")"

# tidy_closer only looks at the last two paragraphs.
printf 'Intro.\n\nUltimately this is too early to count.\n\nMiddle.\n\nMore middle.\n\nThe end.\n' \
  > "$TMP/struct_early.md"
check "tidy closer ignores early paragraphs" 0 \
  "$(struct_count tidy_closer "$TMP/struct_early.md")"

# The three whole-document categories still fire.
cat > "$TMP/struct_body.md" <<'EOF'
My chest tightened and her breath caught.

The lesson here is that experts say studies show it works.
EOF
check "embodied emotion found" 2 "$(struct_count embodied_emotion "$TMP/struct_body.md")"
check "stated lesson found" 1 "$(struct_count stated_lesson "$TMP/struct_body.md")"
check "vague allusion found" 2 "$(struct_count vague_allusion "$TMP/struct_body.md")"

# --strict fires on the 2-hit threshold, not on a single hit.
"$PY" "$STRUCT" --strict "$TMP/struct_body.md" > /dev/null 2>&1
check "structural --strict exits 1 at threshold" 1 "$?"
printf 'My chest tightened once.\n' > "$TMP/struct_one.md"
"$PY" "$STRUCT" --strict "$TMP/struct_one.md" > /dev/null 2>&1
check "structural --strict exits 0 below threshold" 0 "$?"

printf '\n%d passed, %d failed\n' "$pass" "$fail"
[[ "$fail" -eq 0 ]]
