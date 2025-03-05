

import 'package:custom_language_picker/custom_language_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp(key: Key('app')));

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Language Picker Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Custom Language Picker Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Language? _selectedDropdownLanguage;
  Language? _selectedDialogLanguage;
  Language? _selectedCupertinoLanguage;
  List<Language> _favoriteLanguages = [];

  @override
  void initState() {
    super.initState();

    _selectedDropdownLanguage = Languages.getLanguageByCode(LanguageCode.ko);
    _selectedDialogLanguage = Languages.getLanguageByCode(LanguageCode.ko);
    _selectedCupertinoLanguage = Languages.getLanguageByCode(LanguageCode.ko);

    _favoriteLanguages = [
      Languages.getLanguageByCode(LanguageCode.en),
      Languages.getLanguageByCode(LanguageCode.fr),
      Languages.getLanguageByCode(LanguageCode.de),
    ];
  }

  Widget _buildDropdownItem(Language language, {bool? isFavorite, VoidCallback? onFavoriteToggle}) {
    return Row(
      children: <Widget>[
        Text(language.flagEmoji),
        const SizedBox(width: 8.0),
        Expanded(child: Text("${language.name} (${language.isoCode})")),
        if (isFavorite != null)
          IconButton(
            icon: Icon(
              isFavorite ? Icons.star : Icons.star_border,
              size: 20,
              color: isFavorite ? Colors.amber : Colors.grey,
            ),
            onPressed: onFavoriteToggle,
            splashRadius: 20,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 20,
              minHeight: 20,
            ),
          ),
      ],
    );
  }

  Widget _buildDialogItem(Language language, {bool? isFavorite, VoidCallback? onFavoriteToggle}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: <Widget>[
          Text(language.flagEmoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(language.name),
                const SizedBox(height: 4.0),
                Text(
                  language.nativeName,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (isFavorite != null)
            IconButton(
              icon: Icon(
                isFavorite ? Icons.star : Icons.star_border,
                color: isFavorite ? Colors.amber : Colors.grey,
              ),
              onPressed: onFavoriteToggle,
            ),
        ],
      ),
    );
  }

  void _openLanguagePickerDialog() => showDialog(
    context: context,
    builder: (context) => Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
      ),
      child: CustomLanguagePickerDialog(
        titleText: 'Select your language',
        titlePadding: const EdgeInsets.all(16.0),
        searchCursorColor: Colors.pinkAccent,
        searchInputDecoration: const InputDecoration(
          hintText: 'Search...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        isSearchable: true,
        initialFavorites: _favoriteLanguages,
        onValuePicked: (Language language) {
          setState(() {
            _selectedDialogLanguage = language;
            print('Selected language: ${language.name}');
            print('ISO code: ${language.isoCode}');
          });
        },
        onFavoritesChanged: (List<Language> favorites) {
          setState(() {
            _favoriteLanguages = favorites;
            print('Favorites updated: ${favorites.map((e) => e.name).join(', ')}');
          });
        },
        itemBuilder: _buildDialogItem,
      ),
    ),
  );

  void _openCupertinoLanguagePicker() => showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) {
      return CustomLanguagePickerCupertino(
        pickerSheetHeight: 250.0,
        initialFavorites: _favoriteLanguages,
        onValuePicked: (Language language) {
          setState(() {
            _selectedCupertinoLanguage = language;
            print('Selected language: ${language.name}');
            print('ISO code: ${language.isoCode}');
          });
        },
        onFavoritesChanged: (List<Language> favorites) {
          setState(() {
            _favoriteLanguages = favorites;
            print('Favorites updated: ${favorites.map((e) => e.name).join(', ')}');
          });
        },
      );
    },
  );

  Widget _buildCupertinoSelectedItem(Language? language) {
    if (language == null) return const Text('Select a language');

    return Row(
      children: <Widget>[
        Text(language.flagEmoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(width: 12.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(language.name),
              Text(
                language.nativeName,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.arrow_drop_down),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Language Dropdown:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  CustomLanguagePickerDropdown(
                    initialValue: _selectedDropdownLanguage,
                    itemBuilder: _buildDropdownItem,
                    initialFavorites: _favoriteLanguages,
                    onValuePicked: (Language language) {
                      setState(() {
                        _selectedDropdownLanguage = language;
                        print('Selected language: ${language.name}');
                        print('ISO code: ${language.isoCode}');
                      });
                    },
                    onFavoritesChanged: (List<Language> favorites) {
                      setState(() {
                        _favoriteLanguages = favorites;
                        print('Favorites updated: ${favorites.map((e) => e.name).join(', ')}');
                      });
                    },
                    isSearchable: true,
                    showNativeNames: true,
                    showFavoritesFirst: true,
                    searchHintText: 'Search languages...',
                    favoritesSectionLabel: 'Favorites',
                    dropdownBackgroundColor: Colors.white,
                    dropdownTextColor: Colors.black87,
                    dropdownBorderColor: Colors.grey.shade300,
                    dropdownIconColor: Colors.grey.shade700,

                    searchHighlightColor: Colors.blue,
                    searchHighlightBackgroundColor: Colors.blue.withOpacity(0.1),
                    searchFieldTextColor: Colors.black87,
                    searchFieldBackgroundColor: Colors.grey.shade50,
                    searchFieldFocusedBorderColor: Colors.blue,
                    searchFieldHintColor: Colors.grey,
                    searchFieldCursorColor: Colors.blue,

                    selectedItemColor: Colors.blue,
                    selectedItemBackgroundColor: Colors.blue.withOpacity(0.1),
                    favoriteIconActiveColor: Colors.amber,
                    favoriteIconInactiveColor: Colors.grey.shade400,

                    dropdownOverlayColor: Colors.white,
                    dropdownOverlayShadowColor: Colors.black26,
                    dividerColor: Colors.grey.shade200,

                    favoritesSectionLabelColor: Colors.grey.shade800,
                    favoritesSectionIconColor: Colors.amber,
                    favoritesSectionBackgroundColor: Colors.grey.shade50,

                    noResultsTextColor: Colors.grey.shade700,
                    noResultsIconColor: Colors.grey.shade400,
                    dropdownOverlayElevation: 8.0,
                    dropdownBorderRadius: 8.0,
                    dropdownOverlayBorderRadius: 12.0,
                    dropdownBorderWidth: 1.0,
                  ),
                ],
              ),
            ),
            const Divider(),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Language Dialog:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: _selectedDialogLanguage != null
                                ? Row(
                              children: [
                                Text(
                                  _selectedDialogLanguage!.flagEmoji,
                                  style: const TextStyle(fontSize: 24),
                                ),
                                const SizedBox(width: 12),
                                Text(_selectedDialogLanguage!.name),
                              ],
                            )
                                : const Text('No language selected'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: _openLanguagePickerDialog,
                        child: const Text("Open Dialog"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),
            // Cupertino example
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cupertino Picker:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: InkWell(
                      onTap: _openCupertinoLanguagePicker,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: _buildCupertinoSelectedItem(_selectedCupertinoLanguage),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            // Favorites section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Favorite Languages:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _favoriteLanguages.map((language) {
                      return Chip(
                        avatar: Text(language.flagEmoji),
                        label: Text(language.name),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () {
                          setState(() {
                            _favoriteLanguages.removeWhere(
                                    (lang) => lang.code == language.code);
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}