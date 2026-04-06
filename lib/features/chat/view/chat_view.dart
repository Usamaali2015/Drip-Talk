import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:drip_talk/core/common/constants/app_padding.dart';
import 'package:drip_talk/core/common/constants/app_radius.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/core/common/constants/app_text_styles.dart';
import 'package:drip_talk/core/common/widgets/app_asset_image.dart';
import 'package:drip_talk/core/common/widgets/app_gap.dart';
import 'package:drip_talk/core/common/widgets/app_gradient_background.dart';
import 'package:drip_talk/core/common/widgets/app_gradient_border.dart';
import 'package:drip_talk/core/common/widgets/app_text.dart';
import 'package:drip_talk/core/utils/app_utils/toast_utils.dart';
import 'package:drip_talk/features/chat/data/models/ai_chat_request_model.dart';
import 'package:drip_talk/features/chat/domain/chat_bloc.dart';
import 'package:drip_talk/features/chat/domain/chat_event.dart';
import 'package:drip_talk/features/chat/domain/chat_state.dart';
import 'package:drip_talk/features/chat/view/widgets/chat_bubble.dart';
import 'package:drip_talk/features/chat/view/widgets/chat_preferences_sheet.dart';
import 'package:drip_talk/features/chat/view/widgets/typing_indicator.dart';
import 'package:drip_talk/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late final TextEditingController _controller;
  late final FocusNode _inputFocusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _inputFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        centerTitle: true,
        leading: Padding(
          padding: AppPadding.allExtraSmall,
          child: GradientBorder(
            padding: AppPadding.allExtraSmall,
            onTap: () => context.pop(),
            enableShadow: false,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            backgroundColor: AppColors.lightBg,
            borderRadius: AppRadius.r12,
            colors: const [AppColors.primary, AppColors.secondary],
            child: const Icon(
              Icons.arrow_back,
              color: AppColors.surface,
              size: AppSizes.s20,
            ),
          ),
        ),
        title: AppText(
          text: 'DripTalk AI',
          style: AppTextStyles.ts18(context, color: AppColors.white),
        ),
        actions: [
          GradientBorder(
            padding: AppPadding.allExtraSmall,
            onTap: () {},
            enableShadow: false,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            backgroundColor: AppColors.lightBg,
            borderRadius: AppRadius.r12,
            colors: const [AppColors.primary, AppColors.secondary],
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.surface,
              size: AppSizes.s20,
            ),
          ),
          const AppGap(AppSizes.s8, axis: Axis.horizontal),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  return ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.fromLTRB(
                      AppSizes.s16,
                      AppSizes.s12,
                      AppSizes.s16,
                      AppSizes.s20,
                    ),
                    itemCount:
                        state.messages.length + (state.isSending ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (state.isSending && index == 0) {
                        return const TypingIndicator();
                      }

                      final messageIndex = state.isSending ? index - 1 : index;
                      return ChatBubble(message: state.messages[messageIndex]);
                    },
                  );
                },
              ),
            ),
            _InputArea(
              controller: _controller,
              focusNode: _inputFocusNode,
              onSend: _handleSend,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSend() async {
    final draftMessage = _controller.text.trim();
    if (draftMessage.isEmpty) {
      ToastUtils.show(context, 'Type a message first!', type: ToastType.error);
      return;
    }

    final bloc = context.read<ChatBloc>();
    final state = bloc.state;
    if (state.isSending) {
      return;
    }

    _inputFocusNode.unfocus();
    FocusScope.of(context).unfocus();

    final messageHints = const AiChatUserPreferences().withDerivedValues(
      draftMessage,
    );
    final initialPreferences = messageHints.mergeFallbacks(
      state.lastUsedPreferences,
    );

    final selectedPreferences = await ChatPreferencesSheet.show(
      context,
      initialPreferences: initialPreferences,
    );

    if (!mounted || selectedPreferences == null) {
      return;
    }

    bloc.add(
      SendMessageRequested(
        message: draftMessage,
        preferences: selectedPreferences,
      ),
    );
    _controller.clear();
  }
}

class _InputArea extends StatelessWidget {
  const _InputArea({
    required this.controller,
    required this.focusNode,
    required this.onSend,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final Future<void> Function() onSend;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      buildWhen: (previous, current) => previous.isSending != current.isSending,
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.only(
            left: AppSizes.s16,
            right: AppSizes.s16,
            top: AppSizes.s12,
            bottom: MediaQuery.of(context).padding.bottom + AppSizes.s12,
          ),
          decoration: const BoxDecoration(
            color: AppColors.lightBg,
            border: Border(top: BorderSide(color: Colors.white10)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: SizedBox(
                  height: AppSizes.s56,
                  child: Container(
                    clipBehavior: Clip.none,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.s16,
                      vertical: AppSizes.s4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(AppRadius.circular),
                      border: Border.all(
                        color: AppColors.secondary.withValues(alpha: 0.45),
                      ),
                    ),
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.center,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      style: AppTextStyles.ts12(
                        context,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search Fashion...',
                        hintStyle: AppTextStyles.ts14(
                          context,
                          color: Colors.white.withValues(alpha: 0.35),
                        ),
                        border: InputBorder.none,
                        isCollapsed: true,
                      ),
                    ),
                  ),
                ),
              ),
              const AppGap(AppSizes.s12, axis: Axis.horizontal),
              Opacity(
                opacity: state.isSending ? 0.72 : 1,
                child: GestureDetector(
                  onTap: state.isSending ? null : onSend,
                  child: Container(
                    width: AppSizes.s50,
                    height: AppSizes.s50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [AppColors.secondary, AppColors.primary],
                      ),
                    ),
                    child: Center(
                      child: AppAssetImage(
                        assetPath: Assets.iconsSend,
                        width: AppSizes.s18,
                        height: AppSizes.s18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
