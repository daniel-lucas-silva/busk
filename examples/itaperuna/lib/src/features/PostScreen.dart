import 'package:busk/busk.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:itaperuna/src/common/Blogger.dart';
import 'package:itaperuna/src/common/CategoryAndDate.dart';

class PostScreen extends StatelessWidget {
  final Entry entry;
  final Object heroTag;

  const PostScreen({
    Key key,
    this.entry,
    this.heroTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    final textTheme = theme.textTheme;

    final thumbContainer = AspectRatio(
      aspectRatio: 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: entry.thumbnail
                ?.replaceFirst("s72-c", "s360-c")
                .toImageOrAsset("assets/no-image.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );

    return SliverScaffold(
      appBar: SliverAppBar(
        previousPageTitle: "Voltar",
        middle: Offstage(),
      ),
      slivers: <Widget>[
        if (entry.thumbnail != null)
          SliverToBoxAdapter(
            child: heroTag != null
                ? Hero(
                    transitionOnUserGestures: true,
                    tag: heroTag,
                    child: thumbContainer,
                  )
                : thumbContainer,
          ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: DefaultTextStyle(
              style: textTheme.footnote,
              overflow: TextOverflow.visible,
              maxLines: 1,
              child: CategoryAndDate(
                category: entry.category.last,
                date: entry.published,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Text(
              entry.title,
              style: textTheme.title2,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              children: <Widget>[
                Container(
                  height: 32,
                  width: 32,
                  margin: EdgeInsets.only(right: 14.0),
                  child: Avatar.image(
                    "https:${entry.author.image}"
                        .toImageOrAsset("assets/no-image.png"),
                  ),
                ),
                Text(
                  entry.author.name,
                  style: textTheme.footnote.copyWith(
                    color: Colors.label.resolveFrom(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Html(
            data: entry.content,
            style: {
              "html": Style(
                color: Colors.label.resolveFrom(context),
                fontFamily: textTheme.body.fontFamily,
                fontSize: FontSize(textTheme.body.fontSize),
                fontWeight: textTheme.body.fontWeight,
              ),
              "h1": Style(
                color: Colors.label.resolveFrom(context),
                fontFamily: textTheme.title1.fontFamily,
                fontSize: FontSize(textTheme.title1.fontSize),
                fontWeight: textTheme.title1.fontWeight,
              ),
              "h2": Style(
                color: Colors.label.resolveFrom(context),
                fontFamily: textTheme.title2.fontFamily,
                fontSize: FontSize(textTheme.title2.fontSize),
                fontWeight: textTheme.title2.fontWeight,
              ),
              "h3": Style(
                color: Colors.label.resolveFrom(context),
                fontFamily: textTheme.title3.fontFamily,
                fontSize: FontSize(textTheme.title3.fontSize),
                fontWeight: textTheme.title3.fontWeight,
              ),
            },
            onLinkTap: (url) {
              // open url in a webview
            },
            onImageTap: (src) {
              // Display the image in large form.
            },
          ),
        ),
      ],
    );
  }
}
