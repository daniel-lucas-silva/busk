import 'package:busk/busk.dart';

import '../common/CategoryAndDate.dart';
import '../common/CommentsAndViews.dart';
import '../common/ProductTile.dart';
import '../common/Blogger.dart';
import 'ListingScreen.dart';
import 'PostScreen.dart';
import 'RegioesScreen.dart';

class HomeTab extends StatefulWidget {
  final double devicePixelRatio;

  const HomeTab({
    Key key,
    this.devicePixelRatio,
  }) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with AutomaticKeepAliveClientMixin {
  PageController _controller;

  Map<String, Future<void> Function()> _callbacks = {};

  bool wantKeepAlive = true;

  @override
  void initState() {
    double viewportFraction = 2.54;

    print(viewportFraction / widget.devicePixelRatio);
    _controller = PageController(
      viewportFraction: viewportFraction / widget.devicePixelRatio,
      keepPage: true,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    final textTheme = theme.textTheme;

    return CupertinoUserInterfaceLevel(
      data: CupertinoUserInterfaceLevelData.base,
      child: SliverScaffold(
        appBar: SliverAppBar(
          largeTitle: Text("Itaperuna"),
          largeTransparent: true,
        ),
        slivers: <Widget>[
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              for (final load in _callbacks.values) {
                await load();
              }
              return;
            },
          ),
          BloggerBuilder(
              config: BloggerConfig(
                id: "8856333549335806928",
                categories: ["Destaque"],
                limit: 6,
              ),
              builder: (context, snapshot) {
                _callbacks["destaque"] = snapshot.methods.load;

                if (snapshot.state == BloggerResultState.waiting)
                  return SliverLoading("Carregando");
                else
                  return SliverToBoxAdapter(
                    child: Container(
                      height: 242,
                      child: PageView.builder(
                        controller: _controller,
                        itemCount: snapshot.feed.rows.length,
                        itemBuilder: (context, index) {
                          final entry = snapshot.feed.rows[index];
                          final heroTag = "${entry.id}_destaque";

                          return FeaturedTile(
                            heroTag: heroTag,
                            image: entry.thumbnail
                                ?.replaceFirst("s72-c", "s360-c")
                                .toImageOrAsset("assets/no-image.png"),
                            category: entry.category
                                .firstWhere((c) => c != "Destaque"),
                            title: Text(entry.title),
                            onTap: () {
                              push(
                                context,
                                PostScreen(entry: entry, heroTag: heroTag),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  );
              }),
          Section(
            header: ListHeader(
              title: Text(
                "Regiões",
                style: textTheme.title2,
              ),
              after: Button(
                child: Text("Ver todas", style: TextStyle(fontSize: 15)),
                minSize: 0,
                onPressed: () => push(context, RegioesScreen()),
                padding: EdgeInsets.zero,
              ),
            ),
            children: <Widget>[
              Cell(
                child: Text("Boa Ventura"),
                onTap: () => push(
                  context,
                  ListingScreen(
                      title: "Boa Ventura", categories: ["Boa-Ventura"]),
                ),
              ),
              Cell(
                child: Text("Raposo"),
                onTap: () => push(
                  context,
                  ListingScreen(title: "Raposo", categories: ["Raposo"]),
                ),
              ),
              Cell(
                child: Text("Varre-Sai"),
                onTap: () => push(
                  context,
                  ListingScreen(title: "Varre-Sai", categories: ["Varre-Sai"]),
                ),
              ),
            ],
          ),

          SliverHeader(
            title: Text(
              "Covid-19",
              style: textTheme.title2,
            ),
            after: Button(
              child: Text("Ver mais", style: TextStyle(fontSize: 15)),
              minSize: 0,
              onPressed: () {
                push(
                  context,
                  ListingScreen(
                    title: "Covid-19",
                    categories: ["covid"],
                  ),
                );
              },
              padding: EdgeInsets.zero,
            ),
          ),
          BloggerBuilder(
              config: BloggerConfig(
                id: "8856333549335806928",
                categories: ["covid"],
                limit: 6,
              ),
              builder: (context, snapshot) {
                _callbacks["covid"] = snapshot.methods.load;

                if (snapshot.state == BloggerResultState.waiting)
                  return SliverLoading("Carregando");
                else
                  return SliverToBoxAdapter(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(left: 14),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            List.generate(snapshot.feed.rows.length, (index) {
                          final entry = snapshot.feed.rows[index];
                          final heroTag = "${entry.id}_covid";

                          return VerticalTile(
                            heroTag: heroTag,
                            image: entry.thumbnail
                                ?.replaceFirst("s72-c", "s360-c")
                                .toImageOrAsset("assets/no-image.png"),
                            title: Text(entry.title),
                            onTap: () {
                              push(
                                context,
                                PostScreen(entry: entry, heroTag: heroTag),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  );
              }),

          SliverHeader(
            title: Text(
              "Recentes",
              style: textTheme.title2,
            ),
            after: Button(
              child: Text("Ver mais", style: TextStyle(fontSize: 15)),
              minSize: 0,
              onPressed: () {
                push(
                  context,
                  ListingScreen(
                    title: "Recentes",
                  ),
                );
              },
              padding: EdgeInsets.zero,
            ),
          ),
          BloggerBuilder(
            config: BloggerConfig(
              id: "8856333549335806928",
              limit: 4,
            ),
            builder: (context, snapshot) {
              _callbacks["recentes"] = snapshot.methods.load;

              if (snapshot.state == BloggerResultState.waiting)
                return SliverLoading("Carregando");
              else
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final entry = snapshot.feed.rows[index];
                        final heroTag = "${entry.id}_recentes";

                        return HorizontalTile(
                          heroTag: heroTag,
                          onTap: () {
                            push(
                              context,
                              PostScreen(entry: entry, heroTag: heroTag),
                            );
                          },
                          image: entry.thumbnail
                              .toImageOrAsset("assets/no-image.png"),
                          header: CategoryAndDate(
                            category: entry.category.first.toUpperCase(),
                            date: entry.published,
                          ),
                          title: Text(entry.title),
                          footer: CommentsAndViews(comments: entry.total),
                        );
                      },
                      childCount: snapshot.feed.rows.length,
                    ),
                  ),
                );
            },
          ),

          SliverHeader(
            title: Text(
              "Acidentes",
              style: textTheme.title2,
            ),
            after: Button(
              child: Text("Ver mais", style: TextStyle(fontSize: 15)),
              minSize: 0,
              onPressed: () {
                push(
                  context,
                  ListingScreen(
                    title: "Acidentes",
                    categories: ["Acidentes"],
                  ),
                );
              },
              padding: EdgeInsets.zero,
            ),
          ),
          BloggerBuilder(
            config: BloggerConfig(
              id: "8856333549335806928",
              categories: ["Acidentes"],
              limit: 2,
            ),
            builder: (context, snapshot) {
              _callbacks["acidentes"] = snapshot.methods.load;

              if (snapshot.state == BloggerResultState.waiting)
                return SliverLoading("Carregando");
              else
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final entry = snapshot.feed.rows[index];
                        final heroTag = "${entry.id}_acidentes";

                        return HorizontalTile(
                          heroTag: heroTag,
                          onTap: () {
                            push(
                              context,
                              PostScreen(entry: entry, heroTag: heroTag),
                            );
                          },
                          size: TileSize.large,
                          image: entry.thumbnail
                              ?.replaceFirst("s72-c", "s360-c")
                              .toImageOrAsset("assets/no-image.png"),
                          header: CategoryAndDate(
                            category: "ACIDENTE",
                            date: entry.published,
                          ),
                          title: Text(entry.title),
                          footer: CommentsAndViews(comments: entry.total),
                        );
                      },
                      childCount: snapshot.feed.rows.length,
                    ),
                  ),
                );
            },
          ),

          SliverHeader(
            title: Text(
              "Saúde",
              style: textTheme.title2,
            ),
            after: Button(
              child: Text("Ver mais", style: TextStyle(fontSize: 15)),
              minSize: 0,
              onPressed: () {
                push(
                  context,
                  ListingScreen(
                    title: "Saúde",
                    categories: ["Saude"],
                  ),
                );
              },
              padding: EdgeInsets.zero,
            ),
          ),
          BloggerBuilder(
            config: BloggerConfig(
              id: "8856333549335806928",
              categories: ["Saude"],
              limit: 4,
            ),
            builder: (context, snapshot) {
              _callbacks["saude"] = snapshot.methods.load;

              if (snapshot.state == BloggerResultState.waiting)
                return SliverLoading("Carregando");
              else
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final entry = snapshot.feed.rows[index];

                        final heroTag = "${entry.id}_saude";

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
                            category: "Saúde".toUpperCase(),
                            date: entry.published,
                          ),
                          title: Text(entry.title),
                          footer: CommentsAndViews(comments: entry.total),
                        );
                      },
                      childCount: snapshot.feed.rows.length,
                    ),
                  ),
                );
            },
          ),
//          SliverPadding(
//            padding: const EdgeInsets.symmetric(horizontal: 16.0),
//            sliver: SliverList(
//              delegate: SliverChildBuilderDelegate(
//                    (context, index) {
//                  return ProductTile(
//                    title: Text("Splitter Critters"),
//                    description: Text("Split words and save critters"),
//                    trailing: Column(
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      children: <Widget>[
//                        TestButton(
//                          child: Text("OBTER"),
//                          onPressed: () {},
//                        ),
//                      ],
//                    ),
//                  );
//                },
//                childCount: 4,
//              ),
//            ),
//          ),
        ],
      ),
    );
  }
}
