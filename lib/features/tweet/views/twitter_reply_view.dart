import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/common/common.dart';
import 'package:x_clone/constants/appwrite_constants.dart';
import 'package:x_clone/features/tweet/controller/tweet_controller.dart';
import 'package:x_clone/features/tweet/widgets/tweet_card.dart';
import 'package:x_clone/models/tweet_model.dart';
import 'package:x_clone/theme/theme.dart';

class TwitterReplyScreen extends ConsumerStatefulWidget {
  final Tweet tweet;
  const TwitterReplyScreen({
    super.key,
    required this.tweet,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TwiterReplyScreenState();
}

class _TwiterReplyScreenState extends ConsumerState<TwitterReplyScreen> {
  TextEditingController _submitController = TextEditingController();

  @override
  void dispose() {
    _submitController;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tweet'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TweetCard(tweet: widget.tweet),
          ref.watch(getRepliesToTweetsProvider(widget.tweet)).when(
                data: (tweets) {
                  return ref.watch(getLatestTweetProvider).when(
                        data: (data) {
                          final latestTweet = Tweet.fromMap(data.payload);

                          bool isTweetAlreadyPresent = false;
                          for (final tweetModel in tweets) {
                            if (tweetModel.id == latestTweet.id) {
                              isTweetAlreadyPresent = true;
                              break;
                            }
                          }

                          if (!isTweetAlreadyPresent &&
                              latestTweet.repliedTo == widget.tweet.id) {
                            if (data.events.contains(
                              'databases.*.collections.${AppwriteConstants.tweetsCollection}.documents.*.create',
                            )) {
                              tweets.insert(0, Tweet.fromMap(data.payload));
                            } else if (data.events.contains(
                              'databases.*.collections.${AppwriteConstants.tweetsCollection}.documents.*.update',
                            )) {
                              // get id of original tweet
                              final startingPoint =
                                  data.events[0].lastIndexOf('documents.');
                              final endPoint =
                                  data.events[0].lastIndexOf('.update');
                              final tweetId = data.events[0]
                                  .substring(startingPoint + 10, endPoint);

                              var tweet = tweets
                                  .where((element) => element.id == tweetId)
                                  .first;

                              final tweetIndex = tweets.indexOf(tweet);
                              tweets.removeWhere(
                                  (element) => element.id == tweetId);

                              tweet = Tweet.fromMap(data.payload);
                              tweets.insert(tweetIndex, tweet);
                            }
                          }

                          return Expanded(
                            child: ListView.builder(
                              itemCount: tweets.length,
                              itemBuilder: (BuildContext context, int index) {
                                final tweet = tweets[index];
                                return TweetCard(tweet: tweet);
                              },
                            ),
                          );
                        },
                        error: (error, stackTrace) => ErrorText(
                          error: error.toString(),
                        ),
                        loading: () {
                          return Expanded(
                            child: ListView.builder(
                              itemCount: tweets.length,
                              itemBuilder: (BuildContext context, int index) {
                                final tweet = tweets[index];
                                return TweetCard(tweet: tweet);
                              },
                            ),
                          );
                        },
                      );
                },
                error: (error, stackTrace) => ErrorText(
                  error: error.toString(),
                ),
                loading: () => const Loader(),
              ),
          TextField(
            controller: _submitController,
            onSubmitted: (value) {
              ref.read(tweetControllerProvider.notifier).shareTweet(
                    replyingTo: widget.tweet.id,
                    images: [],
                    text: _submitController.text,
                    context: context,
                    repliedTo: widget.tweet.uid,
                    repliedToUserId: widget.tweet.uid,
                  );
              _submitController.text = '';
            },
            decoration: InputDecoration(
              suffixIcon: InkWell(
                onTap: () {
                  ref.read(tweetControllerProvider.notifier).shareTweet(
                    images: [],
                    text: _submitController.text,
                    context: context,
                    repliedTo: widget.tweet.id,
                    repliedToUserId: widget.tweet.uid,
                    replyingTo: widget.tweet.uid,
                  );
                  _submitController.text = '';
                  FocusScope.of(context).unfocus();
                },
                child: const Icon(
                  Icons.send_rounded,
                  color: Pallete.blueColor,
                ),
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                borderSide: BorderSide(color: Pallete.blueColor),
              ),
              hintText: 'Tweet your reply',
              contentPadding: const EdgeInsets.all(20),
            ),
          ),
        ],
      ),
    );
  }
}
