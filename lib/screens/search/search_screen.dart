import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/constants/global_data.dart';
import 'package:oc_demo/models/searchModel/search_model.dart';
import 'package:oc_demo/screens/search/views/search_category_suggestion.dart';
import 'package:oc_demo/screens/search/views/search_suggestion.dart';
import 'package:oc_demo/screens/search/search_query_debouncer.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import '../../common_widgets/Tabbar/bottom_tabbar.dart';
import '../../common_widgets/alert_message.dart';
import '../../common_widgets/common_empty_card.dart';
import '../../common_widgets/dialog_helper.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_routes.dart';
import '../../constants/app_string_constant.dart';
import '../../constants/arguments_map.dart';
import '../../helper/app_localizations.dart';
import '../../helper/app_shared_pref.dart';
import '../../utils/helper.dart';
import 'bloc/search_bloc.dart';
import 'bloc/search_events.dart';
import 'bloc/search_state.dart';
import '../barcode/barcode_scan_screen.dart';
import 'package:oc_demo/network_manager/api_client.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isLoading = false;

//  bool isFirst = true;
  SearchModel? searchData;
  TextEditingController textEditingController = TextEditingController();
  SearchScreenBloc? searchScreenBloc;
  AppLocalizations? _localizations;
  final SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;
  String transcription = '';
  String selectedLang = "en_US";
  bool showCategorySuggestion = true;
  final SearchQueryDebouncer _searchDebouncer = SearchQueryDebouncer(
    delay: const Duration(milliseconds: 400),
  );

  @override
  void initState() {
    activateSpeechRecognizer();
    AppSharedPref.getLanguage().then((value) => selectedLang = value);
    searchScreenBloc = context.read<SearchScreenBloc>();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  void activateSpeechRecognizer() async {
    await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    _isListening = true;
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    _isListening = false;
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      transcription = result.recognizedWords;
      textEditingController.text = transcription;
      _scheduleSearch(transcription);
      _stopListening();
    });
  }

  void _scheduleSearch(String searchKey) {
    final trimmedSearchKey = searchKey.trim();
    if (trimmedSearchKey.isEmpty) {
      _searchDebouncer.cancel();
      searchScreenBloc?.add(const SearchSuggestionEvent(''));
      return;
    }

    _searchDebouncer.submit(
      trimmedSearchKey,
      (query) => searchScreenBloc?.add(SearchSuggestionEvent(query)),
    );
  }

  void errorHandler() => activateSpeechRecognizer();

  void _openSearchResults(String searchKey) {
    final trimmedSearchKey = searchKey.trim();
    if (trimmedSearchKey.isEmpty) {
      return;
    }

    _searchDebouncer.cancel();
    final formattedTag =
        '${trimmedSearchKey[0].toUpperCase()}${trimmedSearchKey.substring(1)}';
    Helper.hideSoftKeyBoard();
    Navigator.of(context).pushNamed(
      AppRoute.catalog,
      arguments: categoryMap(
        trimmedSearchKey,
        formattedTag,
        "",
        "fromProductSearch",
        false,
      ),
    );
  }

  @override
  dispose() {
    _searchDebouncer.dispose();
    textEditingController.dispose();
    _speechToText.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchScreenBloc, SearchState>(
        builder: (context, currentState) {
      print(currentState);
      if (currentState is SearchInitialState) {
        /*   if (!isFirst) {
          isLoading = true;
        }
        isFirst = false;*/
      } else if (currentState is SearchScreenSuccess) {
        print("ddfv........................");
        searchData = currentState.model;
        isLoading = false;
        searchScreenBloc?.emit(SearchActionState());
        print("ddfv........................");
      } else if (currentState is SearchScreenError) {
        isLoading = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          AlertMessage.showError(currentState.message, context);
        });
      } else if (currentState is SearchEmptyState) {
        searchData = null;
        isLoading = false;
      }
      return _buildUI();
    });
  }

  Widget _buildUI() {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.size14),
            child: GestureDetector(
              onTap: () {
                Helper.hideSoftKeyBoard();
                Navigator.of(context).pop();
              },
              child: Image.asset(
                AppImages.backArrow,
                height: AppSizes.size24,
                width: AppSizes.size24,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          ),
          title: Container(
            height: AppSizes.size40,
            decoration: BoxDecoration(
              color: AppColors.searchBackGroundColor,
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.size16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    readOnly: _isListening,
                    controller: textEditingController,
                    maxLines: 1,
                    onChanged: (searchKey) {
                      print("Search key ---> $searchKey");
                      showCategorySuggestion = searchKey.isEmpty;
                      isLoading = true;
                      setState(() {}); // To update the UI when text changes
                      _scheduleSearch(searchKey);
                    },
                    onSubmitted: (searchKey) {
                      print("Search key ---> $searchKey");
                      _openSearchResults(searchKey);
                      // showCategorySuggestion = searchKey.isEmpty;
                      // isLoading = true;
                      // setState(() {}); // To update the UI when text changes
                      // searchScreenBloc?.add(SearchSuggestionEvent(searchKey));
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText:
                          _localizations?.translate(AppStringConstant.search) ??
                              '',
                      hintStyle:
                          Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.normal,
                                color: AppColors.searchText,
                              ),
                      suffixIcon: textEditingController.text.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                textEditingController.clear();
                                showCategorySuggestion = true;
                                setState(() {}); // Clear icon disappears
                                searchScreenBloc
                                    ?.add(const SearchSuggestionEvent(""));
                              },
                              child: Image.asset(
                                AppImages.crossBackButton,
                                height: AppSizes.size40,
                                width: AppSizes.size40,
                              ),
                            )
                          : null,
                    ),
                    style: Theme.of(context).textTheme.bodyLarge,
                    cursorColor: MediaQuery.of(context).platformBrightness ==
                            Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    startBarcodeRecognition();
                    // DialogHelper.searchDialog(
                    //   context,
                    //   _localizations,
                    //       () => startImageRecognition(searchImage),
                    //       () => startImageRecognition(searchText),
                    //   onBarcodeTap: () => startBarcodeRecognition(),
                    // );
                  },
                  icon: Image.asset(
                    AppImages.searchScanIcon,
                    height: AppSizes.size24,
                    width: AppSizes.size24,
                    color: AppColors.searchText,
                  ),
                ),
              ],
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: Colors.grey.shade300,
              height: 1.0,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: isLoading,
                child: const LinearProgressIndicator(
                  backgroundColor: AppColors.black,
                  valueColor: AlwaysStoppedAnimation(AppColors.white),
                ),
              ),
              showCategorySuggestion
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                              AppSizes.size12,
                              AppSizes.size16,
                              AppSizes.size12,
                              AppSizes.size12),
                          child: Text(
                            _localizations
                                    ?.translate(AppStringConstant.categories) ??
                                "",
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                        getSearchCategorySuggestion(GlobalData.subCategory),
                      ],
                    )
                  : Visibility(
                      visible: !isLoading,
                      child: ((searchData?.searchData ?? []).isNotEmpty)
                          ? suggestionList(
                              context,
                              _localizations,
                              searchData?.searchData,
                              onViewAllSearchResults: () => _openSearchResults(
                                textEditingController.text,
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.only(
                                  top: AppSizes.deviceHeight / 3),
                              child: CommonEmptyCard(
                                imagePath: AppImages.noProductFound,
                                title: _localizations?.translate(
                                        AppStringConstant.noProductFound) ??
                                    '',
                                subtitle: _localizations?.translate(
                                        AppStringConstant
                                            .tryDifferentFilters) ??
                                    '',
                                showButton: false,
                                showButtonText: true,
                                buttonText: _localizations?.translate(
                                        AppStringConstant.tryAgain) ??
                                    '',
                                onButtonPressed: () {
                                  // Navigator.of(context).pushNamedAndRemoveUntil(
                                  //   AppRoute.bottomTabBAr,
                                  //       (route) => false,
                                  // );
                                  Helper.hideSoftKeyBoard();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                    )
            ],
          ),
        ));
  }

  String searchImage = "imageSearch";
  String searchText = "textSearch";
  var methodChannel = const MethodChannel(AppConstant.channelName);

  Future<String> startImageRecognition(String type) async {
    try {
      String data = await methodChannel.invokeMethod(type);

      if (!mounted) return data;

      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      textEditingController.text = data;
      isLoading = true;
      searchScreenBloc?.add(SearchSuggestionEvent(data));
      print("dsfeggt........................$data");
      Navigator.of(context).pushNamed(
        AppRoute.catalog,
        arguments: categoryMap(
          data,
          data,
          "",
          "fromProductSearch",
          false,
        ),
      );

      return data;
    } on PlatformException catch (e) {
      return "Failed to Invoke: '${e.message}'.";
    }
  }

  Future<void> startBarcodeRecognition() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const BarcodeScanScreen()),
    );
  }
}
