import 'package:custom_language_picker/src/services/language_servis.dart';
import 'package:flutter/material.dart';
import 'package:custom_language_picker/typedefs.dart';
import 'package:custom_language_picker/src/models/language.dart';
import 'package:custom_language_picker/src/models/language_code.dart';

/// Provides a customizable [DropdownButton] for all languages with favorites support and search functionality
class CustomLanguagePickerDropdown extends StatefulWidget {
  /// This function will be called to build the child of DropdownMenuItem
  final LanguageItemBuilder? itemBuilder;

  /// Preselected language
  final Language? initialValue;

  /// This function will be called whenever a Language item is selected
  final OnLanguageSelected? onValuePicked;

  /// This function will be called whenever favorites are changed
  final OnFavoritesChanged? onFavoritesChanged;

  /// List of languages available in this picker
  final List<Language>? languages;

  /// List of initial favorite languages
  final List<Language>? initialFavorites;

  /// Whether to show favorites at the top of the dropdown list
  final bool showFavoritesFirst;

  /// The language service to use
  final LanguageService? languageService;

  /// Whether to enable search functionality
  final bool isSearchable;

  /// Label for the dropdown when collapsed
  final String? dropdownLabel;

  /// Hint text for the search field
  final String searchHintText;

  /// Whether to show native language names
  final bool showNativeNames;

  /// Custom decoration for the dropdown button
  final BoxDecoration? dropdownDecoration;

  /// Custom style for the dropdown button
  final ButtonStyle? dropdownButtonStyle;

  /// Custom search input decoration
  final InputDecoration? searchInputDecoration;

  /// Custom color for the dropdown button background
  final Color? dropdownBackgroundColor;

  /// Custom color for the dropdown button text
  final Color? dropdownTextColor;

  /// Custom color for the dropdown button border
  final Color? dropdownBorderColor;

  /// Custom color for the dropdown button icon
  final Color? dropdownIconColor;

  /// Custom color for the search highlight
  final Color? searchHighlightColor;

  /// Custom color for the search highlight background
  final Color? searchHighlightBackgroundColor;

  /// Custom color for the dropdown item highlight when selected
  final Color? selectedItemColor;

  /// Custom color for the dropdown item background when selected
  final Color? selectedItemBackgroundColor;

  /// Custom color for the favorite icon when active
  final Color? favoriteIconActiveColor;

  /// Custom color for the favorite icon when inactive
  final Color? favoriteIconInactiveColor;

  /// Custom color for the dropdown overlay background
  final Color? dropdownOverlayColor;

  /// Custom color for the dropdown overlay shadow
  final Color? dropdownOverlayShadowColor;

  /// Custom color for the dropdown divider
  final Color? dividerColor;

  /// Custom color for the favorites section label
  final Color? favoritesSectionLabelColor;

  /// Custom color for the favorites section icon
  final Color? favoritesSectionIconColor;

  /// Custom color for the favorites section background
  final Color? favoritesSectionBackgroundColor;

  /// Custom color for the search field text
  final Color? searchFieldTextColor;

  /// Custom color for the search field background
  final Color? searchFieldBackgroundColor;

  /// Custom color for the search field border when focused
  final Color? searchFieldFocusedBorderColor;

  /// Custom color for the search field hint text
  final Color? searchFieldHintColor;

  /// Custom color for the search field cursor
  final Color? searchFieldCursorColor;

  /// Custom color for the no results text
  final Color? noResultsTextColor;

  /// Custom color for the no results icon
  final Color? noResultsIconColor;

  /// Custom elevation for the dropdown overlay
  final double? dropdownOverlayElevation;

  /// Custom border radius for the dropdown button
  final double dropdownBorderRadius;

  /// Custom border radius for the dropdown overlay
  final double dropdownOverlayBorderRadius;

  /// Custom border width for the dropdown button
  final double dropdownBorderWidth;

  /// Favorite section label text
  final String favoritesSectionLabel;

