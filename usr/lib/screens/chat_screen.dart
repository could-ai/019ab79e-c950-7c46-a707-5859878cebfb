import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../models/ai_agent.dart';
import '../services/mock_ai_service.dart';
import '../widgets/agents_drawer.dart';
import '../widgets/voice_input_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final MockAiService _aiService = MockAiService();
  
  final List<ChatMessage> _messages = [];
  final List<AiAgent> _agents = [];
  
  bool _isTyping = false;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    // Initial greeting
    _addMessage(ChatMessage(
      id: 'init',
      text: "Hello! I'm CouldAI. Hold the mic button to speak, or type a command like 'Create a travel agent'.",
      sender: MessageSender.ai,
      timestamp: DateTime.now(),
    ));
  }

  void _addMessage(ChatMessage message) {
    setState(() {
      _messages.add(message);
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _handleSubmitted(String text) async {
    if (text.trim().isEmpty) return;

    _textController.clear();
    
    // Add user message
    _addMessage(ChatMessage(
      id: DateTime.now().toString(),
      text: text,
      sender: MessageSender.user,
      timestamp: DateTime.now(),
    ));

    setState(() {
      _isTyping = true;
    });

    // Check for agent creation
    final newAgent = _aiService.extractAgentFromInput(text);
    
    // Get AI response
    final response = await _aiService.getResponse(text);

    setState(() {
      _isTyping = false;
    });

    _addMessage(response);

    if (newAgent != null) {
      // Simulate a small delay before "creating" the agent
      await Future.delayed(const Duration(milliseconds: 800));
      setState(() {
        _agents.add(newAgent);
      });
      
      _addMessage(ChatMessage(
        id: DateTime.now().toString(),
        text: "✅ Created new agent: ${newAgent.name}\n${newAgent.description}",
        sender: MessageSender.system,
        timestamp: DateTime.now(),
      ));
    }
  }

  void _startListening() {
    setState(() {
      _isListening = true;
    });
    // In a real app, we would initialize SpeechToText here
  }

  void _stopListening() {
    setState(() {
      _isListening = false;
    });
    
    // Simulate voice recognition result
    // For demo purposes, we'll pick a random command or use a placeholder
    // In a real app, this would be the result from the STT engine
    
    // Let's simulate different commands for variety based on random chance
    final commands = [
      "Create a travel agent for my trip to Japan",
      "Create a coding assistant for Flutter",
      "Create a fitness coach",
      "Hello, how are you?",
      "Create a cooking bot",
    ];
    
    final simulatedText = commands[DateTime.now().second % commands.length];
    
    // Show a dialog to confirm what was "heard" (since we are mocking)
    // This helps the user understand what's happening in the demo
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Voice Input Simulated"),
        content: Text("Simulated voice input: \"$simulatedText\""),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _handleSubmitted(simulatedText);
            },
            child: const Text("Send"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('CouldAI', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      drawer: AgentsDrawer(agents: _agents),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildMessageBubble(msg);
              },
            ),
          ),
          if (_isTyping)
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 8),
              child: Row(
                children: [
                  const SizedBox(
                    width: 16, 
                    height: 16, 
                    child: CircularProgressIndicator(strokeWidth: 2)
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "CouldAI is thinking...",
                    style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
                  ),
                ],
              ),
            ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    final isUser = msg.sender == MessageSender.user;
    final isSystem = msg.sender == MessageSender.system;
    
    if (isSystem) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          border: Border.all(color: Colors.green.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          msg.text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.greenAccent),
        ),
      );
    }

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF6200EA) : const Color(0xFF2C2C2C),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
            bottomRight: isUser ? Radius.zero : const Radius.circular(16),
          ),
        ),
        child: Text(
          msg.text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E1E),
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Type or speak...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                filled: true,
                fillColor: const Color(0xFF2C2C2C),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onSubmitted: _handleSubmitted,
            ),
          ),
          const SizedBox(width: 12),
          VoiceInputWidget(
            isListening: _isListening,
            onStartListening: _startListening,
            onStopListening: _stopListening,
          ),
        ],
      ),
    );
  }
}
