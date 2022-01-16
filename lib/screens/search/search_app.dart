import 'package:flutter/material.dart';
import 'package:guam_community_client/screens/search/search_history.dart';
import 'package:guam_community_client/styles/colors.dart';
import 'package:provider/provider.dart';
import 'search_app_bar.dart';
import 'search_app_textfield.dart';
import 'package:provider/provider.dart';
import '../../providers/search/search.dart';

class SearchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Search()),
      ],
      child: SearchAppScaffold(),
    );
  }
}

class SearchAppScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final searchProvider = context.read<Search>();

    return Scaffold(
      backgroundColor: GuamColorFamily.grayscaleWhite,
      appBar: SearchAppBar(
        title: SearchAppTextField(),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: GuamColorFamily.purpleLight3),
        child: searchProvider.searchHistory.isNotEmpty
            ? SearchHistory(searchProvider.searchHistory)
            : Container(),
      ),
    );
  }
}
