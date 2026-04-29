import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/error/exceptions.dart';
import '../../models/recipe_model.dart';

abstract class RecipeRemoteDataSource {
  Future<List<RecipeModel>> searchRecipes(String query);
  Future<List<RecipeModel>> getRecipesByArea(String area);
  Future<List<RecipeModel>> getRecipesByCategory(String category);
  Future<RecipeModel> getRecipeDetail(String id);
}

class RecipeRemoteDataSourceImpl implements RecipeRemoteDataSource {
  final Dio _dio;
  RecipeRemoteDataSourceImpl(this._dio);

  @override
  Future<List<RecipeModel>> searchRecipes(String query) async {
    try {
      final res = await _dio.get(ApiConstants.search, queryParameters: {'s': query});
      final meals = res.data['meals'];
      if (meals == null) return [];
      return (meals as List)
          .map((m) => RecipeModel.fromJson(m as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      throw ServerException(e.toString());
    }
    return [];
  }

  @override
  Future<List<RecipeModel>> getRecipesByArea(String area) async {
    try {
      // Step 1: get summary list (only id+name+thumb)
      final res = await _dio.get(ApiConstants.filterByArea, queryParameters: {'a': area});
      final meals = res.data['meals'];
      if (meals == null) return [];

      // Step 2: fetch full details in parallel (limit 12 for performance)
      final limited = (meals as List).take(12).toList();
      final details = await Future.wait(
        limited.map((m) => getRecipeDetail(m['idMeal'].toString())),
      );
      return details;
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      throw ServerException(e.toString());
    }
    return [];
  }

  @override
  Future<List<RecipeModel>> getRecipesByCategory(String category) async {
    try {
      final res = await _dio.get(ApiConstants.filterByCategory, queryParameters: {'c': category});
      final meals = res.data['meals'];
      if (meals == null) return [];

      final limited = (meals as List).take(12).toList();
      final details = await Future.wait(
        limited.map((m) => getRecipeDetail(m['idMeal'].toString())),
      );
      return details;
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      throw ServerException(e.toString());
    }
    return [];
  }

  @override
  Future<RecipeModel> getRecipeDetail(String id) async {
    try {
      final res = await _dio.get(ApiConstants.lookupById, queryParameters: {'i': id});
      final meals = res.data['meals'];
      if (meals == null || (meals as List).isEmpty) {
        throw const ServerException('Recipe not found');
      }
      return RecipeModel.fromJson(meals[0] as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
    }
    throw const ServerException('Unknown error');
  }

  Never _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      throw const NetworkException();
    }
    throw ServerException(e.message ?? 'Server error');
  }
}
