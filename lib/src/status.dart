import 'package:flutter/widgets.dart';

import '../theme.dart';
import 'activity_indicator.dart';
import 'icons.dart';

class SliverEmpty extends StatelessWidget {
  const SliverEmpty(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Empty(text),
    );
  }
}

class Empty extends StatelessWidget {
  const Empty(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            CupertinoIcons.collections,
            color: Colors.inactiveGray.resolveFrom(context),
            size: 40,
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: CupertinoTheme.of(context)
                .textTheme
                .detailTextStyle
                .copyWith(fontSize: 15),
          ),
        ],
      ),
    );
  }
}

class SliverLoading extends StatelessWidget {
  const SliverLoading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Loading(text),
    );
  }
}

class Loading extends StatelessWidget {
  const Loading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const CupertinoActivityIndicator(
            radius: 14,
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: CupertinoTheme.of(context)
                .textTheme
                .detailTextStyle
                .copyWith(fontSize: 15),
          ),
        ],
      ),
    );
  }
}
