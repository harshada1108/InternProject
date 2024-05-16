import 'package:internp/viewModel/fetchmodel.dart';

import 'fetchimagApi.dart';
import 'fetchmodel.dart';
import 'package:http/http.dart' as http;

class ViewModel {
  final _repo = fetchImageApi();

  Future<EventModel> fetchApi() async {
    final response = await _repo.fetchApi();
    print("Heyyyyyyyyyyyyyyyyyyyyyy");
    print(response);
    return response;
  }
  Future<EventModel> fetchMoreData() async {
    final response = await _repo.fetchMoreData();
    print("Heyyyyyyyyyyyyyyyyyyyyyy");
    print(response);
    return response;
  }
}
