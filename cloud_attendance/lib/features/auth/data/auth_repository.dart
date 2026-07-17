import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository());

final authStateProvider = StateProvider<UserModel?>((ref) => null);

class AuthRepository {
  Future<UserModel?> login(String email, String password) async {
    // Mock login delay
    await Future.delayed(const Duration(seconds: 2));
    
    if (email == 'user@demo.com' && password == 'password') {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', true);
      
      return UserModel(
        id: '1',
        name: 'John Doe',
        email: email,
        role: 'Employee',
        profileImageUrl: 'https://i.pravatar.cc/150?img=11',
      );
    }
    throw Exception('Invalid email or password');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', false);
    await Future.delayed(const Duration(seconds: 1));
  }
  
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }
}
