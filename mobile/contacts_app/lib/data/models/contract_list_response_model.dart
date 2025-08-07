import '../../domain/entities/contact_list_response.dart';
import 'contact_model.dart';

class ContactListResponseModel extends ContactListResponse {
  const ContactListResponseModel({
    required super.contacts,
    required super.totalCount,
    required super.page,
    required super.pageSize,
  });

  factory ContactListResponseModel.fromJson(Map<String, dynamic> json) {
    final contactsJson = json['contacts'] as List<dynamic>;
    final contacts = contactsJson
        .map((contactJson) => ContactModel.fromJson(contactJson as Map<String, dynamic>))
        .toList();

    return ContactListResponseModel(
      contacts: contacts,
      totalCount: json['totalCount'] as int,
      page: json['page'] as int,
      pageSize: json['pageSize'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contacts': contacts
          .map((contact) => (contact as ContactModel).toJson())
          .toList(),
      'totalCount': totalCount,
      'page': page,
      'pageSize': pageSize,
    };
  }

  factory ContactListResponseModel.fromEntity(ContactListResponse contactListResponse) {
    return ContactListResponseModel(
      contacts: contactListResponse.contacts,
      totalCount: contactListResponse.totalCount,
      page: contactListResponse.page,
      pageSize: contactListResponse.pageSize,
    );
  }

  ContactListResponse toEntity() {
    return ContactListResponse(
      contacts: contacts,
      totalCount: totalCount,
      page: page,
      pageSize: pageSize,
    );
  }
}