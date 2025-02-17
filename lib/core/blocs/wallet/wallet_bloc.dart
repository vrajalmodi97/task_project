import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_project/core/blocs/wallet/wallet_event.dart';
import 'package:task_project/core/blocs/wallet/wallet_state.dart';
import 'package:task_project/core/repositories/wallet_repository.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final WalletRepository walletRepository;

  WalletBloc(this.walletRepository) : super(WalletLoading()) {
    on<LoadWallet>(_onLoadWallet);
    on<SendMoney>(_onSendMoney);
  }

  void _onLoadWallet(LoadWallet event, Emitter<WalletState> emit) async {
    emit(WalletLoading());
    try {
      print("_onLoadWallet>>" + event.userId);
      final balance = await walletRepository.getBalance(event.userId);
      emit(WalletLoaded(balance));
    } catch (e) {
      emit(WalletError(e.toString()));
    }
  }

  Future<String> getWalletBalance(String userId) async {
    try {
      final balance = await walletRepository.getBalance(userId);
      return balance.toString();
    } catch (e) {
      return "Load wallet balance failed: ${e.toString()}";
    }
  }

  void _onSendMoney(SendMoney event, Emitter<WalletState> emit) async {
    try {
      print("_onLoadWallet>>" );
      await walletRepository.sendMoney(event.senderId, event.recipientId,
          event.senderName, event.recipientName, event.amount);
      emit(WalletTransactionSuccess());
      add(LoadWallet(event.senderId));
    } catch (e) {
      emit(WalletError(e.toString()));
    }
  }
}
