import 'package:chat_wave/home/util/transparent_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../blocs/share_profile_bloc/share_profile_bloc.dart';

class ShareScreen extends StatelessWidget {
  const ShareScreen({super.key});

  static Route get route => TransparentRoute(
        builder: (_) => const ShareScreen(),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShareProfileBloc(),
      child: Scaffold(
        backgroundColor: Colors.transparent.withOpacity(0.3),
        body: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          behavior: HitTestBehavior.opaque,
          child: BlocConsumer<ShareProfileBloc, ShareProfileState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (ctx, state) {
              if (state is LoadedSecret) {
                final secret = state.secret;
                return Center(
                  child: QrImage(
                    data: secret,
                    version: 7,
                    size: 300,
                    semanticsLabel:
                        'This QR code should be scanned by your friend to add you',
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
