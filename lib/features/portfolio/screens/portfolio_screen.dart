import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../vscode/views/chat_view.dart';
import '../sections/about_section.dart';
import '../sections/contact_section.dart';
import '../sections/education_section.dart';
import '../sections/experience_section.dart';
import '../sections/footer_section.dart';
import '../sections/header_section.dart';
import '../sections/hero_section.dart';
import '../sections/projects_section.dart';
import '../sections/skills_section.dart';
import '../widgets/background/scroll_responsive_video_background.dart';

class PortfolioScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const PortfolioScreen({super.key, this.onBack});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  bool _isChatOpen = false;
  bool _isReady = false;
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
          backgroundColor: Colors.transparent,
          endDrawer: isMobile
              ? const PortfolioMobileDrawer()
              : null,
          body: Stack(
            children: [
              ScrollResponsiveVideoBackground(
                scrollController: _scrollController,
                onVideoReady: (ready) {
                  if (mounted && !_isReady) {
                    setState(() {
                      _isReady = true;
                    });
                  }
                },
              ),
              AnimatedOpacity(
                opacity: _isReady ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeOut,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: _isReady
                      ? const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        )
                      : const NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      HeaderSection(
                        isMobile: isMobile,
                        onOpenDrawer: () =>
                          _scaffoldKey.currentState?.openEndDrawer(),
                    ),
                    HeroSection(isMobile: isMobile),
                    AboutSection(isMobile: isMobile),
                    ExperienceSection(isMobile: isMobile),
                    EducationSection(isMobile: isMobile),
                    SkillsSection(isMobile: isMobile),
                    ProjectsSection(isMobile: isMobile),
                    ContactSection(isMobile: isMobile),
                      const FooterSection(),
                    ],
                  ),
                ),
              ),
              if (_isChatOpen)
                Positioned(
                  bottom: 80,
                  right: 20,
                  child: Container(
                    width: isMobile ? constraints.maxWidth - 40 : 350,
                    height: 500,
                    decoration: BoxDecoration(
                      color: AppColors.vsCodeEditor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                      border: Border.all(
                        color: AppColors.primary,
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
                  backgroundColor: AppColors.primary,
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
}
