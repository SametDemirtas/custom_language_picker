# Custom Language Picker

A highly customizable language picker for Flutter applications with search functionality, favorites support, and multiple UI styles including dropdown, dialog, and Cupertino pickers.
<p align="center">
  <img src="screenshots/preview.png" width="300" alt="Preview">
</p>
## Features

- 🌎 Support for 60+ languages with native names and flag emojis
- 🔍 Powerful search functionality
- ⭐ Favorites system to quickly access preferred languages
- 🎨 Three UI variants:
    - Material Design dropdown
    - Material Design dialog
    - Cupertino style picker
- 🎭 Fully customizable appearance
- 🔄 Simple callback system for language selection
- 📱 Responsive design for different screen sizes

<p align="center">
  <img src="screenshots/dropdown.png" width="250" alt="Dropdown">
  <img src="screenshots/dialog.png" width="250" alt="Dialog">
  <img src="screenshots/cupertino.png" width="250" alt="Cupertino">
</p>
## Getting Started

Add the package to your `pubspec.yaml`:


dependencies:
  custom_language_picker: ^0.1.0
  
  
  
Then import it in your Dart code:
import 'package:custom_language_picker/custom_language_picker.dart';


Usage
Dropdown Picker

LanguagePickerDropdown(
  initialValue: Languages.getLanguageByCode(LanguageCode.en),
  onValuePicked: (Language language) {
    setState(() {
      _selectedLanguage = language;
      print('Selected: ${language.name}');
    });
  },
  onFavoritesChanged: (List<Language> favorites) {
    setState(() {
      _favoriteLanguages = favorites;
    });
  },
  isSearchable: true,
  showNativeNames: true,
  showFavoritesFirst: true,
)
Dialog Picker
ElevatedButton(
  onPressed: () => showDialog(
    context: context,
    builder: (context) => LanguagePickerDialog(
      titleText: 'Select your language',
      isSearchable: true,
      initialFavorites: _favoriteLanguages,
      onValuePicked: (Language language) {
        setState(() {
          _selectedLanguage = language;
        });
      },
      onFavoritesChanged: (List<Language> favorites) {
        setState(() {
          _favoriteLanguages = favorites;
        });
      },
    ),
  ),
  child: const Text("Open Language Dialog"),
)
Cupertino Picker
CupertinoButton(
  onPressed: () => showCupertinoModalPopup(
    context: context,
    builder: (context) => LanguagePickerCupertino(
      initialFavorites: _favoriteLanguages,
      onValuePicked: (Language language) {
        setState(() {
          _selectedLanguage = language;
        });
      },
      onFavoritesChanged: (List<Language> favorites) {
        setState(() {
          _favoriteLanguages = favorites;
        });
      },
    ),
  ),
  child: Text("Select Language"),
)

Custom Item Builders
You can customize how language items are displayed:
LanguagePickerDropdown(
  // ... other properties
  itemBuilder: (Language language, {bool? isFavorite, VoidCallback? onFavoriteToggle}) {
    return Row(
      children: [
        Text(language.flagEmoji),
        const SizedBox(width: 8),
        Expanded(child: Text(language.name)),
        if (isFavorite != null)
          IconButton(
            icon: Icon(
              isFavorite ? Icons.star : Icons.star_border,
              color: isFavorite ? Colors.amber : Colors.grey,
            ),
            onPressed: onFavoriteToggle,
          ),
      ],
    );
  },
)
Advanced Customization
The library offers extensive customization options. Here's an example with custom colors:

LanguagePickerDropdown(
  // ... other properties
  dropdownBackgroundColor: Colors.white,
  dropdownTextColor: Colors.black87,
  dropdownBorderColor: Colors.grey.shade300,
  dropdownIconColor: Colors.grey.shade700,
  searchHighlightColor: Colors.blue,
  searchHighlightBackgroundColor: Colors.blue.withAlpha(25),
  selectedItemColor: Colors.blue,
  selectedItemBackgroundColor: Colors.blue.withAlpha(25),
  favoriteIconActiveColor: Colors.amber,
  favoriteIconInactiveColor: Colors.grey,
)
Additional Information

Supported languages: check the Languages.defaultLanguages list for all supported languages
Contributions are welcome! Please feel free to submit a Pull Request
Report issues or suggest features on the GitHub repository

License
This package is available under the MIT License.