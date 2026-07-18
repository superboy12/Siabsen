import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/user_model.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  AuthNotifier() : super(const AsyncValue.data(null));

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (email == 'admin@demo.com') {
      state = AsyncValue.data(
        UserModel(
          id: 'admin',
          name: 'Super Admin',
          email: email,
          role: 'Super Admin',
          nip: '000000000',
          department: 'Administrator',
          profileImageUrl: 'https://ui-avatars.com/api/?name=Super+Admin&background=16A34A&color=fff&size=200',
        )
      );
    } else {
      state = AsyncValue.data(
        UserModel(
          id: '1',
          name: 'Budi Santoso',
          email: email.isEmpty ? 'budi.santoso@instansi.go.id' : email,
          role: 'Pegawai',
          nip: '198507232010121001',
          department: 'Biro Teknologi Informasi',
          profileImageUrl: 'https://ui-avatars.com/api/?name=Budi+Santoso&background=2E7D32&color=fff&size=200',
        )
      );
    }
  }

  void logout() {
    state = const AsyncValue.data(null);
  }

  void updateName(String newName) {
    if (state.value != null) {
      final updatedUser = UserModel(
        id: state.value!.id,
        name: newName,
        email: state.value!.email,
        role: state.value!.role,
        nip: state.value!.nip,
        department: state.value!.department,
        profileImageUrl: 'https://ui-avatars.com/api/?name=${newName.replaceAll(' ', '+')}&background=2E7D32&color=fff&size=200',
      );
      state = AsyncValue.data(updatedUser);
    }
  }
}
