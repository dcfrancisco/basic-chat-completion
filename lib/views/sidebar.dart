import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_ui/system_message_provider.dart';

class Sidebar extends StatelessWidget {
  final TextEditingController _systemMessageController;
  final Function(String) onSystemMessageUpdated;

  Sidebar({Key? key, required this.onSystemMessageUpdated})
      : _systemMessageController = TextEditingController(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final systemMessageProvider = Provider.of<SystemMessageProvider>(context);

    // Set the default value of _systemMessageController
    _systemMessageController.text = systemMessageProvider.systemMessage;

    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: const Text('Sidebar Title'),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _updateSystemMessage(context);
                Navigator.of(context).pop();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.60,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
              child: TextFormField(
                controller: _systemMessageController,
                maxLines: null,
                expands: true,
                onChanged: (text) {
                  onSystemMessageUpdated(text);
                },
                decoration: const InputDecoration(
                  labelText: 'System',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding: EdgeInsets.all(8.0),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'API Key',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateSystemMessage(BuildContext context) {
    final systemMessageProvider =
        Provider.of<SystemMessageProvider>(context, listen: false);
    final systemMessage = _systemMessageController.text;
    systemMessageProvider.updateSystemMessage(systemMessage);
  }
}
