import 'dart:io';
import 'package:contacts_app/core/resources/data_state.dart';

import '../../../../domain/entities/contact.dart';
import '../../models/contract_list_response_model.dart';

abstract class ContactRemoteDataSource {
  Future<DataState<ContactListResponseModel>> getContacts({int page = 1, int pageSize = 20});
  Future<DataState<ContactListResponseModel>> addContact({required Contact contact, File? imageFile});
  Future<DataState<ContactListResponseModel>> updateContact({required Contact contact, File? imageFile});
  Future<DataState<void>> deleteContact(String contactId);
}