import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/api_config_cubit.dart';

class ApiConfigPage extends StatefulWidget {
  const ApiConfigPage({super.key});

  @override
  State<ApiConfigPage> createState() => _ApiConfigPageState();
}

class _ApiConfigPageState extends State<ApiConfigPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ApiConfigCubit>().loadConfig();
  }

  String _extractAddressFromUrl(String url) {
    final regex = RegExp(r'http://([^:]+):5000');
    final match = regex.firstMatch(url);
    return match?.group(1) ?? url;
  }

  void _saveAndContinue() {
    final address = _controller.text.trim();
    if (address.isNotEmpty) {
      final fullUrl = 'http://$address:5000';
      context.read<ApiConfigCubit>().updateConfig(fullUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('API Configuration')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<ApiConfigCubit, ApiConfigState>(
          listener: (context, state) {
            if (state is ApiConfigSaved) {
              Navigator.pushReplacementNamed(context, '/login');
            }
          },
          builder: (context, state) {
            if (state is ApiConfigLoaded || state is ApiConfigSaved) {
              final baseUrl = (state as dynamic).baseUrl;
              _controller.text = _extractAddressFromUrl(baseUrl);
            }

            return Column(
              children: [
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'Server Address',
                    hintText: '192.168.1.100 or localhost',
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saveAndContinue,
                  child: state is ApiConfigSaving
                      ? const CircularProgressIndicator()
                      : const Text('Continue'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}