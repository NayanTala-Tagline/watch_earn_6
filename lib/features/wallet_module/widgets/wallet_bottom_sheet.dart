import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/extension/ext_string_alert.dart';
import 'package:daily_cash/features/wallet_module/model/wallet_models.dart';
import 'package:daily_cash/features/wallet_module/provider/wallet_provider.dart';
import 'package:daily_cash/routes/app_router.dart';
import 'package:daily_cash/utils/app_size.dart';
import 'package:daily_cash/utils/remote_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WalletBottomSheet extends StatelessWidget {
  final WalletItem item;
  const WalletBottomSheet({super.key, required this.item});


  @override
  Widget build(BuildContext context) {

    final isWhite = item.color.value == 0xFFFFFFFF;
    final textColor = isWhite
        ? Colors.black
        : context.themeTextColors.textColor;

    return Consumer<WalletProvider>(
      builder: (context, provider, _) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.90,
            ),
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFF1A1A1A),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Form(
              key:provider.formKey,
              child:  SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 5),
                    item.icon,
                    const SizedBox(height: 20),

                    Text(
                      "${rootNavKey.currentContext!.l10n.withdrawTo} ${item.title}",
                      style: context.textTheme.titleLarge?.copyWith(
                        fontSize: AppSize.sp22,
                        fontWeight: FontWeight.w500,
                        color: context.themeTextColors.textColor.withOpacity(0.8),
                      ),
                    ),

                    const SizedBox(height: 20),

                    _buildTextField(
                      context,
                      item.formData.title,
                        Padding(padding: EdgeInsets.only(bottom: 3),child:item.formData.icon),
                      controller: provider.btcWalletAddressController,
                      regex: item.formData.regex,
                    ),
                    const SizedBox(height: 20),

                    _buildTextField(
                      context,
                      "${rootNavKey.currentContext!.l10n.amountCoins}",
                      Padding(padding: EdgeInsets.only(bottom: 3),child: Icon(Icons.monetization_on_sharp, size: 24,color:  item.color) ),

                      controller: provider.amountController,
                      onChanged: provider.onAmountChanged,
                      suffix: true,
                      keyboardType: TextInputType.numberWithOptions(decimal: true)
                    ),

                    if (provider.amountController.text.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 10,
                            ),
                            alignment: AlignmentGeometry.centerStart,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: Colors.red.withOpacity(0.5),
                                width: 0.3,
                              ),
                            ),
                            child: Text(
                              "${rootNavKey.currentContext!.l10n.value}\$${provider.convertedValue}",
                              style: context.textTheme.titleSmall?.copyWith(
                                fontSize: AppSize.sp14,
                                fontWeight: FontWeight.normal,
                                color: Colors.redAccent,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 20),

                    /// 3️⃣ Note
                    _buildTextField(
                      context,
                        "${rootNavKey.currentContext!.l10n.additionalNote}",
                      Padding(padding: EdgeInsets.only(bottom: 3),child: Icon(Icons.note, size: 24,color:  Colors.grey)),
                      controller: provider.noteController,
                      isOptional: true
                    ),

                    const SizedBox(height: 30),

                    /// Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: provider.isLoading
                            ? null // 🔥 disables button
                            : () async {
                          if (!provider.formKey.currentState!.validate()) {
                            return;
                          }
                          final success = await provider.createWithdraw();

                          if (success) {
                            provider.resetWithdrawForm();
                            rootNavKey.currentContext!.l10n.withdrawRequestSent.showSuccessAlert();
                            Navigator.pop(context);
                          } else {
                            (provider.error ?? "Error").showErrorAlert();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: item.color,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),

                        /// 🔥 Child changes based on loading
                          child: SizedBox(
                            height: 25, // ✅ IMPORTANT (fixes vertical centering)
                            child: Center(
                              child: provider.isLoading
                                  ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: textColor,
                                ),
                              )
                                  : Padding(padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  rootNavKey.currentContext!.l10n.confirmWithdrawal,
                                  textAlign: TextAlign.center, // ✅ IMPORTANT
                                  style: context.textTheme.titleLarge?.copyWith(
                                    fontSize: AppSize.sp18,
                                    fontWeight: FontWeight.w800,
                                    color: textColor,
                                    height: 1.0, // ✅ FIX FONT BASELINE ISSUE
                                  ),
                                ))
                            ),
                          )
                      ),
                    ),
                  ],
                ),
              ),
            )
          ),
        );
      },
    );
  }
}

Widget _buildTextField(
  BuildContext context,
  String hint,
  Widget icon,
    {
  TextEditingController? controller,
  Function(String)? onChanged,
  bool suffix = false,
      String? regex,
      bool isOptional = false,
      TextInputType? keyboardType,
}) {
  return TextFormField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (!isOptional) {
          if (value == null || value.isEmpty) {
            return  rootNavKey.currentContext!.l10n.fieldRequired;
          }
        }

        if (regex != null) {
          final regExp = RegExp(regex);
          if (!regExp.hasMatch(value!)) {
            return  rootNavKey.currentContext!.l10n.invalidInput;
          }
        }

        return null;
      },
      textAlignVertical: TextAlignVertical.center,
      cursorColor: Colors.redAccent,
      style: context.textTheme.titleSmall?.copyWith(
        fontSize: AppSize.sp18,
        fontWeight: FontWeight.normal,
        color: context.themeTextColors.textColor.withOpacity(0.7),
        // height: 1.5,
      ),

      decoration: InputDecoration(
        labelText: hint,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
        floatingLabelStyle: const TextStyle(color: Colors.redAccent),

        prefixIcon: icon,

        suffixText: suffix
            ? "${rootNavKey.currentContext!.l10n.min} ${RemoteConfigService.instance.minWithdrawAmount}"
            : null,
        suffixStyle: context.textTheme.titleMedium?.copyWith(
          fontSize: AppSize.sp16,
          fontWeight: FontWeight.normal,
          color: context.themeTextColors.textColor.withOpacity(0.7),
          // height: 1.5,
        ),

        filled: true,
        fillColor: Colors.black26,

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
        errorStyle: const TextStyle(
          color: Colors.redAccent,
          fontSize: 12,
        ),
      ),
    );
}
