# 📝 TODO

## Future Enhancements

### 1. Custom Popup Builder

Add ability to customize the popup container and layout for package users.

**Goal**: Allow developers to fully customize the popup appearance and behavior while keeping the core overlay logic intact.

**Proposed API:**
```dart
Select(
  options: myOptions,
  value: selectedValue,
  onChange: (value) => setState(() => selectedValue = value),
  popupBuilder: (context, options, onSelect, onClose) {
    // Custom popup widget
    return CustomPopupContainer(
      options: options,
      onSelect: onSelect,
      onClose: onClose,
    );
  },
)
```

**Use Cases:**
- Custom positioning (dropdown-style vs centered modal)
- Custom animations (slide, fade, scale)
- Custom backdrop styling
- Custom container design (rounded corners, shadows, borders)
- Integration with app-specific design systems

**Implementation Notes:**
- Keep default centered modal as fallback
- Provide helper widgets for common patterns (dropdown, bottom sheet, etc.)
- Ensure custom builders respect overlay lifecycle management
- Document best practices for backdrop handling

---

### 2. Alternative Overlay Injection Methods

Add support for different overlay integration strategies for apps already using Overlay API.

**Goal**: Prevent blocking conflicts when multiple systems try to use the root overlay simultaneously.

**Problem:**
- Some apps have their own overlay management systems (toast notifications, modals, etc.)
- Multiple `rootOverlay: true` insertions can conflict
- Need a way to integrate Select into existing overlay hierarchies

**Proposed Solutions:**

#### Option A: Scoped Overlay Support
```dart
Select(
  options: myOptions,
  value: selectedValue,
  onChange: (value) => setState(() => selectedValue = value),
  overlayContext: customOverlayContext, // Use specific overlay instead of root
  useRootOverlay: false, // Opt-out of root overlay
)
```

#### Option B: Overlay Manager Integration
```dart
// Register with app's overlay manager
FlekSelectConfig.setOverlayManager(myAppOverlayManager);

// Select automatically uses the registered manager
Select(
  options: myOptions,
  value: selectedValue,
  onChange: (value) => setState(() => selectedValue = value),
)
```

#### Option C: Insertion Strategy Callback
```dart
Select(
  options: myOptions,
  value: selectedValue,
  onChange: (value) => setState(() => selectedValue = value),
  overlayStrategy: (overlayEntry) {
    // Custom insertion logic
    myOverlayManager.insert(overlayEntry, priority: OverlayPriority.select);
  },
)
```

**Use Cases:**
- Apps with existing modal/dialog management systems
- Apps using z-index/priority-based overlay stacking
- Apps with complex navigation patterns requiring overlay coordination
- Integration with overlay-aware state management

**Implementation Notes:**
- Maintain backward compatibility with default behavior
- Document overlay priority/z-index considerations
- Provide migration guide for apps with existing overlay systems
- Consider thread safety and concurrent overlay operations

---

## Additional Ideas (Low Priority)

- [ ] Keyboard navigation support (arrow keys, enter, escape)
- [ ] Accessibility improvements (screen reader support, focus management)
- [ ] Animation customization (fade in/out, slide, scale)
- [ ] Search/filter functionality for long option lists
- [ ] Multi-select support
- [ ] Option grouping/categories
- [ ] Virtual scrolling for thousands of options
- [ ] Dropdown positioning (auto-flip when near screen edges)
