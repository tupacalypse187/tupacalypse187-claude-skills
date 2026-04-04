---
description: Poll PR for review comments, evaluate them, remediate code, push fixes, and re-monitor
arguments:
  - name: pr_number
    description: Pull request number
    required: true
  - name: wait_seconds
    description: Seconds to wait before first poll for review comments (default 180)
    required: false
---

# Git Workflow: Review Remediation

This command polls a PR for code review comments, evaluates each one, makes code fixes if needed, pushes the fixes, replies to each comment, and re-monitors the PR.

## Instructions

### Phase 1: Wait for Reviews

1. Get the PR number from the user
2. Wait the specified number of seconds (default 180) for code reviews to complete
3. Display a countdown while waiting

```bash
echo "⏳ Waiting ${WAIT_SECONDS:-180} seconds for code reviews to complete..."
sleep ${WAIT_SECONDS:-180}
```

### Phase 2: Fetch Review Comments

1. Resolve the repo slug from the git remote
2. Fetch all review comments (inline code comments) and issue comments on the PR
3. Also fetch the review state (APPROVED, CHANGES_REQUESTED, COMMENTED, PENDING)

```bash
# Resolve the repo slug (e.g. "owner/repo")
REPO_SLUG=$(gh repo view --json nameWithOwner --jq '.nameWithOwner')

# Get top-level review comments (inline code-level comments)
# Filter out replies (in_reply_to_id != null) to get only original comments
gh api repos/$REPO_SLUG/pulls/$PR_NUMBER/comments --jq '.[] | select(.in_reply_to_id == null) | {id: .id, path: .path, line: .line, body: .body}'

# Get issue-level comments (general PR comments)
gh api repos/$REPO_SLUG/issues/$PR_NUMBER/comments --jq '.[] | {id: .id, body: .body}'

# Get review state
gh pr view $PR_NUMBER --json reviews --jq '.reviews[] | {state: .state, body: .body, author: .author.login}'
```

**Track comment IDs:** Initialize an empty list of processed IDs. You will compare against this list in Phase 7.

### Phase 3: Evaluate Each Comment

For each review comment:

1. **Read the comment** — understand what the reviewer is requesting
2. **Categorize the feedback:**
   - **Must fix** — bugs, security issues, logic errors, broken tests
   - **Should fix** — code style, naming, missing error handling, performance
   - **Suggestion** — optional improvements, alternative approaches
   - **Question** — reviewer asking for clarification (reply, no code change)
   - **Already addressed** — the comment refers to code already fixed
3. **Determine action** — whether code changes are needed or just a reply

### Phase 4: Remediate Code

For each comment that requires code changes:

1. **Read the referenced file** at the specified line
2. **Make the fix** — apply the minimal change needed to address the feedback
3. **Stage the fix** — stage only the files related to this comment
4. **Commit** with an emoji conventional commit referencing the review:

```bash
git add <changed-files>
git commit -m "🐛 fix: address review feedback - <brief description>"
```

5. **Repeat** for each comment requiring changes

### Phase 5: Push and Reply

After all fixes are committed:

1. **Push all fix commits** to update the PR:

```bash
git push
```

2. **Reply to each review comment** explaining what was done.

Before replying, compute the fix hash:
```bash
FIX_HASH=$(git rev-parse --short HEAD)
```

Then for each comment, reply using the shell variable `$FIX_HASH` and the literal numeric `id` from Phase 2:
```bash
# Reply to inline review comment (use the real comment id from the fetch step)
gh api repos/$REPO_SLUG/pulls/$PR_NUMBER/comments \
  --method POST \
  --field body="✅ Fixed in $FIX_HASH. <describe what was actually changed>" \
  --field in_reply_to=$COMMENT_ID

# Reply to general PR comment (note: this creates a new top-level comment — GitHub API limitation)
gh api repos/$REPO_SLUG/issues/$PR_NUMBER/comments \
  --method POST \
  --field body="✅ Addressed in $FIX_HASH. <describe what was actually changed>"
```

Reply format:
- For fixes: `✅ Fixed in <short_hash> — <what was changed>`
- For questions: `💡 <answer to the question>`
- For suggestions not applied: `🙏 Good suggestion, but <reason for not applying>. Happy to revisit if needed.`

### Phase 6: Re-monitor PR

1. Wait for CI checks to pass on the new commits
2. Check if the PR needs re-approval after the push
3. If checks pass and approved, offer to merge

```bash
# Monitor CI status
for i in {1..60}; do
  pr_status=$(gh pr view $PR_NUMBER --json mergeStateStatus --jq '.mergeStateStatus')

  if [ "$pr_status" = "CLEAN" ]; then
    echo "✅ All checks passed after remediation!"
    break
  fi

  echo "⏳ Waiting for checks... ($i/60) - status: $pr_status"
  sleep 10
done
```

### Phase 7: Loop Check

After pushing fixes and waiting for CI:

1. Re-fetch review comments to check for **new feedback** on the fixes
2. Compare comment IDs against the processed list from Phase 2
3. If new (unprocessed) comment IDs exist, add them to the processed list and repeat from Phase 3
4. If no new comments and checks pass, proceed to merge
5. **Maximum 5 iterations** — after 5 rounds of remediation, stop and inform the user that manual intervention may be needed

```bash
# Re-fetch to check for new comments (compare against previously seen IDs)
gh api repos/$REPO_SLUG/pulls/$PR_NUMBER/comments --jq '.[] | select(.in_reply_to_id == null) | .id'
```

**How to track processed comment IDs:**
1. Before starting Phase 3, initialize an empty list of processed IDs
2. Each time you process a comment, add its numeric `id` to the processed list
3. When re-fetching in Phase 7, compare the new list of IDs against the processed list
4. Only process IDs that appear in the new list but NOT in the processed list

## Important Rules

- **Always reply to every comment** — never leave a comment unacknowledged
- **Make minimal changes** — fix exactly what was requested, nothing more
- **One commit per logical fix** — don't bundle unrelated review fixes
- **Preserve existing functionality** — don't refactor surrounding code unless requested
- **Push after all fixes** — batch commits into a single push to avoid spamming CI
- **Don't push if no changes needed** — only push if actual code was modified
- **Respect reviewer intent** — if unclear, ask for clarification rather than guessing
