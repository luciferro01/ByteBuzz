import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:x_clone/constants/constants.dart';
import 'package:x_clone/features/tweet/views/tweet_view.dart';
import 'package:x_clone/theme/theme.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _page = 0;
  final appBar = UIConstants.appBar();

  void onPageChange(int index) {
    setState(() {
      _page = index;
    });
  }

  onCreateTweet() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateTweetScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _page == 0 ? appBar : null,
      body: Padding(
        padding: const EdgeInsets.all(8.0).copyWith(bottom: 0),
        child: IndexedStack(
          index: _page,
          children: UIConstants.bottomTabBarPages,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onCreateTweet,
        child: const Icon(
          Icons.add,
          color: Pallete.whiteColor,
          size: 28,
        ),
      ),
      // drawer: const SideDrawer(),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _page,
        onTap: onPageChange,
        backgroundColor: Pallete.backgroundColor,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
                _page == 0
                    ? AssetsConstants.homeFilledIcon
                    : AssetsConstants.homeOutlinedIcon,
                theme: const SvgTheme(currentColor: Pallete.whiteColor)
                // color: Pallete.whiteColor,
                ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(AssetsConstants.searchIcon,
                theme: const SvgTheme(currentColor: Pallete.whiteColor)
                // color: Pallete.whiteColor,
                ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
                _page == 2
                    ? AssetsConstants.notifFilledIcon
                    : AssetsConstants.notifOutlinedIcon,
                // color: Pallete.whiteColor,
                theme: const SvgTheme(currentColor: Pallete.whiteColor)),
          ),
        ],
      ),
    );
  }
}
