# GitHub Setup Guide

## Steps to Push to GitHub

### 1. Create a New Repository on GitHub

1. Go to https://github.com/new
2. Repository name: `cln_raw_r_packages` (or your preferred name)
3. Description: "Personal R utility package for data science workflows"
4. Choose: **Public** or **Private**
5. **DO NOT** initialize with README, .gitignore, or license (we already have these)
6. Click "Create repository"

### 2. Link Local Repository to GitHub

Replace `yourusername` with your actual GitHub username:

```bash
git remote add origin https://github.com/yourusername/cln_raw_r_packages.git
```

Or if using SSH:

```bash
git remote add origin git@github.com:yourusername/cln_raw_r_packages.git
```

### 3. Push to GitHub

```bash
# Push to main branch (or master, depending on your default branch name)
git push -u origin master
```

If you want to rename the branch to `main`:

```bash
git branch -M main
git push -u origin main
```

### 4. Verify

Visit your repository on GitHub to confirm all files are uploaded.

## Installation from GitHub

After pushing, you or others can install the package with:

```r
# Install devtools if not already installed
install.packages("devtools")

# Install from GitHub
devtools::install_github("yourusername/cln_raw_r_packages")
```

## Updating the Package

After making changes:

```bash
# Stage changes
git add .

# Commit with descriptive message
git commit -m "Description of changes"

# Push to GitHub
git push
```

## Quick Commands Reference

```bash
# Check status
git status

# View commit history
git log --oneline

# Create and switch to new branch
git checkout -b feature-branch-name

# Switch back to main/master
git checkout master

# Pull latest changes
git pull origin master
```

## Update README

Remember to update the GitHub username in `README.md`:

```r
devtools::install_github("yourusername/cln_raw_r_packages")
```

Change `yourusername` to your actual GitHub username.


