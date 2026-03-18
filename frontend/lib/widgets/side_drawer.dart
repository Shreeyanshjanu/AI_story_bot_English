import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
class SideDrawer extends StatefulWidget {
  const SideDrawer({super.key});
  @override
  State<SideDrawer> createState() => SideDrawerState();
}
class SideDrawerState extends State<SideDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _drawerCtrl;
  late Animation<Offset>   _drawerSlide;
  bool _drawerOpen = false;
  @override
  void initState() {
    super.initState();
    _drawerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _drawerSlide = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end:   Offset.zero,
    ).animate(CurvedAnimation(
      parent: _drawerCtrl,
      curve:  Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _drawerCtrl.dispose();
    super.dispose();
  }

  void openDrawer() {
    setState(() => _drawerOpen = true);
    _drawerCtrl.forward();
  }

  void _closeDrawer() {
    _drawerCtrl.reverse().then((_) {
      if (mounted) setState(() => _drawerOpen = false);
    });
  }

  Future<void> _logout() async {
    _closeDrawer();
    await Future.delayed(const Duration(milliseconds: 350));
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    if (!_drawerOpen) return const SizedBox.shrink();

    return Stack(
      children: [

        // ── Dim backdrop ───────────────────────────────
        GestureDetector(
          onTap: _closeDrawer,
          child: AnimatedBuilder(
            animation: _drawerCtrl,
            builder: (_, __) => Container(
              color: Colors.black.withOpacity(0.4 * _drawerCtrl.value),
            ),
          ),
        ),

        // ── Drawer panel (slides in from left) ─────────
        SlideTransition(
          position: _drawerSlide,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width:  MediaQuery.of(context).size.width * 0.65,
              height: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight:    Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
                boxShadow: [
                  BoxShadow(
                    color:     Color(0x226C4FD4),
                    blurRadius: 32,
                    offset:    Offset(8, 0),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ── Header ────────────────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Menu',
                            style: TextStyle(
                              color:      Color(0xFF1a1a2e),
                              fontSize:   22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: _closeDrawer,
                            child: Container(
                              width:  32,
                              height: 32,
                              decoration: BoxDecoration(
                                color:        const Color(0xFFF0ECFF),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.close_rounded,
                                color: Color(0xFF6C4FD4),
                                size:  18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // ── User email ────────────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                      child: Text(
                        FirebaseAuth.instance.currentUser?.email ?? '',
                        style: const TextStyle(
                          color:    Color(0xFF999999),
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── Divider ───────────────────────
                    const Divider(
                      color:  Color(0xFFEEEEFF),
                      height: 1,
                      indent: 24,
                      endIndent: 24,
                    ),

                    const SizedBox(height: 16),

                    // ── Logout item ───────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GestureDetector(
                        onTap: _logout,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical:   12,
                          ),
                          decoration: BoxDecoration(
                            color:        const Color(0xFFFFF0F0),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.red.withOpacity(0.15),
                            ),
                          ),
                          child: Row(
                            children: [
                              // ── Lottie logout icon ──
                              Lottie.asset(
                                'assets/animations/logout.json',
                                width:  36,
                                height: 36,
                                repeat: true,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Logout',
                                style: TextStyle(
                                  color:      Colors.red,
                                  fontSize:   15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.red,
                                size:  14,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),

                    // ── Footer ────────────────────────
                    const Padding(
                      padding: EdgeInsets.fromLTRB(24, 0, 24, 16),
                      child: Text(
                        'AI Storyteller',
                        style: TextStyle(
                          color:    Color(0xFFCCCCCC),
                          fontSize: 12,
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ),

      ],
    );
  }
}