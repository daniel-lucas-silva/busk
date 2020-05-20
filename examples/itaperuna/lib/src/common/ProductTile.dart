import 'package:busk/busk.dart';

enum TileSize {
  small,
  normal,
  large,
}

class HorizontalTile extends StatelessWidget {
  final TileSize size;
  final ImageProvider image;
  final Widget header;
  final Widget title;
  final Widget footer;
  final Object heroTag;
  final VoidCallback onTap;

  const HorizontalTile({
    Key key,
    this.size: TileSize.normal,
    this.image,
    this.header,
    @required this.title,
    this.heroTag,
    this.footer,
    this.onTap,
  }) : super(key: key);

  double get radius {
    switch (size) {
      case TileSize.small:
        return 50;
      case TileSize.large:
        return 80;
      default:
        return 64;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    final textTheme = theme.textTheme;

    final thumbContainer = Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.tertiarySystemGroupedBackground.darkColor,
        border: Border.all(
          color: Colors.inactiveGray.resolveFrom(context),
          width: 0.3,
        ),
        image: image == null
            ? null
            : DecorationImage(
                image: image,
                fit: BoxFit.cover,
              ),
      ),
    );

    return RawButton(
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.only(top: 10.0, bottom: 10, right: 14.0),
        margin: const EdgeInsets.only(left: 14.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width:
                  kDividerThickness / MediaQuery.of(context).devicePixelRatio,
              color: Colors.divider.resolveFrom(context),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (heroTag != null)
              Hero(
                transitionOnUserGestures: true,
                tag: heroTag,
                child: thumbContainer,
              )
            else
              thumbContainer,
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (header != null)
                    DefaultTextStyle(
                      style: textTheme.footnote,
                      overflow: TextOverflow.visible,
                      maxLines: 1,
                      child: header,
                    ),
                  DefaultTextStyle(
                    child: title,
                    maxLines: 3,
                    overflow: TextOverflow.visible,
                    style: textTheme.subhead,
                  ),
                  SizedBox(height: 2),
                  if (footer != null)
                    DefaultTextStyle(
                      style: textTheme.caption2,
                      overflow: TextOverflow.visible,
                      maxLines: 1,
                      child: footer,
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VerticalTile extends StatelessWidget {
  final VoidCallback onTap;
  final ImageProvider image;
  final Widget title;
  final Object heroTag;

  const VerticalTile({
    Key key,
    this.onTap,
    @required this.image,
    @required this.title,
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
          borderRadius: BorderRadius.circular(5),
          color: Colors.tertiarySystemGroupedBackground.darkColor,
          image: image == null
              ? null
              : DecorationImage(
                  image: image,
                  fit: BoxFit.cover,
                ),
          border: Border.all(
            color: Colors.inactiveGray.resolveFrom(context),
            width: 0.3,
          ),
        ),
      ),
    );

    return Container(
      width: (MediaQuery.of(context).size.width / 2) - 14,
      padding: EdgeInsets.only(right: 14),
      child: RawButton(
        onPressed: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (heroTag != null)
              Hero(
                transitionOnUserGestures: true,
                tag: heroTag,
                child: thumbContainer,
              )
            else
              thumbContainer,
            SizedBox(height: 4),
            DefaultTextStyle(
              child: title,
              style: textTheme.callout,
            ),
          ],
        ),
      ),
    );
  }
}

class FeaturedTile extends StatelessWidget {
  final VoidCallback onTap;
  final ImageProvider image;
  final String category;
  final Object heroTag;
  final Widget title;
  final Widget subtitle;

  const FeaturedTile({
    Key key,
    this.onTap,
    this.image,
    this.category,
    this.heroTag,
    @required this.title,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    final textTheme = theme.textTheme;

    final thumbContainer = Container(
                decoration: BoxDecoration(
                  color: Colors.inactiveGray,
                  borderRadius: BorderRadius.circular(5),
                  image: image == null
                      ? null
                      : DecorationImage(
                          image: image,
                          fit: BoxFit.cover,
                        ),
                ),
              );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: RawButton(
        onPressed: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (category != null)
              Text(
                category.toUpperCase(),
                style: textTheme.caption2.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
            if (category != null) SizedBox(height: 2),
            DefaultTextStyle(
              child: title,
              style: textTheme.title2.copyWith(
                height: 1.2,
                fontWeight: FontWeight.w400,
              ),
              maxLines: subtitle != null ? 1 : 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (subtitle != null)
              DefaultTextStyle(
                child: subtitle,
                style: textTheme.title2.copyWith(
                  color: Colors.secondaryLabel.resolveFrom(context),
                  fontWeight: FontWeight.w400,
                ),
              ),
            SizedBox(height: 8),
            Expanded(
              child: heroTag != null
                ? Hero(
                    transitionOnUserGestures: true,
                    tag: heroTag,
                    child: thumbContainer,
                  )
                : thumbContainer,
            ),
          ],
        ),
      ),
    );
  }
}
