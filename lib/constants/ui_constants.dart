import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:x_clone/features/explore/views/explore_view.dart';
import 'package:x_clone/features/notifications/views/notification_view.dart';
import 'package:x_clone/features/tweet/widgets/tweet_list.dart';
import 'package:x_clone/theme/pallete.dart';
import './assets_constants.dart';

class UIConstants {
  static AppBar appBar() {
    return AppBar(
      title: SvgPicture.asset(
        AssetsConstants.x,
        height: 30,
        color: Pallete.whiteColor,
      ),
      centerTitle: true,
    );
  }

  static const List<Widget> bottomTabBarPages = [
    TweetList(),
    ExploreView(),
    NotificationView(),
  ];
}
