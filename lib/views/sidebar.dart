import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_ui/system_message_provider.dart';
import 'package:mobile_ui/services/chat_service.dart';

class Sidebar extends StatefulWidget {
  final Function(String) onSystemMessageUpdated;

  const Sidebar({super.key, required this.onSystemMessageUpdated});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  late TextEditingController _systemMessageController;
  late TextEditingController _apiKeyController;
  late FocusNode _systemMessageFocus;

  @override
  void initState() {
    super.initState();
    _systemMessageController = TextEditingController();
    _apiKeyController = TextEditingController();
    _systemMessageFocus = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<SystemMessageProvider>(
        context,
        listen: false,
      );
      _systemMessageController.text = provider.systemMessage;
    });
  }

  @override
  void dispose() {
    _systemMessageController.dispose();
    _apiKeyController.dispose();
    _systemMessageFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SystemMessageProvider>(
      builder: (context, systemMessageProvider, child) {
        if (!_systemMessageFocus.hasFocus &&
            _systemMessageController.text !=
                systemMessageProvider.systemMessage) {
          _systemMessageController.text = systemMessageProvider.systemMessage;
        }

        return Drawer(
          child: Column(
            children: <Widget>[
              AppBar(
                title: const Text('Settings'),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _updateSystemMessage(context);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
                automaticallyImplyLeading: false,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle(context, 'AI Persona'),
                      const SizedBox(height: 8),
                      _buildPersonaSelector(systemMessageProvider),
                      const SizedBox(height: 16),
                      _buildSystemMessageInput(systemMessageProvider),
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 16),
                      _buildSectionTitle(context, 'API Configuration'),
                      const SizedBox(height: 16),
                      _buildApiKeyInput(),
                      const SizedBox(height: 16),
                      _buildApiSettings(systemMessageProvider),
                      const SizedBox(height: 24),
                      _buildActionButtons(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildPersonaSelector(SystemMessageProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: provider.selectedPersona,
          isExpanded: true,
          items: provider.personas.keys.map((String persona) {
            return DropdownMenuItem<String>(
              value: persona,
              child: Text(persona),
            );
          }).toList(),
          onChanged: (String? newPersona) {
            if (newPersona != null) {
              provider.selectPersona(newPersona);
              widget.onSystemMessageUpdated(provider.systemMessage);
            }
          },
        ),
      ),
    );
  }

  Widget _buildSystemMessageInput(SystemMessageProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('System Message', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        TextField(
          controller: _systemMessageController,
          focusNode: _systemMessageFocus,
          maxLines: 5,
          textAlignVertical: TextAlignVertical.top,
          decoration: InputDecoration(
            hintText: 'Define the AI\'s personality and instructions...',
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.grey.shade100,
          ),
          onChanged: (text) {
            provider.updateCustomPersona(text);
            widget.onSystemMessageUpdated(text);
          },
        ),
      ],
    );
  }

  Widget _buildApiKeyInput() {
    return TextField(
      controller: _apiKeyController,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: 'OpenAI API Key',
        hintText: 'sk-xxxxxxxxxxxxxxxxxxxx',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.vpn_key_outlined),
      ),
    );
  }

  Widget _buildApiSettings(SystemMessageProvider provider) {
    return ExpansionTile(
      title: Text(
        'Advanced API Settings',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      children: [
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: provider.model,
          decoration: const InputDecoration(
            labelText: 'Model',
            border: OutlineInputBorder(),
          ),
          items: <String>[
            'gpt-3.5-turbo',
            'gpt-4o',
            'gpt-4',
          ].map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
          onChanged: (v) {
            if (v != null) provider.setModel(v);
          },
        ),
        const SizedBox(height: 16),
        _buildSlider(
          label: 'Temperature',
          value: provider.temperature,
          min: 0.0,
          max: 2.0,
          divisions: 20,
          onChanged: (v) => provider.setTemperature(v),
        ),
        _buildSlider(
          label: 'Top-p',
          value: provider.topP,
          min: 0.0,
          max: 1.0,
          divisions: 20,
          onChanged: (v) => provider.setTopP(v),
        ),
        TextFormField(
          initialValue: provider.maxTokens.toString(),
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Max Tokens',
            border: OutlineInputBorder(),
          ),
          onFieldSubmitted: (val) {
            final parsed = int.tryParse(val);
            if (parsed != null) provider.setMaxTokens(parsed);
          },
        ),
        const SizedBox(height: 16),
        _buildSlider(
          label: 'Frequency Penalty',
          value: provider.frequencyPenalty,
          min: -2.0,
          max: 2.0,
          divisions: 40,
          onChanged: (v) => provider.setFrequencyPenalty(v),
        ),
        _buildSlider(
          label: 'Presence Penalty',
          value: provider.presencePenalty,
          min: -2.0,
          max: 2.0,
          divisions: 40,
          onChanged: (v) => provider.setPresencePenalty(v),
        ),
      ],
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ${value.toStringAsFixed(2)}'),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.save),
            label: const Text('Save and Apply'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              _updateSystemMessage(context);
              final provider = Provider.of<SystemMessageProvider>(
                context,
                listen: false,
              );
              if (_apiKeyController.text.isNotEmpty) {
                provider.setClientApiKey(_apiKeyController.text);
              }
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Settings saved successfully!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              Navigator.of(context).pop();
            },
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.api),
            label: const Text('Test API Connection'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              final cs = ChatService();
              final result = await cs.testConnection();
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(result),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _updateSystemMessage(BuildContext context) {
    final systemMessageProvider = Provider.of<SystemMessageProvider>(
      context,
      listen: false,
    );
    final systemMessage = _systemMessageController.text;
    systemMessageProvider.updateSystemMessage(systemMessage);
  }
}
