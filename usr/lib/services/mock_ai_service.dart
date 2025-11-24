import 'dart:async';
import 'dart:math';
import '../models/chat_message.dart';
import '../models/ai_agent.dart';

class MockAiService {
  
  // Simulate AI processing to generate a response
  Future<ChatMessage> getResponse(String userText) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1500));

    String responseText = "I didn't quite catch that. You can ask me to create an agent, like 'Create a travel agent'.";

    if (userText.toLowerCase().contains('hello') || userText.toLowerCase().contains('hi')) {
      responseText = "Hello! I am your Voice AI Architect. Tell me what kind of AI agent you want to build.";
    } else if (userText.toLowerCase().contains('create') && (userText.toLowerCase().contains('agent') || userText.toLowerCase().contains('bot'))) {
      // The actual creation logic happens in the UI state for this demo, 
      // but the bot acknowledges it here.
      // We will handle the "extraction" of the agent details separately.
      responseText = "I'm on it. Constructing your new AI agent based on your specifications...";
    } else if (userText.toLowerCase().contains('help')) {
      responseText = "Try saying 'Create a coding assistant' or 'Create a fitness coach'.";
    } else {
      // Generic response for other inputs
      final responses = [
        "That's interesting. Tell me more.",
        "I can help you build specialized AI agents. Just say the word.",
        "Ready to create. What's your next idea?",
      ];
      responseText = responses[Random().nextInt(responses.length)];
    }

    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: responseText,
      sender: MessageSender.ai,
      timestamp: DateTime.now(),
    );
  }

  // Helper to extract agent details from a command
  AiAgent? extractAgentFromInput(String text) {
    final lowerText = text.toLowerCase();
    if (!lowerText.contains('create')) return null;

    String name = "Custom Agent";
    String description = "A specialized AI agent created by voice command.";
    String icon = "🤖";

    if (lowerText.contains('travel') || lowerText.contains('trip')) {
      name = "Travel Planner";
      description = "Expert in booking flights, hotels, and creating itineraries.";
      icon = "✈️";
    } else if (lowerText.contains('code') || lowerText.contains('coding') || lowerText.contains('program')) {
      name = "Dev Assistant";
      description = "Helps with debugging, code generation, and architecture.";
      icon = "💻";
    } else if (lowerText.contains('fit') || lowerText.contains('gym') || lowerText.contains('workout')) {
      name = "Fitness Coach";
      description = "Creates workout plans and tracks nutrition.";
      icon = "💪";
    } else if (lowerText.contains('cook') || lowerText.contains('food') || lowerText.contains('recipe')) {
      name = "Sous Chef";
      description = "Suggests recipes based on ingredients you have.";
      icon = "🍳";
    } else if (lowerText.contains('write') || lowerText.contains('blog') || lowerText.contains('copy')) {
      name = "Copywriter";
      description = "Generates creative text for blogs, ads, and stories.";
      icon = "✍️";
    } else if (lowerText.contains('finance') || lowerText.contains('money')) {
      name = "Finance Guru";
      description = "Advice on budgeting, investing, and saving.";
      icon = "💰";
    }

    return AiAgent(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
      icon: icon,
    );
  }
}