  const CustomLanguagePickerDropdown({
    Key? key,
    this.itemBuilder,
    this.initialValue,
    this.onValuePicked,
    this.onFavoritesChanged,
    this.languages,
    this.initialFavorites,
    this.showFavoritesFirst = true,
    this.languageService,
    this.isSearchable = true,
    this.dropdownLabel,
    this.searchHintText = 'Search languages...',
    this.showNativeNames = true,
    this.dropdownDecoration,
    this.dropdownButtonStyle,
    this.searchInputDecoration,
    this.dropdownBackgroundColor,
    this.dropdownTextColor,
    this.dropdownBorderColor,
    this.dropdownIconColor,
    this.searchHighlightColor,
    this.searchHighlightBackgroundColor,
    this.selectedItemColor,
    this.selectedItemBackgroundColor,
    this.favoriteIconActiveColor,
    this.favoriteIconInactiveColor,
    this.dropdownOverlayColor,
    this.dropdownOverlayShadowColor,
    this.dividerColor,
    this.favoritesSectionLabelColor,
    this.favoritesSectionIconColor,
    this.favoritesSectionBackgroundColor,
    this.searchFieldTextColor,
    this.searchFieldBackgroundColor,
    this.searchFieldFocusedBorderColor,
    this.searchFieldHintColor,
    this.searchFieldCursorColor,
    this.noResultsTextColor,
    this.noResultsIconColor,
    this.dropdownOverlayElevation = 8.0,
    this.dropdownBorderRadius = 8.0,
    this.dropdownOverlayBorderRadius = 12.0,
    this.dropdownBorderWidth = 1.0,
    this.favoritesSectionLabel = 'Favorites',
  }) : super(key: key);

  @override
  CustomLanguagePickerDropdownState createState() => CustomLanguagePickerDropdownState();
}

class CustomLanguagePickerDropdownState extends State<CustomLanguagePickerDropdown> {
  late LanguageService _languageService;
  late List<Language> _displayedLanguages;
  bool _isDropdownOpen = false;
  final LayerLink _layerLink = LayerLink();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';
  OverlayEntry? _overlayEntry;

  final GlobalKey _dropdownKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    // Initialize language service
    _languageService = widget.languageService ??
        LanguageService(
          languages: widget.languages,
          initialFavorites: widget.initialFavorites,
          initialLanguage: widget.initialValue,
          onFavoritesChanged: widget.onFavoritesChanged,
          onLanguageSelected: widget.onValuePicked,
        );

