import 'package:chess_discord_bot/profile.dart';
import 'package:chess_discord_bot/puzzle.dart';
import 'package:chesscom_dart/chesscom_dart.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

import 'dart:io' show Platform;

void main() async {
  final chess = ChessFactory.createClient(logLevel: Level.ALL);
  final bot = NyxxFactory.createNyxxWebsocket(
      Platform.environment["TOKEN"]!, GatewayIntents.allUnprivileged)
    ..registerPlugin(Logging(logLevel: Level.FINE))
    ..registerPlugin(CliIntegration())
    ..registerPlugin(IgnoreExceptions());
  final interactions = IInteractions.create(WebsocketInteractionBackend(bot));

  final pingCmd = SlashCommandBuilder("ping", "Ping pong!", [])
    ..registerHandler((event) async {
      await event.respond(MessageBuilder.content("Pong!"));
    });

  PuzzleCommands(chess, interactions);
  ProfileCommands(chess, interactions);

  interactions
    ..registerSlashCommand(pingCmd)
    ..syncOnReady();

  bot.onReady.listen((event) {
    print("Bot connected");
  });

  bot.connect();
}
