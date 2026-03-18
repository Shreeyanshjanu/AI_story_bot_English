import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/authentication/signup_screen.dart';
import 'package:frontend/utils/glass_snackbar.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.purple,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Image: top half, 16px padding all sides ─
            Padding(
              padding: EdgeInsets.fromLTRB(16, topPadding + 16, 16, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  'assets/images/login_bg.jpg',
                  width: double.infinity,
                  height: size.height / 2,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Container(
              width: double.infinity,
              color: Colors.purple,
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
              child: Center(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                  decoration: BoxDecoration(
                    color: const Color(0xFF171717),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 28),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      const SignInForm(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (mounted) {
        showGlassSnackbar(
          context,
          'Welcome back!',
          'assets/animations/success.json',
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        showGlassSnackbar(
          context,
          _getErrorMessage(e.code),
          'assets/animations/error.json',
        );
      }
    } catch (e) {
      if (mounted) {
        showGlassSnackbar(
          context,
          'Something went wrong. Please try again.',
          'assets/animations/error.json',
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled. Contact support.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'No internet connection. Check your network.';
      case 'invalid-credential':
        return 'Invalid email or password. Please try again.';
      default:
        return 'Login failed: $code';
    }
  }

  // ── Inset shadow pill field matching the CSS ─────
  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffixIcon,
    TextInputAction action = TextInputAction.next,
    String? Function(String?)? validator,
    void Function(String)? onSubmitted,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF171717),
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFF050505),
            blurRadius: 10,
            spreadRadius: 0,
            offset: Offset(2, 5),
            // inset equivalent — place inside container
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        textInputAction: action,
        keyboardType: keyboardType,
        onFieldSubmitted: onSubmitted,
        style: const TextStyle(color: Color(0xFFD3D3D3), fontSize: 14),
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF888888), fontSize: 14),
          prefixIcon: Icon(icon, color: Colors.white, size: 18),
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: const Color(0xFF171717),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: Color(0xFF444444)),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: Colors.red),
          ),
          errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 11),
        ),
      ),
    );
  }

  // ── Dark button matching .button1 / .button2 / .button3 ─
  Widget _buildButton({
    required String label,
    required VoidCallback? onTap,
    bool isLoading = false,
    bool expanded = false,
  }) {
    return GestureDetector(
      onTapDown: (_) => setState(() {}),
      child: SizedBox(
        width: expanded ? double.infinity : null,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF252525),
            foregroundColor: Colors.white,
            disabledBackgroundColor: const Color(0xFF252525).withOpacity(0.5),
            elevation: 0,
            padding: expanded
                ? const EdgeInsets.symmetric(vertical: 12)
                : const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // ── Email field ────────────────────────────
          _buildField(
            controller: _emailController,
            hint: 'Username',
            icon: Icons.alternate_email,
            keyboardType: TextInputType.emailAddress,
            action: TextInputAction.next,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Email is required';
              if (!v.contains('@')) return 'Enter a valid email';
              return null;
            },
          ),
          const SizedBox(height: 10),

          // ── Password field ─────────────────────────
          _buildField(
            controller: _passwordController,
            hint: 'Password',
            icon: Icons.lock_outline,
            obscure: _obscurePassword,
            action: TextInputAction.done,
            onSubmitted: (_) => _signIn(),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.white54,
                size: 18,
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Password is required';
              if (v.length < 6) return 'Min 6 characters';
              return null;
            },
          ),
          const SizedBox(height: 28),

          // ── Login + Sign Up buttons (side by side) ─
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton(
                label: 'Login',
                onTap: _loading ? null : _signIn,
                isLoading: _loading,
              ),
              const SizedBox(width: 8),
              _buildButton(
                label: 'Sign Up',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SignUpScreen()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // ── Forgot Password button (full width) ────
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // TODO: hook up forgot password
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF252525),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text(
                'Forgot Password',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
