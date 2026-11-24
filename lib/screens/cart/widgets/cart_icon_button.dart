import 'package:flutter/material.dart';

import '../../../constants/app_constants.dart';

class CartIconButton extends StatelessWidget {
  const CartIconButton({
    this.leadingIcon,
    required this.title,
    required this.onClick,
    super.key,
  });

  final IconData? leadingIcon;
  final String title;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.size8),
      child: GestureDetector(
        onTap: onClick,
        child: Container(
          height: AppSizes.size40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6), // rounded corners like the image
            color: Colors.white, // white background
          ),
          child: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleLarge?.copyWith(fontWeight: FontWeight.w600,color: Theme.of(context).primaryColorDark),
          ),
        )

      ),
    );
  }
}
