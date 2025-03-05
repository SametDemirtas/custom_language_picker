import 'language_code.dart';

/// Language class with all necessary information
class Language {
  final LanguageCode code;
  final String name;
  final String nativeName;
  final String flagEmoji;
  bool isFavorite;

  Language({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flagEmoji,
    this.isFavorite = false,
  });

  /// Convert to string for debugging
  @override
  String toString() => '$name ($code)';

  /// Get ISO code as string
  String get isoCode => code.code;

  /// Equals operator
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Language &&
              runtimeType == other.runtimeType &&
              code == other.code;

  /// Hashcode for language
  @override
  int get hashCode => code.hashCode;

  /// Create a copy of this language with different values
  Language copyWith({
    LanguageCode? code,
    String? name,
    String? nativeName,
    String? flagEmoji,
    bool? isFavorite,
  }) {
    return Language(
      code: code ?? this.code,
      name: name ?? this.name,
      nativeName: nativeName ?? this.nativeName,
      flagEmoji: flagEmoji ?? this.flagEmoji,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}