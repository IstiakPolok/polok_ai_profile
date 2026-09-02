# Vercel Deployment Guide

Deploying your Flutter Portfolio to Vercel is simple and fast. Choose either **Method 1 (Instant CLI Deploy)** or **Method 2 (GitHub Continuous Deployment)**.

---

## Prerequisites
- A [Vercel](https://vercel.com) account
- (Optional) A Groq API Key (`GEMINI_API_KEY`) from [console.groq.com](https://console.groq.com) for the AI Chatbot

---

## Method 1: Instant CLI Deployment (Fastest, ~30 seconds)

Since your project is already configured and built locally, you can deploy directly using Vercel CLI:

1. **Build the latest release** (if you made recent changes):
   ```bash
   flutter build web --release
   ```

2. **Deploy to production**:
   ```bash
   vercel --prod
   ```

3. Follow the CLI prompt or confirm the linked project (`polok`).

---

## Method 2: GitHub Continuous Deployment (Auto-Deploy on Push)

1. **Push your code to GitHub**:
   ```bash
   git add .
   git commit -m "Configure Vercel deployment"
   git push origin main
   ```

2. **Connect Project on Vercel Dashboard**:
   - Go to [vercel.com/dashboard](https://vercel.com/dashboard)
   - Click **Add New...** > **Project**
   - Import your `polok_ai_profile` repository
   - **Framework Preset**: `Other`
   - **Root Directory**: `./`
   - **Build & Output Settings**: Already configured automatically via `vercel.json` (`bash build.sh` -> `build/web`)

3. **Set Environment Variables**:
   - In the project settings, add:
     - **Key**: `GEMINI_API_KEY`
     - **Value**: `your_groq_api_key_here`
   - Click **Deploy**

---

## Project Configuration Files

- [`vercel.json`](file:///c:/Users/Polok/StudioProjects/polok_ai_profile/vercel.json): Configures build command, output directory (`build/web`), and SPA rewrites so routing and assets work seamlessly without 404s.
- [`build.sh`](file:///c:/Users/Polok/StudioProjects/polok_ai_profile/build.sh): Automated build script for Vercel's CI server that clones Flutter, sets up `.env`, and builds the web bundle.
- [`package.json`](file:///c:/Users/Polok/StudioProjects/polok_ai_profile/package.json): Defines the npm `build` script (`bash build.sh`).

---

## Adding Custom Domain (Optional)

1. Go to your project on [vercel.com](https://vercel.com)
2. Navigate to **Settings** > **Domains**
3. Enter your domain (e.g. `polok.dev` or `istiakpolok.com`) and follow the DNS verification steps.

