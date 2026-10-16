import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:golden_price/core/helpers/dio_exception.dart';
import 'package:golden_price/core/models/ihsg_model/ihsg_model.dart';
import 'package:golden_price/core/rest/rest_contract.dart';

class IhsgRepo {
  final RestContract _rest = GetIt.instance.get<RestContract>();

  Future<IhsgModel> getIhsg(IhsgRange range) async {
    try {
      final response = await _rest.getIhsgChart(range.range, range.interval);
      if (response.statusCode == 200) {
        return IhsgModel.fromYahoo(response.data as Map<String, dynamic>);
      }
      throw 'Gagal memuat IHSG (${response.statusCode})';
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e).toString();
    }
  }
}
