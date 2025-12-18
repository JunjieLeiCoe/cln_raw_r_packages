# GitHub Repository Check & Auto-Update

## Overview

This package includes an automatic GitHub repository check and update system that runs every time the package is loaded.

## How It Works

When you load the package with `library(jleiutils)`, the following happens:

### 1. **GitHub Availability Check**

The package checks if https://github.com/JunjieLeiCoe/cln_raw_r_packages is:
- Publicly accessible
- Available (not deleted or private)

**Methods used:**
- GitHub API endpoint: `https://api.github.com/repos/JunjieLeiCoe/cln_raw_r_packages`
- Direct web URL check as fallback
- Timeout: 5 seconds

### 2. **If Repository is NOT Available**

The package now detects THREE specific failure conditions:

#### A. Repository Not Found (404)
```
[ ERROR ] GitHub repository not found (404).
[ WARNING ] Uninstalling package from your system...
```

#### B. Repository is Private
```
[ ERROR ] GitHub repository is PRIVATE.
[ WARNING ] Uninstalling package from your system...
```

#### C. Other Access Issues
```
[ ERROR ] GitHub repository not accessible.
[ WARNING ] Uninstalling package from your system...
```

**Automatic Uninstallation:**

The package will automatically:
1. Create an uninstall script in temp directory
2. Schedule removal when you exit R session
3. Provide manual option if you want to uninstall immediately

```
[ INFO ] Uninstall script created at: /tmp/uninstall_jleiutils.R
[ INFO ] Package will be removed after you close this session.
[ INFO ] Or run now: source('/tmp/uninstall_jleiutils.R')
```

**To uninstall immediately:**
```r
# Use the provided path
source('/tmp/uninstall_jleiutils.R')

# Or manually
remove.packages("jleiutils")
```

### 3. **If Repository IS Available**

If the repository is public and accessible:

- ✅ Package checks for updates
- ✅ Compares local version with GitHub version
- ✅ Auto-installs newer version if available
- ✅ Displays success message

```
[ INFO ] jleiutils package loaded successfully
```

### 4. **Auto-Update**

If a newer version is detected on GitHub:

```
[ INFO ] Updating package from GitHub...
[ INFO ] Package updated successfully. Please restart R.
```

The package will:
1. Download the latest version from GitHub
2. Install it automatically
3. Prompt you to restart R

## Requirements

For full functionality, these packages are recommended:

- **curl** - For checking GitHub availability (required)
- **devtools** - For auto-updates from GitHub (suggested)

```r
install.packages(c("curl", "devtools"))
```

## Behavior Summary

| Condition | Action |
|-----------|--------|
| GitHub repo is public & accessible | ✅ Load package normally |
| Newer version available on GitHub | 🔄 Auto-update and prompt restart |
| GitHub repo returns 404 (not found) | ❌ Show "404" error, auto-uninstall |
| GitHub repo is PRIVATE | ❌ Show "PRIVATE" error, auto-uninstall |
| GitHub repo inaccessible (other) | ❌ Show "not accessible" error, auto-uninstall |
| Network timeout or error | ⚠️ Assume not available, auto-uninstall |

## Testing

### Test 1: Check if package loads normally

```r
library(jleiutils)
# Should see: [ INFO ] jleiutils package loaded successfully
```

### Test 2: Check GitHub availability manually

```r
# Check if repo is accessible
url <- "https://api.github.com/repos/JunjieLeiCoe/cln_raw_r_packages"
response <- curl::curl_fetch_memory(url)
response$status_code  # Should be 200 if public
```

### Test 3: Verify current version

```r
packageVersion("jleiutils")
```

## Manual Control

### Disable Auto-Update (if needed)

If you want to prevent auto-updates, you can set an environment variable:

```r
# In your .Renviron file:
JLEIUTILS_NO_UPDATE=TRUE
```

Then modify `R/zzz.R` to check this variable.

### Force Update

```r
# Manually update from GitHub
devtools::install_github("JunjieLeiCoe/cln_raw_r_packages", force = TRUE)
```

### Check Without Loading

```r
# Check repo availability without loading package
url <- "https://github.com/JunjieLeiCoe/cln_raw_r_packages"
httr::GET(url)$status_code  # Should be 200 if accessible
```

## Security Considerations

1. **Network Dependency**: Package requires internet connection on load
2. **Auto-Update Risk**: Automatically installs code from GitHub (your own repo)
3. **Timeout**: 5-second timeout prevents long waits
4. **Silent Failures**: Update failures are silent to avoid disrupting workflow

## Disabling This Feature

If you want to disable the GitHub check:

1. Open `R/zzz.R`
2. Comment out the `.onAttach` function
3. Rebuild package

Or set `.onAttach` to just show a simple message:

```r
.onAttach <- function(libname, pkgname) {
    packageStartupMessage("jleiutils package loaded")
    invisible(NULL)
}
```

## Troubleshooting

**Problem**: Package keeps trying to uninstall

**Solution**: Check if GitHub repo is public and accessible

**Problem**: Auto-update not working

**Solutions**:
1. Install devtools: `install.packages("devtools")`
2. Check internet connection
3. Verify GitHub repo is accessible

**Problem**: Long loading time

**Solution**: Check network connection (5-second timeout applies)

**Problem**: Want to disable this feature

**Solution**: Edit `R/zzz.R` and simplify `.onAttach()` function

