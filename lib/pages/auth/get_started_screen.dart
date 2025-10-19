import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

import '../../core/router/routes.dart';
import '../../widgets/custom_icon_button.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  VideoPlayerController? _playerController;

  @override
  void initState() {
    super.initState();
    _playerController = VideoPlayerController.asset(
        'assets/get_started/get_started_video.mp4',
      )
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() {});
        _playerController
          ?..setLooping(true)
          ..setPlaybackSpeed(1.6)
          ..play();
      });
  }

  @override
  void dispose() {
    _playerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;
    return Scaffold(
      body:
          _playerController != null && _playerController!.value.isInitialized
              ? Stack(
                children: [
                  SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _playerController!.value.size.width,
                        height: _playerController!.value.size.height,
                        child: VideoPlayer(_playerController!),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      color: color.background.withValues(alpha: 0.5),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "DRIPZY",
                      style: TextStyle(
                        color: color.onBackground,
                        fontSize: 23,
                        fontWeight: FontWeight.w100,
                        letterSpacing: 10,
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Column(
                      spacing: 4,
                      children: [
                        const Spacer(),
                        CustomIconButton(
                          label: "Get Started",
                          onPressed:
                              () => context.goNamed(AppRoutes.registerName),
                          icon: Icons.arrow_forward,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: GestureDetector(
                            onTap: () {
                              context.goNamed(AppRoutes.loginName);
                            },
                            child: Text.rich(
                              TextSpan(
                                text: "Already have an account? ",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: color.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Login",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: color.tertiary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
              : const Center(child: CircularProgressIndicator()),
    );
  }
}
