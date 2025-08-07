import 'package:equatable/equatable.dart';
import 'contact.dart';

class ContactListResponse {
  final List<Contact> contacts;
  final int totalCount;
  final int page;
  final int pageSize;

  const ContactListResponse({
    required this.contacts,
    required this.totalCount,
    required this.page,
    required this.pageSize,
  });
}