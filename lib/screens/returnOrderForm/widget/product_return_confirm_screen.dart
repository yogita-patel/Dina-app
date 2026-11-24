import 'package:flutter/material.dart';
import '../../../../common_widgets/Tabbar/bottom_tabbar.dart';
import '../../../../constants/app_constants.dart';
import '../../../../constants/app_string_constant.dart';
import '../../../../helper/app_localizations.dart';

class ProductReturnConfirmScreen extends StatefulWidget {
  const ProductReturnConfirmScreen({super.key, required this.message});

  final String message;

  @override
  State<ProductReturnConfirmScreen> createState() => _ProductReturnConfirmScreenState();
}

class _ProductReturnConfirmScreenState extends State<ProductReturnConfirmScreen> {
  AppLocalizations? localizations;

  @override
  void didChangeDependencies() {
    localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    List<String> parts = widget.message.split(RegExp(r'\.\s+')); // splits on ". "
    String part1 = parts.length > 1 ? '${parts[0]}. ${parts[1]}.' : widget.message;
    String part2 = parts.length > 2 ? parts.sublist(2).join(". ") : '';

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) =>  BottomTabbarWidget()),
              (route) => false,
        );
        return true;
      },
      child: WillPopScope(
        onWillPop: () async {
          print("Back button pressed ............................................");
          Navigator.of(context).popUntil((route) => route.isFirst);
          return true;
        },
        child: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.size16, vertical:AppSizes.size100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(AppImages.successIcon,height: AppSizes.size65,width: AppSizes.size65,),
                  const SizedBox(height: 24),
                  Text(
                    "Product Returns",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    part1,
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    part2,
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSizes.size30,),
                  SizedBox(
                    width: double.infinity,
                    height: AppSizes.size45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFD166),
                        foregroundColor: const Color(0xFF0F4AA1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {

                        print("dwndcdbvvmv,v ............................................");
                        // AppRestart.rebirth(context);
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      child:  Text(
                          localizations?.translate(AppStringConstant.goToHome) ?? ""

                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
