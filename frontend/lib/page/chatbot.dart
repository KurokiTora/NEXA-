import 'package:flutter/material.dart';
import '../style/color_style.dart';
import '../style/text_style.dart';
import 'package:provider/provider.dart';
import '../data/models/course.dart';
import '../data/models/performance_summary.dart';
import '../widgets/nexa_mark.dart';
import 'bottom_navidation.dart';
import 'feedback.dart';
import 'grade.dart';

// Chatbot-specific colors (kept here so color_style.dart stays untouched).
const _botBubble = Color(0xFF9DD9D0);
const _userBubble = Color(0xFFEAF7F3);
const _userBubbleBorder = Color(0xFF8FC9BD);
const _menuTeal = Color(0xFF4A9A8E);

class _ChatMessage {
  final String text;
  final bool isUser;
  const _ChatMessage(this.text, this.isUser);
}

class _BotCommand {
  final String name;
  final String description;
  final Color background;
  final Color border;
  const _BotCommand(this.name, this.description, this.background, this.border);
}

const _commands = [
  _BotCommand(
    '/feedback',
    'Analysis of lecturer feedback and follow-up recommendations.',
    Color(0xFFEBC8F2),
    Color(0xFF8E4B9B),
  ),
  _BotCommand(
    '/attendance',
    'Attendance analysis and suggestions for maintaining attendance.',
    Color(0xFFDCCBEE),
    Color(0xFF8C6BC0),
  ),
  _BotCommand(
    '/studyplan',
    'Study suggestions and grade improvement targets.',
    Color(0xFFF7E6DC),
    Color(0xFFC07B7B),
  ),
  _BotCommand(
    '/performance',
    'Analysis of grades, trends, and courses requiring attention.',
    Color(0xFFC9F2EE),
    Color(0xFF3F8F86),
  ),
];

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  bool _menuOpen = false;
  bool _panelShown = false;

  // Drives the one-by-one entrance of the command cards (bottom -> top).
  late final AnimationController _menuAnim = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 520),
  );

  final List<_ChatMessage> _messages = [
    const _ChatMessage(
      'Hi! I\'m the NEXA assistant. Tap MENU or type "/" to see what I can help with.',
      false,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _menuAnim.dispose();
    super.dispose();
  }

  /// Commands to show in the drop-up panel: all of them when MENU is open,
  /// or the ones matching what the user typed after "/" (Telegram-style).
  List<_BotCommand> get _visibleCommands {
    if (_menuOpen) return _commands;
    final typed = _controller.text.toLowerCase();
    if (typed.startsWith('/')) {
      return _commands.where((c) => c.name.startsWith(typed)).toList();
    }
    return [];
  }

  /// Replays the entrance animation each time the command panel goes from
  /// hidden to visible (MENU opened, or "/" typed).
  void _syncPanel() {
    final shown = _visibleCommands.isNotEmpty;
    if (shown && !_panelShown) _menuAnim.forward(from: 0);
    _panelShown = shown;
  }

  void _toggleMenu() {
    FocusScope.of(context).unfocus();
    setState(() => _menuOpen = !_menuOpen);
    _syncPanel();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  void _send(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(text, true));
      _menuOpen = false;
      _controller.clear();
    });
    _syncPanel();
    _scrollToBottom();

    // Placeholder reply until the chatbot is connected to the backend.
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() => _messages.add(_ChatMessage(_botReply(text), false)));
      _scrollToBottom();
    });
  }

  String _botReply(String input) {
    switch (input.toLowerCase()) {
      case '/feedback':
        return 'Sample reply for /feedback. Once the chatbot is connected, your lecturer feedback analysis and follow-up recommendations will show up here.';
      case '/attendance':
        return 'Sample reply for /attendance. Once the chatbot is connected, your attendance analysis and tips will show up here.';
      case '/studyplan':
        return 'Sample reply for /studyplan. Once the chatbot is connected, your study suggestions and grade targets will show up here.';
      case '/performance':
        return 'Sample reply for /performance. Once the chatbot is connected, your grade trends and courses that need attention will show up here.';
      default:
        return 'I don\'t know that one yet. Open MENU to see the available commands.';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Hide the bottom nav while typing so it doesn't ride above the keyboard.
    final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: AppColor.Background,
      body: SafeArea(
        child: Column(
          children: [
            _buildPerformanceCard(),
            _buildTitlePill(),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                itemCount: _messages.length,
                itemBuilder: (context, i) => _buildMessage(_messages[i]),
              ),
            ),
            _buildCommandPanel(keyboardOpen),
            _buildInputBar(),
          ],
        ),
      ),
      bottomNavigationBar: keyboardOpen ? null : const AppBottomNav(currentIndex: 2),
    );
  }

  // ---------- header ----------

  Widget _buildPerformanceCard() {
    final summary = PerformanceSummary.fromCourses(context.watch<List<Course>>());

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.Secondary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColor.Primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColor.Primary,
            child: const Icon(Icons.school, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(summary.label, style: AppTextStyles.heading.copyWith(fontSize: 22)),
                Text(
                  'Your Performance',
                  style: AppTextStyles.body.copyWith(fontSize: 10, color: AppColor.Primary),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _chip(
                      'Your Grade',
                      Icons.workspace_premium_outlined,
                      AppColor.Success.withValues(alpha: 0.6),
                      () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const GradePage()),
                      ),
                    ),
                    _chip(
                      'Your Feedback',
                      Icons.chat_outlined,
                      const Color(0xFFD5E3FF),
                      () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const FeedbackPage()),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColor.Primary.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: AppColor.TextBody),
            const SizedBox(width: 4),
            Text(label, style: AppTextStyles.body.copyWith(fontSize: 10, fontWeight: FontWeight.w600)),
            const Icon(Icons.chevron_right, size: 14, color: AppColor.TextBody),
          ],
        ),
      ),
    );
  }

  Widget _buildTitlePill() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColor.Primary,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(
        'Chatbot Conversation',
        textAlign: TextAlign.center,
        style: AppTextStyles.subheading.copyWith(color: Colors.white, fontSize: 14),
      ),
    );
  }

  // ---------- messages ----------

  Widget _buildMessage(_ChatMessage m) {
    final maxBubbleWidth = MediaQuery.of(context).size.width * 0.68;

    final bubble = Container(
      constraints: BoxConstraints(maxWidth: maxBubbleWidth),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: m.isUser ? _userBubble : _botBubble,
        borderRadius: BorderRadius.circular(8),
        border: m.isUser ? Border.all(color: _userBubbleBorder) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(m.text, style: AppTextStyles.body.copyWith(fontSize: 11.5)),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: m.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: m.isUser
            ? [bubble, const SizedBox(width: 8), _userAvatar()]
            : [_botAvatar(), const SizedBox(width: 8), bubble],
      ),
    );
  }

  Widget _userAvatar() {
    return CircleAvatar(
      radius: 18,
      backgroundColor: AppColor.Average,
      child: Icon(Icons.person, size: 22, color: AppColor.Primary),
    );
  }

  Widget _botAvatar() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: AppColor.Primary, width: 1.2),
      ),
      child: const Center(child: NexaMark(size: 22)),
    );
  }

  // ---------- command drop-up ----------

  Widget _buildCommandPanel(bool keyboardOpen) {
    final cmds = _visibleCommands;
    if (cmds.isEmpty) return const SizedBox.shrink();

    // Compact cards normally fit without scrolling. The cap only kicks in on
    // very short screens / with the keyboard open, so nothing ever overflows.
    final media = MediaQuery.of(context);
    final reserved = 270 + (keyboardOpen ? 0 : 116);
    final maxHeight = (media.size.height -
            media.viewInsets.bottom -
            media.padding.top -
            media.padding.bottom -
            reserved)
        .clamp(72.0, 230.0)
        .toDouble();

    final n = cmds.length;
    final step = n > 1 ? 0.4 / (n - 1) : 0.0;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
        child: Column(
          children: [
            for (var i = 0; i < n; i++)
              // order 0 = bottom card, which appears first
              _buildCommandCard(cmds[i], order: n - 1 - i, step: step),
          ],
        ),
      ),
    );
  }

  Widget _buildCommandCard(_BotCommand c, {required int order, required double step}) {
    final start = order * step;
    final end = (start + 0.55).clamp(0.0, 1.0).toDouble();
    final interval = Interval(start, end, curve: Curves.easeOut);

    return AnimatedBuilder(
      animation: _menuAnim,
      builder: (context, child) {
        final t = interval.transform(_menuAnim.value);
        return Opacity(
          opacity: t,
          child: Transform.translate(offset: Offset(0, (1 - t) * 14), child: child),
        );
      },
      child: GestureDetector(
        onTap: () => _send(c.name),
        child: Container(
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: c.background,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: c.border, width: 1.2),
          ),
          child: Row(
            children: [
              const Icon(Icons.trending_up, size: 18, color: AppColor.TextBody),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(c.name, style: AppTextStyles.subheading.copyWith(fontSize: 12.5)),
                    Text(c.description, style: AppTextStyles.body.copyWith(fontSize: 9.5)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- input bar ----------

  Widget _buildInputBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 10),
      decoration: BoxDecoration(
        color: _userBubble,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _userBubbleBorder),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: SizedBox(
          height: 46,
          child: Row(
            children: [
              GestureDetector(
                onTap: _toggleMenu,
                child: Container(
                  color: _menuTeal,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_menuOpen ? Icons.close : Icons.menu, color: Colors.white, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        'MENU',
                        style: AppTextStyles.button.copyWith(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  textInputAction: TextInputAction.send,
                  onTap: () {
                    if (_menuOpen) {
                      setState(() => _menuOpen = false);
                      _syncPanel();
                    }
                  },
                  onChanged: (_) {
                    setState(() {});
                    _syncPanel();
                  },
                  onSubmitted: _send,
                  style: AppTextStyles.body.copyWith(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Type something here ........',
                    hintStyle: AppTextStyles.body.copyWith(
                      fontSize: 13,
                      color: AppColor.TextBody.withValues(alpha: 0.4),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _send(_controller.text),
                icon: const Icon(Icons.send_rounded, color: _menuTeal, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
