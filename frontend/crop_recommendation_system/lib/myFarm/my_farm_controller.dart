
import 'package:crop_recommendation_system/myFarm/my_farm_model.dart';
import 'package:crop_recommendation_system/myFarm/my_farm_service.dart';

class MyFarmController {

  Future<MyFarmModel> getDashboard() async {
    return await MyFarmApiService.fetchDashboard();
  }

}