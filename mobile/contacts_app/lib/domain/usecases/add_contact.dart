import 'dart:io';
import 'package:contacts_app/core/resources/data_state.dart';
import 'package:contacts_app/domain/entities/contact_list_response.dart';

import '../entities/contact.dart';
import '../repositories/contact_repository.dart';

class AddContact {
  final ContactRepository repository;

  AddContact(this.repository);

  Future<DataState<ContactListResponse>> call({required Contact contact, File? imageFile}) async {
    return await repository.addContact(contact: contact, imageFile: imageFile);
  }
}