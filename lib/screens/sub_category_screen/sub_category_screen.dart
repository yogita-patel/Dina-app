import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/common_widgets/horizontal_product_list.dart';
import 'package:oc_demo/common_widgets/viewall_header.dart';
import 'package:oc_demo/constants/arguments_map.dart';
import 'package:oc_demo/models/catalog/catalog_model.dart';
import 'package:oc_demo/models/catalog/request/catalog_product_request.dart';
import 'package:oc_demo/models/sub_category/sub_category_model.dart';
import 'package:oc_demo/screens/sub_category_screen/widgets/sub_category_list_item.dart';

import '../../common_widgets/alert_message.dart';
import '../../common_widgets/app_bar.dart';
import '../../common_widgets/loader.dart';
import '../../constants/app_constants.dart';
import '../../helper/app_shared_pref.dart';
import 'bloc/subcategory_screen_bloc.dart';
import 'bloc/subcategory_screen_event.dart';
import 'bloc/subcategory_screen_state.dart';

class SubCategoryScreen extends StatefulWidget {
  final Map<String, dynamic> arguments;

  const SubCategoryScreen(this.arguments, {super.key});

  @override
  State<StatefulWidget> createState() {
    return SubCategoryScreenState();
  }
}

class SubCategoryScreenState extends State<SubCategoryScreen> {
  SubcategoryBloc? subcategoryBloc;
  bool isLoading = false;
  SubCategoryModel? _catalogModel;
  CatalogModel? _model;
  late CatalogProductRequest _request;
  String? name, id;

  @override
  void initState() {
    name = widget.arguments[labelKey];
    id = widget.arguments[categoryId];
    subcategoryBloc = context.read<SubcategoryBloc>();
    subcategoryBloc?.add(SubCategoryScreenDatFetchEvent(id ?? ''));

    AppSharedPref.getWkToken().then((value) {
      _request = CatalogProductRequest(
        page: "1",
        limit: "5",
        path: id,
        token: value,
        width: "${AppSizes.deviceWidth}",
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(name ?? "", context),
      body: _setCategoryData(context),
    );
  }

  _setCategoryData(BuildContext context) {
    return BlocBuilder<SubcategoryBloc, SubCategoryBaseState>(
      builder: (context, currentState) {
        if (currentState is SubCategoryInitialState) {
          isLoading = true;
        } else if (currentState is SubCategorySuccessState) {
          _catalogModel = currentState.categoryScreenModel;
          subcategoryBloc?.add(SubCategoriesProductEvent(_request));
          // isLoading = false;
        } else if (currentState is SubCategoriesProductState) {
          _model = currentState.model;
          isLoading = false;
        } else if (currentState is SubCategoryErrorState) {
          isLoading = false;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AlertMessage.showError(currentState.message ?? '', context);
          });
        }
        return Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Visibility(
                    visible: _model?.categoryData?.products != null &&
                        _model?.categoryData?.products?.isNotEmpty == true,
                    child: Column(
                      children: <Widget>[
                        ViewAllHeader(name, id),
                        HorizontalProductList(_model?.categoryData?.products),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.size8),
                  SubCategoryListItem(_catalogModel?.categories),
                ],
              ),
            ),
            Visibility(visible: isLoading, child: const Loader())
          ],
        );
      },
    );
  }
}
