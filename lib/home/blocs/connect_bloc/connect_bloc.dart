import 'package:bloc/bloc.dart';
import 'package:chat_wave/home/domain/repository/connection_repository.dart';
import 'package:chat_wave/utils/locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

part 'connect_event.dart';
part 'connect_state.dart';

/// This Bloc is responsible for scanning QR code and sending request to connect using
/// the scanned secret.
class ConnectBloc extends Bloc<ConnectEvent, ConnectState> {
  ConnectBloc() : super(Idle()) {
    on<ScanSecret>(_handleScanSecret);
  }

  final _connectRepository = locator<ConnectionRepository>();

  Future<void> _handleScanSecret(
    ScanSecret event,
    Emitter<ConnectState> emit,
  ) async {
    if (state is ScanningQrCode) return;
    emit(ScanningQrCode());
    final secret = await FlutterBarcodeScanner.scanBarcode(
      '#000000',
      'Cancel',
      false,
      ScanMode.QR,
    );
    if (secret == '-1') {
      // User didn't scan anything.
      emit(Idle());
      return;
    }
    emit(Loading());
    try {
      await _connectRepository.connectToFriend(secret);
      emit(ConnectedToFriend());
      await Future.delayed(const Duration(seconds: 1));
      emit(Idle());
    } catch (_) {
      emit(FailedToConnect());
      await Future.delayed(const Duration(seconds: 2));
      emit(Idle());
    }
  }
}
