import 'package:contacts_app/core/resources/data_state.dart';
import 'package:contacts_app/domain/entities/contact_list_response.dart';

import '../entities/contact.dart';
import '../repositories/contact_repository.dart';

class UpdateContact {
  final ContactRepository repository;

  UpdateContact(this.repository);

  Future<DataState<ContactListResponse>> call(Contact contact) async {
    return await repository.updateContact(contact);
  }
}