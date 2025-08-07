import 'package:contacts_app/presentation/contact/pages/add_contact_page.dart';
import 'package:contacts_app/presentation/contact/pages/update_contact_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../../domain/entities/contact.dart';
import '../cubit/contact_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Add this import

class ContactListPage extends StatefulWidget {
  const ContactListPage({Key? key}) : super(key: key);

  @override
  State<ContactListPage> createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  @override
  void initState() {
    super.initState();
    context.read<ContactCubit>().fetchContacts();
  }

  Future<void> _confirmDelete(BuildContext context, Contact contact) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Contact'),
        content: const Text('Are you sure you want to delete this contact?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await context.read<ContactCubit>().deleteContact(contact.contactId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Contact deleted successfully'),
              duration: Duration(seconds: 2),
            ),
          );
          context.read<ContactCubit>().fetchContacts();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete contact: ${e.toString()}'),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    }
  }

  Future<void> _logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        // Clear any stored authentication tokens or user data
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();

        // Navigate to login screen or root
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login', // Replace with your login route
              (route) => false,
        );
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Logout failed: ${e.toString()}'),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black38),
            onPressed: () => _logout(context), // Updated to call _logout
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final shouldRefresh = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const AddContactPage()),
          );
          if (shouldRefresh != false) {
            context.read<ContactCubit>().fetchContacts();
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: BlocConsumer<ContactCubit, ContactState>(
        listener: (context, state) {
          if (state is ContactError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is ContactLoading) return const Center(child: CircularProgressIndicator());
          if (state is ContactError) return _buildErrorState(context, state);
          if (state is ContactLoaded) return _buildContactList(context, state.contacts);
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, ContactError state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(state.message),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<ContactCubit>().fetchContacts(),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.refresh),
                SizedBox(width: 8),
                Text('Retry'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactList(BuildContext context, List<Contact> contacts) {
    final sortedContacts = List<Contact>.from(contacts)
      ..sort((a, b) => b.id.compareTo(a.id));

    if (sortedContacts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.contacts, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('No contacts found'),
            TextButton(
              onPressed: () => context.read<ContactCubit>().fetchContacts(),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.refresh),
                  SizedBox(width: 8),
                  Text('Refresh'),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => context.read<ContactCubit>().fetchContacts(),
      child: ListView.builder(
        itemCount: sortedContacts.length,
        itemBuilder: (context, index) {
          final contact = sortedContacts[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(
                  contact.name[0],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(contact.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(contact.phoneNumber ?? ''),
                ],
              ),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      color: Theme.of(context).primaryColor,
                      onPressed: () async {
                        final shouldRefresh = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => UpdateContactPage(contact: contact),
                          ),
                        );
                        if (shouldRefresh != false) {
                          context.read<ContactCubit>().fetchContacts();
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      color: Colors.red,
                      onPressed: () => _confirmDelete(context, contact),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}