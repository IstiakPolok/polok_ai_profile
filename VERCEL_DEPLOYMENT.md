# Vercel Deployment Guide

## Prerequisites
- GitHub account
- Vercel account (sign up at vercel.com)
- Your Gemini API key

## Deployment Steps

### 1. Prepare Your Repository

1. Make sure your `.gitignore` includes `.env`:
   ```
   .env
   build/
   ```

2. Commit and push your code to GitHub:
   ```bash
   git add .
   git commit -m "Initial commit"
   git remote add origin https://github.com/yourusername/your-repo.git
   git push -u origin main
   ```

### 2. Build Your Flutter App

Before deploying, build the web version:
```bash
flutter build web --release
```

This creates optimized files in `build/web/`

### 3. Deploy to Vercel

#### Option A: Vercel Dashboard (Recommended)

1. Go to [vercel.com](https://vercel.com) and sign in
2. Click "Add New Project"
3. Import your GitHub repository
4. Configure:
   - Framework Preset: **Other**
   - Root Directory: `./`
   - Build Command: Leave empty (we'll upload pre-built files)
   - Output Directory: `build/web`
5. Add Environment Variable:
   - Name: `GEMINI_API_KEY`
   - Value: Your Gemini API key
6. Click "Deploy"

#### Option B: Vercel CLI

1. Install Vercel CLI:
   ```bash
   npm install -g vercel
   ```

2. Login to Vercel:
   ```bash
   vercel login
   ```

3. Deploy from build directory:
   ```bash
   cd build/web
   vercel --prod
   ```

4. Add environment variable via dashboard after first deployment

### 4. Configure Environment Variables

In Vercel Dashboard:
1. Go to your project
2. Click "Settings"
3. Click "Environment Variables"
4. Add:
   - Key: `GEMINI_API_KEY`
   - Value: `AIzaSyAZ7HQnWGes4jHRe-ugslfY4FHrNdgVpF0` (or your key)
   - Environment: Production
5. Redeploy to apply changes

### 5. Custom Domain (Optional)

1. In project settings, go to "Domains"
2. Add your custom domain
3. Follow DNS configuration instructions

## Vercel.json Configuration

The `vercel.json` file handles routing:
```json
{
  "version": 2,
  "builds": [
    {
      "src": "build/web/**",
      "use": "@vercel/static"
    }
  ],
  "routes": [
    {
      "handle": "filesystem"
    },
    {
      "src": "/(.*)",
      "dest": "/index.html"
    }
  ]
}
```

## Deployment Workflow

### For Updates

1. Make your changes locally
2. Test: `flutter run -d chrome`
3. Build: `flutter build web --release`
4. Commit and push:
   ```bash
   git add .
   git commit -m "Update description"
   git push
   ```
5. Vercel auto-deploys!

### Manual Rebuild

If auto-deploy doesn't work:
1. Go to Vercel dashboard
2. Go to your project
3. Click "Deployments"
4. Click "..." on latest deployment
5. Click "Redeploy"

## Troubleshooting

### Issue: White screen after deployment
- Check browser console for errors
- Verify `index.html` base href is correct
- Ensure all assets are in `build/web`

### Issue: API calls failing
- Verify `GEMINI_API_KEY` environment variable in Vercel
- Check API key is valid
- Ensure CORS is not blocking requests

### Issue: 404 on page refresh
- Verify `vercel.json` routes configuration
- Ensure SPA routing is properly configured

### Issue: Build failures
- Run `flutter clean && flutter pub get`
- Delete `build` folder and rebuild
- Check Flutter version compatibility

## Performance Tips

1. **Enable Gzip Compression**: Vercel does this automatically
2. **Use Web Renderer**: We use HTML renderer for better compatibility
3. **Tree Shaking**: Enabled by default in release builds
4. **Lazy Loading**: Consider code splitting for larger apps

## Security Best Practices

1. **Never commit `.env` file**
2. **Use Vercel environment variables** for secrets
3. **Regenerate API keys** if accidentally exposed
4. **Enable rate limiting** on Gemini API
5. **Monitor usage** in Google Cloud Console

## Monitoring

1. **Vercel Analytics**: Enable in project settings
2. **Error Tracking**: Check Vercel logs for runtime errors
3. **API Usage**: Monitor Gemini API usage in Google Cloud Console

## Support

- Vercel Docs: https://vercel.com/docs
- Flutter Web Docs: https://docs.flutter.dev/platform-integration/web
- Gemini API Docs: https://ai.google.dev/docs

---

Your app should now be live at: `https://your-project.vercel.app`
