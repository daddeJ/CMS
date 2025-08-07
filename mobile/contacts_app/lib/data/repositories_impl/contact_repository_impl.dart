import 'dart:io';
import 'package:contacts_app/core/resources/data_state.dart';

import '../../domain/repositories/contact_repository.dart';
import '../../domain/entities/contact.dart';
import '../../domain/entities/contact_list_response.dart';
import '../datasource/remote/contact_remote_data_source.dart';
import '../models/contract_list_response_model.dart';

class ContactRepositoryImpl implements ContactRepository {
  final ContactRemoteDataSource remoteDataSource;

  ContactRepositoryImpl({required this.remoteDataSource});

  @override
  Future<DataState<ContactListResponseModel>> getContacts({int page = 1, int pageSize = 20}) async {
    return await remoteDataSource.getContacts();
  }

  @override
  Future<DataState<ContactListResponseModel>> addContact({required Contact contact, File? imageFile}) async {
    return await remoteDataSource.addContact(contact: contact, imageFile: imageFile);
  }

  @override
  Future<DataState<ContactListResponseModel>> updateContact({required Contact contact, File? imageFile}) async {
    return await remoteDataSource.updateContact(contact: contact, imageFile: imageFile);
  }

  @override
  Future<DataState<void>> deleteContact(String contactId) async {
    await remoteDataSource.deleteContact(contactId);
    return DataSuccess(null);
  }
}