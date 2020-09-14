import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algolia/algolia.dart';
import 'package:p/models/UserModel.dart';
import '../../Constants.dart';
import 'SearchTeachersCache.dart';

class SearchTeachersRepository {
  final SearchTeachersCache cache;

  final Algolia _algolia = Algolia.init(
    applicationId: ALGOLIA_APP_ID,
    apiKey: ALGOLIA_SEARCH_API_KEY,
  );

  SearchTeachersRepository({@required this.cache});

  Future<List<UserModel>> search(
      {@required String term, String profileType}) async {
    if (cache.contains(term)) {
      return cache.get(term);
    } else {
      AlgoliaQuery query = _algolia.instance.index('Users').search(term);

      if (profileType != null) {
        query = query.setFacetFilter('profileType:$profileType');
      }

      final List<AlgoliaObjectSnapshot> results =
          (await query.getObjects()).hits;

      final List<UserModel> users = results
          .map((result) => UserModel.extractAlgoliaObjectSnapshot(aob: result))
          .toList();

      cache.set(term, users);
      return users;
    }
  }
}
