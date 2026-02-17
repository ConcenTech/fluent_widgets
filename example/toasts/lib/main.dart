import 'package:fluent_ui/fluent_ui.dart';
import 'package:fluent_widgets/fluent_widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'Fluent Toast Examples',
      theme: FluentThemeData(),
      darkTheme: FluentThemeData.dark(),
      themeMode: ThemeMode.system,
      home: const ToasterConfiguration(),
    );
  }
}

class ToasterConfiguration extends StatefulWidget {
  const ToasterConfiguration({super.key});

  @override
  State<ToasterConfiguration> createState() => _ToasterConfigurationState();
}

class _ToasterConfigurationState extends State<ToasterConfiguration> {
  ToastPosition _position = ToastPosition.bottomEnd;

  void _setPosition(ToastPosition position) {
    setState(() {
      _position = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Toaster(
      position: _position,
      child: HomePage(onPositionChanged: _setPosition),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.onPositionChanged});

  final void Function(ToastPosition position) onPositionChanged;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // String? _updatableToastId;

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: const PageHeader(title: Text('Fluent Toast - Feature Demo')),
      content: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection('Toast Intents', [
              _buildButton(
                'Info Toast',
                () => _showToast(
                  Toast(
                    title: 'Information',
                    content: const Text('This is an informational message'),
                    intent: ToastIntent.info,
                  ),
                ),
              ),
              _buildButton(
                'Success Toast',
                () => _showToast(
                  Toast(
                    title: 'Success!',
                    content: const Text('Operation completed successfully'),
                    intent: ToastIntent.success,
                  ),
                ),
              ),
              _buildButton(
                'Warning Toast',
                () => _showToast(
                  Toast(
                    title: 'Warning',
                    content: const Text('Please review before proceeding'),
                    intent: ToastIntent.warning,
                  ),
                ),
              ),
              _buildButton(
                'Error Toast',
                () => _showToast(
                  Toast(
                    title: 'Error',
                    content: const Text('Something went wrong'),
                    intent: ToastIntent.error,
                  ),
                ),
              ),
            ]),
            _buildSection('Toast Content Variations', [
              _buildButton(
                'Title Only',
                () => _showToast(
                  Toast(title: 'Simple notification', intent: ToastIntent.info),
                ),
              ),
              _buildButton(
                'With Content',
                () => _showToast(
                  Toast(
                    title: 'Detailed notification',
                    content: const Text(
                      'This toast includes both a title and detailed content message.',
                    ),
                    intent: ToastIntent.info,
                  ),
                ),
              ),
              _buildButton(
                'Long Content',
                () => _showToast(
                  Toast(
                    title: 'Long message',
                    content: const Text(
                      'This is a very long content message that demonstrates '
                      'how the toast handles multi-line text and wraps it '
                      'properly within the toast boundaries.',
                    ),
                    intent: ToastIntent.info,
                  ),
                ),
              ),
            ]),
            _buildSection('Toast Actions', [
              _buildButton(
                'With Trailing Button',
                () => _showToast(
                  Toast(
                    title: 'File uploaded',
                    content: const Text('Your file has been uploaded'),
                    intent: ToastIntent.success,
                    trailing: Button(
                      child: const Text('View'),
                      onPressed: () {
                        _showToast(
                          Toast(
                            title: 'Action clicked',
                            intent: ToastIntent.info,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              _buildButton(
                'With Action & Custom Icon',
                () => _showToast(
                  Toast(
                    title: 'Download complete',
                    content: const Text('3 files downloaded'),
                    intent: ToastIntent.success,
                    icon: const Icon(FluentIcons.download),
                    trailing: Button(
                      child: const Text('Open'),
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
            ]),
            _buildSection('Timeouts & Persistence', [
              _buildButton(
                'Persistent Toast',
                () => _showToast(
                  Toast(
                    title: 'Persistent notification',
                    content: const Text('This toast will not auto-dismiss'),
                    intent: ToastIntent.info,
                    timeout: null, // Persistent
                  ),
                ),
              ),
              _buildButton(
                'Custom Timeout (10s)',
                () => _showToast(
                  Toast(
                    title: 'Long timeout',
                    content: const Text('This toast will stay for 10 seconds'),
                    intent: ToastIntent.info,
                    timeout: const Duration(seconds: 10),
                  ),
                ),
              ),
              _buildButton(
                'Short Timeout (1s)',
                () => _showToast(
                  Toast(
                    title: 'Quick notification',
                    content: const Text('This toast disappears quickly'),
                    intent: ToastIntent.info,
                    timeout: const Duration(seconds: 1),
                  ),
                ),
              ),
            ]),
            _buildSection('Dismissibility', [
              _buildButton(
                'Dismissible Toast',
                () => _showToast(
                  Toast(
                    title: 'Can be dismissed',
                    content: const Text('Click X to dismiss'),
                    intent: ToastIntent.info,
                    dismissible: true,
                  ),
                ),
              ),
              _buildButton(
                'Non-Dismissible Toast',
                () => _showToast(
                  Toast(
                    title: 'Cannot be dismissed',
                    content: const Text('No dismiss button shown'),
                    intent: ToastIntent.warning,
                    dismissible: false,
                    timeout: const Duration(seconds: 5),
                  ),
                ),
              ),
              _buildButton(
                'Dismiss all toasts',
                () => Toaster.of(context).dismissAllToasts(),
              ),
            ]),
            _buildSection('Custom Icons', [
              _buildButton(
                'Custom Icon',
                () => _showToast(
                  Toast(
                    title: 'Custom icon',
                    content: const Text('Using a custom icon widget'),
                    intent: ToastIntent.info,
                    icon: Icon(FluentIcons.add),
                  ),
                ),
              ),
              _buildButton(
                'Emoji Icon',
                () => _showToast(
                  Toast(
                    title: 'Emoji icon',
                    content: const Text('Using emoji as icon'),
                    intent: ToastIntent.success,
                    icon: const Text('🎉', style: TextStyle(fontSize: 14)),
                  ),
                ),
              ),
            ]),
            InteractiveToasts(),
            _buildSection('Multiple Toasts', [
              _buildButton('Show 5 Toasts', () {
                for (int i = 1; i <= 5; i++) {
                  Future.delayed(
                    Duration(milliseconds: i * 200),
                    () => _showToast(
                      Toast(
                        title: 'Toast $i',
                        content: Text('This is toast number $i'),
                        intent: ToastIntent.info,
                      ),
                    ),
                  );
                }
              }),
              _buildButton('Rapid Fire Toasts', () {
                for (int i = 1; i <= 10; i++) {
                  Future.delayed(
                    Duration(milliseconds: i * 100),
                    () => _showToast(
                      Toast(
                        title: 'Toast $i',
                        intent: ToastIntent.info,
                        timeout: const Duration(seconds: 2),
                      ),
                    ),
                  );
                }
              }),
            ]),
            _buildSection('Toast Positions', [
              _buildButton(
                'Bottom End (Default)',
                () => _showToastAtPosition(
                  ToastPosition.bottomEnd,
                  Toast(
                    title: 'Bottom End',
                    content: const Text('Default position'),
                    intent: ToastIntent.info,
                  ),
                ),
              ),
              _buildButton(
                'Bottom Start',
                () => _showToastAtPosition(
                  ToastPosition.bottomStart,
                  Toast(
                    title: 'Bottom Start',
                    content: const Text('Left side'),
                    intent: ToastIntent.info,
                  ),
                ),
              ),
              _buildButton(
                'Bottom Center',
                () => _showToastAtPosition(
                  ToastPosition.bottom,
                  Toast(
                    title: 'Bottom Center',
                    content: const Text('Centered'),
                    intent: ToastIntent.info,
                  ),
                ),
              ),
              _buildButton(
                'Top End',
                () => _showToastAtPosition(
                  ToastPosition.topEnd,
                  Toast(
                    title: 'Top End',
                    content: const Text('Top right'),
                    intent: ToastIntent.info,
                  ),
                ),
              ),
              _buildButton(
                'Top Start',
                () => _showToastAtPosition(
                  ToastPosition.topStart,
                  Toast(
                    title: 'Top Start',
                    content: const Text('Top left'),
                    intent: ToastIntent.info,
                  ),
                ),
              ),
              _buildButton(
                'Top Center',
                () => _showToastAtPosition(
                  ToastPosition.top,
                  Toast(
                    title: 'Top Center',
                    content: const Text('Top centered'),
                    intent: ToastIntent.info,
                  ),
                ),
              ),
            ]),
            _buildSection('Inverted Mode', [
              _buildButton(
                'Inverted Toast',
                () => _showToast(
                  Toast(
                    title: 'Inverted style',
                    content: const Text('This toast uses inverted styling'),
                    intent: ToastIntent.info,
                    inverted: true,
                  ),
                ),
              ),
            ]),
            _buildSection('Interactive Features', [
              _buildButton(
                'Hover to Pause',
                () => _showToast(
                  Toast(
                    title: 'Hover me!',
                    content: const Text(
                      'Hover over this toast to pause auto-dismiss. '
                      'Move away to resume.',
                    ),
                    intent: ToastIntent.info,
                    timeout: const Duration(seconds: 5),
                  ),
                ),
              ),
              _buildButton(
                'Swipe to Dismiss',
                () => _showToast(
                  Toast(
                    title: 'Swipe me!',
                    content: const Text(
                      'Swipe horizontally to dismiss this toast',
                    ),
                    intent: ToastIntent.info,
                    timeout: null,
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  void _showToast(Toast toast) {
    Toaster.of(context).dispatchToast(toast);
  }

  void _showToastAtPosition(ToastPosition position, Toast toast) {
    widget.onPositionChanged(position);
    _showToast(toast);
  }
}

Widget _buildSection(String title, List<Widget> buttons) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 32.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(spacing: 12, runSpacing: 12, children: buttons),
      ],
    ),
  );
}

Widget _buildButton(
  String label,
  VoidCallback? onPressed, {
  bool enabled = true,
}) {
  return Button(onPressed: enabled ? onPressed : null, child: Text(label));
}

class InteractiveToasts extends StatefulWidget {
  const InteractiveToasts({super.key});

  @override
  State<InteractiveToasts> createState() => _InteractiveToastsState();
}

class _InteractiveToastsState extends State<InteractiveToasts> {
  String? _updatableToastId;

  void _showToast(Toast toast) {
    Toaster.of(context).dispatchToast(toast);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget spinner(double? value) => ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 18, maxWidth: 18),
      child: ProgressRing(strokeWidth: 2, value: value),
    );
    return _buildSection('Toast Management', [
      _buildButton('Dismiss All', () => Toaster.of(context).dismissAllToasts()),
      _buildButton('Create Updatable Toast', () {
        final toast = Toast(
          title: 'Progress: 0%',
          icon: spinner(null),
          // content: const Text('Processing...'),
          intent: ToastIntent.info,
          timeout: null,
        );
        _updatableToastId = toast.id;
        _showToast(toast);
      }),
      _buildButton('Update Toast', enabled: _updatableToastId != null, () {
        if (_updatableToastId != null) {
          Toaster.of(context).updateToast(
            Toast(
              id: _updatableToastId!,
              title: 'Progress: 75% ',
              icon: spinner(75),
              content: const Text('Almost done...'),
              intent: ToastIntent.success,
              timeout: null,
            ),
          );
        }
      }),
      _buildButton(
        'Dismiss Specific Toast',
        enabled: _updatableToastId != null,
        () {
          if (_updatableToastId != null) {
            Toaster.of(context).dismissToast(_updatableToastId!);
            setState(() {
              _updatableToastId = null;
            });
          }
        },
      ),
    ]);
  }
}
