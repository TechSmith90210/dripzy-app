import 'package:dripzy/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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
    _playerController =
        VideoPlayerController.asset('assets/get_started/get_started_video.mp4')
          ..initialize().then(
            (value) {
              setState(() {});
              _playerController?.setLooping(true);
              _playerController?.setPlaybackSpeed(1.6);
              _playerController?.play();
            },
          );
  }

  @override
  void dispose() {
    _playerController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _playerController != null && _playerController!.value.isInitialized
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
                    color: LightColors.background.withValues(alpha: 0.5),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "DRIPZY",
                    style: TextStyle(
                        color: LightColors.onBackground,
                        fontSize: 23,
                        fontWeight: FontWeight.w100,
                        letterSpacing: 10),
                  ),
                ),
                SafeArea(
                  child: Column(
                    children: [
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: LightColors.primary,
                              foregroundColor: LightColors.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 8,
                              children: [
                                const Text(
                                  'Get Started',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Icon(Icons.arrow_forward)
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
