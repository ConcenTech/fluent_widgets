# fluent_widgets

A collection of Fluent UI widgets for Flutter, designed to work seamlessly with the [`fluent_ui`](https://pub.dev/packages/fluent_ui) package. This package provides three main components: toast notifications, a data grid, and tag components.

> **Note**: This package is currently in early development and should be considered experimental. The API may change in future versions.

## Features

- **Toast Notifications**: App-wide toast notifications with queue management, auto-dismiss, and configurable positioning
- **Data Grid**: A fully-featured data grid with sorting, filtering, pagination, and selection support
- **Tags**: Flexible tag components with multiple variants (dismissible, interactive, styled)

## Installation

Add `fluent_widgets` to your `pubspec.yaml`:

```yaml
dependencies:
  fluent_ui: ^4.13.0
  fluent_widgets: ^0.1.4
```

## Toast Notifications

App-wide toast notifications that work across your entire Flutter app, not just within a specific route.

### Setup

Wrap your app with the `Toaster` widget:

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
    return Toaster(
      child: FluentApp(
        title: 'My App',
        theme: FluentThemeData(),
        darkTheme: FluentThemeData.dark(),
        home: const HomePage(),
      ),
    );
  }
}

```

### Showing Toasts

```dart
// Get the toaster controller
final toaster = Toaster.of(context);

// Show a simple toast
toaster.dispatchToast(
  Toast(
    title: 'Success!',
    content: Text('Your changes have been saved'),
    intent: ToastIntent.success,
  ),
);

// Show a persistent toast (no auto-dismiss)
toaster.dispatchToast(
  Toast(
    title: 'Important',
    content: Text('This toast stays until dismissed'),
    intent: ToastIntent.warning,
    timeout: null, // No auto-dismiss
  ),
);

// Show a toast with custom icon
toaster.dispatchToast(
  Toast(
    title: 'Processing',
    content: Text('Please wait...'),
    icon: const ProgressRing(),
    timeout: null,
  ),
);
```

### Dismissing Toasts

```dart
// Dismiss a specific toast by ID
final toastId = 'my-toast-id';
toaster.dispatchToast(
  Toast(
    id: toastId,
    title: 'Dismissible',
    intent: ToastIntent.info,
  ),
);

// Later, dismiss it
toaster.dismissToast(toastId);

// Dismiss all toasts
toaster.dismissAllToasts();

