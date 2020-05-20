import 'package:busk/busk.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:itaperuna/src/common/CategoryAndDate.dart';
import 'package:itaperuna/src/common/CommentsAndViews.dart';
import 'package:itaperuna/src/common/ProductTile.dart';

import '../common/Blogger.dart';
import 'PostScreen.dart';

class ListingScreen extends StatefulWidget {
  final String title;
  final String previousPageTitle;
  final List<String> categories;

  const ListingScreen({
    Key key,
    this.previousPageTitle,
    @required this.title,
    this.categories: const [],
  }) : super(key: key);

  @override
  _ListingScreenState createState() => _ListingScreenState();
}

class _ListingScreenState extends State<ListingScreen> {
  @override
  Widget build(BuildContext context) {
    return BloggerBuilder(
      config: BloggerConfig(
        id: "8856333549335806928",
        categories: widget.categories,
        limit: 30,
      ),
      builder: (context, snapshot) {
        print(snapshot.state);

        return NotificationListener<ScrollNotification>(
          onNotification: (n) {
            if (n.metrics.pixels >= (n.metrics.maxScrollExtent - 200)) {
              if (snapshot.hasMore &&
                  snapshot.state != BloggerResultState.loadingMore) {
                snapshot.methods
                    .loadMore(snapshot.feed.offset + snapshot.feed.size);
              }
            }
            return;
          },
          child: SliverScaffold(
            appBar: SliverAppBar(
              previousPageTitle: widget.previousPageTitle ?? "Itaperuna",
              largeTitle: Text(widget.title),
            ),
            slivers: <Widget>[
              CupertinoSliverRefreshControl(
                onRefresh: () async {
                  return snapshot.methods.load();
                },
              ),
              if (snapshot.state == BloggerResultState.waiting)
                SliverLoading("Carregando...")
              else if (snapshot.state == BloggerResultState.empty)
                SliverEmpty("Não há notícias.")
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14.0,
                    vertical: 5.0,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final entry = snapshot.feed.rows[index];

                        final heroTag = "${entry.id}_listing";

                        return HorizontalTile(
                          heroTag: heroTag,
                          onTap: () {
                            push(
                              context,
                              PostScreen(entry: entry, heroTag: heroTag),
                            );
                          },
                          image: entry.thumbnail
                              ?.replaceFirst("s72-c", "s360-c")
                              .toImageOrAsset("assets/no-image.png"),
                          header: CategoryAndDate(
//                        category: "SPORT",
                            date: entry.published,
                          ),
                          title: Text(entry.title),
                          footer: CommentsAndViews(
                            comments: entry.total,
                          ),
                        );
                      },
                      childCount: snapshot.feed.rows.length,
                    ),
                  ),
                ),
              if (snapshot.state == BloggerResultState.loadingMore)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Center(
                      child: CupertinoActivityIndicator(),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
