import 'package:chesscom_dart/chesscom_dart.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

class ProfileCommands {
  final ChessAPI chess;
  final IInteractions interactions;

  ProfileCommands(this.chess, this.interactions) {
    SlashCommandBuilder getProfile = SlashCommandBuilder(
      "profile",
      "Get a Chess.com profile",
      [
        CommandOptionBuilder(
          CommandOptionType.subCommand,
          "fetch",
          "Fetch a Chess.com profile",
          options: [
            CommandOptionBuilder(
              CommandOptionType.string,
              "username",
              "The username to search for",
              required: true,
            ),
          ],
        )..registerHandler((event) async {
          await event.acknowledge();

          final profile = await chess.fetchProfile(event.getArg("username").value);

          final embed = EmbedBuilder(
            author: EmbedAuthorBuilder(
              iconUrl: profile.avatar,
              name: profile.username,
              url: profile.url,
            ),
            title: profile.name,
          );

          embed.addField(
            name: "Followers:",
            content: profile.followers.toString(),
            inline: true,
          );
          embed.addField(
            name: "Country:",
            content: profile.country,
            inline: true,
          );
          embed.addField(
            name: "Location:",
            content: profile.location,
            inline: true,
          );
          embed.addField(
            name: "Last Online:",
            content: profile.lastOnline.toLocal().toString(),
            inline: true,
          );
          embed.addField(
            name: "Joined:",
            content: profile.joined.toLocal().toString(),
            inline: true,
          );
          embed.addField(
            name: "Status:",
            content: profile.status,
            inline: true,
          );
          event.respond(MessageBuilder(embeds: [embed]));
        }),
        CommandOptionBuilder(
          CommandOptionType.subCommand,
          "stats",
          "Get the stats of a Chess.com profile",
          options: [
            CommandOptionBuilder(
              CommandOptionType.string,
              "username",
              "The username to search for",
              required: true,
            ),
          ],
        )..registerHandler((event) async {
          await event.respond(MessageBuilder(content: "Subcommand"));
        }),
      ],
    );

    interactions.registerSlashCommand(getProfile);
  }
}
