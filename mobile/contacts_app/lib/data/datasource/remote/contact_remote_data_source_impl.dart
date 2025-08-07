import 'dart:io';

import 'package:contacts_app/core/resources/data_state.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/logger.dart';
import '../../../core/config/api_config.dart';
import '../../../domain/entities/contact.dart';
import '../../../domain/entities/contact_list_response.dart';
import '../../models/contact_model.dart';
import '../../models/contract_list_response_model.dart';
import '../local/auth_local_data_source.dart';
import 'contact_remote_data_source.dart';

class ContactRemoteDataSourceImpl implements ContactRemoteDataSource {
  final Dio dio;
  final AuthLocalDataSource authLocalDataSource;

  ContactRemoteDataSourceImpl({
    required this.dio,
    required this.authLocalDataSource
  });

  @override
  Future<DataState<ContactListResponseModel>> getContacts({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final token = await authLocalDataSource.getToken();

      // Debug print before request
      AppLogger().debug('Fetching contacts - page: $page, pageSize: $pageSize');

      final response = await dio.get(
        '/contact-api/api/Contacts',
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      // Complete response logging
      AppLogger().debug('''
    Contacts Response:
    Status: ${response.statusCode}
    Headers: ${response.headers}
    Data Length: ${response.data.toString().length}
    First 500 chars: ${response.data.toString().substring(0, response.data.toString().length > 500 ? 500 : response.data.toString().length)}
    ''');

      final model = ContactListResponseModel.fromJson(response.data);
      return DataSuccess<ContactListResponseModel>(model);
    } on DioException catch (e) {
      AppLogger().error('Failed to fetch contacts',
        error: e,
        stackTrace: e.stackTrace,
      );
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to fetch contacts',
        statusCode: e.response?.statusCode,
      );
    } catch (e, stackTrace) {
      AppLogger().error('Unexpected error fetching contacts',
        error: e,
        stackTrace: stackTrace,
      );
      throw ServerException(message: 'Unexpected error fetching contacts');
    }
  }

  @override
  Future<DataState<ContactListResponseModel>> addContact({required Contact contact, File? imageFile}) async {
    try {
      final token = await authLocalDataSource.getToken();
      final contactModel = ContactModel.fromEntity(contact);

      // Debug print before request
      AppLogger().debug('''
    Making POST request to:
    URL: ${ApiConfig.apiBaseUrl}/contact-api/api/Contacts
    Headers: ${{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      }}
    Body: ${contactModel.toCreateJson()}
    ''');

      final response = await dio.post(
        '/contact-api/api/Contacts', // Use relative path (base URL is already configured)
        data: contactModel.toCreateJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json', // Explicit content type
          },
        ),
      );

      // Debug print after request
      AppLogger().debug('''
    Response received:
    Status: ${response.statusCode}
    Data: ${response.data}
    ''');

      final model = ContactListResponseModel.fromJson(response.data);
      final createContact = model.contacts.first;
      final contactId = createContact.contactId;

      // Upload image if provided
      if (imageFile != null) {
        final formData = FormData.fromMap({
          'File': await MultipartFile.fromFile(imageFile.path),
        });

        final uploadResponse = await dio.post(
          '/contact-api/api/Contacts/$contactId/images',
          data: formData,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'multipart/form-data',
            },
          ),
        );

        AppLogger().debug('Image upload response: ${uploadResponse.data}');
      }
      return DataSuccess<ContactListResponseModel>(model);
    } on DioException catch (e) {
      AppLogger().error('''
    DioException in addContact:
    Error: ${e.error}
    Message: ${e.message}
    Response: ${e.response?.data}
    StackTrace: ${e.stackTrace}
    ''');

      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to add contact',
        statusCode: e.response?.statusCode,
      );
    } catch (e, stackTrace) {
      AppLogger().error('Unexpected error in addContact',
          error: e,
          stackTrace: stackTrace
      );
      throw ServerException(message: 'Unexpected error adding contact');
    }
  }

  @override
  Future<DataState<ContactListResponseModel>> updateContact({required Contact contact, File? imageFile}) async {
    try {
      final token = await authLocalDataSource.getToken();
      final contactModel = ContactModel.fromEntity(contact);
      final response = await dio.put(
        '${ApiConfig.apiBaseUrl}/contact-api/api/Contacts/${contact.contactId}',
        data: contactModel.toUpdateJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      final model = ContactListResponseModel.fromJson(response.data);
      final createContact = model.contacts.first;
      final contactId = createContact.contactId;

      // Upload image if provided
      if (imageFile != null) {
        final formData = FormData.fromMap({
          'File': await MultipartFile.fromFile(imageFile.path),
        });

        final uploadResponse = await dio.post(
          '/contact-api/api/Contacts/$contactId/images',
          data: formData,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'multipart/form-data',
            },
          ),
        );

        AppLogger().debug('Image upload response: ${uploadResponse.data}');
      }
      return DataSuccess<ContactListResponseModel>(model);
      return DataSuccess<ContactListResponseModel>(model);
    } on DioException catch (e) {
      AppLogger().error('Failed to update contact', error: e);
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to update contact',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      AppLogger().error('Unexpected error updating contact', error: e);
      throw ServerException(message: 'Unexpected error updating contact');
    }
  }

  @override
  Future<DataState<void>> deleteContact(String contactId) async {
    try {
      final token = await authLocalDataSource.getToken();
      await dio.delete(
        '${ApiConfig.apiBaseUrl}/contact-api/api/Contacts/$contactId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return const DataSuccess(null);
    } on DioException catch (e) {
      AppLogger().error('Failed to delete contact', error: e);
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to delete contact',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      AppLogger().error('Unexpected error deleting contact', error: e);
      throw ServerException(message: 'Unexpected error deleting contact');
    }
  }
}