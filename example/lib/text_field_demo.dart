import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:widgets/widgets.dart';

class TextFieldDemo extends StatefulWidget {
  const TextFieldDemo({super.key});

  @override
  State<TextFieldDemo> createState() => _TextFieldDemoState();
}

class _TextFieldDemoState extends State<TextFieldDemo> {
  final ValueNotifier<bool> passwordNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<int> code1Notifier = ValueNotifier<int>(0);
  final ValueNotifier<int> code2Notifier = ValueNotifier<int>(0);
  final ValueNotifier<String> errorNotifier = ValueNotifier<String>("");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WrapperAppBar(
        titleText: "TextFieldDemo",
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            textFieldOutline,
            textFieldUnderline,
            textFieldNone,
            textFieldPhone,
            textFieldPhoneCupertino,
            textFieldPassword,
            textFieldError,
          ],
        ),
      ),
    );
  }

  Widget get textFieldOutline {
    return Container(
      color: Colors.blue.shade100,
      padding: const EdgeInsets.all(16),
      child: WrapperTextField.outline(),
    );
  }

  Widget get textFieldUnderline {
    return Container(
      color: Colors.red.shade100,
      padding: const EdgeInsets.all(16),
      child: WrapperTextField.underline(),
    );
  }

  Widget get textFieldNone {
    return Container(
      color: Colors.yellow.shade100,
      padding: const EdgeInsets.all(16),
      child: WrapperTextField.none(),
    );
  }

  Widget get textFieldPhone {
    return Container(
      color: Colors.purple.shade100,
      padding: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: WrapperTextField.outline(
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
          borderRadius: BorderRadius.circular(5),
          decorationOutline: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 13,
            ),
            hintText: "请输入行动电话",
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 48,
              minHeight: 0,
            ),
            prefixIcon: const Icon(
              Icons.admin_panel_settings,
              color: Colors.black,
              size: 24,
            ),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 1,
                  height: 18,
                  color: Colors.grey,
                ),
                ValueListenableBuilder(
                  valueListenable: code1Notifier,
                  builder: (context, value, Widget? child) {
                    return WrapperTextButton(
                      width: 86,
                      text: code1Notifier.value <= 0
                          ? "发送"
                          : "${code1Notifier.value} S",
                      onPressed: () {
                        if (code1Notifier.value <= 0) {
                          code1Notifier.value = 60;
                          Timer.periodic(
                            const Duration(seconds: 1),
                            (timer) {
                              if (code1Notifier.value-- <= 0) {
                                timer.cancel();
                              }
                            },
                          );
                        }
                      },
                      textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget get textFieldPhoneCupertino {
    return Container(
      color: Colors.orange.shade100,
      padding: const EdgeInsets.all(16),
      child: Container(
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: CupertinoTextField(
          placeholder: "请输入行动电话",
          placeholderStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(5),
          ),
          prefix: const Padding(
            padding: EdgeInsets.only(left: 12, right: 4),
            child: Icon(
              Icons.admin_panel_settings,
              color: Colors.black,
              size: 24,
            ),
          ),
          suffixMode: OverlayVisibilityMode.always,
          suffix: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 1,
                height: 18,
                color: Colors.grey,
              ),
              ValueListenableBuilder(
                valueListenable: code2Notifier,
                builder: (context, value, Widget? child) {
                  return WrapperTextButton(
                    width: 86,
                    text: code2Notifier.value <= 0
                        ? "发送"
                        : "${code2Notifier.value} S",
                    onPressed: () {
                      if (code2Notifier.value <= 0) {
                        code2Notifier.value = 60;
                        Timer.periodic(
                          const Duration(seconds: 1),
                          (timer) {
                            if (code2Notifier.value-- <= 0) {
                              timer.cancel();
                            }
                          },
                        );
                      }
                    },
                    textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  );
                },
              ),
              const SizedBox(width: 1, height: 0),
            ],
          ),
        ),
      ),
    );
  }

  Widget get textFieldPassword {
    return Container(
      color: Colors.purple.shade100,
      padding: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ValueListenableBuilder(
          valueListenable: passwordNotifier,
          builder: (BuildContext context, value, Widget? child) {
            return WrapperTextField.outline(
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              borderRadius: BorderRadius.circular(5),
              inputFormatters: [
                LengthLimitingTextInputFormatter(12),
              ],
              obscureText: passwordNotifier.value,
              decorationOutline: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 13,
                ),
                hintText: "请输入密码",
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 48,
                  minHeight: 0,
                ),
                prefixIcon: const Icon(
                  Icons.lock,
                  color: Colors.black,
                  size: 24,
                ),
                suffixIconConstraints: const BoxConstraints(
                  minWidth: 66,
                  minHeight: 0,
                ),
                suffixIcon: IconButton(
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    passwordNotifier.value = !passwordNotifier.value;
                  },
                  icon: Icon(
                    passwordNotifier.value
                        ? Icons.remove_red_eye
                        : Icons.remove_red_eye_outlined,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget get textFieldError {
    return Container(
      color: Colors.blue.shade100,
      padding: const EdgeInsets.all(16),
      child: ValueListenableBuilder(
        valueListenable: errorNotifier,
        builder: (BuildContext context, value, Widget? child) {
          return WrapperTextField.none(
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            decorationNone: InputDecoration(
              contentPadding: EdgeInsets.zero,
              hintText: "请输入",
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
              prefixIconConstraints: const BoxConstraints(
                minHeight: 0,
              ),
              prefixIcon: RichText(
                text: const TextSpan(
                  text: "裝修總預算",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  children: [
                    TextSpan(
                      text: "*",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              suffixIconConstraints: const BoxConstraints(
                minWidth: 26,
                minHeight: 0,
              ),
              suffixIcon: const Text(
                "萬",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                textAlign: TextAlign.right,
              ),
              // errorText: "總預算不能為空",
              // errorStyle: const TextStyle(
              //   color: Colors.red,
              //   fontSize: 13,
              // ),
              error: const Text(
                "總預算不能為空",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 13,
                ),
                // textAlign: TextAlign.right,
              ),
            ),
          );
        },
      ),
    );
  }
}
