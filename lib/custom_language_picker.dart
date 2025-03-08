library custom_language_picker;

export 'src/models/language.dart';
export 'src/models/language_code.dart';
export 'src/data/language_data.dart';
export 'src/services/language_servis.dart';
export 'src/widgets/dialog/custom_language_picker_dialog.dart';
export 'src/widgets/dropdown/language_picker_dropdown.dart';
export 'src/widgets/cupertino/custom_language_picker_cupertino.dart';
export 'src/widgets/dropdown/language_picker_dropdown_controller.dart';
export 'src/widgets/dialog/alert_dialog.dart';
export 'typedefs.dart';


import 'package:custom_language_picker/src/services/language_servis.dart';
import 'package:custom_language_picker/src/widgets/dialog/custom_language_picker_dialog.dart';
import 'package:custom_language_picker/src/widgets/dropdown/language_picker_dropdown.dart';
import 'package:flutter/material.dart';

import 'src/models/language.dart';
import 'typedefs.dart';

/// A versatile language picker that can show as a button that opens a dialog
class CustomLanguagePicker extends StatefulWidget {
  /// The currently selected language
  final Language? selectedLanguage;

  /// Callback when a language is selected
  final OnLanguageSelected? onValuePicked;

  /// Callback when favorites are changed
  final OnFavoritesChanged? onFavoritesChanged;

  /// List of languages to display
  final List<Language>? languages;

  /// Initial list of favorite languages
  final List<Language>? initialFavorites;

  /// Whether to show flags for languages
  final bool showFlags;

  /// Whether to show language names
  final bool showLanguageName;

  /// Whether to show native language names
  final bool showNativeName;

  /// Custom builder for language items in the dialog
  final LanguageItemBuilder? itemBuilder;

  /// Whether to enable search in the dialog
  final bool isSearchable;

  /// Whether to show the dialog as fullscreen on small devices
  final bool useFullScreenDialog;

  /// Whether to show favorites at the top of the list
  final bool showFavoritesFirst;

  /// Whether to show a separate favorites section
  final bool showFavoritesSection;

  /// Custom title for the dialog
  final String? dialogTitle;

  /// The language service to use (optional)
  final LanguageService? languageService;

  /// Theme for the button/picker
  final ThemeData? theme;

  /// Style for the picker button
  final ButtonStyle? buttonStyle;

  /// Layout direction (horizontal or vertical)
  final Axis direction;

  /// Whether to show a dropdown instead of opening a dialog
  final bool useDropdown;

  const CustomLanguagePicker({
    Key? key,
    this.selectedLanguage,
    this.onValuePicked,
    this.onFavoritesChanged,
    this.languages,
    this.initialFavorites,
    this.showFlags = true,
    this.showLanguageName = true,
    this.showNativeName = false,
    this.itemBuilder,
    this.isSearchable = true,
    this.useFullScreenDialog = false,
    this.showFavoritesFirst = true,
    this.showFavoritesSection = true,
    this.dialogTitle,
    this.languageService,
    this.theme,
    this.buttonStyle,
    this.direction = Axis.horizontal,
    this.useDropdown = false,
  }) : super(key: key);

  @override
  CustomLanguagePickerState createState() => CustomLanguagePickerState();
}

class CustomLanguagePickerState extends State<CustomLanguagePicker> {
  late LanguageService _languageService;

  @override
  void initState() {
    super.initState();

    // Initialize language service
    _languageService = widget.languageService ??
        LanguageService(
          languages: widget.languages,
          initialFavorites: widget.initialFavorites,
          initialLanguage: widget.selectedLanguage,
          onFavoritesChanged: widget.onFavoritesChanged,
          onLanguageSelected: widget.onValuePicked,
        );
  }

  @override
  Widget build(BuildContext context) {
    final selectedLanguage = _languageService.selectedLanguage ??
        (_languageService.languages.isNotEmpty
            ? _languageService.languages.first
            : null);

    if (selectedLanguage == null) {
      return const SizedBox.shrink();
    }

    if (widget.useDropdown) {
      return CustomLanguagePickerDropdown(
        initialValue: selectedLanguage,
        onValuePicked: (Language language) {
          setState(() {
            _languageService.selectLanguage(language);
          });
        },
        onFavoritesChanged: widget.onFavoritesChanged,
        languages: widget.languages,
        initialFavorites: widget.initialFavorites,
        showFavoritesFirst: widget.showFavoritesFirst,
        languageService: _languageService,
        itemBuilder: widget.itemBuilder ??
                (language, {isFavorite, onFavoriteToggle}) {
              return _buildLanguageItem(language, false);
            },
      );
    }

    // Button that opens dialog
    return Theme(
      data: widget.theme ?? Theme.of(context),
      child: ElevatedButton(
        style: widget.buttonStyle,
        onPressed: () => _openLanguageDialog(context),
        child: _buildLanguageItem(selectedLanguage, true),
      ),
    );
  }

  void _openLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return CustomLanguagePickerDialog(
          title: widget.dialogTitle != null ? Text(widget.dialogTitle!) : null,
          onValuePicked: (Language language) {
            setState(() {
              _languageService.selectLanguage(language);
            });
          },
          onFavoritesChanged: widget.onFavoritesChanged,
          isSearchable: widget.isSearchable,
          languages: widget.languages,
          initialFavorites: widget.initialFavorites,
          showFavoritesSection: widget.showFavoritesSection,
          languageService: _languageService,
          itemBuilder: widget.itemBuilder ??
                  (language, {isFavorite, onFavoriteToggle}) {
                return _buildLanguageItem(language, false);
              },
        );
      },
    );
  }

  Widget _buildLanguageItem(Language language, bool isButton) {
    final List<Widget> content = [];

    // Add flag if enabled
    if (widget.showFlags) {
      content.add(
        Text(
          language.flagEmoji,
          style: const TextStyle(fontSize: 24),
        ),
      );
    }

    // Add language name if enabled
    if (widget.showLanguageName) {
      if (content.isNotEmpty) {
        content.add(const SizedBox(width: 8));
      }

      content.add(
        Text(language.name),
      );
    }

    // Add native name if enabled
    if (widget.showNativeName && language.nativeName.isNotEmpty) {
      if (content.isNotEmpty) {
        content.add(const SizedBox(width: 4));
      }

      content.add(
        Text(
          "(${language.nativeName})",
          style: TextStyle(
            fontSize: isButton ? 12 : 14,
            color: isButton ? null : Colors.grey.shade600,
          ),
        ),
      );
    }

    // Add favorite star if not a button
    if (!isButton && language.isFavorite) {
      if (content.isNotEmpty) {
        content.add(const SizedBox(width: 4));
      }

      content.add(
        const Icon(
          Icons.star,
          color: Colors.amber,
          size: 16,
        ),
      );
    }

    // Return content in the specified direction
    if (widget.direction == Axis.horizontal) {
      return Padding(
        padding: isButton
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: content,
        ),
      );
    } else {
      return Padding(
        padding: isButton
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: content,
        ),
      );
    }
  }

  /// Public method to access the language service
  LanguageService get languageService => _languageService;
}