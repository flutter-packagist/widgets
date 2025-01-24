// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'string_ext.dart';

void main() {
  test('test Text', () async {
    expect(true, '!.,?'.isPunctuation);
    expect(false, 'Hello!'.isPunctuation);
    expect(true, '！，。'.isPunctuation);
    expect(true, '！!'.isPunctuation);

    expect(false, 'Hello'.isChinese);
    expect(true, '你好！'.isChinese);
    expect(false, '你好，World'.isChinese);
    expect(false, 'Hello，世界'.isChinese);
    expect(false, '你好，my 世界'.isChinese);

    expect(true, 'Hello!'.isEnglish);
    expect(false, '你好'.isEnglish);
    expect(false, '你好，World'.isEnglish);
    expect(false, 'Hello，世界'.isEnglish);
    expect(false, '你好，my 世界'.isEnglish);

    expect(false, 'Hello'.isDigits);
    expect(false, '你好'.isDigits);
    expect(false, 'Hello 123'.isDigits);
    expect(false, '你好 123'.isDigits);
    expect(true, '123'.isDigits);

    expect(true, 'Hello'.isChineseOrEnglish);
    expect(true, '你好'.isChineseOrEnglish);
    expect(true, '你好 World'.isChineseOrEnglish);
    expect(true, 'Hello 世界'.isChineseOrEnglish);
    expect(true, '你好 my 世界'.isChineseOrEnglish);

    expect(false, 'Hello'.isChineseOrDigits);
    expect(true, '你好'.isChineseOrDigits);
    expect(false, 'Hello 123'.isChineseOrDigits);
    expect(true, '你好 123'.isChineseOrDigits);
    expect(true, '123'.isChineseOrDigits);

    expect(true, 'Hello'.isEnglishOrDigits);
    expect(false, '你好'.isEnglishOrDigits);
    expect(true, 'Hello 123'.isEnglishOrDigits);
    expect(false, '你好 123'.isEnglishOrDigits);
    expect(true, '123'.isEnglishOrDigits);
  });
}
