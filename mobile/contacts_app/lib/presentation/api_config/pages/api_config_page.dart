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

  void _saveAndContinue() {
    final url = _controller.text;
    context.read<ApiConfigCubit>().updateConfig(url);
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
              _controller.text = (state as dynamic).baseUrl;
            }

            return Column(
              children: [
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'Base URL',
                    hintText: 'http://192.168.x.x:5000',
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
