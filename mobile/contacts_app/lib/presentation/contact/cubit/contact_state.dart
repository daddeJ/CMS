part of 'contact_cubit.dart';

abstract class ContactState extends Equatable {
  const ContactState();

  @override
  List<Object> get props => [];
}

class ContactInitial extends ContactState {}

class ContactLoading extends ContactState {}

class ContactLoaded extends ContactState {
  final List<Contact> contacts;

  const ContactLoaded({required this.contacts});

  @override
  List<Object> get props => [contacts];
}

class ContactError extends ContactState {
  final String message;

  const ContactError({required this.message});

  @override
  List<Object> get props => [message];
}