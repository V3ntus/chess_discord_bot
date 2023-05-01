import 'package:chesscom_dart/chesscom_dart.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

class PuzzleCommands {
  final ChessAPI chess;
  final IInteractions interactions;

  static SlashCommandBuilder getPuzzle = SlashCommandBuilder(
    "puzzle",
    "Grab a puzzle of the day",
    [
      CommandOptionBuilder(
          CommandOptionType.boolean, "random", "Grab a random puzzle"),
    ],
  );

  PuzzleCommands(this.chess, this.interactions) {
    getPuzzle.registerHandler((event) async {
      await event.acknowledge();
      bool isRandom = false;
      try {
        isRandom = event.getArg("random").value as bool;
      } catch (e) {
        // pass
      }

      final puzzle = await chess.fetchPuzzle(random: isRandom);
      String pgn = puzzle.pgn
          .replaceAll("*", "")
          .substring(puzzle.pgn.indexOf("\n") + 1);
      pgn = pgn.substring(pgn.indexOf("\n") + 1);

      final puzzleEmbed = EmbedBuilder(
        title: "${isRandom ? "Random " : ""}Daily Puzzle",
        imageUrl: puzzle.image,
        description: puzzle.title,
        url: puzzle.url,
        timestamp: puzzle.publishTime,
      )
        ..addField(
          name: "PGN:",
          content: "||$pgn||",
        )
        ..addField(
          name: "FEN:",
          content: "||${puzzle.fen}||",
        );

      await event.respond(MessageBuilder(embeds: [puzzleEmbed]));
    });

    interactions.registerSlashCommand(getPuzzle);
  }
}
