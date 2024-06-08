import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/apis/tweet_api.dart';
import 'package:x_clone/core/core.dart';
import 'package:x_clone/features/auth/controller/auth_controller.dart';
import 'package:x_clone/models/tweet_model.dart';

final tweetControllerProvider = StateNotifierProvider((ref) {
  return TweetController(
    ref: ref,
    tweetAPI: ref.watch(tweetAPIProvider),
  );
});

class TweetController extends StateNotifier<bool> {
  final TweetAPI _tweetAPI;
  final Ref _ref;
  TweetController({
    required Ref ref,
    required TweetAPI tweetAPI,
  })  : _ref = ref,
        _tweetAPI = tweetAPI,
        super(false);

  void shareTweet(
      {required String text,
      required List<File> images,
      required BuildContext context}) {
    if (text.isEmpty) {
      showSnackBar(context, "Please enter the text");
    }
    if (images.isEmpty) {
      _shareTextTweet(text: text, context: context);
    } else {
      _shareImageTweet(text: text, images: images, context: context);
    }
  }

  void _shareImageTweet(
      {required String text,
      required List<File> images,
      required BuildContext context}) {}

  void _shareTextTweet({
    required String text,
    required BuildContext context,
  }) async {
    state = true;
    final hashtags = _getHashtagsFromText(text);
    String link = _getLinkFromText(text);
    final user = _ref.read(currentUserDetailsProvider).value!;
    Tweet tweet = Tweet(
      text: text,
      hashtags: hashtags,
      link: link,
      imageLinks: const [],
      uid: user.uid,
      tweetType: TweetType.text,
      tweetedAt: DateTime.now(),
      likes: const [],
      commentIds: const [],
      id: '',
      reshareCount: 0,
    );

    final res = await _tweetAPI.shareTweet(tweet);
    res.fold((l) => showSnackBar(context, l.message), (r) {});
    state = false;
  }

  String _getLinkFromText(String text) {
    String link = '';
    List<String> wordsInSentence = text.split(' ');
    for (String word in wordsInSentence) {
      if (word.startsWith('https://') || word.startsWith('www.')) {
        link = word;
      }
    }
    return link;
  }

  List<String> _getHashtagsFromText(String text) {
    List<String> hashtags = [];
    List<String> wordsInSentence = text.split(' ');
    for (String word in wordsInSentence) {
      if (word.startsWith('#')) {
        hashtags.add(word);
      }
    }
    return hashtags;
  }
}
