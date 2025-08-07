import '../../domain/entities/contact.dart';

class ContactModel extends Contact {
  const ContactModel({
    required super.id,
    required super.contactId,
    required super.userId,
    required super.name,
    required super.email,
    super.phoneNumber,
    super.profilePicture,
    required super.dateCreated,
    super.dateUpdated,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'] as int,
      contactId: json['contactId'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      profilePicture: json['profilePicture'] as String?,
      dateCreated: DateTime.parse(json['dateCreated'] as String),
      dateUpdated: json['dateUpdated'] != null
          ? DateTime.parse(json['dateUpdated'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contactId': contactId,
      'userId': userId,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'profilePicture': profilePicture,
      'dateCreated': dateCreated.toIso8601String(),
      'dateUpdated': dateUpdated?.toIso8601String(),
    };
  }

  Map<String, dynamic> toCreateJson() {
    // Exclude id and timestamps for create requests
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'profilePicture': profilePicture,
    };
  }

  Map<String, dynamic> toUpdateJson() {
    // Exclude auto-generated fields for update requests
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'profilePicture': profilePicture,
    };
  }

  factory ContactModel.fromEntity(Contact contact) {
    return ContactModel(
      id: contact.id,
      contactId: contact.contactId,
      userId: contact.userId,
      name: contact.name,
      email: contact.email,
      phoneNumber: contact.phoneNumber,
      profilePicture: contact.profilePicture,
      dateCreated: contact.dateCreated,
      dateUpdated: contact.dateUpdated,
    );
  }

  Contact toEntity() {
    return Contact(
      id: id,
      contactId: contactId,
      userId: userId,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      profilePicture: profilePicture,
      dateCreated: dateCreated,
      dateUpdated: dateUpdated,
    );
  }

  // Helper method to create a new contact for adding
  ContactModel copyWith({
    int? id,
    String? contactId,
    String? userId,
    String? name,
    String? email,
    String? phoneNumber,
    String? profilePicture,
    DateTime? dateCreated,
    DateTime? dateUpdated,
  }) {
    return ContactModel(
      id: id ?? this.id,
      contactId: contactId ?? this.contactId,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePicture: profilePicture ?? this.profilePicture,
      dateCreated: dateCreated ?? this.dateCreated,
      dateUpdated: dateUpdated ?? this.dateUpdated,
    );
  }
}