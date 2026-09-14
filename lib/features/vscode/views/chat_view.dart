import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/chat_message.dart';
import '../../../../core/services/gemini_service.dart';

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

  static String _getApiKey() {
    const envKey = String.fromEnvironment('GEMINI_API_KEY');
    if (envKey.isNotEmpty) return envKey;
    return dotenv.env['GEMINI_API_KEY'] ?? "";
  }

  late final GeminiService _geminiService = GeminiService(_getApiKey());
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

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
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
    final apiKey = _getApiKey();
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
          color: msg.isUser ? AppColors.primary : AppColors.vsCodeSidebar,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(msg.isUser ? 16 : 0),
            bottomRight: Radius.circular(msg.isUser ? 0 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
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
                  Icon(Icons.auto_awesome, size: 12, color: AppColors.primary),
                  SizedBox(width: 4),
                  Text(
                    "AI Assistant",
                    style: TextStyle(
                      color: AppColors.primary,
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
            color: AppColors.vsCodeSidebar,
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
              color: AppColors.vsCodeSidebar,
              border: Border(bottom: BorderSide(color: AppColors.vsCodeActivityBar)),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: AppColors.primary,
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
            color: AppColors.vsCodeEditor,
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
                              color: AppColors.syntaxKeyword,
                              fontFamily: 'monospace',
                            ),
                          )
                        : Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.vsCodeSidebar,
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
                                        AppColors.primary,
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
            color: AppColors.vsCodeSidebar,
            border: Border(top: BorderSide(color: AppColors.vsCodeActivityBar)),
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
