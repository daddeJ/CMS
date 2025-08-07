import 'package:contacts_app/core/resources/data_state.dart';
import 'package:contacts_app/data/models/contract_list_response_model.dart';

import '../entities/contact.dart';
import '../entities/contact_list_response.dart';

abstract class ContactRepository {
  Future<DataState<ContactListResponseModel>> getContacts({int page = 1, int pageSize = 20});
  Future<DataState<ContactListResponseModel>> addContact(Contact contact);
  Future<DataState<ContactListResponseModel>> updateContact(Contact contact);
  Future<DataState<void>> deleteContact(String contactId);
}