import 'package:busk/busk.dart';
import 'package:dio/dio.dart';

part 'Blogger.g.dart';

@immutable
class BloggerConfig {
  final String id;
  final List<String> categories;
  final int limit;

  const BloggerConfig({
    this.id,
    this.categories: const [],
    this.limit,
  });
}

class BloggerController extends ChangeNotifier {
  final Dio _http;
  final List<String> _defaultPaths;

  Feed feed;
  BloggerResultState state;
  int limit;
  List<String> categories;

  bool hasMore = false;

  // https://www.blogger.com/feeds/[blogID]/posts/default
  BloggerController({
    String blogID,
    this.categories: const [], // /-/Fritz/Laurie
    this.limit: 0, // ?max-results=1
  })  : _defaultPaths = ["feeds", blogID, "posts", "default"],
        _http = new Dio();

//  Entry operator [](String ref) {
//    return entries.containsKey(ref) ? entries[ref] : null;
//  }

  void initState() {
    state = BloggerResultState.none;
  }

  void _changeState(BloggerResultState state) {
    this.state = state;
    notifyListeners();
  }

  Future<void> load({int offset, String query}) async {
    if (state == BloggerResultState.none)
      _changeState(BloggerResultState.waiting);
    else if (query != null)
      _changeState(BloggerResultState.searching);
    else if (offset != null)
      _changeState(BloggerResultState.loadingMore);
    else
      _changeState(BloggerResultState.loading);

    final url = new Uri(
      scheme: "https",
      host: "www.blogger.com",
      pathSegments: [
        ..._defaultPaths,
        if (categories?.isNotEmpty) "-",
        if (categories?.isNotEmpty) ...categories,
      ],
      queryParameters: {
        "alt": "json",
        "max-results": "$limit",
//        "fields": "link,entry(etag,id,image,updated)",
        if (offset != null)
          "start-index": "$offset",
        if (query != null)
          "q": query,
      },
    );

    final response = await _http.get(url.toString());

    if (offset != null) {
      feed.rows.addAll(
        FeedResult.fromJson(response.data).feed.rows,
      );
    } else {
      feed = FeedResult.fromJson(response.data).feed;
    }

    hasMore = !(feed.rows.length < limit);

    if(offset == null && feed.rows.isEmpty) {
      _changeState(BloggerResultState.empty);
    } else {
      _changeState(BloggerResultState.loaded);
    }

    return;
  }
}

enum BloggerResultState {
  none,
  error,
  waiting,
  refreshing,
  loading,
  searching,
  loadingMore,
  loaded,
  empty,
}

@immutable
class BloggerResultSnapshot {
  final BloggerResultState state;
  final bool hasMore;
  final Feed feed;
  final BloggerMethods methods;

  const BloggerResultSnapshot._(
      this.state, this.hasMore, this.feed, this.methods);
}

@immutable
class BloggerMethods {
  final Future<void> Function() load;
  final Future<void> Function(int offset) loadMore;
  final Future<void> Function(String query) search;

  const BloggerMethods._(this.load, this.loadMore, this.search);
}

class BloggerBuilder extends StatefulWidget {
  final BloggerConfig config;
  final Widget Function(BuildContext context, BloggerResultSnapshot snapshot)
      builder;

  const BloggerBuilder({
    Key key,
    @required this.config,
    @required this.builder,
  }) : super(key: key);

  @override
  _BloggerBuilderState createState() => _BloggerBuilderState();
}

class _BloggerBuilderState extends State<BloggerBuilder> with AutomaticKeepAliveClientMixin {
  BloggerController controller;

  @override
  void initState() {
    controller = BloggerController(
      blogID: widget.config.id,
      categories: widget.config.categories,
      limit: widget.config.limit,
    )
      ..initState()
      ..load();
    controller.addListener(_changeStateListener);
    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(_changeStateListener);
    controller.dispose();
    controller = null;
    super.dispose();
  }

  _changeStateListener() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      BloggerResultSnapshot._(
        controller.state,
        controller.hasMore,
        controller.feed,
        BloggerMethods._(
          () => controller.load(),
          (int offset) => controller.load(offset: offset),
          (String query) => controller.load(query: query),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
