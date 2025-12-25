# 📤 GitHub Upload Guide - Thriftly App

Panduan lengkap untuk upload project ke GitHub.

---

## 🚀 Quick Steps

### 1. Initialize Git (DONE)
```bash
git init
git add .
git commit -m "Initial commit: Flutter project with Firebase setup"
```

### 2. Create GitHub Repository

1. Buka https://github.com/
2. Klik **"New repository"** atau tombol **"+"** > **"New repository"**
3. **Repository name**: `thriftly_app` (atau nama lain)
4. **Description**: "Sustainable thrift shopping app built with Flutter & Firebase"
5. **Visibility**: 
   - ✅ **Public** (recommended untuk portfolio)
   - ⬜ Private (jika ingin private)
6. **JANGAN** centang:
   - ⬜ Add a README file (kita sudah punya)
   - ⬜ Add .gitignore (kita sudah punya)
   - ⬜ Choose a license
7. Klik **"Create repository"**

### 3. Connect & Push to GitHub

Setelah repository dibuat, GitHub akan menampilkan command. Copy dan jalankan:

```bash
# Add remote repository
git remote add origin https://github.com/YOUR_USERNAME/thriftly_app.git

# Rename branch to main (if needed)
git branch -M main

# Push to GitHub
git push -u origin main
```

**Ganti `YOUR_USERNAME` dengan username GitHub Anda!**

---

## 📋 Detailed Instructions

### Step 1: Check Git Status

```bash
# Check current status
git status

# Should show all files ready to commit
```

### Step 2: Review Files to be Committed

```bash
# See all files that will be committed
git ls-files

# Should include:
# - lib/ folder
# - assets/ folder
# - Documentation (.md files)
# - pubspec.yaml
# - .gitignore
# - etc.
```

### Step 3: Create GitHub Repository (Web)

**A. Via GitHub Website:**
1. Login ke https://github.com/
2. Klik **"+"** icon (top right) > **"New repository"**
3. Fill in:
   - **Repository name**: `thriftly_app`
   - **Description**: "🛍️ Sustainable thrift shopping app - Flutter & Firebase"
   - **Public** ✅
4. **DON'T** check any initialize options
5. Click **"Create repository"**

**B. Via GitHub CLI (Alternative):**
```bash
gh repo create thriftly_app --public --source=. --remote=origin --push
```

### Step 4: Connect Local to GitHub

```bash
# Add GitHub repository as remote
git remote add origin https://github.com/YOUR_USERNAME/thriftly_app.git

# Verify remote
git remote -v

# Should show:
# origin  https://github.com/YOUR_USERNAME/thriftly_app.git (fetch)
# origin  https://github.com/YOUR_USERNAME/thriftly_app.git (push)
```

### Step 5: Push to GitHub

```bash
# Push to main branch
git push -u origin main

# Enter GitHub credentials if prompted
```

---

## ✅ Verification

### Check di GitHub Website
1. Buka `https://github.com/YOUR_USERNAME/thriftly_app`
2. Pastikan semua file sudah terupload:
   - ✅ README.md tampil di homepage
   - ✅ Folder lib/ ada
   - ✅ Documentation files (.md) ada
   - ✅ pubspec.yaml ada

### Check README Rendering
- README.md harus tampil bagus dengan badges dan formatting
- Links harus bekerja

---

## 🔐 Authentication Options

### Option 1: HTTPS (Recommended untuk pemula)
```bash
git remote add origin https://github.com/YOUR_USERNAME/thriftly_app.git
```
- Nanti akan diminta username & password/token
- Gunakan **Personal Access Token** bukan password

### Option 2: SSH (Recommended untuk advanced users)
```bash
git remote add origin git@github.com:YOUR_USERNAME/thriftly_app.git
```
- Perlu setup SSH key terlebih dahulu
- Lebih aman dan tidak perlu input password

---

## 🔑 GitHub Personal Access Token (If Using HTTPS)

Jika diminta password saat push:

1. Buka https://github.com/settings/tokens
2. Click **"Generate new token"** > **"Generate new token (classic)"**
3. **Note**: "Thriftly App Access"
4. **Expiration**: 90 days (atau sesuai kebutuhan)
5. **Select scopes**: 
   - ✅ repo (full control)
