# Package Authorization Setup

This package includes authorization protection to ensure only you can use it.

## Quick Setup

### Step 1: Check Current Status

```r
library(jleiutils)
show_user_info()
```

This will show:
- Your username
- Your computer name  
- Authorization status

### Step 2: Three Authorization Methods

The package checks THREE methods (you only need ONE to work):

#### Method 1: Username Check (Default)
Currently authorized usernames:
- `jlei`
- `JLei`
- `JLEI`

If your Windows username matches any of these, you're automatically authorized.

#### Method 2: Computer Name Check
The package automatically adds your current computer name to the authorized list.

#### Method 3: Environment Variable (Most Secure - Recommended)

1. **Find or create your `.Renviron` file**
   - Location: `C:\Users\jlei\Documents\.Renviron` (Windows)
   - Or run in R: `file.edit("~/.Renviron")`

2. **Add this line to `.Renviron`:**
   ```
   JLEI_AUTH_KEY="jlei_authorized_2025"
   ```

3. **Change the secret key** (recommended):
   - Open `R/auth.R`
   - Change line: `authorized_key <- "jlei_authorized_2025"` to your own secret
   - Update your `.Renviron` file with the same secret

4. **Restart R session** to load the new environment variable

5. **Verify:**
   ```r
   library(jleiutils)
   show_user_info()
   ```

### Helper Function

Run this for step-by-step instructions:

```r
library(jleiutils)
setup_auth()
```

## How It Works

Every exported function in the package calls `check_auth()` before executing. If authorization fails, the function stops with an error message:

```
[ ERROR ] Unauthorized access detected.
This package is for authorized use only.
Contact the package maintainer for access.
```

## Customizing Authorization

Edit `R/auth.R` to customize:

1. **Add more authorized usernames:**
   ```r
   authorized_users <- c("jlei", "JLei", "JLEI", "your_other_username")
   ```

2. **Add more authorized computers:**
   ```r
   authorized_computers <- c(
       "YOUR-COMPUTER-NAME",
       "YOUR-LAPTOP-NAME"
   )
   ```

3. **Change the secret key:**
   ```r
   authorized_key <- "your_custom_secret_key_here"
   ```

## Testing Authorization

```r
library(jleiutils)

# This will fail if not authorized:
log_info("Testing authorization")

# Check detailed status:
show_user_info()
```

## Removing Authorization (Make Public)

If you want to remove authorization and make it public:

1. Remove `check_auth()` calls from all functions in `R/`
2. Remove or comment out the auth checks
3. Commit and push changes

## Security Notes

- **Username/Computer checks**: Easy to set up, but someone with access to your code could add their username
- **Environment variable**: More secure because the key stays on your machine only
- **Best practice**: Use environment variable + custom secret key that you don't commit to GitHub
- **Even better**: Add `.Renviron` to `.gitignore` (it already is by default)

## Troubleshooting

**Problem**: "Unauthorized access detected" error

**Solutions**:
1. Run `show_user_info()` to see current status
2. Check if your username matches authorized list
3. Verify `.Renviron` file has correct key
4. Restart R session after editing `.Renviron`
5. Edit `R/auth.R` to add your specific username/computer

**Problem**: Can't find `.Renviron` file

**Solution**:
```r
# Create it if it doesn't exist
file.edit("~/.Renviron")
# Add the line: JLEI_AUTH_KEY="jlei_authorized_2025"
# Save and restart R
```

