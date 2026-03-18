import 'package:flutter/material.dart';
import 'package:frontend/servicees/tts_service.dart';

class StoryScreen extends StatefulWidget {
  final String prompt;
  final String storyText;

  const StoryScreen({
    super.key,
    required this.prompt,
    required this.storyText,
  });

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  final TtsService _ttsService = TtsService();
  bool _isPlaying = false;
  bool _isInitialized = false;

  int _currentWordStart = 0;
  int _currentWordEnd   = 0;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    await _ttsService.init();

    _ttsService.setProgressHandler((text, start, end, word) {
      if (mounted) {
        setState(() {
          _currentWordStart = start;
          _currentWordEnd   = end;
        });
      }
    });

    _ttsService.setCompletionHandler(() {
      if (mounted) {
        setState(() {
          _isPlaying        = false;
          _currentWordStart = 0;
          _currentWordEnd   = 0;
        });
      }
    });

    setState(() => _isInitialized = true);
    await _playStory();
  }

  Future<void> _playStory() async {
    await _ttsService.speak(widget.storyText);
    if (mounted) setState(() => _isPlaying = true);
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _ttsService.pause();
      setState(() => _isPlaying = false);
    } else {
      await _playStory();
    }
  }

  Future<void> _replay() async {
    await _ttsService.stop();
    setState(() {
      _isPlaying        = false;
      _currentWordStart = 0;
      _currentWordEnd   = 0;
    });
    await Future.delayed(const Duration(milliseconds: 300));
    await _playStory();
  }

  @override
  void dispose() {
    _ttsService.dispose();
    super.dispose();
  }

  // ── Highlighted story text ─────────────────────────────
  Widget _buildHighlightedText() {
    final text = widget.storyText;

    if (_currentWordStart == 0 && _currentWordEnd == 0) {
      return Text(
        text,
        style: const TextStyle(
          color: Color(0xFF2a2a3e),
          fontSize: 16,
          height: 1.9,
          letterSpacing: 0.1,
        ),
      );
    }

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: text.substring(0, _currentWordStart),
            style: const TextStyle(
              color: Color(0xFF888888),
              fontSize: 16,
              height: 1.9,
              letterSpacing: 0.1,
            ),
          ),
          TextSpan(
            text: text.substring(_currentWordStart, _currentWordEnd),
            style: const TextStyle(
              color: Color(0xFF6C4FD4),
              fontSize: 16,
              height: 1.9,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.1,
              backgroundColor: Color(0x186C4FD4),
            ),
          ),
          TextSpan(
            text: text.substring(_currentWordEnd),
            style: const TextStyle(
              color: Color(0xFF888888),
              fontSize: 16,
              height: 1.9,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FF),
      body: Column(
        children: [

          // ── Custom AppBar ────────────────────────────
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Color(0xFF1a1a2e),
                      size: 20,
                    ),
                    onPressed: () {
                      _ttsService.stop();
                      Navigator.pop(context);
                    },
                  ),
                  const Expanded(
                    child: Text(
                      'Your Story',
                      style: TextStyle(
                        color: Color(0xFF1a1a2e),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  // Playing indicator pill
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _isPlaying
                          ? const Color(0xFF6C4FD4).withOpacity(0.12)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _isPlaying
                            ? const Color(0xFF6C4FD4).withOpacity(0.3)
                            : Colors.transparent,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_isPlaying) ...[
                          const _PulsingDot(),
                          const SizedBox(width: 6),
                        ],
                        Text(
                          _isPlaying ? 'Playing' : 'Paused',
                          style: TextStyle(
                            color: _isPlaying
                                ? const Color(0xFF6C4FD4)
                                : const Color(0xFFAAAAAA),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Prompt tag ───────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 7,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFEDE8FF), Color(0xFFE8F0FF)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF6C4FD4).withOpacity(0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      size: 13,
                      color: Color(0xFF6C4FD4),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        widget.prompt,
                        style: const TextStyle(
                          color: Color(0xFF6C4FD4),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Story text ───────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHighlightedText(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // ── Player card ──────────────────────────────
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: const Color(0xFFE8E0FF),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6C4FD4).withOpacity(0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                // ── Progress bar (visual only) ──────────
                Container(
                  height: 4,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEEEFF),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: _isPlaying
                      ? _AnimatedProgressBar()
                      : const SizedBox(),
                ),
                const SizedBox(height: 20),

                // ── Controls ────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    // Replay
                    _ControlButton(
                      icon: Icons.replay_rounded,
                      onTap: _isInitialized ? _replay : null,
                      size: 22,
                    ),

                    const SizedBox(width: 28),

                    // Play / Pause (big)
                    GestureDetector(
                      onTap: _isInitialized ? _togglePlayPause : null,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _isInitialized
                                ? const [
                                    Color(0xFF9B8FFF),
                                    Color(0xFF6C4FD4),
                                  ]
                                : [Colors.grey.shade300, Colors.grey.shade400],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF6C4FD4).withOpacity(0.35),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: !_isInitialized
                            ? const Padding(
                                padding: EdgeInsets.all(18),
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Icon(
                                _isPlaying
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 34,
                              ),
                      ),
                    ),

                    const SizedBox(width: 28),

                    // Stop
                    _ControlButton(
                      icon: Icons.stop_rounded,
                      onTap: _isInitialized
                          ? () async {
                              await _ttsService.stop();
                              setState(() {
                                _isPlaying        = false;
                                _currentWordStart = 0;
                                _currentWordEnd   = 0;
                              });
                            }
                          : null,
                      size: 22,
                    ),
                  ],
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}


// ─────────────────────────────────────────────────────────────────────────────
// Small circular control button
// ─────────────────────────────────────────────────────────────────────────────
class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final double size;

  const _ControlButton({
    required this.icon,
    required this.onTap,
    this.size = 22,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: enabled
              ? const Color(0xFFF0ECFF)
              : const Color(0xFFF5F5F5),
          shape: BoxShape.circle,
          border: Border.all(
            color: enabled
                ? const Color(0xFFE0D8FF)
                : const Color(0xFFEEEEEE),
          ),
        ),
        child: Icon(
          icon,
          size: size,
          color: enabled
              ? const Color(0xFF6C4FD4)
              : const Color(0xFFCCCCCC),
        ),
      ),
    );
  }
}


// ─────────────────────────────────────────────────────────────────────────────
// Pulsing dot for "Playing" indicator
// ─────────────────────────────────────────────────────────────────────────────
class _PulsingDot extends StatefulWidget {
  const _PulsingDot();

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Container(
        width: 7,
        height: 7,
        decoration: const BoxDecoration(
          color: Color(0xFF6C4FD4),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}


// ─────────────────────────────────────────────────────────────────────────────
// Animated shimmer progress bar
// ─────────────────────────────────────────────────────────────────────────────
class _AnimatedProgressBar extends StatefulWidget {
  @override
  State<_AnimatedProgressBar> createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<_AnimatedProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _position;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _position = Tween<double>(begin: -0.4, end: 1.2).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => LayoutBuilder(
        builder: (_, constraints) {
          final w = constraints.maxWidth;
          return Stack(
            children: [
              Container(
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEEEFF),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Positioned(
                left: _position.value * w,
                child: Container(
                  width: w * 0.4,
                  height: 4,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Colors.transparent,
                        Color(0xFF9B8FFF),
                        Colors.transparent,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}