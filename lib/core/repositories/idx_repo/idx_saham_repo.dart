import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:golden_price/core/components/toast.dart';
import 'package:golden_price/core/constants/cons.dart';
import 'package:golden_price/core/helpers/dio_exception.dart';
import 'package:golden_price/core/models/idx_top7_model/idx_top7_model.dart';
import 'package:golden_price/core/rest/rest_contract.dart';

class IdxSahamRepo {
  final RestContract _rest = GetIt.instance.get<RestContract>();

  Future<List<IdxTop7Model>?> getSahamTop7(BuildContext context) async {
    try {
      var response = await _rest.getSahamTop7();
      log.setInt(STATUSCODE, response.statusCode!);
      if (response.statusCode == 200) {
        Iterable data = response.data;
        List<IdxTop7Model> listData =
            data.map((map) => IdxTop7Model.fromJson(map)).toList();
        return listData;
      } else {
        if (context.mounted) {
          toast(context, log.getString(MESSAGE).toString());
        }
        throw Exception('error');
      }
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }
}
