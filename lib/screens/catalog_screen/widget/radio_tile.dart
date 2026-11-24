// import 'package:flutter/material.dart';
// import 'package:oc_demo/models/catalog/filter.dart';
//
// class RadioTile extends StatelessWidget {
//   const RadioTile(this.filter, this.selectedId, this.onChanged, {Key? key})
//       : super(key: key);
//
//   final Filter? filter;
//   final String? selectedId;
//   final ValueChanged<String> onChanged;
//
//   @override
//   Widget build(BuildContext context) {
//     if (filter == null) return const SizedBox.shrink();
//
//     return RadioListTile<String>(
//       title: Text(filter!.name ?? ''),
//       value: filter!.filterId ?? '',
//       groupValue: selectedId,
//       onChanged: (value) {
//         if (value != null) {
//           // update *this* filter model
//           filter!.selected = true;
//           onChanged(value);
//         }
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:oc_demo/config/theme.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/models/catalog/filter.dart';

class RadioTile extends StatelessWidget {
  const RadioTile(
      this.filter,
      this.selectedId,
      this.onChanged, {
        super.key,
      });

  final Filter? filter;
  final String? selectedId;
  final ValueChanged<String> onChanged;

  bool get isSelected => filter?.filterId == selectedId;

  @override
  Widget build(BuildContext context) {
    if (filter == null) return const SizedBox.shrink();

    return Material(
      child: InkWell(
        onTap: (){
          if (!isSelected && filter?.filterId != null) {
            filter!.selected = true;
            onChanged(filter!.filterId!);
          }
        },
        child: Row(
          children: <Widget>[
            Radio<String>(
              value: filter!.filterId ?? '',
              groupValue: selectedId,
              activeColor: Colors.black,
              fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.selected)) {
                  return MobikulTheme.primaryColor;
                }
                return const Color(0xFF4A5565);
              }),
              onChanged: (value) {
                if (value != null) {
                  // update *this* filter model
                  filter!.selected = true;
                  onChanged(value);
                }
              },
            ),
            const SizedBox(width: AppSizes.size8),
            Text(
              "${filter?.name}",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: AppSizes.size14,
                fontWeight: FontWeight.w400
              )
            ),
          ],
        ),
      ),
    );
  }
}