// Update an existing toast
toaster.updateToast(
  Toast(
    id: toastId,
    title: 'Updated!',
    intent: ToastIntent.success,
  ),
);
```

### Toast Configuration

The `Toast` class supports:

- `title` (required): Main title text
- `content`: Optional widget displayed below the title
- `intent`: Visual intent (`ToastIntent.info`, `success`, `warning`, `error`)
- `timeout`: Auto-dismiss duration (default: 3 seconds, set to `null` for persistent)
- `dismissible`: Whether the toast can be dismissed (default: `true`)
- `inverted`: Inverted color scheme
- `icon`: Custom icon widget
- `trailing`: Custom trailing widget (replaces dismiss button)
- `id`: Unique identifier for programmatic control

The `Toaster` widget supports:

- `maxToasts`: Maximum number of toasts displayed simultaneously (default: 3)
- `position`: Toast position (`ToastPosition.bottomEnd`, `bottomStart`, `topEnd`, `topStart`, `bottom`, `top`)
- `offset`: Offset from screen edge (default: `Offset(5, 5)`)
- `animationDuration`: Animation duration (default: 400ms)

## Data Grid

A Fluent UI-style data grid for displaying tabular data with built-in sorting, filtering, pagination, and selection.

### Basic Usage

```dart
DataGrid<Person>(
  data: people,
  columns: [
    DataGridColumn<Person>(
      title: 'Name',
      valueBuilder: (person) => person.name,
      sortBy: (a, b) => a.name.compareTo(b.name),
    ),
    DataGridColumn<Person>(
      title: 'Age',
      valueBuilder: (person) => person.age.toString(),
      sortBy: (a, b) => a.age.compareTo(b.age),
      textAlign: TextAlign.right,
    ),
    DataGridColumn<Person>(
      title: 'Department',
      valueBuilder: (person) => person.department,
      filterType: FilterType.dropdown,
      filterOptions: ['Sales', 'Engineering', 'Marketing'],
    ),
  ],
  selectionMode: SelectionMode.multi,
  selectedItems: selectedPeople,
  onSelectionChanged: (selected) {
    setState(() => selectedPeople = selected);
  },
  itemsPerPage: 50,
  showRowNumbers: true,
  alternatingRowColors: true,
)
```

### Features

**Sorting**: Click column headers to sort. Supports single-column sorting with visual indicators.

**Filtering**: 
- Text filters: Case-insensitive substring matching
- Dropdown filters: Select from predefined options
- Custom filters: Use `filterBuilder` for custom filter UI
- Filter panel: Collapsible filter panel at the top of the grid

**Selection**:
- `SelectionMode.none`: No selection
- `SelectionMode.single`: Single row selection
- `SelectionMode.multi`: Multiple row selection with checkboxes

**Pagination**: 
- Enable with `itemsPerPage`
- Automatically resets to first page when filters or sorting change
- Shows item counts and page navigation

**Selection Preservation**: Use `itemIdentifier` to preserve selection when data updates:

```dart
DataGrid<Person>(
  data: people,
  itemIdentifier: (person) => person.id, // Preserve selection by ID
  // ...
)
```

### Column Configuration

`DataGridColumn<T>` supports:ppre

- `title`: Column header text
- `valueBuilder`: Function to extract display value (must return String)
- `width`: Fixed width (null for auto-width)
- `sortBy`: Optional comparator function for sorting
- `filterType`: Filter type (`FilterType.none`, `text`, `dropdown`, `dateRange`, `numberRange`)
- `filterOptions`: Options for dropdown filters
- `filterPredicate`: Custom filter matching logic
- `filterBuilder`: Custom filter widget builder
- `cellBuilder`: Custom cell widget builder
- `textAlign`: Text alignment

### Loading State

Show a loading state with shimmer effect:

```dart
DataGrid.loading(
  columns: ['Name', 'Age', 'Department'],
  rowCount: 10,
)
```

## Tags

Tag components for displaying labeled information, useful for categorization, filtering, or status indication.

### Basic Tag

```dart
Tag(
  text: 'Category',
  icon: Icon(FluentIcons.tag),
  tagStyle: TagStyle.filled,
  size: TagSize.medium,
  shape: TagShape.rounded,
)
```

### Dismissible Tag

```dart
DismissibleTag(
  text: 'Removable',
  onDismiss: () {
    // Handle dismissal
  },
)
```

### Interactive Tag

```dart
InteractiveTag(
  text: 'Clickable',
  onPressed: () {
    // Handle tap
  },
)
```

### Dismissible Interactive Tag

```dart
DismissibleInteractiveTag(
  text: 'Full Featured',
  onPressed: () {
    // Handle tap
  },
  onDismiss: () {
    // Handle dismissal
  },
)
```

### Tag Variants

**Styles**:
- `TagStyle.filled`: Filled background (default)
- `TagStyle.outline`: Outlined border
- `TagStyle.brand`: Tinted background with accent color

**Sizes**:
- `TagSize.small`: Compact size
- `TagSize.medium`: Default size
- `TagSize.large`: Larger size for emphasis

**Shapes**:
- `TagShape.rounded`: Rounded corners (default)
- `TagShape.circular`: Fully circular

**Customization**:
- `icon`: Optional leading icon
- `trailing`: Custom trailing widget
- `backgroundColor`: Custom background color
- `textColor`: Custom text color
- `borderColor`: Custom border color (for outline style)
- `enabled`: Enable/disable the tag

## Examples

Complete working examples can be found in the `examples/` directory:

- `examples/toasts/` - Toast notification examples
- `examples/data_grid/` - Data grid examples
- `examples/tags/` - Tag component examples

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

See [LICENSE](LICENSE) file for details.
