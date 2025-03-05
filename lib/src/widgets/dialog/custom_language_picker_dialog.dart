import 'dart:ui';

import 'package:custom_language_picker/src/models/language.dart';
import 'package:flutter/material.dart';

import '../../services/language_servis.dart';
import '../../../typedefs.dart';
/// Provides a modern language picker dialog with search and favorites
class CustomLanguagePickerDialog extends StatefulWidget {
  /// Callback when a language is selected
  final OnLanguageSelected? onValuePicked;

  /// Callback when favorites are changed
  final OnFavoritesChanged? onFavoritesChanged;

  /// Dialog title widget
  final Widget? title;

  /// Text to use for the dialog title
  final String? titleText;

  /// Padding around the title
  final EdgeInsetsGeometry? titlePadding;

  /// Content padding
  final EdgeInsetsGeometry contentPadding;

  /// Custom builder for language items
  final LanguageItemBuilder? itemBuilder;

  /// Whether to enable the search feature
  final bool isSearchable;

  /// Custom decoration for the search input
  final InputDecoration? searchInputDecoration;

  /// Custom cursor color for the search input
  final Color? searchCursorColor;

  /// Widget to display when search returns no results
  final Widget? searchEmptyView;

  /// List of languages to display
  final List<Language>? languages;

  /// Initial list of favorite languages
  final List<Language>? initialFavorites;

  /// Whether to show a separate favorites section at the top
  final bool showFavoritesSection;

  /// Custom title for the favorites section
  final String favoritesTitle;

  /// The language service to use (optional)
  final LanguageService? languageService;

  /// Maximum height for the dialog
  final double? maxHeight;

  /// Whether to show native language names
  final bool showNativeNames;

  /// Whether to show dividers between items
  final bool showDividers;

  /// Whether to group favorites at the top of the list
  final bool showFavoritesFirst;

  const CustomLanguagePickerDialog({
    Key? key,
    this.onValuePicked,
    this.onFavoritesChanged,
    this.title,
    this.titleText,
    this.titlePadding,
    this.contentPadding = const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 16.0),
    this.itemBuilder,
    this.isSearchable = true,
    this.searchInputDecoration,
    this.searchCursorColor,
    this.searchEmptyView,
    this.languages,
    this.initialFavorites,
    this.showFavoritesSection = true,
    this.favoritesTitle = 'Favorites',
    this.languageService,
    this.maxHeight,
    this.showNativeNames = true,
    this.showDividers = true,
    this.showFavoritesFirst = true,
  }) : super(key: key);

  @override
  CustomLanguagePickerDialogState createState() => CustomLanguagePickerDialogState();
}

class CustomLanguagePickerDialogState extends State<CustomLanguagePickerDialog> {
  late LanguageService _languageService;
  late TextEditingController _searchController;
  String _searchQuery = '';
  List<Language> _filteredLanguages = [];
  List<Language> _displayedLanguages = [];

  final ScrollController _scrollController = ScrollController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Initialize search controller
    _searchController = TextEditingController();

    // Initialize language service
    _languageService = widget.languageService ??
        LanguageService(
          languages: widget.languages,
          initialFavorites: widget.initialFavorites,
          onFavoritesChanged: widget.onFavoritesChanged,
          onLanguageSelected: widget.onValuePicked,
        );

    _updateDisplayedLanguages();

