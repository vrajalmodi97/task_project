import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_project/core/blocs/user/user_event.dart';
import 'package:task_project/core/blocs/user/user_state.dart';
import 'package:task_project/core/models/user.dart';
import 'package:task_project/core/repositories/user_repository.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc(this.userRepository) : super(UserLoading()) {
    on<LoadUsers>(_onLoadUsers);
    // on<UpdateWalletBalance>(_onUpdateWalletBalance);
  }

  void _onLoadUsers(LoadUsers event, Emitter<UserState> emit) async {
    try {
      List<UserData> users = await userRepository.fetchUsers();
      emit(UserLoaded(users));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<String> updateWalletBalance(
      String userId, double walletBalance) async {
    try {
      return await userRepository.upadetWalletBalance(userId, walletBalance);
    } catch (e) {
      return "Update wallet balance failed: ${e.toString()}";
    }
  }
}
