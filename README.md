# fluent_widgets

App-wide toast notifications for Flutter apps using the [fluent_ui](https://pub.dev/packages/fluent_ui) package. Visually matches the Fluent UI React Toast component while adapting to Flutter's architecture.

## Features

- ✨ App-wide notifications (not route-scoped)
- 🎨 Visually matches Fluent UI React Toast design
- 🎯 Multiple intent types: info, success, warning, danger
- 📍 Configurable positions: bottom-right (default), bottom-center, top-right, top-center
- ⏱️ Auto-dismiss with configurable duration (default: 3 seconds)
- 🎭 Pause/resume on hover or long-press
- 👆 Swipe-to-dismiss gesture support
- 🎨 Theme-aware (light/dark mode support)
- 🔢 Queue management with max toast limit

## Getting Started

Add `fluent_widgets` to your `pubspec.yaml`:

```yaml
dependencies:
  fluent_ui: ^4.13.0
  fluent_widgets: ^0.0.1
```

## Usage

### 1. Wrap your app with `Toaster`

```dart
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
      title: 'My App',
      theme: FluentThemeData(),
      darkTheme: FluentThemeData.dark(),
      home: const Toaster(
        child: HomePage(),
      ),
    );
  }
}
```

### 2. Show toasts from anywhere

```dart
import 'package:fluent_widgets/fluent_widgets.dart';

// Simple toast
Toaster.of(context).show(
  Toast(
    title: 'Success!',
    subtitle: 'Your changes have been saved',
    intent: ToastIntent.success,
  ),
);

// Persistent toast (no auto-dismiss)
Toaster.of(context).show(
  Toast(
    title: 'Important',
    subtitle: 'This toast stays until dismissed',
    intent: ToastIntent.warning,
    duration: null, // No auto-dismiss
  ),
);

### 3. Dismiss toasts programmatically

```dart
// Show a toast with an ID
Toaster.show(
  context,
  Toast(
    id: 'my-toast',
    title: 'Dismissible',
    intent: ToastIntent.info,
  ),
);

// Later, dismiss a specific toast by ID
Toaster.of(context).dismiss('my-toast');

// Dismiss all toasts
Toaster.of(context).dismissAll();
```

## Toast Options

The `Toast` class accepts the following parameters:

- `title` (required): The main title text
- `subtitle` (optional): Secondary text shown below the title
- `intent` (default: `ToastIntent.info`): Visual intent (info, success, warning, danger)
- `action` (optional): Action button with label and callback
- `dismissible` (default: `true`): Whether the toast can be dismissed
- `duration` (default: `Duration(seconds: 3)`): Auto-dismiss duration. Set to `null` for persistent toasts
- `position` (default: `ToastPosition.bottomRight`): Where the toast appears
- `icon` (optional): Custom icon widget
- `id` (optional): Unique identifier for programmatic dismissal

## Examples

See the [example](example/main.dart) directory for a complete working example.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

See [LICENSE](LICENSE) file for details.
