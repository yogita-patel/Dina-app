import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_constants.dart';

import '../main.dart';

class UnitDropdown extends StatelessWidget {
  final List<String> units;
  final String selectedUnit;
  final ValueChanged<String?>? onChanged;

  const UnitDropdown({
    super.key,
    required this.units,
    required this.selectedUnit,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    print("Unites data===>$units");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Unit of Sale',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 4),
        Container(
          height: AppSizes.size40,
          padding: const EdgeInsets.only(left: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(6),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedUnit,
              isExpanded: true,
              icon: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  border: Border(
                    left: BorderSide(
                        color: Colors.grey.shade300), // Divider at right
                  ),
                ),
                child: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.black54,
                  size: 20,
                ),
              ),
              items: units.map((String unit) {
                return DropdownMenuItem<String>(
                  value: unit,
                  child: Text(
                    unit,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
              onTap: () {
                cartActionDisableToQuote = true;
                Future.delayed(const Duration(seconds: 1), () {
                  print("dcfddvfdvv..............1");
                  cartActionDisableToQuote = false;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
