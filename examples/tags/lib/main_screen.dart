import 'package:fluent_tag/fluent_tag.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_color/flutter_color.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    final colors = [
      ('Filled, Dark, ', theme.resources.textFillColorInverse),
      ('Filled, Light', theme.inactiveBackgroundColor),
      ('Outline', theme.inactiveBackgroundColor),
    ];
    return ScaffoldPage(
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: FocusTraversalGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              spacing: 10,
              children: [
                ...colors.map((e) {
                  final color = e.$2;
                  final r = color.r;
                  final g = color.g;
                  final b = color.b;
                  final argb = color.asHexString;
                  return SelectableText('${e.$1} - ($r, $g, $b) $argb');
                }),
                ...TagSize.values.map(
                  (size) => Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 10,

                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${size.name} - Tag'),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 10,
                        children: [
                          ...TagStyle.values.map(
                            (e) => Tag(
                              icon: Icon(FluentIcons.calendar),
                              text: e.name,
                              tagStyle: e,
                              size: size,
                            ),
                          ),
                          ...TagStyle.values.map(
                            (e) => Tag(
                              enabled: false,
                              text: e.name,
                              tagStyle: e,
                              size: size,
                            ),
                          ),
                        ],
                      ),
                      Text('${size.name} - DismissibleTag'),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 10,
                        children: [
                          ...TagStyle.values.map(
                            (e) => DismissibleTag(
                              icon: Icon(FluentIcons.calendar),
                              text: e.name,
                              tagStyle: e,
                              size: size,
                              shape: TagShape.circular,
                              onDismiss: () {},
                            ),
                          ),
                          ...TagStyle.values.map(
                            (e) => DismissibleTag(
                              enabled: false,
                              text: e.name,
                              tagStyle: e,
                              size: size,
                              onDismiss: () {},
                            ),
                          ),
                        ],
                      ),
                      Text('${size.name} - InteractiveTag'),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 10,
                        children: [
                          ...TagStyle.values.map(
                            (e) => InteractiveTag(
                              icon: Icon(FluentIcons.calendar),
                              text: e.name,
                              tagStyle: e,
                              size: size,
                              onPressed: () {},
                            ),
                          ),
                          ...TagStyle.values.map(
                            (e) => InteractiveTag(
                              enabled: false,
                              text: e.name,
                              tagStyle: e,
                              size: size,
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                      Text('${size.name} - DismissibleInteractiveTag'),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 10,
                        children: [
                          ...TagStyle.values.map(
                            (e) => DismissibleInteractiveTag(
                              icon: Icon(FluentIcons.calendar),
                              text: e.name,
                              tagStyle: e,
                              size: size,
                              onPressed: () {},
                              onDismiss: () {},
                            ),
                          ),
                          ...TagStyle.values.map(
                            (e) => DismissibleInteractiveTag(
                              enabled: false,
                              text: e.name,
                              tagStyle: e,
                              size: size,
                              onPressed: () {},
                              onDismiss: () {},
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
