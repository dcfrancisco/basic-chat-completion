import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_ui/system_messages.dart';

class SystemMessageProvider extends ChangeNotifier {
  String _systemMessage = SystemMessages.defaultAssistant;
  String _selectedPersona = 'Default Assistant';
  String _clientApiKey = '';

  // API model and generation settings
  String _model = 'gpt-3.5-turbo';
  double _temperature = 1.0;
  int _maxTokens = 256;
  double _topP = 1.0;
  double _frequencyPenalty = 0.0;
  double _presencePenalty = 0.0;

  String get systemMessage => _systemMessage;
  String get selectedPersona => _selectedPersona;
  String get clientApiKey => _clientApiKey;
  Map<String, String> get personas => SystemMessages.personas;

  // Settings getters
  String get model => _model;
  double get temperature => _temperature;
  int get maxTokens => _maxTokens;
  double get topP => _topP;
  double get frequencyPenalty => _frequencyPenalty;
  double get presencePenalty => _presencePenalty;

  Map<String, dynamic> get apiSettings => {
    'model': _model,
    'temperature': _temperature,
    'max_tokens': _maxTokens,
    'top_p': _topP,
    'frequency_penalty': _frequencyPenalty,
    'presence_penalty': _presencePenalty,
  };

  SystemMessageProvider() {
    initialize();
  }

  Future<void> initialize() async {
    await _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedPersona =
        prefs.getString('selected_persona') ?? 'Default Assistant';
    _systemMessage =
        prefs.getString('system_message') ?? personas[_selectedPersona]!;
    _clientApiKey = prefs.getString('client_api_key') ?? '';

    // Load saved API settings
    _model = prefs.getString('api_model') ?? _model;
    _temperature = prefs.getDouble('api_temperature') ?? _temperature;
    _maxTokens = prefs.getInt('api_max_tokens') ?? _maxTokens;
    _topP = prefs.getDouble('api_top_p') ?? _topP;
    _frequencyPenalty =
        prefs.getDouble('api_frequency_penalty') ?? _frequencyPenalty;
    _presencePenalty =
        prefs.getDouble('api_presence_penalty') ?? _presencePenalty;
    notifyListeners();
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_persona', _selectedPersona);
    await prefs.setString('system_message', _systemMessage);
    await prefs.setString('client_api_key', _clientApiKey);

    // Save API settings
    await prefs.setString('api_model', _model);
    await prefs.setDouble('api_temperature', _temperature);
    await prefs.setInt('api_max_tokens', _maxTokens);
    await prefs.setDouble('api_top_p', _topP);
    await prefs.setDouble('api_frequency_penalty', _frequencyPenalty);
    await prefs.setDouble('api_presence_penalty', _presencePenalty);
  }

  void updateSystemMessage(String newMessage) {
    if (_systemMessage == newMessage) return;
    _systemMessage = newMessage;
    _saveAndNotify();
  }

  // --- Settings update methods ---
  void setModel(String newModel) {
    if (_model == newModel) return;
    _model = newModel;
    _saveAndNotify();
  }

  void setTemperature(double value) {
    if (_temperature == value) return;
    _temperature = value;
    _saveAndNotify();
  }

  void setMaxTokens(int value) {
    if (_maxTokens == value) return;
    _maxTokens = value;
    _saveAndNotify();
  }

  void setTopP(double value) {
    if (_topP == value) return;
    _topP = value;
    _saveAndNotify();
  }

  void setFrequencyPenalty(double value) {
    if (_frequencyPenalty == value) return;
    _frequencyPenalty = value;
    _saveAndNotify();
  }

  void setPresencePenalty(double value) {
    if (_presencePenalty == value) return;
    _presencePenalty = value;
    _saveAndNotify();
  }

  void setClientApiKey(String key) {
    if (_clientApiKey == key) return;
    _clientApiKey = key;
    _saveAndNotify();
  }

  void selectPersona(String personaName) {
    if (_selectedPersona == personaName) return;
    _selectedPersona = personaName;
    if (personas.containsKey(personaName) && personaName != 'Custom') {
      _systemMessage = personas[personaName]!;
    }
    _saveAndNotify();
  }

  void updateCustomPersona(String customMessage) {
    _selectedPersona = 'Custom';
    _systemMessage = customMessage;
    _saveAndNotify();
  }

  void _saveAndNotify() {
    _savePreferences();
    notifyListeners();
  }
}
