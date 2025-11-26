import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const VideoPlayerApp());
}

class VideoPlayerApp extends StatelessWidget {
  const VideoPlayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Video Oynatıcı',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(73, 19, 232, 1),
        ),
        useMaterial3: true,
      ),
      home: const VideoScreen(),
    );
  }
}

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  VideoPlayerController? _controller;

  final List<Map<String, String>> _playlist = [
    {
      'title': 'Kelebek',
      'url':
          'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      'poster':
          'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
    },
    {
      'title': 'Arı',
      'url':
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      'poster':
          'https://images.unsplash.com/photo-1559252326-228d90209598?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
    },
  ];

  int _currentIndex = 0;
  bool _isLooping = false;
  bool _isMuted = false;
  bool _showPoster = true;

  @override
  void initState() {
    super.initState();
    _startVideo(_currentIndex);
  }

  Future<void> _startVideo(int index) async {
    final newController = VideoPlayerController.networkUrl(
      Uri.parse(_playlist[index]['url']!),
    );

    await newController.initialize();

    newController.addListener(() {
      if (mounted) setState(() {});
    });

    if (mounted) {
      setState(() {
        _controller = newController;
      });
    }
  }

  void _changeVideo(int index) async {
    final oldController = _controller;
    if (oldController != null) {
      await oldController.pause();
      oldController.dispose();
    }

    if (mounted) {
      setState(() {
        _controller = null;
        _currentIndex = index;
        _showPoster = true;
      });
    }

    await _startVideo(index);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    final currentVideo = _playlist[_currentIndex];
    final controller = _controller;

    // Video hazır değilse yükleniyor göster
    final bool isReady = (controller != null && controller.value.isInitialized);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 81, 86, 218),
      appBar: AppBar(
        title: Text(currentVideo['title']!),
        backgroundColor: Colors.red,
      ),
      body: !isReady
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Video alanı ve poster
                  GestureDetector(
                    onDoubleTap: () {
                      setState(() {
                        _showPoster = false;
                        controller.value.isPlaying
                            ? controller.pause()
                            : controller.play();
                      });
                    },
                    onVerticalDragUpdate: (details) {
                      double currentVol = controller.value.volume;
                      double delta = details.primaryDelta! / 100;
                      double newVol = (currentVol - delta).clamp(0.0, 1.0);
                      controller.setVolume(newVol);
                      setState(() {});
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AspectRatio(
                          aspectRatio: controller.value.aspectRatio,
                          child: VideoPlayer(controller),
                        ),

                        // Poster
                        if (_showPoster)
                          Positioned.fill(
                            child: Image.network(
                              currentVideo['poster']!,
                              fit: BoxFit.cover,
                            ),
                          ),

                        // Play butonu
                        if (_showPoster || !controller.value.isPlaying)
                          IconButton(
                            iconSize: 64,
                            color: Colors.white.withAlpha(200),
                            icon: const Icon(Icons.play_circle_fill),
                            onPressed: () {
                              setState(() {
                                _showPoster = false;
                                controller.play();
                              });
                            },
                          ),

                        // Ses seviyesi
                        Positioned(
                          right: 10,
                          top: 10,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            color: Colors.black54,
                            child: Text(
                              "Ses: %${(controller.value.volume * 100).toInt()}",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Column(
                      children: [
                        // İlerleme çubuğu
                        Slider(
                          value: controller.value.position.inSeconds.toDouble(),
                          min: 0.0,
                          max: controller.value.duration.inSeconds.toDouble(),
                          onChanged: (value) {
                            setState(() {
                              controller.seekTo(
                                Duration(seconds: value.toInt()),
                              );
                            });
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_formatDuration(controller.value.position)),
                            Text(_formatDuration(controller.value.duration)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.skip_previous),
                        onPressed: _currentIndex > 0
                            ? () => _changeVideo(_currentIndex - 1)
                            : null,
                      ),

                      // Geri sar
                      IconButton(
                        icon: const Icon(Icons.replay_10),
                        onPressed: () {
                          final newPos =
                              controller.value.position -
                              const Duration(seconds: 10);
                          controller.seekTo(newPos);
                        },
                      ),

                      // Oynat/Duraklat
                      FloatingActionButton(
                        backgroundColor: const Color.fromARGB(255, 5, 96, 153),
                        onPressed: () {
                          setState(() {
                            if (controller.value.isPlaying) {
                              controller.pause();
                            } else {
                              _showPoster = false;
                              controller.play();
                            }
                          });
                        },
                        child: Icon(
                          controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                        ),
                      ),

                      // İleri sar
                      IconButton(
                        icon: const Icon(Icons.forward_10),
                        onPressed: () {
                          final newPos =
                              controller.value.position +
                              const Duration(seconds: 10);
                          controller.seekTo(newPos);
                        },
                      ),

                      IconButton(
                        icon: const Icon(Icons.skip_next),
                        onPressed: _currentIndex < _playlist.length - 1
                            ? () => _changeVideo(_currentIndex + 1)
                            : null,
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          _isMuted ? Icons.volume_off : Icons.volume_up,
                        ),
                        color: _isMuted ? Colors.red : Colors.grey[800],
                        onPressed: () {
                          setState(() {
                            _isMuted = !_isMuted;
                            controller.setVolume(_isMuted ? 0.0 : 1.0);
                          });
                        },
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        icon: const Icon(Icons.loop),
                        color: _isLooping ? Colors.green : Colors.grey,
                        onPressed: () {
                          setState(() {
                            _isLooping = !_isLooping;
                            controller.setLooping(_isLooping);
                          });
                        },
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        icon: const Icon(Icons.fullscreen),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Scaffold(
                                backgroundColor: Colors.black,
                                body: Center(
                                  child: AspectRatio(
                                    aspectRatio: controller.value.aspectRatio,
                                    child: VideoPlayer(controller),
                                  ),
                                ),
                                floatingActionButton: FloatingActionButton(
                                  mini: true,
                                  child: const Icon(Icons.fullscreen_exit),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}
