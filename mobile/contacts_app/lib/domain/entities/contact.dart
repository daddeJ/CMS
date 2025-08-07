import 'package:equatable/equatable.dart';

class Contact extends Equatable {
  final int id;
  final String contactId;
  final String userId;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? profilePicture;
  final DateTime dateCreated;
  final DateTime? dateUpdated;

  const Contact({
    required this.id,
    required this.contactId,
    required this.userId,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.profilePicture,
    required this.dateCreated,
    this.dateUpdated,
  });

  Contact copyWith({
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
    return Contact(
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

  @override
  List<Object?> get props => [
    id,
    contactId,
    userId,
    name,
    email,
    phoneNumber,
    profilePicture,
    dateCreated,
    dateUpdated,
  ];
}
