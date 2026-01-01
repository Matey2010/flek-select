import 'package:flutter/material.dart';
import 'package:flek_select/select.dart';
import 'package:flek_select/select_option.dart';
import 'package:flek_select/toggle_button_group.dart';
import 'package:tappable/tappable.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flek_select Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ExamplePage(),
    );
  }
}

class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key});

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Select state
  String? _selectedLanguage;
  String? _selectedCountryCustom;

  // Toggle button state
  String? _selectedSize;
  String? _selectedColorCustom;

  // Option lists
  final _languageOptions = [
    SelectOption<String, void>(text: 'English', value: 'en'),
    SelectOption<String, void>(text: 'Spanish', value: 'es'),
    SelectOption<String, void>(text: 'French', value: 'fr'),
    SelectOption<String, void>(text: 'German', value: 'de'),
  ];

  final _countryOptions = [
    SelectOption<String, void>(text: 'United States', value: 'us'),
    SelectOption<String, void>(text: 'Canada', value: 'ca'),
    SelectOption<String, void>(text: 'United Kingdom', value: 'uk'),
    SelectOption<String, void>(text: 'Australia', value: 'au'),
  ];

  final _sizeOptions = [
    SelectOption<String, void>(text: 'S', value: 's'),
    SelectOption<String, void>(text: 'M', value: 'm'),
    SelectOption<String, void>(text: 'L', value: 'l'),
    SelectOption<String, void>(text: 'XL', value: 'xl'),
  ];

  final _colorOptions = [
    SelectOption<String, void>(text: 'Red', value: 'red'),
    SelectOption<String, void>(text: 'Blue', value: 'blue'),
    SelectOption<String, void>(text: 'Green', value: 'green'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('flek_select v0.5.0'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Select'),
            Tab(text: 'ToggleButtonGroup'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSelectTab(),
          _buildToggleButtonGroupTab(),
        ],
      ),
    );
  }

  Widget _buildSelectTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('1. Basic Select (Default)'),
          const SizedBox(height: 8),
          const Text(
            'Uses GestureDetector by default (no visual feedback)',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Select<String, void>(
            inputLabel: 'Language',
            options: _languageOptions,
            value: _selectedLanguage,
            onChange: (value) => setState(() => _selectedLanguage = value),
          ),
          const SizedBox(height: 32),
          _buildSectionTitle('2. Select with Custom Input Builder + Tappable'),
          const SizedBox(height: 8),
          const Text(
            'Custom inputBuilder using Tappable for touch feedback',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Select<String, void>(
            options: _countryOptions,
            value: _selectedCountryCustom,
            onChange: (value) =>
                setState(() => _selectedCountryCustom = value),
            inputBuilder: (context, selectedOption, isDisabled, onOpenSelectPopup) {
              return Tappable(
                onTap: isDisabled ? null : onOpenSelectPopup,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedOption?.text ?? 'Select a country',
                        style: TextStyle(
                          color: selectedOption != null
                              ? Colors.blue.shade900
                              : Colors.blue.shade400,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.blue.shade600,
                      ),
                    ],
                  ),
                ),
              );
            },
            backdropBuilder: (context, onCloseSelectPopup) {
              return Tappable(
                onTap: onCloseSelectPopup,
                child: Container(color: Colors.black54),
              );
            },
          ),
          const SizedBox(height: 32),
          _buildSectionTitle('3. Select with InkWell (Material Ripple)'),
          const SizedBox(height: 8),
          const Text(
            'Custom inputBuilder using InkWell for Material feedback',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Select<String, void>(
            inputLabel: 'Language (InkWell)',
            options: _languageOptions,
            value: _selectedLanguage,
            onChange: (value) => setState(() => _selectedLanguage = value),
            inputBuilder: (context, selectedOption, isDisabled, onOpenSelectPopup) {
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: isDisabled ? null : onOpenSelectPopup,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedOption?.text ?? 'Select...',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const Icon(Icons.arrow_drop_down, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButtonGroupTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('1. Basic ToggleButtonGroup (Default)'),
          const SizedBox(height: 8),
          const Text(
            'Uses GestureDetector by default (no visual feedback)',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 8),
          ToggleButtonGroup<String, void>(
            options: _sizeOptions,
            value: _selectedSize,
            onChange: (value) => setState(() => _selectedSize = value),
          ),
          const SizedBox(height: 32),
          _buildSectionTitle('2. ToggleButtonGroup with Custom Builder + Tappable'),
          const SizedBox(height: 8),
          const Text(
            'Custom buttonBuilder using Tappable for touch feedback',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 8),
          ToggleButtonGroup<String, void>(
            options: _colorOptions,
            value: _selectedColorCustom,
            onChange: (value) => setState(() => _selectedColorCustom = value),
            buttonBuilder: (context, option, isActive, onSelect) {
              return Tappable(
                onTap: onSelect,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: isActive ? _getColor(option.value) : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isActive ? _getColor(option.value) : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    option.text,
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.black87,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          _buildSectionTitle('3. ToggleButtonGroup with InkWell'),
          const SizedBox(height: 8),
          const Text(
            'Custom buttonBuilder using InkWell for Material feedback',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 8),
          ToggleButtonGroup<String, void>(
            options: _sizeOptions,
            value: _selectedSize,
            onChange: (value) => setState(() => _selectedSize = value),
            buttonBuilder: (context, option, isActive, onSelect) {
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onSelect,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isActive ? Colors.blue : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      option.text,
                      style: TextStyle(
                        color: isActive ? Colors.white : Colors.black87,
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Color _getColor(String? value) {
    switch (value) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
