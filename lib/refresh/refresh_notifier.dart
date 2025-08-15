import 'dart:async';

import 'package:dio/dio.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:packagist_network/network.dart';

class PageKey {
  static String page = 'page';
  static String pageSize = 'per_page';

  static void init({String? page, String? pageSize}) {
    if (page != null) PageKey.page = page;
    if (pageSize != null) PageKey.pageSize = pageSize;
  }
}

class RefreshNotifier<T> {
  /// 刷新控制器
  final EasyRefreshController easyRefreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  /// 请求链接
  String? requestUrl;

  /// 请求参数
  Map<String, dynamic>? requestParams;

  /// 请求额外参数
  Options? requestOptions;

  /// 请求取消令牌
  CancelToken? cancelToken;

  /// 当前页
  int page = 1;

  /// 请求页大小
  int? pageSize;

  /// 列表数据
  List<T> listData = [];

  /// json数据解析
  late List<T> Function(Map<String, dynamic>) jsonParse;

  Function(bool loadMore)? onBegin;
  Function(Map<String, dynamic> data, bool loadMore)? onSuccess;
  Function(int? stateCode, DioException? error, bool loadMore)? onFailed;
  Function(bool loadMore)? onCommon;

  dynamic bind;

  int get perPage => pageSize ?? 10;

  int get listSize => listData.length;

  Map<String, dynamic> get params => commonParams;

  void setup({
    required String requestUrl,
    Map<String, dynamic>? requestParams,
    Options? requestOptions,
    CancelToken? cancelToken,
    required List<T> Function(Map<String, dynamic>) jsonParse,
    int page = 1,
    int? pageSize,
    Function(bool loadMore)? onBegin,
    Function(Map<String, dynamic> data, bool loadMore)? onSuccess,
    Function(int? stateCode, DioException? error, bool loadMore)? onFailed,
    Function(bool loadMore)? onCommon,
    dynamic bind,
  }) {
    this.requestUrl = requestUrl;
    this.requestParams = requestParams;
    this.requestOptions = requestOptions;
    this.cancelToken = cancelToken;
    this.jsonParse = jsonParse;
    this.page = page;
    this.pageSize = pageSize;
    this.onBegin = onBegin;
    this.onSuccess = onSuccess;
    this.onFailed = onFailed;
    this.onCommon = onCommon;
    this.bind = bind;
  }

  /// 刷新
  Future refresh() async {
    onBegin?.call(false);
    page = 1;
    if (requestUrl == null) return;
    await HttpRequest().get(
      requestUrl!,
      params: commonParams,
      options: requestOptions,
      cancelToken: cancelToken,
      onSuccess: (data) {
        page++;
        listData = jsonParse.call(data);
        if (listData.isEmpty) {
          easyRefreshController.finishRefresh();
          easyRefreshController.finishLoad(IndicatorResult.noMore);
        } else {
          easyRefreshController.finishRefresh();
          easyRefreshController.resetFooter();
        }
        onSuccess?.call(data, false);
      },
      onFailed: (code, error) {
        easyRefreshController.finishRefresh(IndicatorResult.fail);
        onFailed?.call(code, error, false);
      },
      onCommon: () {
        onCommon?.call(false);
      },
      bind: bind,
    );
  }

  /// 加载更多
  Future loadMore() async {
    onBegin?.call(true);
    if (requestUrl == null) return;
    await HttpRequest().get(
      requestUrl!,
      params: commonParams,
      options: requestOptions,
      cancelToken: cancelToken,
      onSuccess: (data) {
        page++;
        final newList = jsonParse.call(data);
        listData.addAll(newList);
        easyRefreshController.finishLoad(
          newList.isEmpty ? IndicatorResult.noMore : IndicatorResult.success,
        );
        onSuccess?.call(data, true);
      },
      onFailed: (code, error) {
        easyRefreshController.finishLoad(IndicatorResult.fail);
        onFailed?.call(code, error, true);
      },
      onCommon: () {
        onCommon?.call(true);
      },
      bind: bind,
    );
  }

  void updateParams(Map<String, dynamic> params) {
    requestParams = params;
  }

  Map<String, dynamic> get commonParams {
    var params = <String, dynamic>{};
    params[PageKey.page] = page;
    if (pageSize != null) {
      params[PageKey.pageSize] = pageSize;
    }
    if (requestParams != null) {
      params.addAll(requestParams!);
    }
    return params;
  }
}
