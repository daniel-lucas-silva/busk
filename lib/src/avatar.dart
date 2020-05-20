import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'theme/colors.dart';

part 'avatar.render.dart';

enum AvatarSize {
  small,
  normal,
  large,
}

enum AvatarShape {
  circular,
  rounded,
}

class Avatar extends StatelessWidget {
  final AvatarSize size;
  final AvatarShape shape;
  final int badge;
  final Widget child;

  const Avatar({
    Key key,
    this.size,
    this.shape: AvatarShape.circular,
    this.badge,
    this.child,
  }) : super(key: key);

  factory Avatar.letter(
    String letter, {
    AvatarSize size,
    AvatarShape shape: AvatarShape.circular,
    int badge,
  }) =>
      Avatar(
        size: size,
        shape: shape,
        badge: badge,
        child: Center(
          child: Text(
            (letter.length > 1 ? letter.substring(0, 2) : letter).toUpperCase(),
            style: TextStyle(
              fontSize: 17.0,
              height: 1.0,
            ),
          ),
        ),
      );

  factory Avatar.image(
    ImageProvider image, {
    AvatarSize size,
    AvatarShape shape: AvatarShape.circular,
    int badge,
  }) =>
      Avatar(
        size: size,
        shape: shape,
        badge: badge,
        child: Image(
          image: image,
          fit: BoxFit.cover,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Color(0xFF444444),
            shape: shape == AvatarShape.circular
                ? BoxShape.circle
                : BoxShape.rectangle,
            borderRadius:
                shape == AvatarShape.rounded ? BorderRadius.circular(10) : null,
          ),
          child: AspectRatio(child: child, aspectRatio: 1),
        ),
        if (badge != null)
          Positioned(
            right: -4,
            top: -3,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: Colors.systemRed,
                borderRadius: BorderRadius.circular(10),
              ),
              child: DefaultTextStyle(
                style: TextStyle(
                  fontSize: 10,
                  height: 1.1,
                ),
                child: Text(badge > 99 ? "99+" : "$badge"),
              ),
            ),
          ),
      ],
    );
  }
}
