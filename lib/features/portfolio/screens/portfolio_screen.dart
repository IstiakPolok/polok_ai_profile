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
  final PageController _pageController = PageController();
  int _currentSectionIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToSection(int index) {
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 900;
        final screenHeight = constraints.maxHeight;

        final sections = <Widget>[
          HeroSection(isMobile: isMobile),
          AboutSection(isMobile: isMobile),
          ExperienceSection(isMobile: isMobile),
          EducationSection(isMobile: isMobile),
          SkillsSection(isMobile: isMobile),
          ProjectsSection(isMobile: isMobile),
          Column(
            children: [
              ContactSection(isMobile: isMobile),
              const FooterSection(),
            ],
          ),
        ];

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          endDrawer: isMobile
              ? PortfolioMobileDrawer(onNavigate: _navigateToSection)
              : null,
          body: Stack(
            children: [
              // Background responsive video locked to PageController scroll offset
              ScrollResponsiveVideoBackground(
                scrollController: _pageController,
                onVideoReady: (ready) {
                  if (mounted && !_isReady) {
                    setState(() {
                      _isReady = true;
                    });
                  }
                },
              ),
              // Fixed Persistent Header
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: HeaderSection(
                  isMobile: isMobile,
                  onOpenDrawer: () =>
                      _scaffoldKey.currentState?.openEndDrawer(),
                  onNavigate: _navigateToSection,
                ),
              ),
              // PageView showing each section individually
              Positioned.fill(
                top: 80,
                child: AnimatedOpacity(
                  opacity: _isReady ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeOut,
                  child: PageView.builder(
                    controller: _pageController,
                    scrollDirection: Axis.vertical,
                    physics: _isReady
                        ? const BouncingScrollPhysics()
                        : const NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() {
                        _currentSectionIndex = index;
                      });
                    },
                    itemCount: sections.length,
                    itemBuilder: (context, index) {
                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: screenHeight - 80,
                          ),
                          child: Center(
                            child: sections[index],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Section Indicator Dots on the right
              if (_isReady && !isMobile)
                Positioned(
                  right: 24,
                  top: screenHeight / 2 - (sections.length * 15),
                  child: Column(
                    children: List.generate(sections.length, (i) {
                      final isSelected = i == _currentSectionIndex;
                      return MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () => _navigateToSection(i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            width: isSelected ? 12 : 8,
                            height: isSelected ? 12 : 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.white.withValues(alpha: 0.3),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: AppColors.primary
                                            .withValues(alpha: 0.6),
                                        blurRadius: 8,
                                        spreadRadius: 2,
                                      ),
                                    ]
                                  : null,
                            ),
                          ),
                        ),
                      );
                    }),
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
