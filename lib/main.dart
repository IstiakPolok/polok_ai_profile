import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'gemini_service.dart';
import 'chat_message.dart';
import 'profile_data.dart';

void main() async {
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Env file not found, using fallback configuration");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fatin Istiak Polok | VS Code Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF007ACC),
          brightness: Brightness.dark,
          background: const Color(0xFF1E1E1E),
        ),
        textTheme: GoogleFonts.firaCodeTextTheme(ThemeData.dark().textTheme),
        scaffoldBackgroundColor: const Color(0xFF1E1E1E),
      ),
      home: const MainLayout(),
    );
  }
}

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;
  bool _isSidebarOpen = true;
  bool _showPortfolio = true;

  @override
  Widget build(BuildContext context) {
    if (_showPortfolio) {
      return PortfolioScreen(
        onBack: () => setState(() => _showPortfolio = false),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        return Scaffold(
          appBar: isMobile
              ? AppBar(
                  backgroundColor: const Color(0xFF333333),
                  title: const Text(
                    "Fatin Istiak Polok",
                    style: TextStyle(fontSize: 14),
                  ),
                  leading: Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.account_circle_outlined),
                      onPressed: () => setState(() => _showPortfolio = true),
                    ),
                  ],
                )
              : null,
          drawer: isMobile
              ? Drawer(
                  backgroundColor: const Color(0xFF252526),
                  child: Column(
                    children: [
                      const DrawerHeader(
                        decoration: BoxDecoration(color: Color(0xFF333333)),
                        child: Center(
                          child: Text(
                            "EXPLORER",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            _buildExplorerItem(
                              "PORTFOLIO",
                              isHeader: true,
                              isExpanded: true,
                            ),
                            _buildExplorerItem(
                              "lib",
                              indent: 10,
                              isFolder: true,
                              isExpanded: true,
                            ),
                            _buildFileItem("profile.dart", 0, indent: 20),
                            _buildFileItem("chat_bot.dart", 1, indent: 20),
                            _buildFileItem("main.dart", 2, indent: 20),
                            _buildExplorerItem(
                              "pubspec.yaml",
                              indent: 10,
                              isFile: true,
                            ),
                            _buildExplorerItem(
                              "README.md",
                              indent: 10,
                              isFile: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : null,
          body: Row(
            children: [
              // Activity Bar (Hidden on Mobile)
              if (!isMobile)
                Container(
                  width: 50,
                  color: const Color(0xFF333333),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      _buildActivityIcon(0, Icons.copy_outlined), // Explorer
                      _buildActivityIcon(1, Icons.search), // Search
                      _buildActivityIcon(2, Icons.source_outlined), // Git
                      _buildActivityIcon(3, Icons.bug_report_outlined), // Debug
                      _buildActivityIcon(4, Icons.grid_view), // Extensions
                      const Spacer(),
                      _buildActivityIcon(
                        5,
                        Icons.account_circle_outlined,
                        isAccount: true,
                      ), // Account
                      _buildActivityIcon(
                        6,
                        Icons.settings_outlined,
                      ), // Settings
                      const SizedBox(height: 10),
                    ],
                  ),
                ),

              // Sidebar (Explorer) (Hidden on Mobile)
              if (_isSidebarOpen && !isMobile)
                Container(
                  width: 250,
                  color: const Color(0xFF252526),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "EXPLORER",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFBBBBBB),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.more_horiz,
                                size: 16,
                                color: Colors.white70,
                              ),
                              onPressed: () {},
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ),
                      _buildExplorerItem(
                        "PORTFOLIO",
                        isHeader: true,
                        isExpanded: true,
                      ),
                      _buildExplorerItem(
                        "lib",
                        indent: 10,
                        isFolder: true,
                        isExpanded: true,
                      ),
                      _buildFileItem("profile.dart", 0, indent: 20),
                      _buildFileItem("chat_bot.dart", 1, indent: 20),
                      _buildFileItem("main.dart", 2, indent: 20),
                      _buildExplorerItem(
                        "pubspec.yaml",
                        indent: 10,
                        isFile: true,
                      ),
                      _buildExplorerItem("README.md", indent: 10, isFile: true),
                    ],
                  ),
                ),

              // Main Editor Area
              Expanded(
                child: Column(
                  children: [
                    // Tab Bar
                    Container(
                      height: 35,
                      color: const Color(0xFF252526),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildTab("profile.dart", 0),
                            _buildTab("chat_bot.dart", 1),
                          ],
                        ),
                      ),
                    ),

                    // Content
                    Expanded(
                      child: Container(
                        color: const Color(0xFF1E1E1E),
                        child: _selectedIndex == 0
                            ? const ProfileCodeView()
                            : const ChatView(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            height: 22,
            color: const Color(0xFF007ACC),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                const Icon(
                  Icons.source_outlined,
                  size: 12,
                  color: Colors.white,
                ),
                const SizedBox(width: 5),
                const Text(
                  "main",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.sync, size: 12, color: Colors.white),
                const Spacer(),
                const Text(
                  "Dart",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                const SizedBox(width: 10),
                const Icon(
                  Icons.notifications_none,
                  size: 12,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActivityIcon(
    int index,
    IconData icon, {
    bool isAccount = false,
  }) {
    final isSelected =
        _selectedIndex == index && index < 2; // Only first two are real tabs
    return InkWell(
      onTap: () {
        if (isAccount) {
          setState(() => _showPortfolio = true);
        } else if (index < 2) {
          setState(() => _selectedIndex = index);
        }
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          border: isSelected
              ? const Border(left: BorderSide(color: Colors.white, width: 2))
              : null,
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.white54,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildExplorerItem(
    String title, {
    bool isHeader = false,
    bool isFolder = false,
    bool isFile = false,
    bool isExpanded = false,
    double indent = 0,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: indent, top: 4, bottom: 4),
      child: Row(
        children: [
          if (isHeader || isFolder)
            Icon(
              isExpanded
                  ? Icons.keyboard_arrow_down
                  : Icons.keyboard_arrow_right,
              size: 16,
              color: Colors.white70,
            ),
          if (isFolder) ...[
            const SizedBox(width: 4),
            const Icon(Icons.folder, size: 16, color: Color(0xFFD4D4D4)),
          ],
          if (isFile) ...[
            const SizedBox(width: 20), // Indent for file icon
            const Icon(Icons.description, size: 16, color: Color(0xFFD4D4D4)),
          ],
          const SizedBox(width: 4),
          Text(
            title,
            style: TextStyle(
              color: isHeader
                  ? const Color(0xFFBBBBBB)
                  : const Color(0xFFCCCCCC),
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileItem(String filename, int index, {double indent = 0}) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        color: isSelected ? const Color(0xFF37373D) : null,
        padding: EdgeInsets.only(left: indent, top: 3, bottom: 3),
        child: Row(
          children: [
            const SizedBox(width: 20), // Arrow placeholder
            Icon(
              filename.endsWith('.dart') ? Icons.code : Icons.description,
              size: 16,
              color: filename.endsWith('.dart')
                  ? const Color(0xFF519ABA)
                  : const Color(0xFFD4D4D4),
            ),
            const SizedBox(width: 6),
            Text(
              filename,
              style: const TextStyle(color: Color(0xFFCCCCCC), fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        color: isSelected ? const Color(0xFF1E1E1E) : const Color(0xFF2D2D2D),
        child: Row(
          children: [
            Icon(
              title.endsWith('.dart') ? Icons.code : Icons.description,
              size: 14,
              color: title.endsWith('.dart')
                  ? const Color(0xFF519ABA)
                  : const Color(0xFFD4D4D4),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF969696),
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 8),
            if (isSelected)
              const Icon(Icons.close, size: 14, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class ProfileCodeView extends StatelessWidget {
  const ProfileCodeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCodeLine(1, "class Profile {", color: const Color(0xFF569CD6)),
          _buildCodeLine(
            2,
            "  final String name = '${ProfileData.name}';",
            indent: 2,
          ),
          _buildCodeLine(
            3,
            "  final String title = '${ProfileData.title}';",
            indent: 2,
          ),
          _buildCodeLine(
            4,
            "  final String location = '${ProfileData.location}';",
            indent: 2,
          ),
          _buildCodeLine(5, ""),
          _buildCodeLine(
            6,
            "  // About Me",
            color: const Color(0xFF6A9955),
            indent: 2,
          ),
          _buildCodeLine(7, "  String get bio => '''", indent: 2),
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Text(
              ProfileData.bio,
              style: GoogleFonts.firaCode(
                color: const Color(0xFFCE9178),
                fontSize: 14,
              ),
            ),
          ),
          _buildCodeLine(8, "  ''';", indent: 2),
          _buildCodeLine(9, ""),
          _buildCodeLine(
            10,
            "  // Experience",
            color: const Color(0xFF6A9955),
            indent: 2,
          ),
          _buildCodeLine(
            11,
            "  List<Experience> get workExperience => [",
            indent: 2,
          ),
          ...ProfileData.workExperience.map(
            (exp) => _buildExperienceBlock(exp),
          ),
          _buildCodeLine(12, "  ];", indent: 2),
          _buildCodeLine(13, ""),
          _buildCodeLine(
            14,
            "  // Projects",
            color: const Color(0xFF6A9955),
            indent: 2,
          ),
          _buildCodeLine(15, "  List<Project> get projects => [", indent: 2),
          ...ProfileData.projects.map((proj) => _buildProjectBlock(proj)),
          _buildCodeLine(16, "  ];", indent: 2),
          _buildCodeLine(17, "}"),
        ],
      ),
    );
  }

  Widget _buildExperienceBlock(Map<String, String> exp) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCodeLine(0, "    Experience(", indent: 4),
        _buildCodeLine(0, "      company: '${exp['company']}',", indent: 6),
        _buildCodeLine(0, "      role: '${exp['position']}',", indent: 6),
        _buildCodeLine(0, "      duration: '${exp['duration']}',", indent: 6),
        _buildCodeLine(0, "    ),", indent: 4),
      ],
    );
  }

  Widget _buildProjectBlock(Map<String, String> proj) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCodeLine(0, "    Project(", indent: 4),
        _buildCodeLine(0, "      name: '${proj['name']}',", indent: 6),
        _buildCodeLine(0, "      tech: '${proj['technologies']}',", indent: 6),
        _buildCodeLine(0, "    ),", indent: 4),
      ],
    );
  }

  Widget _buildCodeLine(
    int lineNum,
    String code, {
    Color? color,
    double indent = 0,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (lineNum > 0)
          SizedBox(
            width: 30,
            child: Text(
              "$lineNum",
              style: const TextStyle(color: Color(0xFF858585), fontSize: 14),
              textAlign: TextAlign.right,
            ),
          ),
        const SizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: indent * 10),
            child: Text(
              code,
              style: GoogleFonts.firaCode(
                color: color ?? const Color(0xFFD4D4D4),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  final GeminiService _geminiService = GeminiService(
    dotenv.env['GEMINI_API_KEY'] ?? "",
  );
  bool _isLoading = false;

  // Voice features
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  bool _isListening = false;
  bool _speechEnabled = false;

  @override
  void initState() {
    super.initState();
    _addInitialMessage();
    _initSpeech();
    _initTts();
  }

  void _initSpeech() async {
    _speechEnabled = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          setState(() => _isListening = false);
        }
      },
      onError: (errorNotification) {
        setState(() => _isListening = false);
        debugPrint('Speech error: $errorNotification');
      },
    );
    setState(() {});
  }

  void _initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5);
  }

  void _listen() async {
    if (!_speechEnabled) {
      _initSpeech();
      return;
    }

    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
    } else {
      setState(() => _isListening = true);
      await _speech.listen(
        onResult: (result) {
          setState(() {
            _controller.text = result.recognizedWords;
            if (result.finalResult) {
              _isListening = false;
              _sendMessage();
            }
          });
        },
      );
    }
  }

  Future<void> _speak(String text) async {
    await _flutterTts.speak(text);
  }

  void _addInitialMessage() {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? "";
    final isPlaceholder = apiKey == "YOUR_GROQ_API_KEY_HERE" || apiKey.isEmpty;

    setState(() {
      _messages.add(
        ChatMessage(
          text: isPlaceholder
              ? "👋 Hi! It looks like your AI Chat isn't set up yet. To enable it, please add your Groq API key to the .env file in the root directory.\n\nType 'help' to see how!"
              : "Hi! I'm Polok's AI Assistant. Ask me anything about his experience, skills, or projects!",
          isUser: false,
        ),
      );
    });
  }

  Future<void> _sendMessage() async {
    if (_controller.text.isEmpty) return;

    final userMessage = _controller.text;
    setState(() {
      _messages.add(ChatMessage(text: userMessage, isUser: true));
      _isLoading = true;
      _controller.clear();
    });

    _scrollToBottom();

    try {
      final response = await _geminiService.sendMessage(userMessage);
      setState(() {
        _messages.add(ChatMessage(text: response, isUser: false));
        _isLoading = false;
      });
      _speak(response);
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(text: "Error: $e", isUser: false));
        _isLoading = false;
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Terminal Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: const Color(0xFF252526),
          child: const Row(
            children: [
              Text(
                "TERMINAL",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              SizedBox(width: 16),
              Text(
                "OUTPUT",
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
              SizedBox(width: 16),
              Text(
                "DEBUG CONSOLE",
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            color: const Color(0xFF1E1E1E),
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      "> AI is typing...",
                      style: TextStyle(
                        color: Color(0xFF569CD6),
                        fontFamily: 'monospace',
                      ),
                    ),
                  );
                }
                final msg = _messages[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            msg.isUser
                                ? "user@polok-portfolio:~\$ "
                                : "ai@polok-portfolio:~\$ ",
                            style: TextStyle(
                              color: msg.isUser
                                  ? const Color(0xFF98C379)
                                  : const Color(0xFF61AFEF),
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              msg.text,
                              style: const TextStyle(
                                color: Color(0xFFD4D4D4),
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Color(0xFF252526),
            border: Border(top: BorderSide(color: Color(0xFF333333))),
          ),
          child: Row(
            children: [
              const Text(
                ">",
                style: TextStyle(
                  color: Color(0xFF98C379),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'monospace',
                  ),
                  decoration: const InputDecoration(
                    hintText: "Type a command...",
                    hintStyle: TextStyle(color: Colors.white30),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              IconButton(
                onPressed: _speechEnabled ? _listen : _initSpeech,
                icon: Icon(
                  _isListening ? Icons.mic : Icons.mic_none,
                  color: _isListening ? Colors.red : Colors.white54,
                  size: 20,
                ),
              ),
              IconButton(
                onPressed: _sendMessage,
                icon: const Icon(Icons.send, color: Colors.white54, size: 20),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// --- Portfolio Screen (Fancy UI) ---

class PortfolioScreen extends StatefulWidget {
  final VoidCallback onBack;
  const PortfolioScreen({super.key, required this.onBack});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  bool _isChatOpen = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 900;
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: const Color(0xFF111111),
          endDrawer: isMobile ? _buildMobileDrawer() : null,
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    _buildHeader(isMobile),
                    _buildHeroSection(isMobile),
                    _buildServicesSection(isMobile),
                    _buildAboutSection(isMobile),
                    _buildSkillsSection(isMobile),
                    _buildPortfolioSection(isMobile),
                    _buildContactSection(isMobile),
                    _buildFooter(),
                  ],
                ),
              ),
              if (_isChatOpen)
                Positioned(
                  bottom: 80,
                  right: 20,
                  child:
                      Container(
                        width: isMobile ? constraints.maxWidth - 40 : 350,
                        height: 500,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                          border: Border.all(
                            color: const Color(0xFFFF9C07),
                            width: 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: const ChatView(),
                        ),
                      ).animate().scale(
                        duration: 300.ms,
                        curve: Curves.easeOutBack,
                      ),
                ),
              Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton(
                  onPressed: () => setState(() => _isChatOpen = !_isChatOpen),
                  backgroundColor: const Color(0xFFFF9C07),
                  child: Icon(
                    _isChatOpen ? Icons.close : Icons.chat_bubble_outline,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMobileDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF1E1E1E),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFFFF9C07)),
            child: Center(
              child: Text(
                "POLOK",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          _buildDrawerItem("Home"),
          _buildDrawerItem("Services"),
          _buildDrawerItem("About me"),
          _buildDrawerItem("Portfolio"),
          _buildDrawerItem("Contact me"),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: widget.onBack,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9C07),
                foregroundColor: Colors.white,
              ),
              child: const Text("Back to Code"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(String title) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {},
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 40,
        vertical: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "POLOK",
            style: TextStyle(
              color: Color(0xFFFF9C07),
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          if (isMobile)
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
            )
          else
            Row(
              children: [
                _buildNavLink("Home"),
                _buildNavLink("Services"),
                _buildNavLink("About me"),
                _buildNavLink("Portfolio"),
                _buildNavLink("Contact me"),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: widget.onBack,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9C07),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text("Back to Code"),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildNavLink(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white70, fontSize: 14),
      ),
    );
  }

  Widget _buildHeroSection(bool isMobile) {
    final content = Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        const Text(
          "Hi I am",
          style: TextStyle(color: Colors.white70, fontSize: 18),
        ),
        const SizedBox(height: 10),
        Text(
          ProfileData.name,
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 36 : 48,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "Flutter Developer",
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          style: TextStyle(
            color: const Color(0xFFFF9C07),
            fontSize: isMobile ? 36 : 48,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: isMobile
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            _buildSocialIcon(
              FontAwesomeIcons.github,
              url: 'https://github.com/IstiakPolok',
            ),
            _buildSocialIcon(
              FontAwesomeIcons.linkedinIn,
              url: 'https://www.linkedin.com/in/fatin-istiak-polok-885574137/',
            ),
            _buildSocialIcon(FontAwesomeIcons.dribbble),
            _buildSocialIcon(FontAwesomeIcons.behance),
          ],
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: isMobile
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9C07),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 20,
                ),
              ),
              child: const Text(
                "Hire Me",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 20),
            OutlinedButton(
              onPressed: () => launchUrl(
                Uri.parse(
                  'https://drive.google.com/file/d/1BakrTaCyv0gX4NSPtxTaQKgepA-37IIL/view?usp=sharing',
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 20,
                ),
              ),
              child: const Text(
                "Download CV",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 60),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1F1F1F),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Wrap(
            spacing: 30,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: const [
              _StatItem(label: "Experiences", value: "4+"),
              _StatItem(label: "Project done", value: "20+"),
              _StatItem(label: "Happy Clients", value: "80+"),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(duration: 800.ms, curve: Curves.easeOut).slideY(begin: 0.1);

    final image =
        Center(
              child: Image.asset(
                'assets/images/profile.png',
                width: isMobile ? 300 : 400,
              ),
            )
            .animate()
            .fadeIn(duration: 800.ms)
            .scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 100,
        vertical: 80,
      ),
      child: isMobile
          ? Column(children: [image, const SizedBox(height: 50), content])
          : Row(
              children: [
                Expanded(child: content),
                Expanded(child: image),
              ],
            ),
    );
  }

  Widget _buildSocialIcon(IconData icon, {String? url}) {
    return InkWell(
      onTap: () {
        if (url != null) launchUrl(Uri.parse(url));
      },
      child: Container(
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF1F1F1F),
          border: Border.all(color: Colors.white24),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }

  Widget _buildServicesSection(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 100,
        vertical: 60,
      ),
      child: Column(
        children: [
          const Text(
            "Services",
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn().slideX(begin: -0.2),
          const SizedBox(height: 10),
          const Text(
            "Lorem ipsum dolor sit amet consectetur. Imperdiet convallis blandit felis ligula aliquam",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54),
          ),
          const SizedBox(height: 50),
          GridView.count(
            crossAxisCount: isMobile ? 1 : 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: isMobile ? 1.5 : 1.2,
            children: [
              const _ServiceCard(
                title: "App Design",
                icon: Icons.phone_android,
                desc:
                    "Crafting beautiful and functional mobile applications using Flutter and modern design principles.",
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
              const _ServiceCard(
                title: "Web Design",
                icon: Icons.web,
                desc:
                    "Creating responsive and interactive web experiences that look great on any device.",
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
              const _ServiceCard(
                title: "UI/UX Design",
                icon: Icons.design_services,
                desc:
                    "Focusing on user-centric design to provide intuitive and engaging digital interfaces.",
              ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(bool isMobile) {
    final image = Image.asset(
      'assets/images/image.png',
      height: isMobile ? 300 : 400,
    );

    final content = Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          ProfileData.bio,
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          style: const TextStyle(
            color: Colors.white70,
            height: 1.8,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () => launchUrl(
            Uri.parse(
              'https://drive.google.com/file/d/1BakrTaCyv0gX4NSPtxTaQKgepA-37IIL/view?usp=sharing',
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF9C07),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          ),
          child: const Text(
            "Download CV",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 100,
        vertical: 60,
      ),
      child: Column(
        children: [
          const Text(
            "About Me",
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn().slideX(begin: -0.2),
          const SizedBox(height: 10),
          const Text(
            "User Interface And User Experience And Also Video Editing",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54),
          ),
          const SizedBox(height: 50),
          if (isMobile)
            Column(children: [image, const SizedBox(height: 30), content])
          else
            Row(
              children: [
                Expanded(child: image),
                const SizedBox(width: 50),
                Expanded(child: content),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildSkillsSection(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 100,
        vertical: 60,
      ),
      child: isMobile
          ? Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: const [
                _SkillCircle(label: "Flutter", percent: 95, color: Colors.blue),
                _SkillCircle(
                  label: "Dart",
                  percent: 92,
                  color: Colors.blueAccent,
                ),
                _SkillCircle(
                  label: "REST APIs",
                  percent: 88,
                  color: Colors.orange,
                ),
                _SkillCircle(label: "UI/UX", percent: 85, color: Colors.purple),
              ],
            )
          : const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _SkillCircle(label: "Flutter", percent: 95, color: Colors.blue),
                _SkillCircle(
                  label: "Dart",
                  percent: 92,
                  color: Colors.blueAccent,
                ),
                _SkillCircle(
                  label: "REST APIs",
                  percent: 88,
                  color: Colors.orange,
                ),
                _SkillCircle(label: "UI/UX", percent: 85, color: Colors.purple),
              ],
            ),
    );
  }

  Widget _buildPortfolioSection(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 100,
        vertical: 60,
      ),
      child: Column(
        children: [
          const Text(
            "Portfolio",
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 50),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 1 : 3,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 1.3,
            ),
            itemCount: ProfileData.projects.length,
            itemBuilder: (context, index) {
              final project = ProfileData.projects[index];
              return Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1F1F1F),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.image,
                            size: 50,
                            color: Colors.white24,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            project['name']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            project['technologies']!,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: (index * 100).ms).slideY(begin: 0.1);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 100,
        vertical: 60,
      ),
      child: Column(
        children: [
          const Text(
            "Contact me",
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Cultivating Connections: Reach Out And Connect With Me",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54),
          ),
          const SizedBox(height: 50),
          SizedBox(
            width: 600,
            child: Column(
              children: [
                if (isMobile) ...[
                  _buildTextField("Name"),
                  const SizedBox(height: 20),
                  _buildTextField("Email"),
                ] else
                  Row(
                    children: [
                      Expanded(child: _buildTextField("Name")),
                      const SizedBox(width: 20),
                      Expanded(child: _buildTextField("Email")),
                    ],
                  ),
                const SizedBox(height: 20),
                if (isMobile) ...[
                  _buildTextField("Phone Number"),
                  const SizedBox(height: 20),
                  _buildTextField("Service Of Interest"),
                ] else
                  Row(
                    children: [
                      Expanded(child: _buildTextField("Phone Number")),
                      const SizedBox(width: 20),
                      Expanded(child: _buildTextField("Service Of Interest")),
                    ],
                  ),
                const SizedBox(height: 20),
                _buildTextField("Project Details...", maxLines: 4),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF9C07),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                    ),
                    child: const Text(
                      "Send",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24),
        filled: true,
        fillColor: const Color(0xFF1F1F1F),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(40),
      color: const Color(0xFF0F0F0F),
      child: const Center(
        child: Text(
          "Designed by Polok AI",
          style: TextStyle(color: Colors.white24),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFFFF9C07),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
      ],
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String desc;

  const _ServiceCard({
    required this.title,
    required this.icon,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFFFF9C07), size: 40),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _SkillCircle extends StatelessWidget {
  final String label;
  final double percent;
  final Color color;

  const _SkillCircle({
    required this.label,
    required this.percent,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                value: percent / 100,
                strokeWidth: 8,
                color: const Color(0xFFFF9C07),
                backgroundColor: Colors.white10,
              ),
            ),
            Text(
              "${percent.toInt()}%",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
