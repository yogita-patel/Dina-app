
import 'package:flutter/material.dart';
import 'package:oc_demo/models/registerAccountModel/register_account_model.dart';


class OptionsCheckBoxWidget extends StatefulWidget {
  OptionsCheckBoxWidget(
      {super.key, this.variants,this.selectedOption,this.selectedIds,
        this.isRequired = true,
        this.fieldLabel = '',});
  List<CustomFieldValue>? variants;
  ValueChanged<List>? selectedOption = (test) {};
  final List<dynamic>? selectedIds;
  final bool isRequired;
  final String fieldLabel;

  @override
  _OptionsCheckBoxWidgetState createState() => _OptionsCheckBoxWidgetState();
}

class _OptionsCheckBoxWidgetState extends State<OptionsCheckBoxWidget> {
  var selectedCheckBoxes = [];

  @override
  void initState() {
    super.initState();

    if (widget.variants != null && widget.selectedIds != null) {
      for (var item in widget.variants!) {
        if (widget.selectedIds!.contains(item.custom_field_value_id)) {
          item.isSelected = true;
          selectedCheckBoxes.add(item.custom_field_value_id);
        }
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.selectedOption?.call(selectedCheckBoxes);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FormField<List<String>>(
      initialValue: selectedCheckBoxes.cast<String>(),
      validator: (value) {
        if (widget.isRequired && (value == null || value.isEmpty)) {
          return 'Please accept ${widget.fieldLabel}';
        }
        return null;
      },
      builder: (FormFieldState<List<String>> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCheckBox(widget.variants, state),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Text(
                  state.errorText ?? '',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              )
          ],
        );
      },
    );
  }


  Widget _buildCheckBox(List<CustomFieldValue>? data,FormFieldState<List<String>> state) => Padding(
    padding:  EdgeInsets.zero,
    child: Container(

      /* padding:
      EdgeInsets.only(left: AppSizes.size10, right: AppSizes.size10),*/
      // decoration: const BoxDecoration(
      //     border: Border.symmetric(
      //       horizontal: BorderSide(color: AppColors.dividerColor, width: 0.5),
      //     )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(
          data?.length ?? 0,
              (index) {
            String optionString = data?[index].name ?? "";
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CheckboxListTile(
                  dense: true,
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  selected: data?[index].isSelected ?? false,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6)), // Simulates a circle
                  ),
                  side: const BorderSide(color: Colors.grey),
                  fillColor: WidgetStateProperty.resolveWith<Color>(
                        (Set<WidgetState> states) {
                      if (states.contains(WidgetState.selected)) {
                        // Active/checked state
                        return const Color(0xFF0D479C); // or any other active color
                      }
                      return Colors.white; // Inactive/unchecked background
                    },
                  ),
                  title: Text(
                    optionString,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  value: data?[index].isSelected ?? false,
                  onChanged: (value) {
                    if (data?[index].isSelected == true) {
                      data?[index].isSelected = false;
                      selectedCheckBoxes.remove(data?[index].custom_field_value_id);
                    } else {
                      data?[index].isSelected = true;
                      selectedCheckBoxes.add(data?[index].custom_field_value_id);
                    }

                    setState(() {
                      widget.selectedOption!(selectedCheckBoxes);
                      state.didChange(selectedCheckBoxes.cast<String>());
                    });
                  },
                ),
              ],
            );
          },
        ),
      ),
    ),
  );
}
