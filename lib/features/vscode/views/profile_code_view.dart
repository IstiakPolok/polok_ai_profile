import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/data/profile_data.dart';

class ProfileCodeView extends StatelessWidget {
  const ProfileCodeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCodeLine(1, "class Profile {", color: AppColors.syntaxKeyword),
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
            color: AppColors.syntaxComment,
            indent: 2,
          ),
          _buildCodeLine(7, "  String get bio => '''", indent: 2),
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Text(
              ProfileData.bio,
              style: GoogleFonts.firaCode(
                color: AppColors.syntaxString,
                fontSize: 14,
              ),
            ),
          ),
          _buildCodeLine(8, "  ''';", indent: 2),
          _buildCodeLine(9, ""),
          _buildCodeLine(
            10,
            "  // Experience",
            color: AppColors.syntaxComment,
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
            color: AppColors.syntaxComment,
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
