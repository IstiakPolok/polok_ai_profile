class ProfileData {
  static const String name = "Fatin Istiak Polok";
  static const String title = "Flutter Developer";
  static const String bio = """
Versatile professional with 4+ years of experience in graphic design, business management, 
and web development, specializing in Flutter app development with API integration and 
responsive UI. Skilled in building end-to-end mobile solutions, WordPress, and front-end 
technologies. Experienced in managing projects from concept to deployment, with a published 
app available on the Google Play Store.
""";

  static const String email = "fatin15-1944@diu.edu.com";
  static const String phone = "+880 19955 33007";
  static const String location = "Dhaka, Bangladesh";

  // Social Media Links
  static const Map<String, String> socialLinks = {
    'GitHub': 'https://github.com/IstiakPolok',
    'LinkedIn': 'https://www.linkedin.com/in/fatin-istiak-polok-885574137/',
    'Portfolio': 'http://www.polok.site',
  };

  // Social Media Summary (from GitHub/LinkedIn Research)
  static const String githubSummary = """
- Active GitHub user (IstiakPolok) with 800+ contributions in the last year.
- Top Languages: Dart, C++, JavaScript, HTML, CSS.
- Notable Repositories: book-class-assignment, liveTest, exam_week_2_assignment (focused on Dart and C++).
""";

  static const String linkedinSummary = """
- Headline: Flutter Dev || Management Executive || Graphics designer.
- Currently working as a Flutter Mobile Application Developer at Join Venture AI.
- Previous professional experience includes SM Technology, Flowline Artwork, and Eurobangla Associates.
""";

  // Work Experience
  static const List<Map<String, String>> workExperience = [
    {
      'company': 'Join Venture AI',
      'position': 'Flutter Mobile Application Developer',
      'duration': 'Jul 2025 - Present',
      'description':
          'Building scalable mobile solutions with Flutter and REST APIs.',
    },
    {
      'company': 'SM Technology',
      'position': 'Flutter Mobile Application Developer',
      'duration': 'Apr 2025 - Jun 2025',
      'description': 'Mobile app development for various clients.',
    },
    {
      'company': 'Flowline Artwork (Watertec Malaysia)',
      'position': 'Management Executive',
      'duration': 'Feb 2022 - Apr 2025',
      'description':
          'Oversaw internal operations and managed client relations for a subsidiary of Watertec Malaysia.',
    },
    {
      'company': 'Eurobangla Associates Ltd',
      'position': 'Business Administrator',
      'duration': 'May 2021 - Jan 2022',
      'description': 'Managed administrative tasks and project delivery.',
    },
    {
      'company': 'Unitas Group of Companies Ltd',
      'position': 'Communications Executive',
      'duration': 'Apr 2020 - Apr 2021',
      'description': 'Handled internal and external communications.',
    },
  ];

  // Education
  static const List<Map<String, String>> education = [
    {
      'institution': 'Daffodil International University, Bangladesh',
      'degree': 'B.Sc. in Computer Science & Engineering (CSE)',
      'duration': '2018 - 2023',
      'description': 'Graduated with a CGPA of 3.23/4.00.',
    },
    {
      'institution': 'Cambrian College, Dhaka, Bangladesh',
      'degree': 'Higher Secondary Certificate (Science)',
      'duration': '2014 - 2016',
      'description': 'Achieved GPA 4.50/5.00.',
    },
    {
      'institution': 'Monipur High School, Dhaka, Bangladesh',
      'degree': 'Secondary School Certificate (Science)',
      'duration': '2004 - 2014',
      'description': 'Achieved GPA 4.50/5.00.',
    },
  ];

  // Skills
  static const Map<String, List<String>> organizedSkills = {
    'Languages': [
      'Dart (Flutter)',
      'JavaScript',
      'HTML',
      'CSS',
      'Python',
      'C',
      'C++',
      'SQL',
    ],
    'Technologies': [
      'Flutter',
      'GetX',
      'REST APIs',
      'WordPress',
      'FastAPI',
      'Firebase',
      'Supabase',
      'Git',
    ],
    'Design': ['UI/UX Design', 'Graphic Design', 'Responsive Web Design'],
  };

  // Flat skills list for compatibility
  static List<String> get skills =>
      organizedSkills.values.expand((x) => x).toList();

  // Projects
  static const List<Map<String, String>> projects = [
    {
      'name': 'GastCallDe – Restaurant Management App',
      'description':
          'Built the mobile app for a multi-restaurant system with AI-powered order handling via Twilio, synced to React dashboards with menu, order, reservation, and customer management.',
      'technologies': 'Flutter, Twilio, AI, REST API, Firebase',
    },
    {
      'name': 'Goliaths – Self-Growth and Donation App',
      'description':
          'Developed a self-growth app with donation via Stripe, daily motivational quotes, birthday tracking & sharing, AI chatbot for mental health guidance, and subscription management.',
      'technologies': 'Flutter, Stripe, AI, Firebase',
      'link':
          'https://play.google.com/store/apps/details?id=com.breaking.goliathsitled',
    },
    {
      'name': 'Roady – Tourmate Matching App',
      'description':
          'Developed a swipe-based travel companion app with real-time chat, user profiles, and map-sharing to connect travelers.',
      'technologies': 'Flutter, Firebase, Google Maps, REST API',
    },
    {
      'name': 'Dallas – Messaging App',
      'description':
          'Built a WhatsApp-like messaging app with secure real-time chat, audio/video calls, and AI-powered transcription for conversations.',
      'technologies': 'Flutter, WebRTC, Firebase, REST API',
    },
    {
      'name': 'WardKavin',
      'description':
          'Developed an AI-powered wound analysis and patient management application for nurses, enabling intelligent wound assessment through image analysis. The system suggests appropriate medications using AI insights, tracks wound healing history over time, and manages patient records efficiently. Built with a Flutter frontend and a Django backend.',
      'technologies': 'Flutter, Django, OpenAI API',
    },
  ];

  // Languages
  static const List<String> languages = [
    'English - Fluent',
    'Bangla - Native',
    'Hindi - Verbal',
  ];

  // Generate context for AI
  static String getProfileContext() {
    StringBuffer context = StringBuffer();

    context.writeln('Profile Information:');
    context.writeln('Name: $name');
    context.writeln('Title: $title');
    context.writeln('Bio: $bio');
    context.writeln('Email: $email');
    context.writeln('Phone: $phone');
    context.writeln('Location: $location');
    context.writeln('\nSocial Media Links:');
    socialLinks.forEach((platform, link) {
      context.writeln('$platform: $link');
    });

    context.writeln('\nGitHub Activity:');
    context.writeln(githubSummary);

    context.writeln('\nLinkedIn Highlights:');
    context.writeln(linkedinSummary);

    context.writeln('\nWork Experience:');
    for (var exp in workExperience) {
      context.writeln(
        '${exp['position']} at ${exp['company']} (${exp['duration']})',
      );
      context.writeln('${exp['description']}');
    }

    context.writeln('\nEducation:');
    for (var edu in education) {
      context.writeln(
        '${edu['degree']} from ${edu['institution']} (${edu['duration']})',
      );
      context.writeln('${edu['description']}');
    }

    context.writeln('\nSkills:');
    context.writeln(skills.join(', '));

    context.writeln('\nProjects:');
    for (var project in projects) {
      context.writeln('${project['name']}: ${project['description']}');
      context.writeln('Technologies: ${project['technologies']}');
    }

    context.writeln('\nLanguages:');
    context.writeln(languages.join(', '));

    return context.toString();
  }
}
