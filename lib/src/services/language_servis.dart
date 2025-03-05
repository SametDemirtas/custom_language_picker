import 'package:flutter/foundation.dart';
import 'package:custom_language_picker/typedefs.dart';
import 'package:custom_language_picker/src/data/language_data.dart';
import 'package:custom_language_picker/src/models/language.dart';
import 'package:custom_language_picker/src/models/language_code.dart';

/// Service to manage language selection and favorites
class LanguageService extends ChangeNotifier {
  List<Language> _languages = [];
  List<Language> _favorites = [];
  Language? _selectedLanguage;

  // Callbacks for external integrations
  final OnFavoritesChanged? onFavoritesChanged;
  final OnLanguageSelected? onLanguageSelected;

  LanguageService({
    List<Language>? languages,
    List<Language>? initialFavorites,
    Language? initialLanguage,
    this.onFavoritesChanged,
    this.onLanguageSelected,
  }) {
    _languages = languages ?? Languages.defaultLanguages;

    // Set initial favorites if provided
    if (initialFavorites != null && initialFavorites.isNotEmpty) {
      for (final favorite in initialFavorites) {
        final index = _languages.indexWhere((lang) => lang.code == favorite.code);
        if (index != -1) {
          _languages[index] = _languages[index].copyWith(isFavorite: true);
          _favorites.add(_languages[index]);
        }
      }
    }

    // Set initial language if provided
    if (initialLanguage != null) {
      _selectedLanguage = _languages.firstWhere(
            (lang) => lang.code == initialLanguage.code,
        orElse: () => _languages.first,
      );
    } else {
      _selectedLanguage = _languages.firstWhere(
            (lang) => lang.code == LanguageCode.en,
        orElse: () => _languages.first,
      );
    }
  }

  /// Get all available languages
  List<Language> get languages => _languages;

  /// Get favorite languages
  List<Language> get favorites => _favorites;

  /// Get currently selected language
  Language? get selectedLanguage => _selectedLanguage;

  /// Set selected language
  void selectLanguage(Language language) {
    final index = _languages.indexWhere((lang) => lang.code == language.code);
    if (index != -1) {
      _selectedLanguage = _languages[index];
      notifyListeners();

      // Call the external callback if provided
      if (onLanguageSelected != null) {
        onLanguageSelected!(_selectedLanguage!);
      }
    }
  }

  /// Toggle favorite status for a language
  void toggleFavorite(Language language) {
    final index = _languages.indexWhere((lang) => lang.code == language.code);
    if (index != -1) {
      final isFavorite = !_languages[index].isFavorite;
      _languages[index] = _languages[index].copyWith(isFavorite: isFavorite);

      if (isFavorite) {
        _favorites.add(_languages[index]);
      } else {
        _favorites.removeWhere((lang) => lang.code == language.code);
      }

      notifyListeners();

      // Call the external callback if provided
      if (onFavoritesChanged != null) {
        onFavoritesChanged!(_favorites);
      }
    }
  }

  /// Add language to favorites
  void addFavorite(Language language) {
    final index = _languages.indexWhere((lang) => lang.code == language.code);
    if (index != -1 && !_languages[index].isFavorite) {
      _languages[index] = _languages[index].copyWith(isFavorite: true);
      _favorites.add(_languages[index]);
      notifyListeners();

      // Call the external callback if provided
      if (onFavoritesChanged != null) {
        onFavoritesChanged!(_favorites);
      }
    }
  }

  /// Remove language from favorites
  void removeFavorite(Language language) {
    final index = _languages.indexWhere((lang) => lang.code == language.code);
    if (index != -1 && _languages[index].isFavorite) {
      _languages[index] = _languages[index].copyWith(isFavorite: false);
      _favorites.removeWhere((lang) => lang.code == language.code);
      notifyListeners();

      // Call the external callback if provided
      if (onFavoritesChanged != null) {
        onFavoritesChanged!(_favorites);
      }
    }
  }

  /// Set multiple favorites at once
  void setFavorites(List<Language> favorites) {
    // Reset all favorites first
    for (var i = 0; i < _languages.length; i++) {
      _languages[i] = _languages[i].copyWith(isFavorite: false);
    }

    _favorites.clear();

    // Set new favorites
    for (final favorite in favorites) {
      final index = _languages.indexWhere((lang) => lang.code == favorite.code);
      if (index != -1) {
        _languages[index] = _languages[index].copyWith(isFavorite: true);
        _favorites.add(_languages[index]);
      }
    }

    notifyListeners();

    // Call the external callback if provided
    if (onFavoritesChanged != null) {
      onFavoritesChanged!(_favorites);
    }
  }

  /// Filter languages by search query
  List<Language> filterLanguages(String query) {
    if (query.isEmpty) return _languages;

    final lowerQuery = query.toLowerCase();
    return _languages.where((language) {
      return language.name.toLowerCase().contains(lowerQuery) ||
          language.nativeName.toLowerCase().contains(lowerQuery) ||
          language.isoCode.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}