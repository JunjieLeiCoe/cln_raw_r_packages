# Auto-Uninstall Behavior

## Overview

This package **automatically uninstalls itself** from the user's computer if the GitHub repository https://github.com/JunjieLeiCoe/cln_raw_r_packages is not publicly accessible.

## When Does Uninstall Happen?

Every time a user runs `library(jleiutils)`, the package performs these checks:

### ✅ Scenario 1: Repository is PUBLIC (Normal)

```r
> library(jleiutils)
[ INFO ] jleiutils package loaded successfully
[ INFO ] Loaded packages (12):
  base, compiler, datasets, ...
```

**Result:** Package loads normally ✅

---

### ❌ Scenario 2: Repository Returns 404 (Not Found)

If the repository is deleted or URL is incorrect:

```r
> library(jleiutils)
[ ERROR ] GitHub repository not found (404).
[ WARNING ] Uninstalling package from your system...
[ INFO ] Uninstall script created at: C:\Users\...\Temp\uninstall_jleiutils.R
[ INFO ] Package will be removed after you close this session.
[ INFO ] Or run now: source('C:\Users\...\Temp\uninstall_jleiutils.R')
```

**Result:** Package creates uninstall script and schedules removal ❌

---

### 🔒 Scenario 3: Repository is PRIVATE

If you make the GitHub repository private:

```r
> library(jleiutils)
[ ERROR ] GitHub repository is PRIVATE.
[ WARNING ] Uninstalling package from your system...
[ INFO ] Uninstall script created at: C:\Users\...\Temp\uninstall_jleiutils.R
[ INFO ] Package will be removed after you close this session.
[ INFO ] Or run now: source('C:\Users\...\Temp\uninstall_jleiutils.R')
```

**Result:** Package creates uninstall script and schedules removal ❌

---

### ⚠️ Scenario 4: Repository Inaccessible (Other)

Network errors, GitHub down, or other issues:

```r
> library(jleiutils)
[ ERROR ] GitHub repository not accessible.
[ WARNING ] Uninstalling package from your system...
[ INFO ] Uninstall script created at: C:\Users\...\Temp\uninstall_jleiutils.R
[ INFO ] Package will be removed after you close this session.
[ INFO ] Or run now: source('C:\Users\...\Temp\uninstall_jleiutils.R')
```

**Result:** Package creates uninstall script and schedules removal ❌

---

## How Auto-Uninstall Works

### Step 1: Detection
When `library(jleiutils)` is called, the package checks:

1. **GitHub API:** `https://api.github.com/repos/JunjieLeiCoe/cln_raw_r_packages`
   - Status code 404 → Repository not found
   - Status code 200 with `"private": true` → Repository is private
   - Status code 200 with `"private": false` → Repository is public ✅

2. **GitHub Web URL:** `https://github.com/JunjieLeiCoe/cln_raw_r_packages` (fallback)
   - Status code 404 → Repository not found
   - Status code 200 → Accessible

### Step 2: Create Uninstall Script
If repository is not accessible, creates script at:
```
Windows: C:\Users\USERNAME\AppData\Local\Temp\uninstall_jleiutils.R
Linux/Mac: /tmp/uninstall_jleiutils.R
```

### Step 3: Schedule Removal
- Adds removal to `.Last` function (runs when R session exits)
- Or user can run the script immediately

### Step 4: Actual Removal
When executed, the script:
```r
remove.packages("jleiutils")
```

Displays:
```
[ INFO ] jleiutils package has been uninstalled.
[ INFO ] Reason: GitHub repository is not publicly accessible.
```

## Manual Uninstall Options

### Option 1: Run Provided Script Immediately
```r
# Use the path shown in the message
source('C:/Users/.../Temp/uninstall_jleiutils.R')
```

### Option 2: Wait for R Session to Exit
Simply close R, and the package will be removed automatically.

### Option 3: Manual Removal
```r
remove.packages("jleiutils")
```

## Testing the Behavior

### Test 1: Verify Current Status (Should Work)
```r
library(jleiutils)
# Should load normally since repo is currently public
```

### Test 2: Check GitHub Manually
```r
library(curl)

# Check API
api_url <- "https://api.github.com/repos/JunjieLeiCoe/cln_raw_r_packages"
response <- curl_fetch_memory(api_url)
response$status_code  # Should be 200

# Check if private
content <- rawToChar(response$content)
grepl('"private"\\s*:\\s*false', content)  # Should be TRUE (not private)
```

### Test 3: Simulate 404 (For Development)
To test the 404 behavior, temporarily change the repo name in `R/zzz.R`:
```r
github_repo <- "JunjieLeiCoe/fake_repo_that_doesnt_exist"
```
Then rebuild and load the package.

## Security & Protection

### Why This Feature?

1. **Control Distribution:** Ensures package only works when repo is public
2. **Prevent Unauthorized Use:** If repo goes private, all installations stop working
3. **Auto-Cleanup:** No orphaned packages on user systems
4. **Version Control:** Keep repo public = package works; make private = all stop

### Limitations

- Requires internet connection on package load
- 5-second timeout (won't hang, but might uninstall on temporary network issues)
- User can reinstall if they have the package files locally

### Bypassing (For Development)

If you want to disable this check during development:

1. Open `R/zzz.R`
2. Comment out the GitHub check:
```r
.onAttach <- function(libname, pkgname) {
    # suppressMessages(suppressWarnings({
    #     check_result <- check_github_availability(api_url, github_url)
    #     ... rest of check code ...
    # }))
    
    packageStartupMessage("[ INFO ] jleiutils package loaded (checks disabled)")
    invisible(NULL)
}
```

## Troubleshooting

### Issue: Package keeps uninstalling even though repo is public

**Solution:**
1. Check your internet connection
2. Verify repo is actually public on GitHub
3. Check if GitHub API is accessible from your network

### Issue: Want to keep package even if repo goes private

**Solution:** 
This is by design. If you want to use the package without the check:
1. Fork the repository
2. Remove the check from `R/zzz.R`
3. Build your own version

### Issue: False positives due to network issues

**Solution:**
The 5-second timeout is intentional to prevent long hangs. If your network is slow:
1. Ensure stable connection before loading package
2. Or modify timeout in `R/zzz.R` (line with `timeout = 5`)

## Use Case Example

### Scenario: Internal Company Package that Becomes Open Source

1. **Phase 1 - Private Development:**
   - Keep repo private
   - Package won't work for anyone (self-uninstalls)
   - Perfect for testing

2. **Phase 2 - Public Release:**
   - Make repo public
   - All installations now work
   - Package loads normally for everyone

3. **Phase 3 - Pull Package Back:**
   - Make repo private again
   - All existing installations detect this
   - Package auto-uninstalls from all user systems

## Summary

| Repository Status | Package Behavior |
|-------------------|------------------|
| ✅ Public (200 + "private":false) | Loads normally |
| ❌ Private (200 + "private":true) | Auto-uninstalls |
| ❌ Not Found (404) | Auto-uninstalls |
| ❌ Inaccessible (error/timeout) | Auto-uninstalls |

**Key Point:** This package **only works** when https://github.com/JunjieLeiCoe/cln_raw_r_packages is public and accessible.



