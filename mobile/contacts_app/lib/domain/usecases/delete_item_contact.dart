import 'package:contacts_app/core/resources/data_state.dart';

import '../repositories/contact_repository.dart';

class DeleteItemContact {
  final ContactRepository repository;

  DeleteItemContact(this.repository);

  Future<DataState<void>> call(String contactId) async {
    return await repository.deleteContact(contactId);
  }
}