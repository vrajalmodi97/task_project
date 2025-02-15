import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_project/core/blocs/auth/auth_event.dart';
import 'package:task_project/core/blocs/auth/auth_state.dart';
import 'package:task_project/core/repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authRepository.login(event.email, event.password);
        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final value = await authRepository.register(
            event.name, event.email, event.phoneNumber, event.password);
        emit(RegisterSuccess(value));
      } catch (e) {
        emit(RegisterFailure(e.toString()));
      }
    });
  }
}
