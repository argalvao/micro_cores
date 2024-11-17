import 'dart:math';
import 'package:just_audio/just_audio.dart';

class BackgroundMusicManager {
  final List<String> selectedStyles;
  final Map<String, List<String>> songsByStyle = {
  'Infantil': [
    'assets/songs/infantil/A Day to Remember - FiftySounds.mp3',
    'assets/songs/infantil/A Dogs Life - FiftySounds.mp3',
    'assets/songs/infantil/Candy Town.mp3',
    'assets/songs/infantil/Dogs and Cats.mp3',
    'assets/songs/infantil/Flowers in your Hair.mp3',
    'assets/songs/infantil/Friends Forever.mp3',
  ],
  'Calmo': [
    'assets/songs/calmo/At First Sight - FiftySounds.mp3',
    'assets/songs/calmo/Make It Happen.mp3',
    'assets/songs/calmo/Meeting Point.mp3',
    'assets/songs/calmo/Neon Lights.mp3',
    'assets/songs/calmo/They Say.mp3',
  ],
  'Animado': [
    'assets/songs/animado/Endless Night.mp3',
    'assets/songs/animado/High Fidelity.mp3',
    'assets/songs/animado/It Starts Here.mp3',
    'assets/songs/animado/Neon Lights.mp3',
    'assets/songs/animado/Sweet Antidote.mp3',
  ],
  'Instrumental': [
    'assets/songs/instrumental/In Your Hands.mp3',
    'assets/songs/instrumental/liquid-planet.mp3',
    'assets/songs/instrumental/Make It Happen.mp3',
    'assets/songs/instrumental/Meeting Point.mp3',
    'assets/songs/instrumental/Spirit of Fire.mp3',
  ],
};


  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentSong;

  BackgroundMusicManager({required this.selectedStyles});

  Future<void> start() async {
    print('BackgroundMusicManager: Starting music...');
    _playNextSong();
    // Detect when a song finishes and play the next one
    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _playNextSong();
      }
    });
  }

  Future<void> stop() async {
    print('BackgroundMusicManager: Stopping music...');
    await _audioPlayer.stop();
  }

  Future<void> _playNextSong() async {
    final availableSongs = _getAvailableSongs();
    print('Available songs: $availableSongs');

    if (availableSongs.isNotEmpty) {
      final nextSong = availableSongs[Random().nextInt(availableSongs.length)];
      print('Playing next song: $nextSong');

      if (nextSong != _currentSong) {
        _currentSong = nextSong;
        await _audioPlayer.setAsset(nextSong);
        _audioPlayer.play();
      }
    } else {
      print('No songs available to play.');
    }
  }

  List<String> _getAvailableSongs() {
    final songs = selectedStyles
        .expand((style) => (songsByStyle[style] ?? []).cast<String>())
        .toList();
    print('Available songs for styles $selectedStyles: $songs');
    return songs;
  }
}
