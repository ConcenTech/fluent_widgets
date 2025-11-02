import 'tag_shape.dart';

/// Internal class to hold dimension values
class TagDimensions {
  final double fontSize;
  final double iconSize;
  final double horizontalPadding;
  final double verticalPadding;
  final double borderRadius;
  final double borderRadiusCircular;
  final double iconSpacing;
  final double iconVerticalPadding;

  const TagDimensions({
    required this.fontSize,
    required this.iconSize,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.borderRadius,
    required this.borderRadiusCircular,
    required this.iconSpacing,
    required this.iconVerticalPadding,
  });

  double radius(TagShape shape) {
    switch (shape) {
      case TagShape.rounded:
        return borderRadius;
      case TagShape.circular:
        return borderRadiusCircular;
    }
  }
}
