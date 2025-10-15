import 'package:flutter/material.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();
  bool _hasText = false;

  // Array de mensajes para evitar código repetido
  List<Map<String, dynamic>> messages = [
    {'text': 'Hello! John', 'isFromUser': true, 'timestamp': '09:25 AM'},
    {
      'text': 'Hello! Carlos hry?',
      'isFromUser': false,
      'timestamp': '09:25 AM',
    },
    {'text': 'Hello! John', 'isFromUser': true, 'timestamp': '09:25 AM'},
    {
      'text': 'Hello! Carlos hry?',
      'isFromUser': false,
      'timestamp': '09:25 AM',
    },
    {'text': 'Hello! John', 'isFromUser': true, 'timestamp': '09:25 AM'},
    {
      'text': 'Hello! Carlos hry?',
      'isFromUser': false,
      'timestamp': '09:25 AM',
    },
    {'text': 'Hello! John', 'isFromUser': true, 'timestamp': '09:25 AM'},
    {
      'text': 'Hello! Carlos hry?',
      'isFromUser': false,
      'timestamp': '09:25 AM',
    },
    {'text': 'Hello! John', 'isFromUser': true, 'timestamp': '09:25 AM'},
    {
      'text': 'Hello! Carlos hry?',
      'isFromUser': false,
      'timestamp': '09:25 AM',
    },
  ];

  // Función para enviar mensaje
  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        messages.add({
          'text': _messageController.text.trim(),
          'isFromUser': true,
          'timestamp': _getCurrentTime(),
        });
      });
      _messageController.clear();
    }
  }

  // Función para obtener la hora actual
  String _getCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : now.hour;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'PM' : 'AM';
    return '${hour == 0 ? 12 : hour}:$minute $period';
  }

  @override
  void initState() {
    super.initState();
    _messageController.addListener(() {
      setState(() {
        _hasText = _messageController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Container(
            height: 100,
            color: const Color(0xFFFFC436),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  children: [
                    // Back button
                    IconButton(
                      onPressed: () => {},
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage(
                            'assets/images/chats-cesar-picture.png',
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(width: 12),

                    // Contact info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Cesar Avellanea',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const Text(
                            'Active now',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        // Handle phone call
                      },
                      icon: const Icon(
                        Icons.phone,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Chat messages
          Expanded(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  // Date separator
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Today',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),

                  // Messages
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final isFromUser = message['isFromUser'] as bool;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: isFromUser
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (!isFromUser) ...[
                                // Profile picture for left messages
                                CircleAvatar(
                                  radius: 12,
                                  backgroundImage: AssetImage(
                                    'assets/images/chats-cesar-picture.png',
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],

                              // Message bubble
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.7,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: isFromUser
                                      ? const Color(0xFFFFC436)
                                      : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      message['text'] as String,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: isFromUser
                                            ? Colors.white
                                            : Colors.black,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      message['timestamp'] as String,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: isFromUser
                                            ? Colors.white70
                                            : Colors.grey[600],
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey[100],
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.attach_file,
                    color: Colors.grey[600],
                    size: 24,
                  ),
                ),

                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _messageFocusNode.requestFocus();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: TextField(
                        controller: _messageController,
                        focusNode: _messageFocusNode,
                        decoration: const InputDecoration(
                          hintText: 'Write your message',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 1,
                          ),
                          isDense: true,
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          color: Colors.black,
                        ),
                        maxLines: null,
                        minLines: 1,
                        textCapitalization: TextCapitalization.sentences,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendMessage(),
                        enabled: true,
                        readOnly: false,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                IconButton(
                  onPressed: _sendMessage,
                  icon: Icon(
                    Icons.send,
                    color: _hasText
                        ? const Color(0xFFFFC436)
                        : Colors.grey[600],
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
