import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class LiveSupportScreen extends StatefulWidget {
  const LiveSupportScreen({super.key});

  @override
  State<LiveSupportScreen> createState() => _LiveSupportScreenState();
}

class _LiveSupportScreenState extends State<LiveSupportScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _messages = [
    {
      'sender': 'agent',
      'text': 'Mingalarpar Htet Myat Oo! Welcome to Himo Pay 24/7 Priority Support. My name is May Thu. How can I assist you with your wallet today?',
      'time': '9:41 AM',
    },
  ];

  bool _isTyping = false;

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'sender': 'user',
        'text': text.trim(),
        'time': 'Just now',
      });
      _isTyping = true;
    });

    _messageController.clear();
    _scrollToBottom();

    // Simulated Agent Reply
    Timer(const Duration(seconds: 1), () {
      if (mounted) {
        String reply = 'Thank you for reaching out! I am checking that for you right away. Your account status is in good standing.';
        final lower = text.toLowerCase();
        if (lower.contains('transfer') || lower.contains('money')) {
          reply = 'All internal transfers on Himo Pay are instantaneous and 100% free of charge! You can verify receipts under the History tab.';
        } else if (lower.contains('kyc') || lower.contains('level') || lower.contains('tier')) {
          reply = 'Your Tier 2 NRC verification is currently Approved. You enjoy a 5,000,000 MMK daily transfer limit.';
        } else if (lower.contains('top up') || lower.contains('bill')) {
          reply = 'Utility and mobile top-ups are cleared in real-time. If you ever experience a network delay, our team automatically reconciles within 15 minutes.';
        }

        setState(() {
          _isTyping = false;
          _messages.add({
            'sender': 'agent',
            'text': reply,
            'time': 'Just now',
          });
        });
        _scrollToBottom();
      }
    });
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final quickReplies = [
      'Check Transfer Status',
      'KYC Tier 2 Verification',
      'How to Cash Out',
      'Weekend 2X Rewards',
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.surfaceElevatedDark : Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryGold,
                  ),
                  child: const Center(
                    child: Text('MT', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.black, fontSize: 13)),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('May Thu (Support)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: isDark ? Colors.white : Colors.black)),
                const Text('Online • Avg reply < 1 min', style: TextStyle(fontSize: 11, color: AppColors.success, fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Messages list
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                itemCount: _messages.length,
                itemBuilder: (context, i) {
                  final msg = _messages[i];
                  final isAgent = msg['sender'] == 'agent';

                  return Align(
                    alignment: isAgent ? Alignment.centerLeft : Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isAgent
                            ? (isDark ? AppColors.surfaceElevatedDark : AppColors.gray100)
                            : AppColors.primaryGold,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: Radius.circular(isAgent ? 4 : 16),
                          bottomRight: Radius.circular(isAgent ? 16 : 4),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: isAgent ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                        children: [
                          Text(
                            msg['text'] as String,
                            style: TextStyle(
                              fontSize: 13,
                              color: isAgent ? (isDark ? Colors.white : Colors.black) : Colors.black,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            msg['time'] as String,
                            style: TextStyle(
                              fontSize: 10,
                              color: isAgent ? AppColors.gray500 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_isTyping)
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 8),
                child: Row(
                  children: [
                    const Text('May Thu is typing...', style: TextStyle(fontSize: 11, color: AppColors.gray500, fontStyle: FontStyle.italic)),
                  ],
                ),
              ),
            // Quick reply pills
            SizedBox(
              height: 38,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: quickReplies.length,
                itemBuilder: (context, idx) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ActionChip(
                      label: Text(quickReplies[idx], style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                      onPressed: () => _sendMessage(quickReplies[idx]),
                      backgroundColor: isDark ? AppColors.surfaceElevatedDark : AppColors.gray100,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            // Input row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                border: Border(top: BorderSide(color: isDark ? AppColors.borderDark : AppColors.gray200)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceElevatedDark : AppColors.gray100,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _messageController,
                        style: const TextStyle(fontSize: 14),
                        decoration: const InputDecoration(
                          hintText: 'Type your message...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        ),
                        onSubmitted: _sendMessage,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryGold,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, color: Colors.black, size: 20),
                      onPressed: () => _sendMessage(_messageController.text),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
