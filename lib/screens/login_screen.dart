import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'register_screen.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    // Validar campos
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, preencha todos os campos.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Tentar login
      await Provider.of<UserProvider>(context, listen: false).login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      
      // Login bem-sucedido, navegar para dashboard
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      }
    } catch (e) {
      // Tratar erro de login
      setState(() {
        _errorMessage = _getErrorMessage(e.toString());
        _isLoading = false;
      });
    }
  }

  void _navigateToRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  String _getErrorMessage(String error) {
    if (error.contains('user-not-found')) {
      return 'Usuário não encontrado. Verifique seu email.';
    } else if (error.contains('wrong-password')) {
      return 'Senha incorreta. Tente novamente.';
    } else if (error.contains('invalid-email')) {
      return 'Email inválido. Verifique o formato.';
    } else if (error.contains('user-disabled')) {
      return 'Esta conta foi desativada.';
    } else if (error.contains('too-many-requests')) {
      return 'Muitas tentativas. Tente novamente mais tarde.';
    } else {
      return 'Erro ao fazer login. Tente novamente.';
    }
  }
}