    // Set focus to search field if searchable
    if (widget.isSearchable) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_searchFocusNode);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _updateDisplayedLanguages() {
    if (_searchQuery.isEmpty) {
      if (widget.showFavoritesFirst && _languageService.favorites.isNotEmpty) {
        final nonFavorites = _languageService.languages
            .where((lang) => !lang.isFavorite)
            .toList();

        _displayedLanguages = [
          ..._languageService.favorites,
          ...nonFavorites,
        ];
      } else {
        _displayedLanguages = List.from(_languageService.languages);
      }
    } else {
      _displayedLanguages = _languageService.filterLanguages(_searchQuery);
    }

    _filteredLanguages = _displayedLanguages;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final double dialogHeight = widget.maxHeight ??
        mediaQuery.size.height * (mediaQuery.size.height > 700 ? 0.7 : 0.8);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      elevation: 8,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: dialogHeight,
          maxWidth: 400,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Dialog header with title and close button
            _buildHeader(theme),

            // Search field if enabled
            if (widget.isSearchable) _buildSearchField(theme),

            // Favorites section if enabled
            if (widget.showFavoritesSection &&
                _languageService.favorites.isNotEmpty &&
                _searchQuery.isEmpty)
              _buildFavoritesSection(theme),

            // Language list
            Flexible(
              child: _filteredLanguages.isEmpty
                  ? widget.searchEmptyView ?? _buildEmptyView(theme)
                  : _buildLanguageList(theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: widget.titlePadding ?? const EdgeInsets.fromLTRB(20, 16, 12, 16),
      child: Row(
        children: [
          Expanded(
            child: widget.title ??
                Text(
                  widget.titleText ?? 'Select Language',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          ),
          IconButton(
            icon: Icon(
              Icons.close,
              color: theme.colorScheme.onPrimary,
            ),
            onPressed: () => Navigator.of(context).pop(),
            splashRadius: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        decoration: widget.searchInputDecoration ??
            InputDecoration(
              hintText: 'Search language',
              prefixIcon: const Icon(Icons.search),
              prefixIconColor: theme.colorScheme.primary.withOpacity(0.7),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    _searchController.clear();
                    _searchQuery = '';
                    _updateDisplayedLanguages();
                  });
                },
              )
                  : null,
              filled: true,
              fillColor: theme.colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: theme.colorScheme.outline.withOpacity(0.5),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: theme.colorScheme.outline.withOpacity(0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: theme.colorScheme.primary,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
        cursorColor: widget.searchCursorColor ?? theme.colorScheme.primary,
        style: theme.textTheme.bodyLarge,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
            _updateDisplayedLanguages();
          });
        },
      ),
    );
  }

  Widget _buildFavoritesSection(ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 16, 8),
          child: Row(
            children: [
              Icon(
                Icons.star_rounded,
                size: 18,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                widget.favoritesTitle,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 64,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              },
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _languageService.favorites.length,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemBuilder: (context, index) {
                final language = _languageService.favorites[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        _languageService.selectLanguage(language);
                        if (widget.onValuePicked != null) {
                          widget.onValuePicked!(language);
                        }
                        Navigator.pop(context);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Chip(
                          backgroundColor: theme.colorScheme.primaryContainer.withOpacity(0.7),
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          avatar: CircleAvatar(
                            backgroundColor: theme.colorScheme.primaryContainer,
                            child: Text(language.flagEmoji),
                          ),
                          label: Text(
                            language.name,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          deleteIcon: Icon(
                            Icons.star,
                            size: 18,
                            color: theme.colorScheme.primary,
                          ),
                          onDeleted: () {
                            setState(() {
                              _languageService.toggleFavorite(language);
                              _updateDisplayedLanguages();
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        if (widget.showDividers) const Divider(height: 1),
      ],
    );
  }

  Widget _buildLanguageList(ThemeData theme) {

    return ListView.separated(
      controller: _scrollController,
      itemCount: _filteredLanguages.length,
      shrinkWrap: true,
      padding: EdgeInsets.only(
        top: 8,
        bottom: 16,
        left: 0,
        right: 0,
      ),
      separatorBuilder: (context, index) {
        if (!widget.showDividers) return const SizedBox(height: 1);
        return Divider(
          height: 1,
          thickness: 0.5,
          indent: 68,
          endIndent: 0,
          color: theme.dividerColor.withOpacity(0.5),
        );
      },
      itemBuilder: (context, index) {
        final language = _filteredLanguages[index];
        final bool isSelected = _languageService.selectedLanguage?.code == language.code;

        return Material(
          color: isSelected
              ? theme.colorScheme.primaryContainer.withOpacity(0.3)
              : Colors.transparent,
          child: InkWell(
            onTap: () {
              _languageService.selectLanguage(language);
              if (widget.onValuePicked != null) {
                widget.onValuePicked!(language);
              }
              Navigator.pop(context);
            },
            child: widget.itemBuilder != null
                ? widget.itemBuilder!(
              language,
              isFavorite: language.isFavorite,
              onFavoriteToggle: () => _toggleFavorite(language),
            )
                : _buildDefaultLanguageItem(language, theme, isSelected),
          ),
        );
      },
    );
  }

  Widget _buildDefaultLanguageItem(Language language, ThemeData theme, bool isSelected) {
    // Show highlight for matches when searching
    Widget buildHighlightedText(String text, TextStyle? style) {
      if (_searchQuery.isEmpty) {
        return Text(text, style: style);
      }

      final lowerQuery = _searchQuery.toLowerCase();
      final lowerText = text.toLowerCase();

      if (!lowerText.contains(lowerQuery)) {
        return Text(text, style: style);
      }

      final spans = <TextSpan>[];
      int start = 0;
      int indexOfMatch;

      while (true) {
        indexOfMatch = lowerText.indexOf(lowerQuery, start);
        if (indexOfMatch < 0) break;

        if (indexOfMatch > start) {
          spans.add(TextSpan(
            text: text.substring(start, indexOfMatch),
            style: style,
          ));
        }

        spans.add(TextSpan(
          text: text.substring(indexOfMatch, indexOfMatch + _searchQuery.length),
          style: style?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
            backgroundColor: theme.colorScheme.primaryContainer.withOpacity(0.3),
          ),
        ));

        start = indexOfMatch + _searchQuery.length;
      }

      if (start < text.length) {
        spans.add(TextSpan(
          text: text.substring(start),
          style: style,
        ));
      }

      return RichText(text: TextSpan(children: spans));
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        border: isSelected
            ? Border(
          left: BorderSide(
            color: theme.colorScheme.primary,
            width: 4,
          ),
        )
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            child: Text(
              language.flagEmoji,
              style: const TextStyle(fontSize: 28),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildHighlightedText(
                  language.name,
                  theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.textTheme.bodyLarge?.color,
                  ),
                ),
                if (widget.showNativeNames && language.nativeName.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  buildHighlightedText(
                    language.nativeName,
                    theme.textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? theme.colorScheme.primary.withOpacity(0.7)
                          : theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              language.isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
              color: language.isFavorite ? Colors.amber : theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
              size: 24,
            ),
            onPressed: () => _toggleFavorite(language),
            splashRadius: 20,
            tooltip: language.isFavorite ? 'Remove from favorites' : 'Add to favorites',
          ),
        ],
      ),
    );
  }

  void _toggleFavorite(Language language) {
    setState(() {
      _languageService.toggleFavorite(language);
      _updateDisplayedLanguages();
    });
  }

  Widget _buildEmptyView(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64,
              color: theme.colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No languages found',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try a different search term',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Public method to access the language service
  LanguageService get languageService => _languageService;
}