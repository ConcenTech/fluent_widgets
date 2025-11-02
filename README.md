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

# fluent_data_grid

A Fluent UI-style DataGrid for Flutter desktop (Windows and macOS) built on top of `fluent_ui`.

## What it provides

- Sorting (single-column) with visual indicators
- Row selection (single and multi-select)
- Pagination (page size, current page, and callbacks)
- Column filters (text and dropdown)
- Collapsible filter panel (using Expander)
- Row numbering, alternating row colors, horizontal/vertical scrolling

## Getting started

1) Add the package to your Flutter project. For local development, use a path dependency in your app's `pubspec.yaml` pointing to this package folder.

2) Import the library and use the exported types in your UI. You will typically:

- Provide a list of data items
- Declare a list of columns (one per field you want to display), each defining how to extract values and (optionally) how to sort and filter
- Opt-in to features like selection, pagination, filters, and visual options (row numbers, alternating colors)

3) Wire callbacks for:

- Page changes (to keep `currentPage` in sync)
- Selection changes (to reflect changes in app state)
- Filter changes (if you need to persist or observe filter state externally)

## Concepts & configuration

- Data: The grid displays a list of items (`List<T>`). The grid internally applies filtering, then sorting, then pagination in that order.

- Columns: Each column defines:
  - A title and width
  - A `valueBuilder` to extract the value from a row item
  - Optional `sortBy` comparator
  - Optional filtering config (text or dropdown) and an optional `filterPredicate` for custom matching

- Selection: Opt-in via `selectable`. For multi-select, enable `multiSelect`. The grid will track selected items and emit changes via `onSelectionChanged`.

- Pagination: Enable via `enablePagination` and configure `itemsPerPage`, `currentPage`, and `onPageChanged`. The grid shows item counts and page counts derived from the filtered dataset.

- Filtering:
  - Column filters can be enabled via `showColumnFilters`
  - Each column can be filterable (`filterable: true`)
  - Dropdown filters accept a fixed set of options
  - Text filters perform case-insensitive substring matches by default, and can be overridden with a custom predicate
  - The filter panel is collapsible and starts collapsed

- Visuals: Optional row numbering, alternating row colors, and a Fluent-styled header with sort indicators. Horizontal scrolling is supported for wide sets of columns.

## Behavior details

- Ordering of operations: filter → sort → paginate
- Counts shown (items and pages) are based on the filtered set
- "Select all" applies to the filtered rows currently in view, not the entire unfiltered dataset
- Sorting applies to the full filtered set (not just the current page)

## Accessibility & keyboard

- Uses `fluent_ui` controls for consistency with Windows Fluent design
- The filter panel uses an Expander to expose a11y/keyboard expectations

## Best practices

- Keep `itemsPerPage` aligned with your layout height to minimize partial pages
- Use deterministic comparators for sorting
- For large datasets, consider applying coarse filtering in your data layer before passing to the grid
- Keep column widths explicit for predictable horizontal layouts

## Limitations

- Single-column sorting (multi-column sorting is not yet implemented)
- Client-side only (no built-in data source abstraction)
- Focus management and advanced keyboard navigation are basic; enhancements may be added later

## Versioning & stability

- This is an evolving local package intended for internal use
- API may change until a stable release is tagged

## Contributing

- Keep the public API small and documented
- Maintain a clean separation between public exports (`lib/fluent_data_grid.dart`) and internals (`lib/src/...`)
- Add small, focused examples to the `example` app for new features

## License

- Licensed under the BSD-3 License. See the LICENSE file for details.
