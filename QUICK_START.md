# Quick Start Guide 🚀

## ⚡ Immediate Next Steps

### 1. Customize Your Profile (5 minutes)
Open `lib/profile_data.dart` and update:

```dart
static const String name = "Your Full Name";
static const String title = "Your Professional Title";
static const String bio = "Your bio here...";
static const String email = "your.email@example.com";
```

Update work experience, education, skills, and social links too!

### 2. Test Locally

```bash
flutter run -d chrome
```

Or use the "Run" button in VS Code!

### 3. Deploy to Vercel

**Quick Method:**
1. Push code to GitHub
2. Go to [vercel.com](https://vercel.com)
3. Click "Import Project"
4. Select your repo
5. Add environment variable:
   - `GEMINI_API_KEY` = Your API key
6. Deploy!

## 📋 Essential Commands

```bash
# Run in browser
flutter run -d chrome

# Build for production
flutter build web --release

# Clean and rebuild
flutter clean
flutter pub get
flutter build web --release

# Check for errors
flutter analyze
```

## 🎨 Customization Quick Reference

| File | Purpose |
|------|---------|
| `lib/profile_data.dart` | Your CV, bio, skills, experience |
| `lib/gemini_service.dart` | AI behavior and prompts |
| `lib/main.dart` | UI layout and styling |
| `.env` | API key (keep secret!) |

## ⚠️ Important Security Notes

1. ❌ **NEVER** commit `.env` file to GitHub
2. ✅ Use Vercel environment variables for deployment
3. ✅ Your `.env` is already in `.gitignore`

## 🐛 Quick Troubleshooting

**White screen?**
- Check browser console (F12)
- Verify API key in `.env`

**API errors?**
- Verify Gemini API key is valid
- Check internet connection

**Build fails?**
```bash
flutter clean
flutter pub get
```

## 📱 Project Structure

```
lib/
├── main.dart          ← Main app & UI
├── profile_data.dart  ← EDIT THIS FIRST!
├── gemini_service.dart ← AI integration
└── chat_message.dart  ← Message model
```

## 🎯 What This App Does

1. **Profile View**: Shows your CV beautifully
2. **AI Chat**: Visitors can ask questions about you
3. **Responsive**: Works on desktop and mobile
4. **Modern UI**: Material Design 3

## 💡 Pro Tips

- The AI uses info from `profile_data.dart`
- Update profile data → AI answers change automatically
- Test chat locally before deploying
- Dark mode is supported by default!

## 🔗 Useful Links

- [Flutter Docs](https://docs.flutter.dev/)
- [Gemini API Docs](https://ai.google.dev/docs)
- [Vercel Docs](https://vercel.com/docs)
- [Material Design](https://m3.material.io/)

## 📞 Need Help?

1. Check `README.md` for detailed docs
2. Check `VERCEL_DEPLOYMENT.md` for deployment guide
3. Review error messages carefully
4. Search Flutter/Gemini documentation

---

## ✅ Checklist Before Deploying

- [ ] Updated profile data in `profile_data.dart`
- [ ] Tested locally with `flutter run -d chrome`
- [ ] Verified AI chat works
- [ ] Checked all social links
- [ ] Added `.env` to `.gitignore`
- [ ] Tested different screen sizes
- [ ] Ready to push to GitHub!

---

**You're all set! Start customizing and deploy your AI-powered profile! 🎉**
