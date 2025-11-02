import 'tag_dimensions.dart';

/// Size variants for the Tag component
enum TagSize {
  /// Small size for compact layouts
  small(_xSmallDimensions),

  /// Medium size (default)
  medium(_smallDimensions),

  /// Large size for emphasis
  large(_mediumDimensions);

  const TagSize(this.dimensions);

  final TagDimensions dimensions;
}

const borderRadiusSmall = 2.0;
const borderRadiusMedium = 4.0;
const borderRadiusLarge = 6.0;
const borderRadiusExtraLarge = 8.0;
const borderRadiusCircular = 1000.0;

const _xSmallDimensions = TagDimensions(
  fontSize: 10.0,
  iconSize: 9.0,
  horizontalPadding: 8.0,
  verticalPadding: 4.0,
  borderRadius: borderRadiusMedium,
  borderRadiusCircular: borderRadiusCircular,
  iconSpacing: 4.0,
  iconVerticalPadding: 5.5,
);

const _smallDimensions = TagDimensions(
  fontSize: 12.0,
  iconSize: 11.0,
  horizontalPadding: 10.0,
  verticalPadding: 6.0,
  borderRadius: borderRadiusMedium,
  borderRadiusCircular: borderRadiusCircular,
  iconSpacing: 6.0,
  iconVerticalPadding: 7.5,
);

const _mediumDimensions = TagDimensions(
  fontSize: 14.0,
  iconSize: 13.0,
  horizontalPadding: 12.0,
  verticalPadding: 8.0,
  borderRadius: borderRadiusMedium,
  borderRadiusCircular: borderRadiusCircular,
  iconSpacing: 8.0,
  iconVerticalPadding: 9.5,
);