6. Click **"Generate token"**
7. **COPY TOKEN** (you won't see it again!)
8. Use this token as password saat git push

---

## 📝 Future Git Commands

### Daily Workflow

**After making changes:**
```bash
# Check what changed
git status

# Add all changes
git add .

# Commit with message
git commit -m "Add product detail screen"

# Push to GitHub
git push
```

### Good Commit Messages

✅ **Good:**
- `"Add product detail screen with image gallery"`
- `"Fix login button not working"`
- `"Update Firebase security rules"`
- `"Improve home screen performance"`

❌ **Bad:**
- `"update"`
- `"fix bug"`
- `"changes"`
- `"asdf"`

### Useful Commands

```bash
# See commit history
git log --oneline

# See changes before commit
git diff

# Undo last commit (keep changes)
git reset --soft HEAD~1

# Create new branch
git checkout -b feature/new-feature

# Switch branch
git checkout main

# Merge branch
git merge feature/new-feature

# Pull latest from GitHub
git pull
```

---

## 🌿 Branching Strategy (Optional)

Untuk project yang lebih terstruktur:

```bash
# Main branch (production-ready)
main

# Development branch
git checkout -b develop

# Feature branches
git checkout -b feature/product-detail
git checkout -b feature/shopping-cart

# Bug fix branches  
git checkout -b fix/login-error
```

**Workflow:**
1. Develop di feature branch
2. Merge ke develop setelah selesai
3. Test di develop
4. Merge ke main untuk release

---

## ⚠️ Files NOT to Commit

Already handled by `.gitignore`:
- ✅ `build/` folder
- ✅ `.dart_tool/` folder
- ✅ IDE settings (`.idea/`, `.vscode/`)
- ✅ Environment files (`.env`)

**Firebase config files:**
- `firebase_options.dart` - **SAFE to commit** ✅
- `google-services.json` - **SAFE to commit** ✅
- These files are safe because Firebase has backend security rules

---

## 🐛 Troubleshooting

### "fatal: not a git repository"
```bash
git init
```

### "remote origin already exists"
```bash
git remote remove origin
git remote add origin https://github.com/YOUR_USERNAME/thriftly_app.git
```

### "failed to push some refs"
```bash
# Force push (CAREFUL!)
git push -f origin main

# Or pull first
git pull origin main --allow-unrelated-histories
git push origin main
```

### "Permission denied (publickey)"
- Setup SSH key: https://docs.github.com/en/authentication/connecting-to-github-with-ssh
- Or use HTTPS instead

### Large files (>100MB) warning
- Add to `.gitignore`
- Or use Git LFS: `git lfs install`

---

## 📊 GitHub Repository Settings

### After Upload

1. **Add Topics** (helps discoverability):
   - `flutter`
   - `firebase`
   - `thrift-shopping`
   - `mobile-app`
   - `marketplace`
   - `dart`

2. **Add Description**:
   "🛍️ Sustainable thrift shopping marketplace app built with Flutter & Firebase"

3. **Set Website** (optional):
   - Link ke demo/documentation

4. **Enable Discussions** (optional):
   Settings > Features > ✅ Discussions

5. **Add README Badges** (already included in README.md):
   - Flutter version
   - Firebase
   - License

---

## 🎯 Next Steps After Upload

1. ✅ **Add GitHub Repository URL to README.md**
   - Update `YOUR_USERNAME` dengan username Anda

2. ✅ **Add Screenshot** (setelah UI selesai)
   - Folder: `screenshots/`
   - Update README.md dengan gambar

3. ✅ **Create Releases**
   - Setiap major update
   - Tag version: `v1.0.0`, `v1.1.0`, etc.

4. ✅ **Setup GitHub Actions** (CI/CD - optional)
   - Auto-build on push
   - Auto-test
   - Auto-deploy

---

## 📖 Resources

- [GitHub Docs](https://docs.github.com/)
- [Git Cheat Sheet](https://education.github.com/git-cheat-sheet-education.pdf)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [GitHub Desktop](https://desktop.github.com/) - GUI alternative

---

**Happy Coding & Happy Git-ing! 🚀**
