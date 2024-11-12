// lib/services/spotify_service.dart

import 'package:spotify_sdk/spotify_sdk.dart';
import '../models/config.dart';

class SpotifyService {
  static final String clientId = 'YOUR_CLIENT_ID';
  static final String redirectUri = 'micro_cores://callback';

  // Conectar ao Spotify
  static Future<void> connectToSpotify() async {
    try {
      await SpotifySdk.connectToSpotifyRemote(
        clientId: clientId,
        redirectUrl: redirectUri,
      );
      print("Conectado ao Spotify com sucesso");
    } catch (e) {
      print('Erro ao conectar ao Spotify: $e');
    }
  }

  // Reproduzir música com base nos estilos salvos em Configuracoes
  static Future<void> playMusicFromConfig(Configuracoes config) async {
    if (config.estilosMusicais.isNotEmpty) {
      String estilo = config.estilosMusicais[0].toLowerCase();
      
      String playlistUri = _getPlaylistUriForStyle(estilo);
      
      if (playlistUri.isNotEmpty) {
        try {
          await SpotifySdk.play(spotifyUri: playlistUri);
          print("Reproduzindo música para o estilo $estilo");
        } catch (e) {
          print('Erro ao iniciar reprodução: $e');
        }
      } else {
        print('Nenhuma playlist encontrada para o estilo $estilo');
      }
    }
  }

  // Função para mapear estilos musicais a playlists do Spotify
  static String _getPlaylistUriForStyle(String estilo) {
    // Mapeamento de estilos para playlists
    final Map<String, String> playlistMap = {
      'infantil': 'spotify:playlist:YOUR_PLAYLIST_ID_1',
      'calmo': 'spotify:playlist:YOUR_PLAYLIST_ID_2',
      'animado': 'spotify:playlist:YOUR_PLAYLIST_ID_3',
      'instrumental': 'spotify:playlist:YOUR_PLAYLIST_ID_4',
    };

    return playlistMap[estilo] ?? '';
  }
}
