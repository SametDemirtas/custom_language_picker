import 'package:custom_language_picker/src/models/language.dart';
import 'package:flutter/material.dart';


/// Callback when a language is selected
typedef OnLanguageSelected = void Function(Language language);

/// Callback when language favorites change
typedef OnFavoritesChanged = void Function(List<Language> favorites);

/// Builder for language item widgets
typedef LanguageItemBuilder = Widget Function(Language language, {bool? isFavorite, VoidCallback? onFavoriteToggle});