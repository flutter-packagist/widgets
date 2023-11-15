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
  final ValueNotifier<String> errorNotifier2 = ValueNotifier<String>("");
  final ValueNotifier<String> counterNotifier = ValueNotifier<String>("0/100");

  final FocusNode focusNode = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  final TextEditingController errorEditingController = TextEditingController();
  final TextEditingController errorEditingController2 = TextEditingController();
  final TextEditingController counterEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        errorNotifier.value =
            errorEditingController.text.isEmpty ? "内容不能为空" : "";
      }
    });
    focusNode2.addListener(() {
      if (!focusNode2.hasFocus) {
        errorNotifier2.value =
            errorEditingController2.text.isEmpty ? "内容不能为空" : "";
      }
    });
  }

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
            textFieldSearch,
            textFieldPhone,
            textFieldPhoneCupertino,
            textFieldPassword,
            textFieldError,
            textFieldSuffix,
            textFieldCounter,
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

  Widget get textFieldSearch {
    return Container(
      padding: const EdgeInsets.all(16),
      child: WrapperTextField.outline(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(
          style: BorderStyle.none,
        ),
        prefixWidget: const Icon(
          Icons.search,
          color: Colors.grey,
          size: 14,
        ),
        prefixWidgetConstraints: const BoxConstraints(
          minWidth: 30,
          minHeight: 0,
        ),
        decorationOutline: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          filled: true,
          fillColor: Colors.grey.shade200,
          hintText: "搜索",
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 14,
          ),
        ),
      ),
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
            prefixWidgetConstraints: const BoxConstraints(
              minWidth: 48,
              minHeight: 0,
            ),
            prefixWidget: const Icon(
              Icons.admin_panel_settings,
              color: Colors.black,
              size: 24,
            ),
            suffixWidget: Row(
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
            decorationOutline: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 13,
              ),
              hintText: "请输入行动电话",
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          )),
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
              prefixWidgetConstraints: const BoxConstraints(
                minWidth: 48,
                minHeight: 0,
              ),
              prefixWidget: const Icon(
                Icons.lock,
                color: Colors.black,
                size: 24,
              ),
              suffixWidgetConstraints: const BoxConstraints(
                minWidth: 66,
                minHeight: 0,
              ),
              suffixWidget: IconButton(
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
              decorationOutline: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 13,
                ),
                hintText: "请输入密码",
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
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
            focusNode: focusNode,
            controller: errorEditingController,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            prefixWidget: RichText(
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
            suffixWidget: const SizedBox(
              width: 30,
              child: Text(
                "萬",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            onEditingComplete: () {
              errorNotifier.value =
                  errorEditingController.text.isEmpty ? "内容不能为空" : "";
            },
            decorationNone: InputDecoration(
              hintText: "请输入",
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
              error: errorNotifier.value.isEmpty
                  ? null
                  : SizedBox(
                      width: double.infinity,
                      child: Text(
                        errorNotifier.value,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget get textFieldSuffix {
    return Container(
      color: Colors.yellow.shade100,
      padding: const EdgeInsets.all(16),
      child: ValueListenableBuilder(
        valueListenable: errorNotifier2,
        builder: (BuildContext context, value, Widget? child) {
          return WrapperTextField.none(
            focusNode: focusNode2,
            controller: errorEditingController2,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            prefixWidget: RichText(
              text: const TextSpan(
                text: "裝修總預算",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                children: [
                  TextSpan(
                    text: "*\n",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            onEditingComplete: () {
              errorNotifier2.value =
                  errorEditingController2.text.isEmpty ? "内容不能为空" : "";
            },
            enabled: false,
            maxLines: 2,
            decorationNone: InputDecoration(
              hintText: "请输入\n裝修總預算",
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
              error: errorNotifier2.value.isEmpty
                  ? null
                  : SizedBox(
                      width: double.infinity,
                      child: Text(
                        errorNotifier2.value,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget get textFieldCounter {
    return Container(
      color: Colors.purple.shade100,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "特殊要求",
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          ValueListenableBuilder(
            valueListenable: counterNotifier,
            builder: (BuildContext context, value, Widget? child) {
              return WrapperTextField.none(
                controller: counterEditingController,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
                maxLines: 4,
                maxLength: 100,
                decorationNone: InputDecoration(
                  hintText: "请输入特殊要求",
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  counterText: counterNotifier.value,
                  counterStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                ),
                onChanged: (value) {
                  counterNotifier.value = "${value.length}/100";
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
