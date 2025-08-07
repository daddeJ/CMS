import 'package:contacts_app/core/resources/data_state.dart';

import '../entities/contact_list_response.dart';
import '../repositories/contact_repository.dart';

class FetchContactList {
  final ContactRepository repository;

  FetchContactList(this.repository);

  Future<DataState<ContactListResponse>> call({int page = 1, int pageSize = 20}) async {
    return await repository.getContacts(page: page, pageSize: pageSize);
  }
}