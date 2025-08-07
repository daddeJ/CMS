import 'dart:io';
import 'package:contacts_app/core/resources/data_state.dart';
import 'package:contacts_app/data/models/contract_list_response_model.dart';

import '../entities/contact.dart';

abstract class ContactRepository {
  Future<DataState<ContactListResponseModel>> getContacts({int page = 1, int pageSize = 20});
  Future<DataState<ContactListResponseModel>> addContact({required Contact contact, File? imageFile});
  Future<DataState<ContactListResponseModel>> updateContact({required Contact contact, File? imageFile});
  Future<DataState<void>> deleteContact(String contactId);
}