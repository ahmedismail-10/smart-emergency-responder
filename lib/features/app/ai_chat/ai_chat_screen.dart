import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<_ChatMessage> _messages = <_ChatMessage>[
    const _ChatMessage(
      text:
          'Hi, I am your AI First Aid assistant. Tell me what happened and I will guide you step by step.',
      isUser: false,
    ),
  ];

  bool _isReplying = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
      );
    });
  }

  String _replyForPrompt(String prompt) {
    final normalized = prompt.toLowerCase();

    if (normalized.contains('bleed') || normalized.contains('نزيف')) {
      return 'Apply direct pressure with a clean cloth, keep the injured area elevated if possible, and call emergency services if bleeding does not stop quickly.';
    }
    if (normalized.contains('burn') || normalized.contains('حرق')) {
      return 'Cool the burn under running water for 20 minutes, remove tight accessories, and avoid applying ice or toothpaste. Seek urgent care for large or deep burns.';
    }
    if (normalized.contains('chest') || normalized.contains('صدر')) {
      return 'Chest pain can be serious. Keep the person seated and calm, avoid exertion, and contact emergency services immediately.';
    }
    if (normalized.contains('unconscious') || normalized.contains('فاقد')) {
      return 'Check responsiveness and breathing. If no breathing, start CPR and call emergency services immediately. If breathing, place in recovery position.';
    }
    return 'I suggest monitoring airway, breathing, and circulation first. If symptoms are severe or worsening, contact emergency services immediately.';
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isReplying) {
      return;
    }

    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true));
      _isReplying = true;
    });
    _messageController.clear();
    _scrollToBottom();

    Future<void>.delayed(const Duration(milliseconds: 420), () {
      if (!mounted) {
        return;
      }
      setState(() {
        _messages.add(_ChatMessage(text: _replyForPrompt(text), isUser: false));
        _isReplying = false;
      });
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI First Aid Chat')),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 10),
            decoration: BoxDecoration(
              color: AppColors.errorContainer.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.verified_user_outlined,
                  color: AppColors.error,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'AI guidance is supportive only and does not replace emergency professionals in critical situations.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _PromptChip(
                  label: 'Bleeding',
                  onTap: () {
                    _messageController.text = 'How to handle heavy bleeding?';
                    _sendMessage();
                  },
                ),
                _PromptChip(
                  label: 'Burn',
                  onTap: () {
                    _messageController.text = 'First aid for a burn?';
                    _sendMessage();
                  },
                ),
                _PromptChip(
                  label: 'Chest pain',
                  onTap: () {
                    _messageController.text =
                        'What should I do for chest pain?';
                    _sendMessage();
                  },
                ),
                _PromptChip(
                  label: 'Unconscious person',
                  onTap: () {
                    _messageController.text =
                        'How to help an unconscious person?';
                    _sendMessage();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              itemCount: _messages.length + (_isReplying ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isReplying && index == _messages.length) {
                  return const _TypingBubble();
                }
                final message = _messages[index];
                return _MessageBubble(message: message);
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 12,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: 'Describe the emergency...',
                        suffixIcon: IconButton(
                          onPressed: _messageController.text.trim().isEmpty
                              ? null
                              : () {
                                  _messageController.clear();
                                  setState(() {});
                                },
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: const CircleBorder(),
                      minimumSize: const Size(48, 48),
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: _messageController.text.trim().isEmpty
                        ? null
                        : _sendMessage,
                    child: const Icon(Icons.send_rounded),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final _ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        constraints: const BoxConstraints(maxWidth: 320),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primary : AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Text(
          message.text,
          style: TextStyle(
            color: isUser ? Colors.white : AppColors.onSurface,
            height: 1.35,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _TypingBubble extends StatelessWidget {
  const _TypingBubble();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Text(
          'Typing...',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _PromptChip extends StatelessWidget {
  const _PromptChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        backgroundColor: AppColors.surfaceContainerLow,
        side: BorderSide(color: AppColors.outline.withValues(alpha: 0.25)),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        onPressed: onTap,
      ),
    );
  }
}

class _ChatMessage {
  const _ChatMessage({required this.text, required this.isUser});

  final String text;
  final bool isUser;
}
