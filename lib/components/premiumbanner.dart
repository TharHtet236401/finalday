import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../screens/subscription.dart';


class PremiumMembershipAd extends StatelessWidget {
  final PremiumMembershipController premiumMembershipController =
  Get.find<PremiumMembershipController>();


  @override
  Widget build(BuildContext context) {
    return Obx(
          () => premiumMembershipController.isBannerVisible.value
          ?
      GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return SubscriptionPlans();
          }));
        },
        child: Container(
          height: 100,
          child: Column(
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Image.asset(
                    'images/premiumad.png',
                    width: double.infinity,
                    height: 100, // Adjust the height as needed
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(140, 12, 15, 8),
                    child: Text(
                      'Upgrade to Premium Membership for Exclusive Benefits!',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      premiumMembershipController.hideBanner();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      )
          : SizedBox(height: 0), // Return an empty SizedBox when the banner is not visible
    );
  }


}




class PremiumMembershipController extends GetxController {
  final storage = GetStorage();

  RxBool isBannerVisible = true.obs;

  @override
  void onInit() {
    super.onInit();
    isBannerVisible.value = storage.read("isBannerVisible") ?? true;
  }

// Add the following method to reinitialize the state when returning to the page
  void reinitialize() {
    isBannerVisible.value = storage.read("isBannerVisible") ?? true;
  }

  void hideBanner() {
    isBannerVisible.value = false;
    storage.write("isBannerVisible", false);
  }
}
