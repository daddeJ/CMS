import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../domain/entities/contact.dart';
import '../../../../domain/usecases/fetch_contact_list.dart';
import '../../../../domain/usecases/add_contact.dart';
import '../../../../domain/usecases/update_contact.dart';
import '../../../../domain/usecases/delete_item_contact.dart';
import '../../../core/resources/data_state.dart';

part 'contact_state.dart';

class ContactCubit extends Cubit<ContactState> {
  final FetchContactList fetchContactList;
  final AddContact addContact;
  final UpdateContact updateContact;
  final DeleteItemContact deleteItemContact;
  DateTime? _lastOperationTime;

  ContactCubit({
    required this.fetchContactList,
    required this.addContact,
    required this.updateContact,
    required this.deleteItemContact,
  }) : super(ContactInitial());

  Future<void> fetchContacts() async {
    if (state is! ContactLoading) emit(ContactLoading());
    try {
      final response = await fetchContactList();
      if (response is DataSuccess && response.data != null) {
        emit(ContactLoaded(contacts: response.data!.contacts));
      } else if (response is DataFailed) {
        emit(ContactError(message: response.error?.message ?? "Network error"));
      }
    } catch (e) {
      emit(ContactError(message: "Failed to load contacts"));
    }
  }

  Future<void> addNewContact({required Contact contact, File? imageFile}) async {
    emit(ContactLoading());
    try {
      final response = await addContact(contact: contact, imageFile: imageFile);
      if (response is DataSuccess) {
        // Force a complete refresh from server
        await fetchContacts();
      } else if (response is DataFailed) {
        emit(ContactError(message: response.error?.message ?? "Add failed"));
        // Revert to previous state if available
        if (state is ContactLoaded) {
          emit(ContactLoaded(contacts: (state as ContactLoaded).contacts));
        }
      }
    } catch (e) {
      emit(ContactError(message: e.toString()));
      if (state is ContactLoaded) {
        emit(ContactLoaded(contacts: (state as ContactLoaded).contacts));
      }
    }
  }

  Future<void> _safeFetch() async {
    if (_lastOperationTime != null &&
        DateTime.now().difference(_lastOperationTime!) < Duration(seconds: 1)) {
      await Future.delayed(Duration(seconds: 1));
    }
    _lastOperationTime = DateTime.now();
    await fetchContacts();
  }

  // Similar optimizations for update/delete
  Future<void> updateExistingContact({required Contact contact, File? imageFile}) async {
    emit(ContactLoading());
    try {
      final response = await updateContact(contact: contact, imageFile: imageFile);
      if (response is DataSuccess) {
        if (state is ContactLoaded) {
          final contacts = (state as ContactLoaded).contacts.map((c) =>
          c.id == contact.id ? contact : c).toList();
          emit(ContactLoaded(contacts: contacts));
        } else {
          await _safeFetch();
        }
      }
    } catch (e) {
      emit(ContactError(message: e.toString()));
    }
  }

  Future<void> deleteContact(String contactId) async {
    emit(ContactLoading());
    try {
      final response = await deleteItemContact(contactId);
      if (response is DataSuccess) {
        if (state is ContactLoaded) {
          final contacts = (state as ContactLoaded).contacts
              .where((c) => c.id != contactId).toList();
          emit(ContactLoaded(contacts: contacts));
        } else {
          await _safeFetch();
        }
      }
    } catch (e) {
      emit(ContactError(message: e.toString()));
    }
  }
}