# AI Profile Chat

A Flutter Web application that showcases your professional profile with an intelligent AI chatbot powered by Google's Gemini API. The AI assistant can answer questions about your CV, work experience, skills, and projects.

## ✨ Features

- 📱 **Responsive Profile Page** - Display your professional information beautifully
- 🤖 **AI Chat Assistant** - Powered by Google Gemini 1.5 Flash
- 💼 **CV Integration** - Showcase work experience, education, skills, and projects
- 🔗 **Social Links** - Easy access to LinkedIn, GitHub, and other profiles
- 🎨 **Modern UI** - Material Design 3 with dark mode support
- 🚀 **Vercel Ready** - Optimized for deployment on Vercel

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0 or higher)
- Google Gemini API Key ([Get one here](https://makersuite.google.com/app/apikey))

### Installation

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd polok_ai_profile
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure your API key**
   - Open `.env` file
   - Replace the API key with your own:
     ```
     GEMINI_API_KEY=your_api_key_here
     ```

4. **Customize your profile**
   - Edit `lib/profile_data.dart`
   - Update your personal information:
     - Name, title, bio
     - Contact information
     - Social media links
     - Work experience
     - Education
     - Skills
     - Projects

### Running Locally

```bash
flutter run -d chrome
```

Or for web server:
```bash
flutter run -d web-server --web-port=8080
```

## 📝 Customization

### Update Profile Information

Edit `lib/profile_data.dart`:

```dart
class ProfileData {
  static const String name = "Your Name";
  static const String title = "Your Title";
  // ... update other fields
}
```

### Modify AI Behavior

Edit the system instruction in `lib/gemini_service.dart` to change how the AI responds.

## 🌐 Deploy to Vercel

### Method 1: Vercel CLI

1. **Install Vercel CLI**
   ```bash
   npm install -g vercel
   ```

2. **Build the project**
   ```bash
   flutter build web --release
   ```

3. **Deploy**
   ```bash
   cd build/web
   vercel --prod
   ```

### Method 2: GitHub Integration

1. Push your code to GitHub
2. Import the project in Vercel dashboard
3. Set environment variable:
   - Key: `GEMINI_API_KEY`
   - Value: Your API key
4. Deploy!

### Environment Variables

In Vercel, add the following environment variable:
- `GEMINI_API_KEY` - Your Google Gemini API key

## 📁 Project Structure

```
lib/
├── main.dart           # Main app and UI components
├── profile_data.dart   # Your CV and profile information
├── gemini_service.dart # AI service integration
└── chat_message.dart   # Chat message model

web/
├── index.html         # Web entry point
└── manifest.json      # PWA manifest

.env                   # API key (DO NOT COMMIT!)
vercel.json           # Vercel configuration
pubspec.yaml          # Dependencies
```

## 🔒 Security Notes

- Never commit your `.env` file with real API keys
- The `.env` file is in `.gitignore` by default
- When deploying to Vercel, use environment variables in the dashboard
- Consider implementing rate limiting for production use

## 🛠️ Technologies Used

- **Flutter** - UI framework
- **Google Generative AI** - AI chat capabilities
- **Material Design 3** - Modern, beautiful UI
- **Vercel** - Hosting and deployment

## 📱 Features Breakdown

### Profile View
- Professional header with avatar
- Contact information chips
- Clickable social media links
- Work experience timeline
- Education section
- Skills showcase
- Projects portfolio

### Chat View
- Real-time AI responses
- Message history
- Chat reset functionality
- Loading indicators
- Timestamp for messages
- Responsive message bubbles

## 🎯 Use Cases

- Personal portfolio website
- Interactive resume
- Professional profile
- Career showcase
- Networking tool

## 🆘 Troubleshooting

### API Key Issues
- Verify your API key is correct in `.env`
- Check if the API key has proper permissions
- Ensure billing is enabled in Google Cloud Console

### Build Issues
```bash
flutter clean
flutter pub get
flutter build web --release
```

### Deployment Issues
- Ensure `build/web` directory exists
- Check Vercel environment variables
- Review build logs in Vercel dashboard

---

**Made with ❤️ using Flutter and Google Gemini AI**
