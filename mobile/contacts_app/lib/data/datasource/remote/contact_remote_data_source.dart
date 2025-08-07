import 'package:contacts_app/core/resources/data_state.dart';

import '../../../../domain/entities/contact.dart';
import '../../../../domain/entities/contact_list_response.dart';
import '../../models/contract_list_response_model.dart';

abstract class ContactRemoteDataSource {
  Future<DataState<ContactListResponseModel>> getContacts({int page = 1, int pageSize = 20});
  Future<DataState<ContactListResponseModel>> addContact(Contact contact);
  Future<DataState<ContactListResponseModel>> updateContact(Contact contact);
  Future<DataState<void>> deleteContact(String contactId);
}