import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:golden_price/core/components/toast.dart';
import 'package:golden_price/core/constants/cons.dart';
import 'package:golden_price/core/helpers/dio_exception.dart';
import 'package:golden_price/core/models/gold_model/gold_model.dart';
import 'package:golden_price/core/rest/rest_contract.dart';

class GoldenPriceRepository {
  final RestContract _rest = GetIt.instance.get<RestContract>();

  Future<GoldModel?> getGoldPrice(BuildContext context) async {
    try {
      var response = await _rest.goldenPrice();
      var map = response.data;

      log.setInt(STATUSCODE, response.statusCode!);
      if (response.statusCode == 200) {
        return GoldModel.fromJson(map);
      } else if (response.statusCode == 504) {
        if (context.mounted) {
          toast(context, 'error');
        }
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
