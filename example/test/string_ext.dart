extension StringExt on String {
  bool get isChinese => matchRegExp("$_chinese$_space$_punctuation");

  bool get isEnglish => matchRegExp("$_english$_space$_punctuation");

  bool get isDigits => matchRegExp("$_digits$_space$_punctuation");

  bool get isChineseOrEnglish =>
      matchRegExp("$_chinese$_english$_space$_punctuation");

  bool get isChineseOrDigits =>
      matchRegExp("$_chinese$_digits$_space$_punctuation");

  bool get isEnglishOrDigits =>
      matchRegExp("$_english$_digits$_space$_punctuation");

  bool get isChineseOrEnglishOrDigits =>
      matchRegExp("$_chinese$_english$_digits$_space$_punctuation");

  bool get isPunctuation => matchRegExp(_punctuation);

  bool matchRegExp(String regExp) => RegExp('^[$regExp]+\$').hasMatch(this);
}

const String _chinese = "\\u4e00-\\u9fa5";
const String _english = "a-zA-Z";
const String _digits = "\\d";
const String _space = "\\s";
const String _chinesePunctuation = "·—“”‘’！。，、：；？";
const String _englishPunctuation = "!\"#\$%&'()*+,-./:;<=>?@[\\]^_`{|}~";
const String _punctuation = _chinesePunctuation + _englishPunctuation;
