import 'dart:ui';

import 'package:custom_language_picker/src/models/language.dart';
import 'package:flutter/material.dart';
import 'package:custom_language_picker/src/services/language_servis.dart';
import 'package:custom_language_picker/typedefs.dart';

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

  /// Search hint text
  final String searchHintText;

  /// Custom color for the dialog background
  final Color? dialogBackgroundColor;

  /// Custom color for the header background
  final Color? headerBackgroundColor;

  /// Custom color for the header text
  final Color? headerTextColor;

  /// Custom shadow for the header
  final List<BoxShadow>? headerShadow;

  /// Custom close icon for the header
  final IconData? closeIcon;

  /// Custom color for the close icon
  final Color? closeIconColor;

  /// Border radius for the dialog
  final double dialogBorderRadius;

  /// Elevation for the dialog
  final double dialogElevation;

  /// Color for the search text
  final Color? searchTextColor;

  /// Background color for the search field
  final Color? searchBackgroundColor;

  /// Border color for the search field
  final Color? searchBorderColor;

  /// Focused border color for the search field
  final Color? searchFocusedBorderColor;

  /// Color for the search icon
  final Color? searchIconColor;

  /// Color for the search clear icon
  final Color? searchClearIconColor;

  /// Border radius for the search field
  final double searchBorderRadius;

  /// Color for the favorites section title
  final Color? favoritesTitleColor;

  /// Color for the favorites section icon
  final Color? favoritesIconColor;

  /// Background color for the favorites chips
  final Color? favoritesChipBackgroundColor;

  /// Text color for the favorites chips
  final Color? favoritesChipTextColor;

  /// Avatar background color for the favorites chips
  final Color? favoritesChipAvatarBackgroundColor;

  /// Icon color for the favorites chip delete icon
  final Color? favoritesChipDeleteIconColor;

  /// Background color for the selected item
  final Color? selectedItemBackgroundColor;

  /// Text color for the selected item
  final Color? selectedItemTextColor;

  /// Left border color for the selected item
  final Color? selectedItemBorderColor;

  /// Left border width for the selected item
  final double selectedItemBorderWidth;

  /// Color for the dividers
  final Color? dividerColor;

  /// Color for the favorite icon when active
  final Color? favoriteIconActiveColor;

  /// Color for the favorite icon when inactive
  final Color? favoriteIconInactiveColor;

  /// Color for the no results text
  final Color? noResultsTextColor;

  /// Color for the no results icon
  final Color? noResultsIconColor;

  /// Color for the search highlight
  final Color? searchHighlightColor;

  /// Background color for the search highlight
  final Color? searchHighlightBackgroundColor;

  /// Whether to show a close button in the header
  final bool showCloseButton;

  /// Custom style for the dialog
  final BoxDecoration? dialogDecoration;

  /// Custom style for the header
  final BoxDecoration? headerDecoration;

  /// Custom style for the search field container
  final BoxDecoration? searchContainerDecoration;

  /// Custom style for the favorites section container
  final BoxDecoration? favoritesSectionDecoration;

  /// Custom text to display when no search results are found
  final String noResultsText;

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
    this.searchHintText = 'Search language',
    this.dialogBackgroundColor,
    this.headerBackgroundColor,
    this.headerTextColor,
    this.headerShadow,
    this.closeIcon,
    this.closeIconColor,
    this.dialogBorderRadius = 20.0,
    this.dialogElevation = 8.0,
    this.searchTextColor,
    this.searchBackgroundColor,
    this.searchBorderColor,
    this.searchFocusedBorderColor,
    this.searchIconColor,
    this.searchClearIconColor,
    this.searchBorderRadius = 12.0,
    this.favoritesTitleColor,
    this.favoritesIconColor,
    this.favoritesChipBackgroundColor,
    this.favoritesChipTextColor,
    this.favoritesChipAvatarBackgroundColor,
    this.favoritesChipDeleteIconColor,
    this.selectedItemBackgroundColor,
    this.selectedItemTextColor,
    this.selectedItemBorderColor,
    this.selectedItemBorderWidth = 4.0,
    this.dividerColor,
    this.favoriteIconActiveColor,
    this.favoriteIconInactiveColor,
    this.noResultsTextColor,
    this.noResultsIconColor,
    this.searchHighlightColor,
    this.searchHighlightBackgroundColor,
    this.showCloseButton = true,
    this.dialogDecoration,
    this.headerDecoration,
    this.searchContainerDecoration,
    this.favoritesSectionDecoration,
    this.noResultsText = 'No languages found',
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
        borderRadius: BorderRadius.circular(widget.dialogBorderRadius),
      ),
      clipBehavior: Clip.antiAlias,
      elevation: widget.dialogElevation,
      backgroundColor: widget.dialogBackgroundColor,
      child: widget.dialogDecoration != null
          ? Container(
        decoration: widget.dialogDecoration,
        child: _buildDialogContent(theme, dialogHeight),
      )
          : _buildDialogContent(theme, dialogHeight),
    );
  }

  Widget _buildDialogContent(ThemeData theme, double dialogHeight) {
    return ConstrainedBox(
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
    );
  }

  Widget _buildHeader(ThemeData theme) {
    final headerBg = widget.headerBackgroundColor ?? theme.colorScheme.primary;
    final headerText = widget.headerTextColor ?? theme.colorScheme.onPrimary;
    final closeIconColor = widget.closeIconColor ?? theme.colorScheme.onPrimary;
    final closeIconData = widget.closeIcon ?? Icons.close;

    final defaultShadow = [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ];

    final headerContainer = Container(
      decoration: widget.headerDecoration ?? BoxDecoration(
        color: headerBg,
        boxShadow: widget.headerShadow ?? defaultShadow,
      ),
      padding: widget.titlePadding ?? const EdgeInsets.fromLTRB(20, 16, 12, 16),
      child: Row(
        children: [
          Expanded(
            child: widget.title ??
                Text(
                  widget.titleText ?? 'Select Language',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: headerText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          ),
          if (widget.showCloseButton)
            IconButton(
              icon: Icon(
                closeIconData,
                color: closeIconColor,
              ),
              onPressed: () => Navigator.of(context).pop(),
              splashRadius: 24,
            ),
        ],
      ),
    );

    return headerContainer;
  }

  Widget _buildSearchField(ThemeData theme) {
    final searchTextColor = widget.searchTextColor ?? theme.textTheme.bodyLarge?.color;
    final searchBgColor = widget.searchBackgroundColor ?? theme.colorScheme.surface;
    final searchBorderColor = widget.searchBorderColor ?? theme.colorScheme.outline.withOpacity(0.3);
    final searchFocusedBorderColor = widget.searchFocusedBorderColor ?? theme.colorScheme.primary;
    final searchIconColor = widget.searchIconColor ?? theme.colorScheme.primary.withOpacity(0.7);
    final searchClearIconColor = widget.searchClearIconColor ?? theme.colorScheme.onSurface.withOpacity(0.7);
    final cursorColor = widget.searchCursorColor ?? theme.colorScheme.primary;

    return Container(
      decoration: widget.searchContainerDecoration,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        decoration: widget.searchInputDecoration ??
            InputDecoration(
              hintText: widget.searchHintText,
              prefixIcon: Icon(Icons.search, color: searchIconColor),
              prefixIconColor: searchIconColor,
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                icon: Icon(Icons.clear, color: searchClearIconColor),
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
              fillColor: searchBgColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.searchBorderRadius),
                borderSide: BorderSide(
                  color: searchBorderColor,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.searchBorderRadius),
                borderSide: BorderSide(
                  color: searchBorderColor,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.searchBorderRadius),
                borderSide: BorderSide(
                  color: searchFocusedBorderColor,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
        cursorColor: cursorColor,
        style: theme.textTheme.bodyLarge?.copyWith(color: searchTextColor),
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
    final favoritesTitleColor = widget.favoritesTitleColor ?? theme.colorScheme.primary;
    final favoritesIconColor = widget.favoritesIconColor ?? theme.colorScheme.primary;
    final favChipBgColor = widget.favoritesChipBackgroundColor ?? theme.colorScheme.primaryContainer.withOpacity(0.7);
    final favChipTextColor = widget.favoritesChipTextColor ?? theme.textTheme.bodyMedium?.color;
    final favChipAvatarBgColor = widget.favoritesChipAvatarBackgroundColor ?? theme.colorScheme.primaryContainer;
    final favChipDeleteIconColor = widget.favoritesChipDeleteIconColor ?? theme.colorScheme.primary;

    return Container(
      decoration: widget.favoritesSectionDecoration,
      child: Column(
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
                  color: favoritesIconColor,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.favoritesTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: favoritesTitleColor,
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
                            backgroundColor: favChipBgColor,
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            avatar: CircleAvatar(
                              backgroundColor: favChipAvatarBgColor,
                              child: Text(language.flagEmoji),
                            ),
                            label: Text(
                              language.name,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: favChipTextColor,
                              ),
                            ),
                            deleteIcon: Icon(
                              Icons.star,
                              size: 18,
                              color: favChipDeleteIconColor,
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
          if (widget.showDividers) Divider(
            height: 1,
            color: widget.dividerColor ?? theme.dividerColor.withOpacity(0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageList(ThemeData theme) {
    final customDividerColor = widget.dividerColor ?? theme.dividerColor.withOpacity(0.5);

    return ListView.separated(
      controller: _scrollController,
      itemCount: _filteredLanguages.length,
      shrinkWrap: true,
      padding: const EdgeInsets.only(
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
          color: customDividerColor,
        );
      },
      itemBuilder: (context, index) {
        final language = _filteredLanguages[index];
        final bool isSelected = _languageService.selectedLanguage?.code == language.code;
        final selectedBgColor = widget.selectedItemBackgroundColor ?? theme.colorScheme.primaryContainer.withOpacity(0.3);

        return Material(
          color: isSelected ? selectedBgColor : Colors.transparent,
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
    final selectedTextColor = widget.selectedItemTextColor ?? theme.colorScheme.primary;
    final selectedBorderColor = widget.selectedItemBorderColor ?? theme.colorScheme.primary;
    final favoriteActiveColor = widget.favoriteIconActiveColor ?? Colors.amber;
    final favoriteInactiveColor = widget.favoriteIconInactiveColor ?? theme.colorScheme.onSurfaceVariant.withOpacity(0.5);
    final highlightColor = widget.searchHighlightColor ?? theme.colorScheme.primary;
    final highlightBgColor = widget.searchHighlightBackgroundColor ?? theme.colorScheme.primaryContainer.withOpacity(0.3);

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
            color: highlightColor,
            backgroundColor: highlightBgColor,
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
            color: selectedBorderColor,
            width: widget.selectedItemBorderWidth,
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
                        ? selectedTextColor
                        : theme.textTheme.bodyLarge?.color,
                  ),
                ),
                if (widget.showNativeNames && language.nativeName.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  buildHighlightedText(
                    language.nativeName,
                    theme.textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? selectedTextColor.withOpacity(0.7)
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
              color: language.isFavorite ? favoriteActiveColor : favoriteInactiveColor,
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
    final noResultsTextColor = widget.noResultsTextColor ?? theme.colorScheme.onSurface.withOpacity(0.7);
    final noResultsIconColor = widget.noResultsIconColor ?? theme.colorScheme.onSurface.withOpacity(0.3);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64,
              color: noResultsIconColor,
            ),
            const SizedBox(height: 16),
            Text(
              widget.noResultsText,
              style: theme.textTheme.titleMedium?.copyWith(
                color: noResultsTextColor,
                fontWeight: FontWeight.w500,
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