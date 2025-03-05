import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../typedefs.dart';
import '../../models/language.dart';
import '../../services/language_servis.dart';

const double defaultPickerSheetHeight = 300.0;
const double defaultPickerItemHeight = 40.0;

/// Provides a customizable language picker in Cupertino style with favorites support and search
class CustomLanguagePickerCupertino extends StatefulWidget {
  /// Callback that is called with selected language
  final OnLanguageSelected? onValuePicked;

  /// Callback that is called when favorites are changed
  final OnFavoritesChanged? onFavoritesChanged;

  /// Custom builder for language items
  final LanguageItemBuilder? itemBuilder;

  /// The height of each item in the picker
  final double pickerItemHeight;

  /// The height of the entire picker sheet
  final double pickerSheetHeight;

  /// The text style for items in the picker
  final TextStyle? textStyle;

  /// Relative ratio between this picker's height and the simulated cylinder's diameter
  final double diameterRatio;

  /// Background color behind the children
  final Color? backgroundColor;

  /// Off-axis fraction for the picker
  final double offAxisFraction;

  /// Whether to use magnifier effect
  final bool useMagnifier;

  /// Magnification factor
  final double magnification;

  /// A controller to read and control the current item
  final FixedExtentScrollController? scrollController;

  /// List of languages to display
  final List<Language>? languages;

  /// Initial list of favorite languages
  final List<Language>? initialFavorites;

  /// Whether to show favorites at the top of the picker
  final bool showFavoritesFirst;

  /// The language service to use (optional)
  final LanguageService? languageService;

  /// Whether to enable search functionality
  final bool isSearchable;

  /// Search placeholder text
  final String searchPlaceholder;

  /// Whether to show native language names
  final bool showNativeNames;

  /// Whether to show flag emojis
  final bool showFlags;

  /// Custom close button widget
  final Widget? closeButton;

  /// Custom title for the picker
  final Widget? title;

  const CustomLanguagePickerCupertino({
    Key? key,
    this.onValuePicked,
    this.onFavoritesChanged,
    this.itemBuilder,
    this.pickerItemHeight = defaultPickerItemHeight,
    this.pickerSheetHeight = defaultPickerSheetHeight,
    this.textStyle,
    this.diameterRatio = 1.07,
    this.backgroundColor,
    this.offAxisFraction = 0.0,
    this.useMagnifier = false,
    this.magnification = 1.0,
    this.scrollController,
    this.languages,
    this.initialFavorites,
    this.showFavoritesFirst = true,
    this.languageService,
    this.isSearchable = true,
    this.searchPlaceholder = 'Search languages',
    this.showNativeNames = true,
    this.showFlags = true,
    this.closeButton,
    this.title,
  }) : super(key: key);

  @override
  CustomLanguagePickerCupertinoState createState() => CustomLanguagePickerCupertinoState();
}

class CustomLanguagePickerCupertinoState extends State<CustomLanguagePickerCupertino> {
  late LanguageService _languageService;
  late List<Language> _displayedLanguages;
  late List<Language> _allLanguages;
  late FixedExtentScrollController _scrollController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isShowingSearch = false;

