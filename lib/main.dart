import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_file.dart';

import 'screens/loading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'components/premiumbanner.dart';

void main() async{

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: new ThemeData(scaffoldBackgroundColor: const Color(0xffeeeeee)),
      debugShowCheckedModeBanner: false,
      home: Loading(),
      initialBinding: PremiumMembershipBinding(),
    );
  }
}

class PremiumMembershipBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PremiumMembershipController());
  }
}
