import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../portfolio/screens/portfolio_screen.dart';
import '../views/chat_view.dart';
import '../views/profile_code_view.dart';

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
                  backgroundColor: AppColors.vsCodeActivityBar,
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
                  backgroundColor: AppColors.vsCodeSidebar,
                  child: Column(
                    children: [
                      const DrawerHeader(
                        decoration: BoxDecoration(
                          color: AppColors.vsCodeActivityBar,
                        ),
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
                  color: AppColors.vsCodeActivityBar,
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
                  color: AppColors.vsCodeSidebar,
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
                      color: AppColors.vsCodeSidebar,
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
                        color: AppColors.vsCodeEditor,
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
            color: AppColors.vsCodeStatusBar,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: const [
                Icon(
                  Icons.source_outlined,
                  size: 12,
                  color: Colors.white,
                ),
                SizedBox(width: 5),
                Text(
                  "main",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                SizedBox(width: 10),
                Icon(Icons.sync, size: 12, color: Colors.white),
                Spacer(),
                Text(
                  "Dart",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                SizedBox(width: 10),
                Icon(
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
    final isSelected = _selectedIndex == index && index < 2;
    return InkWell(
      onTap: () {
        if (isAccount) {
          setState(() => _showPortfolio = true);
        } else if (index == 0) {
          setState(() {
            if (_selectedIndex == 0) {
              _isSidebarOpen = !_isSidebarOpen;
            } else {
              _selectedIndex = 0;
              _isSidebarOpen = true;
            }
          });
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
            const SizedBox(width: 20),
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
            const SizedBox(width: 20),
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
        color: isSelected ? AppColors.vsCodeEditor : const Color(0xFF2D2D2D),
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
