class ProfileData {
  static const String name = "Fatin Istiak Polok";
  static const String title = "Flutter Developer";
  static const String bio = """
Versatile Flutter Developer with almost 2 years of specialized mobile development experience and 4+ years of business management experience. Skilled in scalable app architecture, API integration, responsive UI/UX, and production releases on the App Store and Google Play. Experienced with Apple and Google Play in-app purchases, RevenueCat, bKash, Stripe, Supabase, Google Maps, Firebase, and TestFlight.
""";

  static const String email = "fatin15-1944@diu.edu.com";
  static const String phone = "+880 19955 33007";
  static const String location = "Dhaka, Bangladesh";

  // Social Media Links
  static const Map<String, String> socialLinks = {
    'GitHub': 'https://github.com/IstiakPolok',
    'LinkedIn': 'https://www.linkedin.com/in/fatin-istiak-polok-885574137/',
    'Portfolio': 'http://www.polok.com',
  };

  // Social Media Summary (from GitHub/LinkedIn Research)
  static const String githubSummary = """
- Active GitHub user (IstiakPolok) with strong contributions.
- Top Languages: Dart, Python, JavaScript, HTML, CSS.
""";

  static const String linkedinSummary = """
- Headline: Flutter Developer.
- Versatile Flutter Developer with experience in production releases on App Store and Google Play.
""";

  // Work Experience
  static const List<Map<String, String>> workExperience = [
    {
      'company': 'Hook And Took Group',
      'position': 'Flutter Developer',
      'duration': 'Apr 2025 - Present',
      'description': 'Mobile app development and production deployment.',
    },
    {
      'company': 'Flowline Artwork',
      'position': 'Management Executive',
      'duration': 'Feb 2022 - Apr 2025',
      'description': 'Business management and internal operations.',
    },
    {
      'company': 'Eurobangla Associates Ltd',
      'position': 'Business Administrator',
      'duration': 'May 2021 - Feb 2022',
      'description': 'Managed administrative tasks and project delivery.',
    },
  ];

  // Education
  static const List<Map<String, String>> education = [
    {
      'institution': 'Daffodil International University',
      'degree': 'B.Sc. in CSE',
      'duration': '2018 - 2023',
      'description': 'CGPA 3.23/4.00',
    },
    {
      'institution': 'Cambrian College',
      'degree': 'HSC (Science)',
      'duration': '2014 - 2016',
      'description': 'GPA 4.50/5.00',
    },
    {
      'institution': 'Monipur High School',
      'degree': 'SSC (Science)',
      'duration': '2004 - 2014',
      'description': 'GPA 4.41/5.00',
    },
  ];

  // Skills
  static const Map<String, List<String>> organizedSkills = {
    'Languages': [
      'Dart',
      'Python',
      'SQL',
      'JavaScript',
    ],
    'Frameworks': [
      'Flutter',
      'FastAPI',
      'Flask',
      'WordPress',
    ],
    'Backend': [
      'REST APIs',
      'API Integration',
    ],
    'Databases': [
      'Firebase',
      'Supabase',
      'SQL Databases',
    ],
    'DevOps & Cloud': [
      'Git',
      'Docker',
      'Microsoft Azure',
    ],
    'Design': ['UI/UX Design', 'Graphic Design'],
  };

  // Flat skills list for compatibility
  static List<String> get skills =>
      organizedSkills.values.expand((x) => x).toList();

  // Projects
  static const List<Map<String, String>> projects = [
    {
      'name': 'TrustTaste AI',
      'description': 'Restaurant Management App.',
      'technologies': 'Flutter, Twilio, AI, Firebase',
    },
    {
      'name': 'Goliaths',
      'description': 'Self-Growth and Donation App.',
      'technologies': 'Flutter, Stripe, AI, Firebase',
    },
    {
      'name': 'Qurany',
      'description': 'AI-Powered Quranic Companion.',
      'technologies': 'Flutter, GetX, RevenueCat, AI, Firebase',
    },
    {
      'name': 'CircleSlate',
      'description': 'iOS Deployment via App Store Connect and TestFlight.',
      'technologies': 'App Store Connect, TestFlight',
    },
    {
      'name': 'Chatter Matters',
      'description': 'iOS & Android Deployment.',
      'technologies': 'App Store Connect, Google Play Console',
    },
  ];

  // Languages
  static const List<String> languages = [
    'English - Fluent',
    'Bangla - Native',
    'Hindi - Conversational',
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
