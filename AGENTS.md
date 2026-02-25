# Development Workflow

This document outlines the Git workflow best practices for this project.

**Important:** This is a detached fork. Changes are pushed to this fork (origin), not contributed back to the upstream repository.

## Git Workflow: Local Fork Development

This project follows a **branch-based workflow** optimized for independent development on a detached fork.

### Core Principles

1. **Main branch is stable** - The `main` branch should always be in a working state
2. **Create feature branches** - All work happens in branches, never directly on `main`
3. **Review changes before merging** - Use `git diff` and self-review before merging
4. **Keep history clean** - Use squash merges for feature branches
5. **Delete branches after merge** - Clean up branches immediately after merging
6. **Push to your fork only** - Changes go to origin, not upstream

### Branch Naming Conventions

Use kebab-case with descriptive prefixes:

| Prefix | Purpose | Example |
|--------|---------|---------|
| `feature/` | New functionality | `feature/user-authentication` |
| `bugfix/` | Non-urgent bug fixes | `bugfix/login-redirect-loop` |
| `hotfix/` | Urgent production fixes | `hotfix/payment-null-pointer` |
| `docs/` | Documentation changes | `docs/api-documentation` |
| `refactor/` | Code refactoring | `refactor/database-queries` |
| `test/` | Test additions | `test/integration-suite` |
| `chore/` | Maintenance tasks | `chore/update-dependencies` |

**Guidelines:**
- Use lowercase with hyphens (kebab-case)
- Keep under 50 characters
- Include ticket numbers when applicable: `feature/PROJ-1234-user-auth`
- No spaces or special characters (except `/` and `-`)

### Workflow Steps

#### 1. Create a Feature Branch

```bash
git checkout main
git pull origin main
git checkout -b feature/your-feature-name
```

#### 2. Make Commits

```bash
git add .
git commit -m "feat: add user authentication system"
git push -u origin feature/your-feature-name
```

**Commit Message Format:**
- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `style:` Code style changes (formatting, missing semi-colons)
- `refactor:` Code refactoring
- `test:` Test additions/changes
- `chore:` Build process or auxiliary tool changes

#### 3. Review Changes

Before merging, review your changes:

```bash
git diff main...feature/your-feature-name
```

Check that:
- Changes are focused and complete
- No debugging code or secrets committed
- Tests pass (if applicable)
- Code follows project conventions

#### 4. Merge and Cleanup

Merge using **squash merge** for clean history:

```bash
# Switch to main and pull latest
git checkout main
git pull origin main

# Merge the feature branch with squash
git merge --squash feature/your-feature-name
git commit -m "feat: add user authentication system"

# Push to your fork (origin)
git push origin main

# Delete the local branch
git branch -d feature/your-feature-name

# Optionally delete remote branch on your fork
git push origin --delete feature/your-feature-name
```

### Merge Strategies

- **Squash Merge**: Default for feature branches - combines all commits into one clean commit
- **Regular Merge**: Use when you want to preserve individual commits from the branch
- **Rebase**: For linear history without merge commits (optional)

### Handling Merge Conflicts

1. Sync with main frequently:
   ```bash
   git fetch origin
   git rebase origin/main
   ```

2. If conflicts occur:
   ```bash
   # Open conflicted files and resolve markers
   git add <resolved-file>
   git rebase --continue
   ```

3. Enable `rerere` to remember resolutions:
   ```bash
   git config --global rerere.enabled true
   ```

### Best Practices

- **Keep branches small and focused** - Under 400 lines when possible
- **Short-lived branches** - Merge within days, not weeks
- **Regular syncs** - Rebase/merge from `main` daily
- **Descriptive commits** - Each commit should be an isolated, complete change
- **One branch per feature** - Don't combine unrelated changes
- **Clean up** - Delete branches immediately after merging
- **Don't push to upstream** - Remember this is a detached fork

### Emergency Hotfixes

For urgent fixes:

```bash
git checkout main
git checkout -b hotfix/critical-fix
# Fix and commit
git commit -am "fix: critical security patch"
git merge --squash hotfix/critical-fix
git push origin main
git branch -d hotfix/critical-fix
```

### Resources

- [GitHub Flow Documentation](https://docs.github.com/get-started/quickstart/github-flow)
- [Git Branching Strategies Guide](https://devtoolbox.dedyn.io/blog/git-branching-strategies-guide)
