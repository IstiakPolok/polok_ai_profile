class ProfileData {
  static const String name = "Fatin Istiak Polok";
  static const String title = "Flutter Developer | Mobile App Specialist";
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
    'LinkedIn': 'https://www.linkedin.com/in/fatin-istiak-polok',
    'Portfolio': 'https://polok.com',
    'Play Store':
        'https://play.google.com/store/apps/details?id=com.goliaths.app',
  };

  // Work Experience
  static const List<Map<String, String>> workExperience = [
    {
      'company': 'Join Venture AI',
      'position': 'Flutter Developer',
      'duration': 'Apr 2025 - Present',
      'description':
          'Flutter app development with focus on delivery and team coordination. Working with Flutter and REST APIs to build scalable mobile solutions.',
    },
    {
      'company': 'Flowline Artwork',
      'position': 'Management Executive',
      'duration': 'Feb 2022 - Apr 2025',
      'description':
          'Oversaw operations, optimized workflows, and managed client/vendor relations. Handled operations management, workflow optimization, and client relations.',
    },
    {
      'company': 'Eurobangla Associates Ltd',
      'position': 'Business Administrator',
      'duration': 'May 2021 - Feb 2022',
      'description':
          'Managed administrative tasks, supported project delivery, and coordinated teams. Focused on business management and administration.',
    },
  ];

  // Education
  static const List<Map<String, String>> education = [
    {
      'institution': 'Daffodil International University, Bangladesh',
      'degree': 'B.Sc. in Computer Science & Engineering (CSE)',
      'duration': '2018 - 2023',
      'description':
          'Graduated with a CGPA of 3.23/4.00. Focused on software engineering, mobile development, and algorithms.',
    },
    {
      'institution': 'Cambrian College, Dhaka, Bangladesh',
      'degree': 'Higher Secondary Certificate (Science)',
      'duration': '2014 - 2016',
      'description': 'Achieved GPA 4.50/5.00 in Science group.',
    },
    {
      'institution': 'Monipur High School, Dhaka, Bangladesh',
      'degree': 'Secondary School Certificate (Science)',
      'duration': '2004 - 2014',
      'description': 'Achieved GPA 4.50/5.00 in Science group.',
    },
  ];

  // Skills
  static const List<String> skills = [
    'Flutter & Dart',
    'JavaScript',
    'HTML & CSS',
    'Python',
    'C & C++',
    'SQL',
    'GetX State Management',
    'REST APIs',
    'WordPress',
    'FastAPI',
    'Firebase',
    'Supabase',
    'Git',
    'UI/UX Design',
    'Graphic Design',
    'Responsive Web Design',
    'Mobile App Development',
  ];

  // Projects
  static const List<Map<String, String>> projects = [
    {
      'name': 'Goliaths - Self-Growth and Donation App',
      'description':
          'Developed a self-growth app with donation via Stripe, daily motivational quotes, birthday tracking & sharing, AI chatbot for mental health guidance, and subscription management. Available on Google Play Store.',
      'technologies': 'Flutter, Stripe, AI, Firebase',
      'link': 'https://play.google.com/store/apps/details?id=com.goliaths.app',
    },
    {
      'name': 'GastCallDe - Restaurant Management App',
      'description':
          'Built the mobile app for a multi-restaurant system with AI-powered order handling via Twilio, synced to React dashboards with menu, order, reservation, and customer management.',
      'technologies': 'Flutter, Twilio, AI, REST API, Firebase',
    },
    {
      'name': 'Roady - Tourmate Matching App',
      'description':
          'Developed a swipe-based travel companion app with real-time chat, user profiles, and map-sharing to connect travelers.',
      'technologies': 'Flutter, Firebase, Google Maps, REST API',
    },
    {
      'name': 'Dallas - Messaging App',
      'description':
          'Built a WhatsApp-like messaging app with secure real-time chat, audio/video calls, and AI-powered transcription for conversations.',
      'technologies': 'Flutter, WebRTC, Firebase, REST API',
    },
    {
      'name': 'WardKavin - Hospital Ward Management',
      'description':
          'Developed an intelligent hospital ward management app that automates patient tracking, staff scheduling, and report generation using AI-powered insights. Integrated a Flutter frontend with a Django backend for secure data handling and seamless real-time communication.',
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
