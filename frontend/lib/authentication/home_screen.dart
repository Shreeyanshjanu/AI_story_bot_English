import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/screens/story_screen.dart';
import 'package:frontend/screens/generating_screen.dart';
import 'package:frontend/servicees/groq_service.dart';
import 'package:lottie/lottie.dart';
import 'package:frontend/widgets/side_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _promptController = TextEditingController();
  final GroqService _groqService = GroqService();
  final FocusNode _focusNode = FocusNode();
  final GlobalKey<SideDrawerState> _drawerKey = GlobalKey<SideDrawerState>();

  bool _isLoading = false;

  @override
  void dispose() {
    _promptController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _generateStory() async {
    final prompt = _promptController.text.trim();
    if (prompt.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a story idea first')),
      );
      return;
    }
    _focusNode.unfocus();
    setState(() => _isLoading = true);

    try {
      final storyText = await _groqService.generateStory(prompt);
      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StoryScreen(prompt: prompt, storyText: storyText),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _setSuggestion(String text) {
    _promptController.text = text;
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const GeneratingScreen();

    final user     = FirebaseAuth.instance.currentUser;
    final username = user?.email?.split('@')[0] ?? 'Storyteller';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FF),
      body: Stack(
        children: [

          // ── Main content ─────────────────────────────
          SafeArea(
            child: Column(
              children: [

                // ── AppBar ──────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, $username',
                            style: const TextStyle(
                              color:      Color(0xFF1a1a2e),
                              fontSize:   18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'What story shall we tell today?',
                            style: TextStyle(
                              color:    Color(0xFF888888),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),

                      // ── Hamburger → opens SideDrawer ──
                      GestureDetector(
                        onTap: () => _drawerKey.currentState?.openDrawer(),
                        child: Container(
                          width:  40,
                          height: 40,
                          decoration: BoxDecoration(
                            color:        Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFE8E0FF),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color:      Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset:     const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.menu_rounded,
                            color: Color(0xFF1a1a2e),
                            size:  20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Centre Lottie + tagline ──────────────
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const _SparkleIcon(),
                        const SizedBox(height: 20),
                        const Text(
                          'Ask our AI anything',
                          style: TextStyle(
                            color:         Color(0xFF1a1a2e),
                            fontSize:      22,
                            fontWeight:    FontWeight.w600,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Type a story idea and let the magic begin',
                          style: TextStyle(
                            color:    Color(0xFF999999),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Suggestions label ────────────────────
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Suggestions on what to ask',
                      style: TextStyle(
                        color:      Color(0xFF888888),
                        fontSize:   12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                // ── Suggestion chips ─────────────────────
                SizedBox(
                  height: 70,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    children: [
                      _SuggestionChip(
                        text:  'A lion and a clever fox\nin the jungle',
                        onTap: () => _setSuggestion(
                          'A lion and a clever fox in the jungle',
                        ),
                      ),
                      const SizedBox(width: 10),
                      _SuggestionChip(
                        text:  'A fairy who helps\na poor child',
                        onTap: () => _setSuggestion(
                          'A fairy who helps a poor child',
                        ),
                      ),
                      const SizedBox(width: 10),
                      _SuggestionChip(
                        text:  'A child who travels\nto space in a rocket',
                        onTap: () => _setSuggestion(
                          'A child who travels to space in a rocket',
                        ),
                      ),
                      const SizedBox(width: 10),
                      _SuggestionChip(
                        text:  'A dragon who\nfears fire',
                        onTap: () => _setSuggestion(
                          'A dragon who fears fire',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // ── Bottom input bar ─────────────────────
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  decoration: BoxDecoration(
                    color:        Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color:      Colors.black.withOpacity(0.08),
                        blurRadius: 20,
                        offset:     const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: const Color(0xFFE8E0FF),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller:      _promptController,
                          focusNode:       _focusNode,
                          textInputAction: TextInputAction.send,
                          onSubmitted:     (_) => _generateStory(),
                          style: const TextStyle(
                            color:    Color(0xFF1a1a2e),
                            fontSize: 14,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Ask me anything about stories...',
                            hintStyle: TextStyle(
                              color:    Color(0xFFAAAAAA),
                              fontSize: 14,
                            ),
                            border:         InputBorder.none,
                            contentPadding: EdgeInsets.fromLTRB(20, 16, 8, 16),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: _generateStory,
                          child: Container(
                            width:  40,
                            height: 40,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFD4A8FF), Color(0xFF9B8FFF)],
                                begin:  Alignment.topLeft,
                                end:    Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.send_rounded,
                              color: Colors.white,
                              size:  18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),

          // ── SideDrawer overlays everything ───────────
          SideDrawer(key: _drawerKey),

        ],
      ),
    );
  }
}


// ─────────────────────────────────────────────────────────────────────────────
// Sparkle Icon (Lottie)
// ─────────────────────────────────────────────────────────────────────────────
class _SparkleIcon extends StatelessWidget {
  const _SparkleIcon();

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'assets/animations/home_screen_animation.json',
      width:  180,
      height: 180,
      repeat: true,
      fit:    BoxFit.contain,
    );
  }
}


// ─────────────────────────────────────────────────────────────────────────────
// Suggestion Chip
// ─────────────────────────────────────────────────────────────────────────────
class _SuggestionChip extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _SuggestionChip({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFE8E0FF),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color:      Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset:     const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(
            color:    Color(0xFF444444),
            fontSize: 12,
            height:   1.5,
          ),
        ),
      ),
    );
  }
}