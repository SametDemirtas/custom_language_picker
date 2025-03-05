import 'package:custom_language_picker/src/models/language.dart';
import 'package:flutter/widgets.dart';


class LanguagePickerDropdownController extends ValueNotifier<Language> {
  /// @param value the pre-selected value. Note that LanguagePickerDropdown's
  /// `initialValue` takes precedence over this parameter.
  LanguagePickerDropdownController(Language value) : super(value);
}