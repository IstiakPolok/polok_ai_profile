import 'dart:ui';
import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
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
  final bool isTerminalMode;
  const ChatView({super.key, this.isTerminalMode = true});

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

  Widget _buildTerminalMessage(ChatMessage msg) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
  }

  Widget _buildBubbleMessage(ChatMessage msg) {
    return Align(
      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: msg.isUser ? const Color(0xFFFF9C07) : const Color(0xFF252526),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(msg.isUser ? 16 : 0),
            bottomRight: Radius.circular(msg.isUser ? 0 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!msg.isUser)
              const Row(
                children: [
                  Icon(Icons.auto_awesome, size: 12, color: Color(0xFFFF9C07)),
                  SizedBox(width: 4),
                  Text(
                    "AI Assistant",
                    style: TextStyle(
                      color: Color(0xFFFF9C07),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            if (!msg.isUser) const SizedBox(height: 4),
            Text(
              msg.text,
              style: TextStyle(
                color: msg.isUser ? Colors.white : const Color(0xFFD4D4D4),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Terminal Header - Only show in terminal mode
        if (widget.isTerminalMode)
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

        // Bubble Header - For Portfolio mode
        if (!widget.isTerminalMode)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFF252526),
              border: Border(bottom: BorderSide(color: Color(0xFF333333))),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: Color(0xFFFF9C07),
                  child: Icon(Icons.person, size: 14, color: Colors.white),
                ),
                SizedBox(width: 8),
                Text(
                  "Polok's AI Chat",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
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
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: widget.isTerminalMode
                        ? const Text(
                            "> AI is typing...",
                            style: TextStyle(
                              color: Color(0xFF569CD6),
                              fontFamily: 'monospace',
                            ),
                          )
                        : Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF252526),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 12,
                                    height: 12,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xFFFF9C07),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Typing...",
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  );
                }
                final msg = _messages[index];
                return widget.isTerminalMode
                    ? _buildTerminalMessage(msg)
                    : _buildBubbleMessage(msg);
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
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: widget.isTerminalMode ? 'monospace' : null,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.isTerminalMode
                        ? "Type a command..."
                        : "Ask me something...",
                    hintStyle: const TextStyle(color: Colors.white30),
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
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
              ParallaxBackground(scrollController: _scrollController),
              SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    _buildHeader(isMobile),
                    const AWaves(height: 300),
                    _buildHeroSection(isMobile),
                    _buildAboutSection(isMobile),
                    _buildExperienceSection(isMobile),
                    _buildEducationSection(isMobile),
                    _buildSkillsSection(isMobile),
                    _buildProjectsSection(isMobile),
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
                          child: const ChatView(isTerminalMode: false),
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
          _buildDrawerItem("About me"),
          _buildDrawerItem("Experience"),
          _buildDrawerItem("Education"),
          _buildDrawerItem("Skills"),
          _buildDrawerItem("Projects"),
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
                _buildNavLink("About me"),
                _buildNavLink("Experience"),
                _buildNavLink("Education"),
                _buildNavLink("Skills"),
                _buildNavLink("Projects"),
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
        SwappingTextHero(isMobile: isMobile),
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
              child: ParallaxTiltCard(
                size: isMobile ? 320 : 420,
                child: EyeTrackingAvatar(size: isMobile ? 260 : 350),
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

  Widget _buildSocialIcon(dynamic icon, {String? url}) {
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
        child: icon is IconData
            ? Icon(icon, color: Colors.white, size: 18)
            : FaIcon(icon as FaIconData, color: Colors.white, size: 18),
      ),
    );
  }

  Widget _buildAboutSection(bool isMobile) {
    final image = Image.asset(
      'assets/images/image.png',
      height: isMobile ? 300 : 400,
      errorBuilder: (context, error, stackTrace) => Container(
        height: isMobile ? 300 : 400,
        width: isMobile ? 300 : 400,
        decoration: BoxDecoration(
          color: const Color(0xFF1F1F1F),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.person, size: 100, color: Color(0xFFFF9C07)),
      ),
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
            "Passionate about scalable mobile solutions & modern design.",
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

  Widget _buildExperienceSection(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 100,
        vertical: 60,
      ),
      child: Column(
        children: [
          const Text(
            "Experience",
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn().slideX(begin: -0.2),
          const SizedBox(height: 50),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: ProfileData.workExperience.length,
            itemBuilder: (context, index) {
              final exp = ProfileData.workExperience[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F1F1F).withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exp['position']!,
                      style: const TextStyle(
                        color: Color(0xFFFF9C07),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "${exp['company']} | ${exp['duration']}",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      exp['description']!,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 14,
                        height: 1.5,
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

  Widget _buildEducationSection(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 100,
        vertical: 60,
      ),
      child: Column(
        children: [
          const Text(
            "Education",
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn().slideX(begin: -0.2),
          const SizedBox(height: 50),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 1 : 3,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: isMobile ? 2.0 : 1.2,
            ),
            itemCount: ProfileData.education.length,
            itemBuilder: (context, index) {
              final edu = ProfileData.education[index];
              return Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F1F1F).withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.school, color: Color(0xFFFF9C07), size: 40),
                    const SizedBox(height: 15),
                    Text(
                      edu['degree']!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      edu['institution']!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      edu['duration']!,
                      style: const TextStyle(
                        color: Color(0xFFFF9C07),
                        fontSize: 12,
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

  Widget _buildSkillsSection(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 100,
        vertical: 60,
      ),
      child: Column(
        children: [
          const Text(
            "Skills",
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn().slideX(begin: -0.2),
          const SizedBox(height: 50),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: ProfileData.organizedSkills.entries.map((entry) {
              return Container(
                width: isMobile ? double.infinity : 300,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F1F1F).withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(
                        color: Color(0xFFFF9C07),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: entry.value.map((skill) {
                        return Chip(
                          label: Text(skill, style: const TextStyle(color: Colors.white)),
                          backgroundColor: Colors.white10,
                          side: BorderSide.none,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            }).toList(),
          ).animate().fadeIn().slideY(begin: 0.1),
        ],
      ),
    );
  }

  Widget _buildProjectsSection(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 100,
        vertical: 60,
      ),
      child: Column(
        children: [
          const Text(
            "Projects",
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn().slideX(begin: -0.2),
          const SizedBox(height: 50),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 1 : 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: isMobile ? 1.5 : 2.5,
            ),
            itemCount: ProfileData.projects.length,
            itemBuilder: (context, index) {
              final project = ProfileData.projects[index];
              return Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F1F1F).withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.code, color: Color(0xFFFF9C07)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            project['name']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      project['description']!,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Text(
                      project['technologies']!,
                      style: const TextStyle(
                        color: Color(0xFFFF9C07),
                        fontSize: 12,
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
          Icon(icon, color: const Color(0xFFFF9C07), size: 36),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
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

// --- Animated Waves (AWaves) Widget ---

class AWaves extends StatefulWidget {
  final double height;
  const AWaves({super.key, this.height = 300});

  @override
  State<AWaves> createState() => _AWavesState();
}

class _AWavesState extends State<AWaves> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Mouse properties
  double mouseX = -1000;
  double mouseY = -1000;
  double mouseSx = -1000;
  double mouseSy = -1000;
  double mouseLx = -1000;
  double mouseLy = -1000;
  double mouseV = 0;
  double mouseVs = 0;
  double mouseA = 0;
  bool mouseSet = false;

  // Noise generator
  final PerlinNoise _noise = PerlinNoise();

  // Grid of points
  List<List<WavePoint>> _lines = [];
  Size _lastSize = Size.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateMousePosition(double x, double y) {
    mouseX = x;
    mouseY = y;

    if (!mouseSet) {
      mouseSx = mouseX;
      mouseSy = mouseY;
      mouseLx = mouseX;
      mouseLy = mouseY;
      mouseSet = true;
    }
  }

  void _initializeLines(Size size) {
    if (_lastSize == size) return;
    _lastSize = size;

    final width = size.width;
    final height = size.height;

    const double xGap = 10;
    const double yGap = 32;

    final double oWidth = width + 200;
    final double oHeight = height + 30;

    final int totalLines = (oWidth / xGap).ceil();
    final int totalPoints = (oHeight / yGap).ceil();

    final double xStart = (width - xGap * totalLines) / 2;
    final double yStart = (height - yGap * totalPoints) / 2;

    _lines = List.generate(totalLines + 1, (i) {
      return List.generate(totalPoints + 1, (j) {
        return WavePoint(x: xStart + xGap * i, y: yStart + yGap * j);
      });
    });
  }

  void _movePoints(double time) {
    if (mouseSet) {
      mouseSx += (mouseX - mouseSx) * 0.1;
      mouseSy += (mouseY - mouseSy) * 0.1;

      final dx = mouseX - mouseLx;
      final dy = mouseY - mouseLy;
      final d = sqrt(dx * dx + dy * dy);

      mouseV = d;
      mouseVs += (d - mouseVs) * 0.1;
      mouseVs = mouseVs.clamp(0, 100);

      mouseLx = mouseX;
      mouseLy = mouseY;

      mouseA = atan2(dy, dx);
    } else {
      double t = time * 0.001;
      double cx = _lastSize.width / 2 + cos(t) * (_lastSize.width / 3);
      double cy = _lastSize.height / 2 + sin(t * 1.5) * (_lastSize.height / 3);

      if (mouseSx == -1000) {
        mouseSx = cx;
        mouseSy = cy;
        mouseLx = cx;
        mouseLy = cy;
      } else {
        mouseSx += (cx - mouseSx) * 0.05;
        mouseSy += (cy - mouseSy) * 0.05;
      }
      mouseVs = 20;
      mouseA = t;
    }

    for (var points in _lines) {
      for (var p in points) {
        final double move =
            _noise.perlin2(
              (p.x + time * 0.0125) * 0.002,
              (p.y + time * 0.005) * 0.0015,
            ) *
            12;
        p.waveX = cos(move) * 32;
        p.waveY = sin(move) * 16;

        final dx = p.x - mouseSx;
        final dy = p.y - mouseSy;
        final d = sqrt(dx * dx + dy * dy);
        final l = max(175.0, mouseVs);

        if (d < l) {
          final s = 1 - d / l;
          final f = cos(d * 0.001) * s;

          p.cursorVx += cos(mouseA) * f * l * mouseVs * 0.00065;
          p.cursorVy += sin(mouseA) * f * l * mouseVs * 0.00065;
        }

        p.cursorVx += (0 - p.cursorX) * 0.005;
        p.cursorVy += (0 - p.cursorY) * 0.005;

        p.cursorVx *= 0.925;
        p.cursorVy *= 0.925;

        p.cursorX += p.cursorVx * 2;
        p.cursorY += p.cursorVy * 2;

        p.cursorX = p.cursorX.clamp(-100, 100);
        p.cursorY = p.cursorY.clamp(-100, 100);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: double.infinity,
      color: const Color(0xFF111111), // Black background
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);
          _initializeLines(size);

          return MouseRegion(
            onHover: (event) {
              _updateMousePosition(
                event.localPosition.dx,
                event.localPosition.dy,
              );
            },
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final double timeMs = DateTime.now().millisecondsSinceEpoch
                    .toDouble();
                _movePoints(timeMs);
                return CustomPaint(
                  size: size,
                  painter: WavePainter(
                    lines: _lines,
                    mouseSx: mouseSx,
                    mouseSy: mouseSy,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class WavePoint {
  final double x;
  final double y;
  double waveX = 0;
  double waveY = 0;
  double cursorX = 0;
  double cursorY = 0;
  double cursorVx = 0;
  double cursorVy = 0;

  WavePoint({required this.x, required this.y});

  Offset moved({bool withCursorForce = true}) {
    double rx = x + waveX + (withCursorForce ? cursorX : 0);
    double ry = y + waveY + (withCursorForce ? cursorY : 0);

    rx = (rx * 10).roundToDouble() / 10;
    ry = (ry * 10).roundToDouble() / 10;

    return Offset(rx, ry);
  }
}

class WavePainter extends CustomPainter {
  final List<List<WavePoint>> lines;
  final double mouseSx;
  final double mouseSy;

  WavePainter({
    required this.lines,
    required this.mouseSx,
    required this.mouseSy,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color =
          const Color(0xFFFF9C07) // Yellow primary color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    for (var points in lines) {
      if (points.isEmpty) continue;

      final path = Path();
      final p1 = points[0].moved(withCursorForce: false);
      path.moveTo(p1.dx, p1.dy);

      for (int pIndex = 0; pIndex < points.length; pIndex++) {
        final isLast = pIndex == points.length - 1;
        final p = points[pIndex].moved(withCursorForce: !isLast);
        path.lineTo(p.dx, p.dy);
      }

      canvas.drawPath(path, linePaint);
    }

    final cursorPaint = Paint()
      ..color =
          const Color(0xFFFF9C07) // Yellow primary color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(mouseSx, mouseSy), 4.0, cursorPaint);
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) => true;
}

class PerlinNoise {
  final List<int> _p = List.generate(256, (index) => index);

  PerlinNoise() {
    _p.shuffle(Random(42));
    _p.addAll(List.from(_p));
  }

  double perlin2(double x, double y) {
    int X = x.floor() & 255;
    int Y = y.floor() & 255;

    double xf = x - x.floor();
    double yf = y - y.floor();

    double u = _fade(xf);
    double v = _fade(yf);

    int aa = _p[_p[X] + Y];
    int ab = _p[_p[X] + Y + 1];
    int ba = _p[_p[X + 1] + Y];
    int bb = _p[_p[X + 1] + Y + 1];

    double x1 = _lerp(u, _grad2d(aa, xf, yf), _grad2d(ba, xf - 1, yf));
    double x2 = _lerp(u, _grad2d(ab, xf, yf - 1), _grad2d(bb, xf - 1, yf - 1));

    return _lerp(v, x1, x2);
  }

  double _fade(double t) => t * t * t * (t * (t * 6 - 15) + 10);
  double _lerp(double t, double a, double b) => a + t * (b - a);

  double _grad2d(int hash, double x, double y) {
    switch (hash & 3) {
      case 0:
        return x + y;
      case 1:
        return -x + y;
      case 2:
        return x - y;
      case 3:
        return -x - y;
      default:
        return 0;
    }
  }
}

// --- Interactive Eye-Tracking Software Dev Avatar ---

class EyeTrackingAvatar extends StatefulWidget {
  final double size;

  const EyeTrackingAvatar({super.key, required this.size});

  @override
  State<EyeTrackingAvatar> createState() => _EyeTrackingAvatarState();
}

class _EyeTrackingAvatarState extends State<EyeTrackingAvatar> {
  Offset _localMousePos = Offset.zero;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      GestureBinding.instance.pointerRouter.addGlobalRoute(_handlePointerEvent);
    });
  }

  @override
  void dispose() {
    GestureBinding.instance.pointerRouter.removeGlobalRoute(
      _handlePointerEvent,
    );
    super.dispose();
  }

  void _handlePointerEvent(PointerEvent event) {
    if (!mounted) return;

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;

    final localPos = renderBox.globalToLocal(event.position);
    setState(() {
      _localMousePos = localPos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: CustomPaint(
        painter: AvatarPainter(mousePos: _localMousePos, size: widget.size),
      ),
    );
  }
}

class AvatarPainter extends CustomPainter {
  final Offset mousePos;
  final double size;

  AvatarPainter({required this.mousePos, required this.size});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Draw light warm circular background badge so dark outlines pop on the dark website background
    final bgPaint = Paint()
      ..color = const Color(0xFFFFF8EC)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w / 2, h / 2), w / 2 - 6, bgPaint);

    final ringPaint = Paint()
      ..color = const Color(0xFFFF9C07)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0;
    canvas.drawCircle(Offset(w / 2, h / 2), w / 2 - 6, ringPaint);

    // Define colors matching website yellow theme
    const outlineColor = Color(0xFF1E1E1E); // Dark charcoal outlines
    const hairColor = Color(0xFFFF9C07); // Yellow/orange primary hair & shirt
    const skinColor = Color(0xFFFFDBB5); // Warm skin tone
    const blushColor = Color(0xFFFFB0B0); // Soft pink cheek blush
    const laptopColor = Color(0xFF2D2D2D); // Dark laptop matching editor tabs
    const badgeColor = Color(0xFF4EE2C6); // Laptop screen teal badge (contrast)

    // Set up paints
    final outlinePaint = Paint()
      ..color = outlineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final skinPaint = Paint()
      ..color = skinColor
      ..style = PaintingStyle.fill;

    final hairPaint = Paint()
      ..color = hairColor
      ..style = PaintingStyle.fill;

    final laptopPaint = Paint()
      ..color = laptopColor
      ..style = PaintingStyle.fill;

    final badgePaint = Paint()
      ..color = badgeColor
      ..style = PaintingStyle.fill;

    // 1. Draw Shoulders/Shirt
    final shirtPath = Path();
    shirtPath.moveTo(w * 0.28, h * 0.68);
    shirtPath.quadraticBezierTo(w * 0.26, h * 0.62, w * 0.36, h * 0.62);
    shirtPath.lineTo(w * 0.64, h * 0.62);
    shirtPath.quadraticBezierTo(w * 0.74, h * 0.62, w * 0.72, h * 0.68);
    shirtPath.lineTo(w * 0.8, h * 0.9);
    shirtPath.lineTo(w * 0.2, h * 0.9);
    shirtPath.close();

    canvas.drawPath(shirtPath, hairPaint); // shirt shares hair color
    canvas.drawPath(shirtPath, outlinePaint);

    // 2. Draw Neck
    final neckPath = Path();
    neckPath.moveTo(w * 0.44, h * 0.54);
    neckPath.lineTo(w * 0.44, h * 0.64);
    neckPath.quadraticBezierTo(w * 0.5, h * 0.67, w * 0.56, h * 0.64);
    neckPath.lineTo(w * 0.56, h * 0.54);
    neckPath.close();

    canvas.drawPath(neckPath, skinPaint);
    canvas.drawPath(neckPath, outlinePaint);

    // 3. Draw Ears
    // Left Ear
    final leftEarCenter = Offset(w * 0.26, h * 0.38);
    final earRadius = w * 0.065;
    canvas.drawCircle(leftEarCenter, earRadius, skinPaint);
    canvas.drawCircle(leftEarCenter, earRadius, outlinePaint);

    // Right Ear
    final rightEarCenter = Offset(w * 0.74, h * 0.38);
    canvas.drawCircle(rightEarCenter, earRadius, skinPaint);
    canvas.drawCircle(rightEarCenter, earRadius, outlinePaint);

    // 4. Draw Face/Head (Rounded Rectangle)
    final faceRect = Rect.fromLTRB(w * 0.28, h * 0.21, w * 0.72, h * 0.56);
    final faceRRect = RRect.fromRectAndRadius(
      faceRect,
      Radius.circular(w * 0.16),
    );
    canvas.drawRRect(faceRRect, skinPaint);
    canvas.drawRRect(faceRRect, outlinePaint);

    // 5. Draw Hair (Blue hair with front hairline detail and upper puff)
    final hairPath = Path()
      ..moveTo(w * 0.28, h * 0.34)
      ..cubicTo(w * 0.22, h * 0.14, w * 0.32, h * 0.03, w * 0.5, h * 0.03)
      ..cubicTo(w * 0.68, h * 0.03, w * 0.78, h * 0.14, w * 0.72, h * 0.34)
      ..lineTo(w * 0.68, h * 0.30)
      // Front hairline curves
      ..quadraticBezierTo(w * 0.5, h * 0.25, w * 0.32, h * 0.30)
      ..close();

    canvas.drawPath(hairPath, hairPaint);
    canvas.drawPath(hairPath, outlinePaint);

    // Hair grid/texture lines (the crosshatch pattern shown in hair)
    final hairTexturePaint = Paint()
      ..color = outlineColor.withOpacity(0.15)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    // Draw simple crosshatch lines on the hair
    for (double i = 0.1; i <= 0.9; i += 0.15) {
      canvas.drawLine(
        Offset(w * (0.3 + i * 0.4), h * 0.04),
        Offset(w * (0.28 + i * 0.4), h * 0.25),
        hairTexturePaint,
      );
    }

    // Hair parting/detailing line
    final hairDetailPath = Path()
      ..moveTo(w * 0.5, h * 0.03)
      ..quadraticBezierTo(w * 0.52, h * 0.15, w * 0.5, h * 0.25);
    canvas.drawPath(hairDetailPath, outlinePaint);

    // 6. Draw Blush/Cheeks (Soft red/pink ovals)
    final blushPaint = Paint()
      ..color = blushColor
      ..style = PaintingStyle.fill;

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.37, h * 0.46),
        width: w * 0.08,
        height: w * 0.045,
      ),
      blushPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.63, h * 0.46),
        width: w * 0.08,
        height: w * 0.045,
      ),
      blushPaint,
    );

    // 7. Draw Smile Mouth
    final mouthPaint = Paint()
      ..color = outlineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round;

    final mouthPath = Path()
      ..moveTo(w * 0.46, h * 0.47)
      ..quadraticBezierTo(w * 0.5, h * 0.50, w * 0.54, h * 0.47);
    canvas.drawPath(mouthPath, mouthPaint);

    // 8. Draw Glasses (Thick rectangular-round spectacles)
    final glassesPaint = Paint()
      ..color = outlineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;

    final glassWidth = w * 0.17;
    final glassHeight = h * 0.12;
    final glassY = h * 0.36;

    final leftGlassRect = Rect.fromLTWH(
      w * 0.31,
      glassY,
      glassWidth,
      glassHeight,
    );
    final leftGlassRRect = RRect.fromRectAndRadius(
      leftGlassRect,
      const Radius.circular(16),
    );

    final rightGlassRect = Rect.fromLTWH(
      w * 0.52,
      glassY,
      glassWidth,
      glassHeight,
    );
    final rightGlassRRect = RRect.fromRectAndRadius(
      rightGlassRect,
      const Radius.circular(16),
    );

    // Glasses lens background (very subtle translucent light blue)
    final lensBgPaint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(leftGlassRRect, lensBgPaint);
    canvas.drawRRect(leftGlassRRect, glassesPaint);

    canvas.drawRRect(rightGlassRRect, lensBgPaint);
    canvas.drawRRect(rightGlassRRect, glassesPaint);

    // Bridge line
    canvas.drawLine(
      Offset(w * 0.48, glassY + glassHeight / 2),
      Offset(w * 0.52, glassY + glassHeight / 2),
      glassesPaint,
    );

    // Temples (temple arms on ears)
    canvas.drawLine(
      Offset(w * 0.28, glassY + glassHeight / 2),
      Offset(w * 0.31, glassY + glassHeight / 2),
      glassesPaint,
    );
    canvas.drawLine(
      Offset(w * 0.69, glassY + glassHeight / 2),
      Offset(w * 0.72, glassY + glassHeight / 2),
      glassesPaint,
    );

    // 9. Draw Eyes (Oval pupils tracking the cursor)
    void drawEye(Offset defaultCenter) {
      final targetVector = Offset(
        mousePos.dx - defaultCenter.dx,
        mousePos.dy - defaultCenter.dy,
      );
      final angle = atan2(targetVector.dy, targetVector.dx);
      final dist = targetVector.distance;

      // Restrict eye pupil to stay within glasses lens
      final maxShiftX = glassWidth * 0.22;
      final maxShiftY = glassHeight * 0.22;

      final shiftX = cos(angle) * min(maxShiftX, dist * 0.06);
      final shiftY = sin(angle) * min(maxShiftY, dist * 0.06);

      final pupilCenter = Offset(
        defaultCenter.dx + shiftX,
        defaultCenter.dy + shiftY,
      );

      final pupilPaint = Paint()
        ..color = outlineColor
        ..style = PaintingStyle.fill;

      // Draw oval capsule pupils
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: pupilCenter,
            width: w * 0.04,
            height: h * 0.075,
          ),
          const Radius.circular(8),
        ),
        pupilPaint,
      );
    }

    drawEye(Offset(w * 0.395, glassY + glassHeight / 2));
    drawEye(Offset(w * 0.605, glassY + glassHeight / 2));

    // 10. Draw Laptop (Foreground covers bottom part of body)
    // Main screen panel
    final laptopRect = Rect.fromLTRB(w * 0.24, h * 0.64, w * 0.76, h * 0.94);
    final laptopRRect = RRect.fromRectAndRadius(
      laptopRect,
      const Radius.circular(12),
    );
    canvas.drawRRect(laptopRRect, laptopPaint);
    canvas.drawRRect(laptopRRect, outlinePaint);

    // Keyboard Base
    final baseRect = Rect.fromLTRB(w * 0.21, h * 0.94, w * 0.79, h * 0.98);
    final baseRRect = RRect.fromRectAndRadius(
      baseRect,
      const Radius.circular(8),
    );
    canvas.drawRRect(baseRRect, laptopPaint);
    canvas.drawRRect(baseRRect, outlinePaint);

    // Green screen badge inside laptop screen
    final badgeRect = Rect.fromLTRB(w * 0.32, h * 0.72, w * 0.68, h * 0.86);
    final badgeRRect = RRect.fromRectAndRadius(
      badgeRect,
      const Radius.circular(12),
    );
    canvas.drawRRect(badgeRRect, badgePaint);
    canvas.drawRRect(badgeRRect, outlinePaint);

    // Code symbol `</>` inside green screen badge
    final codePaint = Paint()
      ..color = outlineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Brackets '<' and '>'
    final codePath = Path()
      // '<'
      ..moveTo(w * 0.44, h * 0.76)
      ..lineTo(w * 0.39, h * 0.79)
      ..lineTo(w * 0.44, h * 0.82)
      // '/'
      ..moveTo(w * 0.48, h * 0.82)
      ..lineTo(w * 0.52, h * 0.76)
      // '>'
      ..moveTo(w * 0.56, h * 0.76)
      ..lineTo(w * 0.61, h * 0.79)
      ..lineTo(w * 0.56, h * 0.82);

    canvas.drawPath(codePath, codePaint);
  }

  @override
  bool shouldRepaint(covariant AvatarPainter oldDelegate) {
    return oldDelegate.mousePos != mousePos || oldDelegate.size != size;
  }
}

// --- Interactive 3D Parallax Tilt Card ---

class ParallaxTiltCard extends StatefulWidget {
  final Widget child;
  final double size;
  const ParallaxTiltCard({super.key, required this.child, this.size = 350});

  @override
  State<ParallaxTiltCard> createState() => _ParallaxTiltCardState();
}

class _ParallaxTiltCardState extends State<ParallaxTiltCard> {
  double _hoverX = 0.0;
  double _hoverY = 0.0;
  bool _isHovered = false;

  void _onHover(PointerEvent event, Size size) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final localPos = renderBox.globalToLocal(event.position);

    setState(() {
      _hoverX = (localPos.dx / size.width) * 2 - 1.0;
      _hoverY = (localPos.dy / size.height) * 2 - 1.0;
      _isHovered = true;
    });
  }

  void _onExit() {
    setState(() {
      _hoverX = 0.0;
      _hoverY = 0.0;
      _isHovered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cardSize = widget.size;

    return MouseRegion(
      onHover: (event) => _onHover(event, Size(cardSize, cardSize)),
      onExit: (_) => _onExit(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutQuad,
        width: cardSize,
        height: cardSize,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // 1. Background glow and grid (Deepest parallax layer)
            Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(_isHovered ? -_hoverY * 0.15 : 0.0)
                ..rotateY(_isHovered ? _hoverX * 0.15 : 0.0)
                ..translate(
                  _isHovered ? -_hoverX * 15.0 : 0.0,
                  _isHovered ? -_hoverY * 15.0 : 0.0,
                ),
              alignment: FractionalOffset.center,
              child: Container(
                width: cardSize * 0.95,
                height: cardSize * 0.95,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFFF9C07).withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(
                        0xFFFF9C07,
                      ).withOpacity(_isHovered ? 0.25 : 0.1),
                      blurRadius: _isHovered ? 30 : 15,
                      spreadRadius: _isHovered ? 5 : 2,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: CustomPaint(
                    painter: GridPainter(
                      hoverX: _hoverX,
                      hoverY: _hoverY,
                      isHovered: _isHovered,
                    ),
                  ),
                ),
              ),
            ),

            // 2. Middle Layer: The Avatar (Floats forward and tilts)
            Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(_isHovered ? -_hoverY * 0.25 : 0.0)
                ..rotateY(_isHovered ? _hoverX * 0.25 : 0.0)
                ..translate(
                  _isHovered ? _hoverX * 10.0 : 0.0,
                  _isHovered ? _hoverY * 10.0 : 0.0,
                ),
              alignment: FractionalOffset.center,
              child: widget.child,
            ),

            // 3. Foreground Layer: Floating Code Tags (Highest parallax layer, moves faster)
            // Tag A (Top Left)
            Positioned(
              top: cardSize * 0.1,
              left: cardSize * 0.02,
              child: Transform(
                transform: Matrix4.identity()
                  ..translate(
                    _isHovered ? _hoverX * 35.0 : 0.0,
                    _isHovered ? _hoverY * 35.0 : 0.0,
                  ),
                child: const _FloatingTag(
                  text: "{ }",
                  color: Color(0xFF4EE2C6),
                ),
              ),
            ),
            // Tag B (Bottom Right)
            Positioned(
              bottom: cardSize * 0.15,
              right: cardSize * 0.02,
              child: Transform(
                transform: Matrix4.identity()
                  ..translate(
                    _isHovered ? _hoverX * 40.0 : 0.0,
                    _isHovered ? _hoverY * 40.0 : 0.0,
                  ),
                child: const _FloatingTag(
                  text: "</>",
                  color: Color(0xFFFF9C07),
                ),
              ),
            ),
            // Tag C (Top Right)
            Positioned(
              top: cardSize * 0.18,
              right: cardSize * 0.05,
              child: Transform(
                transform: Matrix4.identity()
                  ..translate(
                    _isHovered ? _hoverX * 30.0 : 0.0,
                    _isHovered ? _hoverY * 30.0 : 0.0,
                  ),
                child: const _FloatingTag(
                  text: "Dart",
                  color: Colors.blueAccent,
                ),
              ),
            ),
            // Tag D (Bottom Left)
            Positioned(
              bottom: cardSize * 0.1,
              left: cardSize * 0.08,
              child: Transform(
                transform: Matrix4.identity()
                  ..translate(
                    _isHovered ? _hoverX * 38.0 : 0.0,
                    _isHovered ? _hoverY * 38.0 : 0.0,
                  ),
                child: const _FloatingTag(text: "Flutter", color: Colors.cyan),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FloatingTag extends StatelessWidget {
  final String text;
  final Color color;

  const _FloatingTag({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F).withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  final double hoverX;
  final double hoverY;
  final bool isHovered;

  GridPainter({
    required this.hoverX,
    required this.hoverY,
    required this.isHovered,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFFFF9C07).withOpacity(0.04)
      ..strokeWidth = 1.0;

    const double step = 20.0;
    final double dx = isHovered ? hoverX * 8.0 : 0.0;
    final double dy = isHovered ? hoverY * 8.0 : 0.0;

    for (double x = dx % step; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    for (double y = dy % step; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant GridPainter oldDelegate) {
    return oldDelegate.hoverX != hoverX ||
        oldDelegate.hoverY != hoverY ||
        oldDelegate.isHovered != isHovered;
  }
}

// --- Interactive Swapping Text Hero Widget ---

class SwappingTextHero extends StatefulWidget {
  final bool isMobile;
  const SwappingTextHero({super.key, required this.isMobile});

  @override
  State<SwappingTextHero> createState() => _SwappingTextHeroState();
}

class _SwappingTextHeroState extends State<SwappingTextHero> {
  final List<String> _texts = [
    "FATIN ISTIAK POLOK",
    "CREATIVE FLUTTER DEVELOPER",
  ];

  List<int> _lineSlots = [0, 1];
  late Timer _timer;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted) return;
      setState(() {
        _lineSlots = _lineSlots[0] == 0 ? [1, 0] : [0, 1];
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = widget.isMobile;
    final double screenWidth = MediaQuery.of(context).size.width;

    // Calculate responsive font sizes that scale with screen width
    final double nameFontSize = isMobile
        ? (screenWidth * 0.068).clamp(20.0, 32.0)
        : (screenWidth * 0.034).clamp(26.0, 42.0);

    final double subtitleFontSize = isMobile
        ? (screenWidth * 0.05).clamp(15.0, 22.0)
        : (screenWidth * 0.024).clamp(18.0, 30.0);

    final double slot0 = 0.0;
    final double slot1 = nameFontSize + (isMobile ? 12.0 : 18.0);
    final double containerHeight = slot1 + subtitleFontSize + 10.0;

    return SizedBox(
      height: containerHeight,
      width: double.infinity,
      child: Stack(
        alignment: isMobile ? Alignment.center : Alignment.centerLeft,
        children: List.generate(2, (lineIndex) {
          final slotIndex = _lineSlots[lineIndex];
          final text = _texts[lineIndex];

          double topPos = slotIndex == 0 ? slot0 : slot1;

          TextStyle textStyle;
          if (slotIndex == 0) {
            textStyle = GoogleFonts.outfit(
              color: Colors.white,
              fontSize: nameFontSize,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            );
          } else {
            textStyle = GoogleFonts.outfit(
              color: const Color(0xFFFF9C07),
              fontSize: subtitleFontSize,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            );
          }

          return AnimatedPositioned(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.elasticOut,
            top: topPos,
            left: isMobile ? null : 0.0,
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              style: textStyle,
              child: Text(
                text,
                textAlign: isMobile ? TextAlign.center : TextAlign.left,
              ),
            ),
          );
        }),
      ),
    );
  }
}

class ParallaxBackground extends StatelessWidget {
  final ScrollController scrollController;

  const ParallaxBackground({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scrollController,
      builder: (context, child) {
        double offset = 0.0;
        if (scrollController.hasClients) {
          offset = scrollController.offset;
        }

        return Stack(
          children: [
            Positioned(
              top: -offset * 0.2,
              left: 0,
              right: 0,
              height: 4000, // Large enough to cover scroll area
              child: CustomPaint(painter: ParallaxGridPainter()),
            ),
            Positioned(
              top: -offset * 0.5 + 400,
              left: 100,
              child: _buildGlowingOrb(const Color(0x22FF9C07), 300),
            ),
            Positioned(
              top: -offset * 0.6 + 1200,
              right: 50,
              child: _buildGlowingOrb(const Color(0x11FFFFFF), 400),
            ),
            Positioned(
              top: -offset * 0.4 + 2200,
              left: 200,
              child: _buildGlowingOrb(const Color(0x22FF9C07), 250),
            ),
            Positioned(
              top: -offset * 0.7 + 3000,
              right: 200,
              child: _buildGlowingOrb(const Color(0x11FFFFFF), 350),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGlowingOrb(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, Colors.transparent],
        ),
      ),
    );
  }
}

class ParallaxGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFF9C07).withOpacity(0.03)
      ..strokeWidth = 1.0;

    for (double i = 0; i < size.width; i += 60) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 60) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