  @override
  void initState() {
    super.initState();

    // Initialize language service
    _languageService = widget.languageService ??
        LanguageService(
          languages: widget.languages,
          initialFavorites: widget.initialFavorites,
          onFavoritesChanged: widget.onFavoritesChanged,
          onLanguageSelected: widget.onValuePicked,
        );

    _allLanguages = List.from(_languageService.languages);
    _updateDisplayedLanguages();

    // Initialize scroll controller
    _scrollController = widget.scrollController ?? FixedExtentScrollController();

    // Set initial scroll position if we have a selected language
    if (_languageService.selectedLanguage != null) {
      final index = _displayedLanguages.indexWhere(
              (lang) => lang.code == _languageService.selectedLanguage!.code
      );
      if (index != -1) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.jumpToItem(index);
        });
      }
    }
  }

  @override
  void dispose() {
    // Only dispose the controller if we created it internally
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    _searchController.dispose();
    super.dispose();
  }

  void _updateDisplayedLanguages() {
    List<Language> filtered;

    // Filter by search query if not empty
    if (_searchQuery.isNotEmpty) {
      filtered = _allLanguages.where((language) {
        final name = language.name.toLowerCase();
        final nativeName = language.nativeName.toLowerCase();
        final isoCode = language.isoCode.toLowerCase();
        final query = _searchQuery.toLowerCase();

        return name.contains(query) ||
            nativeName.contains(query) ||
            isoCode.contains(query);
      }).toList();
    } else {
      filtered = List.from(_allLanguages);
    }

    // Show favorites first if enabled
    if (widget.showFavoritesFirst && _languageService.favorites.isNotEmpty && _searchQuery.isEmpty) {
      // Create a list with favorites first, followed by non-favorites
      final nonFavorites = filtered
          .where((lang) => !lang.isFavorite)
          .toList();

      final favorites = filtered
          .where((lang) => lang.isFavorite)
          .toList();

      _displayedLanguages = [
        ...favorites,
        ...nonFavorites,
      ];
    } else {
      _displayedLanguages = filtered;
    }

    // If no languages to display, show empty list
    if (_displayedLanguages.isEmpty) {
      _displayedLanguages = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    // Update displayed languages in case favorites changed
    _updateDisplayedLanguages();

    return Container(
      height: widget.pickerSheetHeight,
      color: widget.backgroundColor ?? CupertinoColors.systemBackground,
      child: Column(
        children: [
          // Header with search and optional title
          _buildHeader(),

          // Search field if enabled
          if (widget.isSearchable && _isShowingSearch)
            _buildSearchField(),

          // Picker or "No results" view
          Expanded(
            child: _displayedLanguages.isEmpty
                ? _buildEmptyResults()
                : _buildPicker(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? CupertinoColors.systemBackground,
        border: Border(
          bottom: BorderSide(
            color: CupertinoColors.separator,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // Title (if provided)
          if (widget.title != null)
            Expanded(child: widget.title!),

          // Search button (if searchable)
          if (widget.isSearchable)
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                setState(() {
                  _isShowingSearch = !_isShowingSearch;
                  if (!_isShowingSearch && _searchQuery.isNotEmpty) {
                    _searchController.clear();
                    _searchQuery = '';
                    _updateDisplayedLanguages();
                  }
                });
              },
              child: Icon(
                _isShowingSearch ? CupertinoIcons.clear : CupertinoIcons.search,
                color: CupertinoColors.activeBlue,
                size: 22,
              ),
            ),

          // Done/Close button
          widget.closeButton ??
              CupertinoButton(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Done'),
              ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: CupertinoSearchTextField(
        controller: _searchController,
        placeholder: widget.searchPlaceholder,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
            _updateDisplayedLanguages();
          });
        },
        onSubmitted: (value) {
          // If only one result, select it automatically
          if (_displayedLanguages.length == 1) {
            _selectLanguage(_displayedLanguages[0]);
          }
        },
        autocorrect: false,
      ),
    );
  }

  Widget _buildEmptyResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            CupertinoIcons.search,
            size: 48,
            color: CupertinoColors.systemGrey,
          ),
          const SizedBox(height: 16),
          Text(
            'No languages found',
            style: widget.textStyle ?? const TextStyle(
              color: CupertinoColors.systemGrey,
              fontSize: 16.0,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different search term',
            style: widget.textStyle?.copyWith(
              fontSize: 14.0,
              color: CupertinoColors.systemGrey,
            ) ?? const TextStyle(
              color: CupertinoColors.systemGrey,
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPicker() {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        // Hide keyboard when scrolling
        if (notification is ScrollStartNotification) {
          FocusScope.of(context).unfocus();
        }
        return false;
      },
      child: CupertinoPicker(
        itemExtent: widget.pickerItemHeight,
        backgroundColor: widget.backgroundColor ?? CupertinoColors.systemBackground,
        diameterRatio: widget.diameterRatio,
        offAxisFraction: widget.offAxisFraction,
        useMagnifier: widget.useMagnifier,
        magnification: widget.magnification,
        scrollController: _scrollController,
        selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
          background: CupertinoColors.activeBlue.withOpacity(0.1),
        ),
        children: _displayedLanguages.map((language) {
          return widget.itemBuilder != null
              ? widget.itemBuilder!(
            language,
            isFavorite: language.isFavorite,
            onFavoriteToggle: () => _toggleFavorite(language),
          )
              : _buildDefaultItem(language);
        }).toList(),
        onSelectedItemChanged: (int index) {
          if (_displayedLanguages.isNotEmpty) {
            final selectedLanguage = _displayedLanguages[index];
            _selectLanguage(selectedLanguage);
          }
        },
      ),
    );
  }

  void _selectLanguage(Language language) {
    _languageService.selectLanguage(language);
  }

  void _toggleFavorite(Language language) {
    setState(() {
      _languageService.toggleFavorite(language);
      _updateDisplayedLanguages();
    });
  }

  Widget _buildDefaultItem(Language language) {
    final isFavorite = language.isFavorite;

    // Highlight search term if present
    Widget buildHighlightedText(String text, {double? fontSize, Color? color}) {
      final TextStyle style = TextStyle(
        fontSize: fontSize ?? 16.0,
        color: color ?? CupertinoColors.label,
        height: 1.0, // Tighter line height to prevent overflow
      );

      if (_searchQuery.isEmpty) {
        return Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: style,
        );
      }

      final lowerQuery = _searchQuery.toLowerCase();
      final lowerText = text.toLowerCase();

      if (!lowerText.contains(lowerQuery)) {
        return Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: style,
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
          style: style.copyWith(
            fontWeight: FontWeight.bold,
            color: CupertinoColors.activeBlue,
            backgroundColor: CupertinoColors.activeBlue.withOpacity(0.1),
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

    // Simplified layout with fixed height container
    return Container(
      height: widget.pickerItemHeight,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      // Use alignment instead of Column when possible
      child: Row(
        children: [
          if (widget.showFlags) ...[
            Text(
              language.flagEmoji,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 12.0),
          ],

          // Either show just name or name + native name with fixed heights
          Expanded(
            child: widget.showNativeNames && language.nativeName.isNotEmpty
                ? SizedBox(
              height: widget.pickerItemHeight - 4, // Leave room for padding
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildHighlightedText(language.name),
                  SizedBox(height: 2), // Fixed small gap
                  buildHighlightedText(
                    language.nativeName,
                    fontSize: 12,
                    color: CupertinoColors.secondaryLabel,
                  ),
                ],
              ),
            )
                : Align(
              alignment: Alignment.centerLeft,
              child: buildHighlightedText(language.name),
            ),
          ),

          // Star icon - always centered vertically
          if (isFavorite)
            const Icon(
              CupertinoIcons.star_fill,
              color: CupertinoColors.systemYellow,
              size: 18,
            )
          else
            GestureDetector(
              onTap: () => _toggleFavorite(language),
              child: const Icon(
                CupertinoIcons.star,
                color: CupertinoColors.systemGrey,
                size: 18,
              ),
            ),
        ],
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
    );
  }

  /// Public method to access the language service
  LanguageService get languageService => _languageService;
}