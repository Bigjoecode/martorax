import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/supabase/supabase_config.dart';

// Chat message model
class ChatMessage {
  final String sender;
  final String text;
  final String time;
  final bool isMe;

  ChatMessage({
    required this.sender,
    required this.text,
    required this.time,
    required this.isMe,
  });
}

class ProviderChatScreen extends ConsumerStatefulWidget {
  const ProviderChatScreen({super.key});

  @override
  ConsumerState<ProviderChatScreen> createState() => _ProviderChatScreenState();
}

class _ProviderChatScreenState extends ConsumerState<ProviderChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  StreamSubscription? _realtimeSubscription;

  @override
  void initState() {
    super.initState();
    _loadInitialMessages();
    _subscribeToRealtimeChannel();
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _realtimeSubscription?.cancel();
    super.dispose();
  }

  void _loadInitialMessages() {
    _messages.addAll([
      ChatMessage(
        sender: 'John Doe',
        text: 'I need help fixing my kitchen sink today. Can you come? The pipe underneath is leaking heavily since morning.',
        time: '10:24 AM',
        isMe: false,
      ),
      ChatMessage(
        sender: 'You',
        text: 'Yes, I am available. I can head over to your location in 30 minutes. Do you have replacement parts already?',
        time: '10:26 AM',
        isMe: true,
      ),
      ChatMessage(
        sender: 'John Doe',
        text: "No, I don't have anything. Please buy what's needed and add it to the bill. What's your service charge?",
        time: '10:27 AM',
        isMe: false,
      ),
    ]);
  }

  // Subscribe to real-time broadcasts
  void _subscribeToRealtimeChannel() {
    try {
      // In a real staging environment, this connects directly to Supabase WebSockets:
      final channel = SupabaseConfig.client.channel('chat_lobby_asaba');
      channel.onBroadcast(
        event: 'message_received',
        callback: (payload) {
          if (mounted) {
            setState(() {
              _messages.add(ChatMessage(
                sender: payload['sender'] ?? 'John Doe',
                text: payload['message'] ?? '',
                time: 'Just now',
                isMe: false,
              ));
            });
            _scrollToBottom();
          }
        },
      ).subscribe();
    } catch (_) {
      // Graceful offline real-time sandboxed channel setup
    }
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

  // Send message method
  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final now = DateTime.now();
    final timeStr = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}";

    setState(() {
      _messages.add(ChatMessage(
        sender: 'You',
        text: text,
        time: timeStr,
        isMe: true,
      ));
    });

    _textController.clear();
    _scrollToBottom();

    // Secure async insertion into Supabase db
    try {
      SupabaseConfig.client.from('messages').insert({
        'chat_room_id': 'room_john_doe',
        'sender_id': 'current_user_placeholder_uuid',
        'receiver_id': 'john_doe_placeholder_uuid',
        'message_content': text,
      }).then((_) {});
    } catch (_) {}

    // Simulated responsive customer reply
    _simulateBuyerResponse(text);
  }

  // Intelligent conversational simulator
  void _simulateBuyerResponse(String userText) {
    setState(() => _isTyping = true);
    _scrollToBottom();

    Timer(const Duration(milliseconds: 1500), () {
      if (!mounted) return;

      String responseText = "Naira don set! Make we do the work.";
      if (userText.contains('₦') || userText.toLowerCase().contains('charge') || userText.toLowerCase().contains('cost')) {
        responseText = "Okay, ₦5,000 for work is perfect. Please come quickly, water is filling the room!";
      } else if (userText.toLowerCase().contains('location') || userText.toLowerCase().contains('where')) {
        responseText = "I dey for 12 Nnebisi Road, close to the big junction.";
      } else if (userText.toLowerCase().contains('come') || userText.toLowerCase().contains('road')) {
        responseText = "Great! I dey wait for you for house.";
      } else {
        responseText = "Oya! Let's arrange this quickly. I am ready to release SafePay as soon as you finish.";
      }

      setState(() {
        _isTyping = false;
        _messages.add(ChatMessage(
          sender: 'John Doe',
          text: responseText,
          time: 'Just now',
          isMe: false,
        ));
      });
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 8),
            decoration: BoxDecoration(
              color: AppColors.darkBg.withValues(alpha: 0.8),
              border: Border(bottom: BorderSide(color: AppColors.slate700)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.cardBg,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'John Doe',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: AppColors.emerald600.withValues(alpha: 0.5),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: AppColors.emerald600,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'ACTIVE LEAD',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.emerald600,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceBg,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.emerald600.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: Icon(Icons.person_rounded, color: AppColors.slate400, size: 20),
                  ),
                ],
              ),
            ),
          ),
          
          // Chat Messages View
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return const _TypingIndicatorBubble();
                }
                final msg = _messages[index];
                if (msg.isMe) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _ProviderMessage(
                      text: msg.text,
                      time: msg.time,
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _CustomerMessage(
                      name: msg.sender,
                      text: msg.text,
                      time: msg.time,
                    ),
                  );
                }
              },
            ),
          ),

          // Quick response chips + input
          Container(
            decoration: BoxDecoration(
              color: AppColors.darkBg,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  offset: const Offset(0, -4),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 56,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    children: [
                      _QuickChip('Fit do am for ₦5,000?', onTap: () => _sendMessage('Fit do am for ₦5,000?')),
                      _QuickChip('Wetin be your location?', onTap: () => _sendMessage('Wetin be your location?')),
                      _QuickChip('I dey come now now', onTap: () => _sendMessage('I dey come now now')),
                      _QuickChip('Work don set', onTap: () => _sendMessage('Work don set')),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 4,
                    bottom: MediaQuery.of(context).padding.bottom + 12,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.emerald600,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.add_circle_outline_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 48,
                          padding: const EdgeInsets.only(left: 16, right: 8),
                          decoration: BoxDecoration(
                            color: AppColors.cardBg,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _textController,
                                  onSubmitted: (val) => _sendMessage(val),
                                  style: GoogleFonts.inter(fontSize: 14, color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'Type a message...',
                                    hintStyle: GoogleFonts.inter(fontSize: 14, color: AppColors.slate400),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _sendMessage(_textController.text),
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: AppColors.emerald600.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(Icons.send_rounded, color: AppColors.emerald600, size: 18),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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

class _CustomerMessage extends StatelessWidget {
  final String name;
  final String text;
  final String time;

  const _CustomerMessage({
    required this.name,
    required this.text,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.surfaceBg,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.person_rounded, color: AppColors.slate400, size: 16),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 4),
                child: Text(
                  name,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.slate400,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  color: Color(0xFF334155),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(4),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Text(
                  text,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.white,
                    height: 1.5,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4, top: 4),
                child: Text(
                  time,
                  style: GoogleFonts.inter(fontSize: 10, color: AppColors.slate400),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProviderMessage extends StatelessWidget {
  final String text;
  final String time;

  const _ProviderMessage({
    required this.text,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 4, bottom: 4),
                child: Text(
                  'You',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.slate400,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.emerald600,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(4),
                  ),
                ),
                child: Text(
                  text,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.white,
                    height: 1.5,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 4, top: 4),
                child: Text(
                  time,
                  style: GoogleFonts.inter(fontSize: 10, color: AppColors.slate400),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.emerald600.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.engineering_rounded, color: AppColors.emerald600, size: 16),
        ),
      ],
    );
  }
}

class _TypingIndicatorBubble extends StatelessWidget {
  const _TypingIndicatorBubble();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 42, bottom: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            color: Color(0xFF334155),
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDot(0),
              _buildDot(150),
              _buildDot(300),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDot(int delayMs) {
    return Container(
      width: 6,
      height: 6,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _QuickChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QuickChip(this.label, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
