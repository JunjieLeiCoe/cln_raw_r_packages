# Package Startup Behavior

## What Happens When You Load jleiutils

When you run `library(jleiutils)`, the following sequence occurs:

### 1. GitHub Availability Check (Silent)

The package automatically checks if https://github.com/JunjieLeiCoe/cln_raw_r_packages is:
- ✅ Public and accessible
- 🔄 Has newer version available

**This check:**
- Runs silently in background
- Times out after 5 seconds
- Does not disrupt your workflow

### 2. Auto-Update Check (If Applicable)

If a newer version is detected:

```
[ INFO ] Updating package from GitHub...
[ INFO ] Package updated successfully. Please restart R.
```

### 3. Success Message

```
[ INFO ] jleiutils package loaded successfully
```

### 4. Loaded Packages Display

**NEW!** The package automatically shows all loaded packages:

```
[ INFO ] Loaded packages (45):
  base, compiler, curl, datasets, devtools
  graphics, grDevices, jleiutils, methods, parallel
  rstudioapi, stats, tools, utils, ...
```

**Example Output:**
```r
> library(jleiutils)
[ INFO ] jleiutils package loaded successfully
[ INFO ] Loaded packages (12):
  base, compiler, datasets, graphics, grDevices
  jleiutils, methods, rstudioapi, stats, tools
  utils, usethis
```

## Loaded Packages Display

### What Gets Shown

- **All loaded namespaces** - Every package currently in memory
- **Count** - Total number of packages loaded
- **Clean format** - 5 packages per line for readability

### Why This Is Useful

1. **Debugging** - See what's loaded and might cause conflicts
2. **Documentation** - Know your environment for reproducibility
3. **Awareness** - Understand dependencies
4. **Troubleshooting** - Identify unexpected packages

### Example in Your Scripts

Based on your output:

```r
> source("c:\\Users\\jlei\\r-workspace\\clasp-consolidated\\...")
[ INFO ] Workspace cleared 
[ INFO ] Working directory set to: c:/Users/jlei/r-workspace/clasp-consolidated/...
[ INFO ] Script started successfully
```

Now when you first load jleiutils, you'll also see:

```r
> library(jleiutils)
[ INFO ] jleiutils package loaded successfully
[ INFO ] Loaded packages (15):
  base, dplyr, ggplot2, jleiutils, readr
  rstudioapi, stats, tidyr, utils, ...
```

## Additional Functions

You can also call these functions anytime:

### Simple View
```r
show_loaded_packages()
```
Output:
```
[ INFO ] === Loaded Packages (15) ===

  base, compiler, datasets, dplyr, ggplot2
  graphics, grDevices, jleiutils, methods, parallel
  readr, stats, tidyr, tools, utils
```

### Detailed View with Versions
```r
show_loaded_packages(detailed = TRUE)
```
Output:
```
[ INFO ] === Loaded Packages (15) ===

  base                      4.3.1
  dplyr                     1.1.3
  ggplot2                   3.4.4
  jleiutils                 0.1.0
  ...
```

### Full Session Info
```r
show_session_info()
```
Output:
```
[ INFO ] === Session Information ===

R version:     R version 4.3.1 (2023-06-16)
Platform:      x86_64-w64-mingw32/x64 (64-bit)
Running under: Windows 11 x64 (build 26100)

[ INFO ] Base packages (7):
  base, datasets, graphics, grDevices, methods, stats, utils

[ INFO ] Attached packages (3):
  dplyr                1.1.3
  ggplot2              3.4.4
  jleiutils            0.1.0

[ INFO ] Loaded via namespace (12):
  compiler, parallel, rstudioapi, tidyr, ...
```

### Check Package Version
```r
check_package_version()
```
Output:
```
[ INFO ] Current jleiutils version: 0.1.0
```

Or check against GitHub:
```r
check_package_version(check_github = TRUE)
```
Output:
```
[ INFO ] Current jleiutils version: 0.1.0
[ INFO ] Checking GitHub for latest version...
[ INFO ] GitHub version: 0.1.0
[ INFO ] You have the latest version
```

## Suppressing Startup Messages

If you want to load the package silently (without the loaded packages list):

```r
suppressPackageStartupMessages(library(jleiutils))
```

This will suppress:
- ✅ Success message
- ✅ Loaded packages list
- ✅ Update notifications

But GitHub checks still run in background.

## Customization

If you want to disable the loaded packages display on startup:

1. Open `R/zzz.R`
2. Comment out line in `.onAttach()`:

```r
# show_loaded_packages_on_startup()
```

3. Rebuild package

## Performance Impact

- **GitHub check**: ~1-5 seconds (only on first load per session)
- **Loaded packages display**: <0.1 seconds
- **Total overhead**: Minimal, runs once per session

## Troubleshooting

**Issue**: Too many packages shown, output is cluttered

**Solution**: Use `suppressPackageStartupMessages(library(jleiutils))`

**Issue**: Want more detail

**Solution**: After loading, run `show_session_info()`

**Issue**: Want to see packages later in script

**Solution**: Call `show_loaded_packages()` anytime



