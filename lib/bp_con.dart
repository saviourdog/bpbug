import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

bpCon(String url, {cache}) => BetterPlayerController(
    BetterPlayerConfiguration(
      placeholder: Center(
        child: CircularProgressIndicator(),
      ),
      // showPlaceholderUntilPlay: false,
      looping: true,
      fit: BoxFit.cover,
      // controlsConfiguration: BetterPlayerControlsConfiguration(
      //   showControlsOnInitialize: false,
      //   customControlsBuilder: (con) => Stack(
      //     children: [
      //       Positioned(right: 10, bottom: 10, child: PlayBtn(con)),
      //     ],
      //   ),
      //   playerTheme: BetterPlayerTheme.custom,
      // ),
    ),
    betterPlayerDataSource: url.startsWith('http')
        ? BetterPlayerDataSource(BetterPlayerDataSourceType.network, url,
            cacheConfiguration: BetterPlayerCacheConfiguration(useCache: cache??true))
        : BetterPlayerDataSource(
            BetterPlayerDataSourceType.file,
            url,
          ));
