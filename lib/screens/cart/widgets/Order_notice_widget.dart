import 'package:flutter/material.dart';
import '../../../constants/app_constants.dart';
import '../../../models/cart/cart_model.dart';

class OrderNoticeWidget extends StatelessWidget {
  final CartModel? model;

  const OrderNoticeWidget(this.model, {super.key});

  @override
  Widget build(BuildContext context) {
    // Step 1: Get raw HTML string list from API
    final List<String> topTextRawList = model?.topText ?? [];

    // Step 2: Extract individual <p>...</p> blocks and clean them
    List<String> topTextList = [];
    for (final html in topTextRawList) {
      topTextList.addAll(_extractParagraphs(html));
    }

    if (topTextList.isEmpty) {
      return const SizedBox(); // No data
    }

    // Step 3: Render each paragraph
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFD46A).withOpacity(0.4), // Light yellow background
      ),
      padding: const EdgeInsets.only(left:AppSizes.size16,right: AppSizes.size16,top:AppSizes.size16 ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(topTextList.length, (index) {
          final text = topTextList[index];
          final isWarning = text.toLowerCase().contains("note:");

          return Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.size16),
            child: _infoRow(
              context: context,
              iconColor: isWarning ? AppColors.red : Theme.of(context).primaryColorDark,
              textColor: isWarning ? AppColors.red : Theme.of(context).primaryColorDark,
              text: text,
            ),
          );
        }),
      ),
    );
  }

  Widget _infoRow({
    required Color iconColor,
    required Color textColor,
    required String text,
    required BuildContext context,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.info_outline, color: iconColor),
        const SizedBox(width: AppSizes.size8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: AppSizes.size14,
              color: textColor,
            ),
          ),
        ),
      ],
    );
  }

  /// Extracts all <p>...</p> content as clean strings
  List<String> _extractParagraphs(String htmlContent) {
    final RegExp exp = RegExp(r'<p>(.*?)<\/p>', multiLine: true, dotAll: true);
    final matches = exp.allMatches(htmlContent);
    return matches
        .map((e) => e.group(1)?.replaceAll('&nbsp;', ' ').trim() ?? '')
        .where((e) => e.isNotEmpty)
        .toList();
  }
}
