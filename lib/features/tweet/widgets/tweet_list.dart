import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/common/common.dart';
import 'package:x_clone/constants/appwrite_constants.dart';
import 'package:x_clone/features/tweet/controller/tweet_controller.dart';
import 'package:x_clone/features/tweet/widgets/tweet_card.dart';
import 'package:x_clone/models/tweet_model.dart';

class TweetList extends ConsumerWidget {
  const TweetList({super.key});
  static int buildValue = 0;
  static buildCount() {
    buildValue++;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isLoading = false;
    buildCount();
    debugPrint("Tweet List : ${buildValue.toString()}");

    return ref.watch(getTweetsProvider).when(
          data: (tweets) {
            return ref.watch(getLatestTweetProvider).when(
                  data: (data) {
                    bool isTweetAlreadyExist = false;
                    final latestTweet = Tweet.fromMap(data.payload);
                    for (Tweet tweetModel in tweets) {
                      if (tweetModel.id == latestTweet.id) {
                        isTweetAlreadyExist = true;
                        break;
                      }
                    }
                    if (!isTweetAlreadyExist &&
                        data.events.contains(
                          'databases.*.collections.${AppwriteConstants.tweetsCollection}.documents.*.create',
                        )) {
                      tweets.insert(0, Tweet.fromMap(data.payload));
                    } else if (data.events.contains(
                      'databases.*.collections.${AppwriteConstants.tweetsCollection}.documents.*.update',
                    )) {
                      // get id of original tweet
                      final startingPoint =
                          data.events[0].lastIndexOf('documents.');
                      final endPoint = data.events[0].lastIndexOf('.update');
                      final tweetId = data.events[0]
                          .substring(startingPoint + 10, endPoint);

                      var tweet = tweets
                          .where((element) => element.id == tweetId)
                          .first;

                      final tweetIndex = tweets.indexOf(tweet);
                      tweets.removeWhere((element) => element.id == tweetId);

                      tweet = Tweet.fromMap(data.payload);
                      tweets.insert(tweetIndex, tweet);
                    }

                    return ListView.builder(
                      itemCount: tweets.length,
                      itemBuilder: (BuildContext context, int index) {
                        final tweet = tweets[index];
                        return TweetCard(tweet: tweet);
                      },
                    );
                  },
                  error: (error, stackTrace) => ErrorText(
                    error: error.toString(),
                  ),
                  loading: () {
                    return ListView.builder(
                      itemCount: tweets.length,
                      itemBuilder: (BuildContext context, int index) {
                        final tweet = tweets[index];
                        return TweetCard(tweet: tweet);
                      },
                    );
                  },
                );
          },
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}
