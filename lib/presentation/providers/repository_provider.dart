import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/network_info.dart';
import '../../core/services/location_service.dart';
import '../../core/services/notification_service.dart';
import '../../data/datasources/local/recipe_local_datasource.dart';
import '../../data/datasources/remote/recipe_remote_datasource.dart';
import '../../data/repositories/recipe_repository.dart';
import '../../data/repositories/recipe_repository_impl.dart';

final recipeRepositoryProvider = Provider<RecipeRepository>((ref) {
  final dio          = DioClient.create();
  final connectivity = Connectivity();
  final box          = Hive.box('recipes');

  return RecipeRepositoryImpl(
    remote:      RecipeRemoteDataSourceImpl(dio),
    local:       RecipeLocalDataSourceImpl(box),
    networkInfo: NetworkInfoImpl(connectivity),
  );
});

final locationServiceProvider = Provider((_) => LocationService());
final notificationServiceProvider = Provider((_) => NotificationService.instance);
