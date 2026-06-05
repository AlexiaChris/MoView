import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final AuthService _authService = AuthService();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLogin = false;
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  void _toggleTab(bool isLogin) {
    setState(() {
      _isLogin = isLogin;
      _errorMessage = null;
      _usernameController.clear();
      _passwordController.clear();
    });
  }

  Future<void> _submit() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Please fill in all fields');
      return;
    }

    setState(() { _isLoading = true; _errorMessage = null; });

    try {
      if (_isLogin) {
        await _authService.login(username, password);
      } else {
        await _authService.register(username, password);
        await _authService.login(username, password);
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = e.toString().replaceAll('Exception: ', ''));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
                        SizedBox(width: 6),
                        Text('Back', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48),
              const Text(
                'MoView',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'FrunchySage',
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  
                  height: 0.8,
                ),
              ),

              const Text(
                'Where Movie Lovers Share Their Thoughts.',
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 13,
                  fontFamily: 'Alata',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              _buildTabToggle(),
              const SizedBox(height: 28),
              _buildLabel('Username'),
              const SizedBox(height: 8),
              _buildTextField(controller: _usernameController, hint: 'Enter your username'),
              const SizedBox(height: 20),
              _buildLabel('Password'),
              const SizedBox(height: 8),
              _buildPasswordField(),
              if (!_isLogin) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Min. 6 characters',
                    style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11),
                  ),
                ),
              ],
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ),
              ],
              const SizedBox(height: 28),
              _buildSubmitButton(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

Widget _buildTabToggle() {
  return Stack(
    children: [
      Container(
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white, width: 1.5),
        ),
      ),
      // Yang aktif di atas nimpa border putih
      Positioned(
        top: 0, bottom: 0,
        left: _isLogin ? 0 : null,
        right: !_isLogin ? 0 : null,
        width: MediaQuery.of(context).size.width * 0.5 - 32,
        child: GestureDetector(
          onTap: () => _toggleTab(_isLogin),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF380056),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: const Color(0xFFA600FF), width: 1.5),
            ),
          ),
        ),
      ),
      Positioned(
        top: 0, bottom: 0,
        left: 0,
        width: MediaQuery.of(context).size.width * 0.5 - 32,
        child: GestureDetector(
          onTap: () => _toggleTab(true),
          child: Center(
            child: Text('Log In',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: _isLogin ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),

      Positioned(
        top: 0, bottom: 0,
        right: 0,
        width: MediaQuery.of(context).size.width * 0.5 - 32,
        child: GestureDetector(
          onTap: () => _toggleTab(false),
          child: Center(
            child: Text('Sign Up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: !_isLogin ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFF380056),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFA600FF), width: 1.5),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        cursorColor: const Color(0xFFA600FF),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFF380056),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFA600FF), width: 1.5),
      ),
      child: TextField(
        controller: _passwordController,
        obscureText: _obscurePassword,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        cursorColor: const Color(0xFFA600FF),
        decoration: InputDecoration(
          hintText: 'Enter your password',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          suffixIcon: GestureDetector(
            onTap: () => setState(() => _obscurePassword = !_obscurePassword),
            child: Icon(
              _obscurePassword ? Icons.lock_outline_rounded : Icons.lock_open_rounded,
              color: Colors.white.withOpacity(0.5),
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: 160,
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFF380056),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFA600FF), width: 1.5),
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20, height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : Text(
                _isLogin ? 'Log In' : 'Sign Up',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}