# Setup and maintenance runbook

How to rebuild and maintain this AI harness configuration: skills and subagents come from this fork by symlink, instructions stay short, and every always-loaded item has to earn its tokens. The reasoning and the token budget are in [`ai-config-plan.md`](ai-config-plan.md). This file is the procedure.

Throughout, `$FORK` is where you cloned this repository, for example `~/code/agent-skills`.

## What lives where

| Item | Location | Notes |
|---|---|---|
| Skills and subagents (source of truth) | `$FORK/skills/`, `$FORK/agents/` | Upstream-owned; never edited in place |
| Shared checklists skills cite as `../../references/*.md` | `$FORK/references/` | Linked beside every skills folder |
| Which skills load everywhere | `yeison/skills-core.txt` | One name per line, with an approximate token cost |
| Which subagents load everywhere | `yeison/agents-core.txt` | Same format |
| Installer | `yeison/install.sh` | Symlinks only; never overwrites real files |
| Per-project skills | `<project>/.claude/skills.txt` | A manifest in the project; the links stay out of Git |
| Local notes that must not be public | `yeison/private/` | Not committed (see step 4) |

## Bootstrap on a new machine

1. **Tools.** Install Git and the GitHub CLI (`brew install gh` on macOS), then Claude Code and, if you use it, Cursor.
2. **Git identities by folder.** In `~/.gitconfig`, use one `[includeIf "gitdir:~/path/to/personal/"]` block per identity, each pointing at a small file that sets `user.name` and `user.email`. Never set the identity by hand in a repository. Check with `git config user.email` inside a repo of each kind.
3. **Clone and wire the fork.**
   ```bash
   git clone <your-fork-url> $FORK && cd $FORK
   git remote add upstream https://github.com/addyosmani/agent-skills.git
   ```
4. **Make the private folder local-only.** It is not part of the repository, so recreate it and keep Git from ever seeing it:
   ```bash
   mkdir -p yeison/private
   echo 'yeison/private/' >> .git/info/exclude
   ```
5. **Log the GitHub CLI in** (opens a browser; use a separate terminal tab):
   ```bash
   gh auth login -h github.com -p ssh -w
   ```
   Make sure no stale token variables are exported in your shell (see the pitfalls).
6. **Install the skills.**
   ```bash
   $FORK/yeison/install.sh --target claude --dry-run   # look first
   $FORK/yeison/install.sh --target claude              # skills, references, subagents
   ```
   Cursor also scans `~/.claude/skills`. Running `--target cursor` as well links the same skills into `~/.cursor/skills`; if you ever see duplicates in Cursor, keep only one of the two.
7. **Per-project skills.** In a project that needs an extra skill, create `.claude/skills.txt` (one skill name per line), then from the project root:
   ```bash
   $FORK/yeison/install.sh --target .claude/skills --manifest .claude/skills.txt
   printf '.claude/skills/\n.claude/references\n' >> .git/info/exclude
   ```
   The manifest is the only tracked file; the links are local.
8. **Instruction files.** Keep the global `~/.claude/CLAUDE.md` to a few lines. Put rules that apply to one employer or group of repositories in a `CLAUDE.md` in the parent folder of those repositories (Claude Code reads every instruction file from the working directory up to the root and concatenates them). Keep long references beside it and read them on demand.
9. **Verify.** Start a fresh session and run `/context`. Record the totals; compare with the numbers in the plan.

## Day-to-day maintenance

**Sync with upstream**
```bash
cd $FORK
git fetch upstream
git merge-tree --write-tree HEAD upstream/main >/dev/null && echo "no conflicts"   # optional dry run
git merge upstream/main
git push origin main
$FORK/yeison/install.sh --target claude        # safe to rerun; picks up new references
```
Because everything custom is add-only (`yeison/`, new files), merges should not conflict. If you must edit an upstream file, list it in `YEISON-FORK.md`.

**Add a skill everywhere:** add its name to `yeison/skills-core.txt`, then run the installer. **Remove one:** delete its line, then run the installer with `--prune`.

**Add a subagent:** add its name to `yeison/agents-core.txt` and run the installer. The default agents manifest is used only with `--target claude`; pass `--agents <file>` for other targets. **Remove one:** delete its line and remove the link by hand (`rm ~/.claude/agents/<name>.md`); `--prune` only handles skills.

**Audit the token cost:** run `/context` in a fresh session. For each always-loaded item, ask what it is worth; remove or shrink what cannot justify itself. Revisit after a few weeks of real use and drop any skill you never trigger.

## Pitfalls

1. **Git-ignored links can be overwritten by a branch switch.** If another branch still tracks files at the path where your ignored link lives (for example an old vendored copy), checking that branch out restores those files over the link. After the branch that removed them is merged, rerun the installer.
2. **Skills cite `../../references/<file>.md`.** Resolved as plain text, that path is `<skills folder>/../references`. Every skills folder needs a `references` link beside it; the installer creates it.
3. **Do not copy skills into projects or home folders.** Copies drift: they stop matching the fork after the next sync. Use links.
4. **Account-level skills sync in by themselves.** Skills enabled on your claude.ai account are downloaded into `~/.claude/skills/synced/`. Deleting that folder does nothing: it syncs again. To stop loading them, set `"syncClaudeAiSkills": false` in a settings file (allowed scopes: user, local or managed). To remove them everywhere, turn them off in your account's skills settings.
5. **A token in the environment beats the CLI's own login.** An exported `GH_TOKEN` or `GITHUB_TOKEN` takes precedence over a stored `gh` login, so a stale or revoked token makes `gh` fail. Remove stale exports from shell startup files, and keep credentials in the OS keychain, not in plain-text files.
6. **Never print process lists with arguments or environments** (for example `pgrep -fl`, `ps eww`). They can contain credentials. List executable names only.
7. **Local-only ignores.** For personal files inside a shared repository, use that repository's `.git/info/exclude`, not `.gitignore`. It is never committed. It only works for untracked files, and it does not stop `git add -f`.
8. **The fork is public.** Keep employer names, hostnames, internal repository names and incident notes out of every committed file. Use `yeison/private/` for those.
9. **Instruction files add up; they do not override.** Use `claudeMdExcludes` in a settings file to skip one for a specific project.

## Rollback

- **Skills and subagents:** the links are plain symlinks. Remove one with `rm ~/.claude/skills/<name>` (no `-r`, so the fork is never touched), or rerun the installer with `--prune` and a smaller manifest.
- **Upstream merge:** `git reset --hard <commit before the merge>` in the fork; the previous commit is shown when you merge.
- **Anything else:** take a dated backup of `~/.claude`, `~/.cursor` and your shell startup files before a large change, and keep it private (it may contain credentials). Delete it once the new setup is verified.

## Quick health check

```bash
ls -la ~/.claude/skills ~/.claude/agents | grep '^l'     # links into the fork
ls ~/.claude/references | head -3                        # shared references resolve
cd your-project && git status --short                    # links and generated files stay invisible
```
Then `/context` in a fresh session.