    _updateDisplayedLanguages();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _updateDisplayedLanguages() {
    List<Language> filteredLanguages;

    // Filter by search query if it exists
    if (_searchQuery.isNotEmpty) {
      filteredLanguages = _languageService.filterLanguages(_searchQuery);
    } else {
      filteredLanguages = List.from(_languageService.languages);
    }

    // Sort favorites first if needed
    if (widget.showFavoritesFirst && _languageService.favorites.isNotEmpty && _searchQuery.isEmpty) {
      final favoriteLanguages = filteredLanguages
          .where((lang) => lang.isFavorite)
          .toList();

      final nonFavoriteLanguages = filteredLanguages
          .where((lang) => !lang.isFavorite)
          .toList();

      _displayedLanguages = [
        ...favoriteLanguages,
        if (favoriteLanguages.isNotEmpty)
          Language(
            code: LanguageCode.en,
            name: '──────────',
            nativeName: '',
            flagEmoji: '',
            isFavorite: false,
          ),
        ...nonFavoriteLanguages,
      ];
    } else {
      _displayedLanguages = filteredLanguages;
    }
  }

  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _removeOverlay();
    } else {
      _createOverlay();
    }

    setState(() {
      _isDropdownOpen = !_isDropdownOpen;
    });
  }

  void _createOverlay() {
    _removeOverlay();

    final RenderBox renderBox = _dropdownKey.currentContext!.findRenderObject() as RenderBox;
    final Size size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        final theme = Theme.of(context);
        final maxHeight = MediaQuery.of(context).size.height * 0.5;

        return Positioned(
          width: size.width,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, size.height + 4),
            child: Material(
              elevation: widget.dropdownOverlayElevation ?? 8,
              borderRadius: BorderRadius.circular(widget.dropdownOverlayBorderRadius),
              clipBehavior: Clip.antiAlias,
              color: widget.dropdownOverlayColor ?? theme.cardColor,
              shadowColor: widget.dropdownOverlayShadowColor ?? Colors.black38,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: maxHeight,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: widget.dropdownBorderColor ?? theme.dividerColor.withOpacity(0.2),
                    width: widget.dropdownBorderWidth,
                  ),
                  borderRadius: BorderRadius.circular(widget.dropdownOverlayBorderRadius),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Search field
                    if (widget.isSearchable) _buildSearchBox(theme),

                    // Results list
                    Flexible(
                      child: _displayedLanguages.isEmpty
                          ? _buildEmptySearchResults(theme)
                          : _buildLanguageList(theme, maxHeight),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);


    // Set focus to search field
    if (widget.isSearchable) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_searchFocusNode.canRequestFocus) {
          _searchFocusNode.requestFocus();
        }
      });
    }
  }

  void _removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;


      // Clear search query
      if (_searchController.text.isNotEmpty) {
        _searchController.clear();
        _searchQuery = '';
        _updateDisplayedLanguages();
      }
    }
  }

  Widget _buildSearchBox(ThemeData theme) {
    final hintColor = widget.searchFieldHintColor ?? theme.hintColor;
    final textColor = widget.searchFieldTextColor ?? theme.textTheme.bodyMedium?.color;
    final backgroundColor = widget.searchFieldBackgroundColor ?? theme.inputDecorationTheme.fillColor ?? theme.cardColor;
    final focusedBorderColor = widget.searchFieldFocusedBorderColor ?? theme.colorScheme.primary;
    final cursorColor = widget.searchFieldCursorColor ?? theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: widget.dividerColor ?? theme.dividerColor.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        decoration: widget.searchInputDecoration ?? InputDecoration(
          hintText: widget.searchHintText,
          hintStyle: TextStyle(color: hintColor),
          isDense: true,
          prefixIcon: Icon(Icons.search, size: 20, color: hintColor),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
            icon: Icon(Icons.clear, size: 18, color: hintColor),
            splashRadius: 16,
            onPressed: () {
              _searchController.clear();
              setState(() {
                _searchQuery = '';
                _updateDisplayedLanguages();
              });
            },
          )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: widget.dropdownBorderColor ?? theme.dividerColor.withOpacity(0.3),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: widget.dropdownBorderColor ?? theme.dividerColor.withOpacity(0.2),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: focusedBorderColor,
              width: 1.5,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          filled: true,
          fillColor: backgroundColor,
        ),
        style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
        cursorColor: cursorColor,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
            _updateDisplayedLanguages();
            if (_overlayEntry != null) {
              _overlayEntry!.markNeedsBuild();
            }
          });
        },
      ),
    );
  }

  Widget _buildLanguageList(ThemeData theme, double maxHeight) {
    final isSearchActive = _searchQuery.isNotEmpty;
    final customDividerColor = widget.dividerColor ?? theme.dividerColor.withOpacity(0.2);

    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: _displayedLanguages.length,
      separatorBuilder: (context, index) {
        // Check if this is the divider between favorites and other languages
        if (_displayedLanguages[index].name == '──────────') {
          return const SizedBox.shrink();
        }

        return Divider(
          height: 1,
          thickness: 0.5,
          indent: isSearchActive ? 0 : 56,
          endIndent: 0,
          color: customDividerColor,
        );
      },
      itemBuilder: (context, index) {
        final language = _displayedLanguages[index];

        // Check if this is a divider item
        if (language.name == '──────────') {
          return Container(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
            decoration: BoxDecoration(
              color: widget.favoritesSectionBackgroundColor ?? theme.dividerColor.withOpacity(0.05),
            ),
            child: Row(
              children: [
                Icon(
                    Icons.star,
                    size: 14,
                    color: widget.favoritesSectionIconColor ?? Colors.amber
                ),
                const SizedBox(width: 6),
                Text(
                  widget.favoritesSectionLabel,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: widget.favoritesSectionLabelColor ??
                        theme.textTheme.bodySmall?.color?.withOpacity(0.8),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Container(
                    height: 1,
                    margin: const EdgeInsets.only(left: 4),
                    color: customDividerColor,
                  ),
                ),
              ],
            ),
          );
        }

        final isSelected = _languageService.selectedLanguage?.code == language.code;
        final selectedBgColor = widget.selectedItemBackgroundColor ?? theme.highlightColor;

        return InkWell(
          onTap: () {
            _selectLanguage(language);
          },
          child: Container(
            color: isSelected ? selectedBgColor : null,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            child: widget.itemBuilder != null
                ? widget.itemBuilder!(
              language,
              isFavorite: language.isFavorite,
              onFavoriteToggle: () => _toggleFavorite(language),
            )
                : _buildDefaultMenuItem(language, theme, isSelected),
          ),
        );
      },
    );
  }

  Widget _buildDefaultMenuItem(Language language, ThemeData theme, bool isSelected) {
    // Default colors that can be overridden
    final textColor = isSelected
        ? (widget.selectedItemColor ?? theme.colorScheme.primary)
        : (widget.dropdownTextColor ?? theme.textTheme.bodyMedium?.color);

    final highlightColor = widget.searchHighlightColor ?? theme.colorScheme.primary;
    final highlightBgColor = widget.searchHighlightBackgroundColor ?? theme.colorScheme.primary.withOpacity(0.1);

    final favoriteActiveColor = widget.favoriteIconActiveColor ?? Colors.amber;
    final favoriteInactiveColor = widget.favoriteIconInactiveColor ?? theme.disabledColor;

    // Show highlight for matches when searching
    Widget buildHighlightedText(String text, TextStyle? style) {
      if (_searchQuery.isEmpty) {
        return Text(
          text,
          style: style,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );
      }

      final lowerQuery = _searchQuery.toLowerCase();
      final lowerText = text.toLowerCase();

      if (!lowerText.contains(lowerQuery)) {
        return Text(
          text,
          style: style,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );
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

      return RichText(
        text: TextSpan(children: spans),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    return Row(
      children: [
        Text(
          language.flagEmoji,
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              buildHighlightedText(
                language.name,
                theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: textColor,
                  height: 1.2,
                ),
              ),
              if (widget.showNativeNames && language.nativeName.isNotEmpty) ...[
                const SizedBox(height: 2),
                buildHighlightedText(
                  language.nativeName,
                  theme.textTheme.bodySmall?.copyWith(
                    color: textColor?.withOpacity(0.7),
                    fontSize: 12,
                    height: 1.2,
                  ),
                ),
              ],
            ],
          ),
        ),
        IconButton(
          icon: Icon(
            language.isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
            size: 20,
            color: language.isFavorite ? favoriteActiveColor : favoriteInactiveColor,
          ),
          onPressed: () => _toggleFavorite(language),
          constraints: const BoxConstraints(
            minWidth: 32,
            minHeight: 32,
          ),
          padding: EdgeInsets.zero,
          splashRadius: 20,
          tooltip: language.isFavorite ? 'Remove from favorites' : 'Add to favorites',
        ),
      ],
    );
  }

  Widget _buildEmptySearchResults(ThemeData theme) {
    final textColor = widget.noResultsTextColor ?? theme.textTheme.bodyMedium?.color;
    final iconColor = widget.noResultsIconColor ?? theme.disabledColor;

    return Container(
      padding: const EdgeInsets.all(24),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 40,
            color: iconColor,
          ),
          const SizedBox(height: 8),
          Text(
            'No languages found',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Try a different search term',
            style: theme.textTheme.bodySmall?.copyWith(
              color: textColor?.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  void _selectLanguage(Language language) {
    _languageService.selectLanguage(language);
    _toggleDropdown();
  }

  void _toggleFavorite(Language language) {
    setState(() {
      _languageService.toggleFavorite(language);
      _updateDisplayedLanguages();
      if (_overlayEntry != null) {
        _overlayEntry!.markNeedsBuild();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedLanguage = _languageService.selectedLanguage;

    // Apply custom colors or fallback to theme colors
    final backgroundColor = widget.dropdownBackgroundColor;
    final textColor = widget.dropdownTextColor ?? theme.textTheme.bodyMedium?.color;
    final borderColor = widget.dropdownBorderColor ?? theme.dividerColor.withOpacity(0.5);
    final iconColor = widget.dropdownIconColor ?? theme.iconTheme.color;

    return CompositedTransformTarget(
      link: _layerLink,
      child: Material(
        key: _dropdownKey,
        color: Colors.transparent,
        child: InkWell(
          onTap: _toggleDropdown,
          borderRadius: BorderRadius.circular(widget.dropdownBorderRadius),
          child: Container(
            decoration: widget.dropdownDecoration ?? BoxDecoration(
              color: backgroundColor,
              border: Border.all(
                color: borderColor,
                width: widget.dropdownBorderWidth,
              ),
              borderRadius: BorderRadius.circular(widget.dropdownBorderRadius),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            child: Row(
              children: [
                if (selectedLanguage != null) ...[
                  Text(
                    selectedLanguage.flagEmoji,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 8),
                ],

                Expanded(
                  child: Text(
                    selectedLanguage != null
                        ? "${selectedLanguage.name} ${widget.showNativeNames && selectedLanguage.nativeName.isNotEmpty ? '(${selectedLanguage.nativeName})' : ''}"
                        : widget.dropdownLabel ?? "Select Language",
                    style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                Icon(
                  _isDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: iconColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Public method to access the language service
  LanguageService get languageService => _languageService;
}