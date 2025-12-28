import 'package:flutter/material.dart';
import '../main.dart'; // Ensure this points to where your ThemeManager class is

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsPage> {
  // Initialize the switch state based on the current global theme
  late bool appearanceDark = ThemeManager.themeMode.value == ThemeMode.dark;
  bool notificationDark = true;

  @override
  Widget build(BuildContext context) {
    // Determine if the current theme is dark to adjust UI colors
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // Background color changes based on theme
      backgroundColor: isDarkMode
          ? const Color(0xFF121212)
          : const Color(0xFFEFF2F9),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle("Appearance", isDarkMode),
                  _cardSwitch(
                    "Dark Mode",
                    "Switch between light and dark theme",
                    appearanceDark,
                    isDarkMode,
                    (v) {
                      setState(() {
                        appearanceDark = v;
                      });
                      // 🔥 GLOBAL LOGIC: Update the entire app theme
                      ThemeManager.toggleTheme(v);
                    },
                  ),

                  const SizedBox(height: 20),
                  _sectionTitle("Notifications", isDarkMode),
                  _cardSwitch(
                    "Notification Alerts",
                    "Get updates on task deadlines",
                    notificationDark,
                    isDarkMode,
                    (v) {
                      setState(() => notificationDark = v);
                    },
                  ),

                  const SizedBox(height: 20),
                  _sectionTitle("General", isDarkMode),
                  _settingItem(
                    Icons.privacy_tip_outlined,
                    "Privacy & Security",
                    isDarkMode,
                    () {},
                  ),
                  _settingItem(
                    Icons.info_outline,
                    "About TaskFlow",
                    isDarkMode,
                    () {},
                  ),
                  _settingItem(
                    Icons.support_agent_outlined,
                    "Contact Support",
                    isDarkMode,
                    () {},
                  ),

                  const SizedBox(height: 25),
                  Text(
                    "Reset data",
                    style: TextStyle(
                      color: isDarkMode
                          ? const Color(0xFFD4A5FF)
                          : const Color(0xFFB24EFF),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 10),
                  _gradientButton("Clear All Data", Icons.delete, () {}),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- UI COMPONENTS (Updated for Theme Support) ----------------

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 30),
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Row(
        children: const [
          Icon(Icons.arrow_back, color: Colors.white, size: 26),
          SizedBox(width: 10),
          Text(
            "Settings",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
    );
  }

  Widget _cardSwitch(
    String title,
    String subtitle,
    bool value,
    bool isDark,
    Function(bool) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(
            value ? Icons.dark_mode_outlined : Icons.wb_sunny_outlined,
            color: const Color(0xFF8E2DE2),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black54,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF8E2DE2),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _settingItem(
    IconData icon,
    String title,
    bool isDark,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isDark ? Colors.white38 : Colors.black45,
            ),
          ],
        ),
      ),
    );
  }

  Widget _gradientButton(String text, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(
            colors: [Color(0xFF7B61FF), Color(0xFFBE73E0)],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
