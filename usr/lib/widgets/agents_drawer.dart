import 'package:flutter/material.dart';
import '../models/ai_agent.dart';

class AgentsDrawer extends StatelessWidget {
  final List<AiAgent> agents;

  const AgentsDrawer({super.key, required this.agents});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1E1E1E),
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6200EA), Color(0xFFB388FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Icon(Icons.smart_toy, size: 48, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'My AI Agents',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: agents.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.dashboard_customize_outlined, 
                             size: 48, color: Colors.white24),
                        const SizedBox(height: 16),
                        const Text(
                          "No agents yet.\nTry 'Create a travel agent'",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white54),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: agents.length,
                    itemBuilder: (context, index) {
                      final agent = agents[index];
                      return ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            agent.icon,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                        title: Text(
                          agent.name,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          agent.description,
                          style: const TextStyle(color: Colors.white54),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          // In a real app, this would switch context to that agent
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Switched to ${agent.name}')),
                          );
                        },
                      );
                    },
                  ),
          ),
          const Divider(color: Colors.white24),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.white70),
            title: const Text('Settings', style: TextStyle(color: Colors.white70)),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
