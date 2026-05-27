import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_cash/db/app_db.dart';
import 'package:daily_cash/di/injector.dart';
import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/purse_module/model/purse_models.dart';
import 'package:daily_cash/gen/assets.gen.dart';
import 'package:daily_cash/routes/app_router.dart';
import 'package:daily_cash/utils/app_dimens.dart';
import 'package:daily_cash/utils/pattern_helper.dart';
import 'package:daily_cash/utils/remote_settings_service.dart';
import 'package:flutter/material.dart';

class PurseProvider extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final _db = Injector.instance<AppDB>();

  List<PurseCategory> getWalletCategories(BuildContext context) {
    return [
      PurseCategory(
        title: rootNavKey.currentContext!.l10n.cash,
        dbTitle: "Cash",
        items: [
          PurseItem(
            rootNavKey.currentContext!.l10n.paypal,
            "PayPal",
            Icon(Icons.paypal, size: AppDimens.w24, color: Color(0xFF2559ca)),
            Color(0xFF2559ca),
            FormPayload(
              rootNavKey.currentContext!.l10n.enterPaypalEmail,
              Icon(Icons.payment, size: AppDimens.w24, color: Color(0xFF2559ca)),
              PatternHelper.email,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.wise,
            "Wise",
            Icon(Icons.flag_outlined, size: AppDimens.w24, color: Color(0xFF00aeff)),
            Color(0xFF00aeff),
            FormPayload(
              rootNavKey.currentContext!.l10n.emailIban,
              Icon(Icons.account_balance_sharp, size: 24, color: Color(0xFF00aeff)),
              PatternHelper.email_or_iban,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.payoneer,
            "Payoneer",
            Icon(Icons.repeat_on_sharp, size: AppDimens.w24, color: Color(0xFFff4000)),
            Color(0xFFff4000),
            FormPayload(
              rootNavKey.currentContext!.l10n.payoneerEmail,
              Icon(Icons.email_sharp, size: 24, color: Color(0xFFff4000)),
              PatternHelper.email,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.skrill,
            "Skrill",
            Icon(Icons.local_play_sharp, size: AppDimens.w24, color: Color(0xFFb82986)),
            Color(0xFFb82986),
            FormPayload(
              rootNavKey.currentContext!.l10n.skrillEmail,
              Icon(Icons.email_sharp, size: 24, color: Color(0xFFb82986)),
              PatternHelper.email,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.applePay,
            "Apple Pay",
            Icon(Icons.apple, size: AppDimens.w24, color: Color(0xFFFFFFFF)),
            Color(0xFFFFFFFF),
            FormPayload(
              rootNavKey.currentContext!.l10n.appleId,
              Icon(Icons.phone_android_sharp, size: 24, color: Color(0xFFFFFFFF)),
              PatternHelper.email_or_phone,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.googleWallet,
            "Google Wallet",
            Assets.cashWithdrawIcons.googlewallet.image(width: AppDimens.w24),
            Color(0xFF3a7af2),
            FormPayload(
              rootNavKey.currentContext!.l10n.googlePayNumber,
              Icon(Icons.email_sharp, size: 24, color: Color(0xFF3a7af2)),
              PatternHelper.email_or_phone,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.samsungWallet,
            "Samsung Wallet",
            Icon(Icons.phone_android, size: AppDimens.w24, color: Color(0xFF43a546)),
            Color(0xFF43a546),
            FormPayload(
              rootNavKey.currentContext!.l10n.samsungPayId,
              Icon(Icons.email_sharp, size: 24, color: Color(0xFF43a546)),
              PatternHelper.alphanumeric,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.wellsFargo,
            "Wells Fargo",
            Icon(Icons.account_balance_outlined, size: AppDimens.w24, color: Color(0xFFf68819)),
            Color(0xFFf68819),
            FormPayload(
              rootNavKey.currentContext!.l10n.accountNumber,
              Icon(Icons.account_balance_sharp, size: 24, color: Color(0xFFf68819)),
              PatternHelper.iban_or_account,
            ),
          ),

          // Europe / Asia wallets
          PurseItem(
            rootNavKey.currentContext!.l10n.alipay,
            "Alipay",
            Assets.cashWithdrawIcons.alipay.svg(width: AppDimens.w24),
            Color(0xFF166bff),
            FormPayload(
              rootNavKey.currentContext!.l10n.alipayId,
              Icon(Icons.qr_code, size: 24, color: Color(0xFF166bff)),
              PatternHelper.wallet_id,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.wechatPay,
            "WeChat Pay",
            Icon(Icons.wechat, size: AppDimens.w24, color: Color(0xFF009e5f)),
            Color(0xFF009e5f),
            FormPayload(
              rootNavKey.currentContext!.l10n.wechatId,
              Icon(Icons.message, size: 24, color: Color(0xFF009e5f)),
              PatternHelper.wallet_id,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.upi,
            "UPI",
            Icon(Icons.qr_code_2, size: AppDimens.w24, color: Color(0xFFFF7900)),
            Color(0xFFFF7900),
            FormPayload(
              rootNavKey.currentContext!.l10n.upiId,
              Icon(Icons.alternate_email, size: 24, color: Color(0xFFFF7900)),
              PatternHelper.upi,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.phonepe,
            "PhonePe",
            Icon(Icons.local_parking_outlined, size: AppDimens.w24, color: Color(0xFF6F2C91)),
            Color(0xFF6F2C91),
            FormPayload(
              rootNavKey.currentContext!.l10n.phonepeNumber,
              Icon(Icons.call, size: 24, color: Color(0xFF6F2C91)),
              PatternHelper.phone,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.paytm,
            "Paytm",
            Icon(Icons.credit_card, size: AppDimens.w24, color: Color(0xFF00AEEF)),
            Color(0xFF00AEEF),
            FormPayload(
              rootNavKey.currentContext!.l10n.paytmNumber,
              Icon(Icons.call, size: 24, color: Color(0xFF00AEEF)),
              PatternHelper.phone,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.gcash,
            "GCash",
            Icon(Icons.wallet, size: AppDimens.w24, color: Color(0xFF0066FF)),
            Color(0xFF0066FF),
            FormPayload(
              rootNavKey.currentContext!.l10n.gcashNumber,
              Icon(Icons.call, size: 24, color: Color(0xFF0066FF)),
              PatternHelper.phone,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.grabpay,
            "GrabPay",
            Icon(Icons.local_taxi_rounded, size: AppDimens.w24, color: Color(0xFF00A651)),
            Color(0xFF00A651),
            FormPayload(
              rootNavKey.currentContext!.l10n.grabRegisteredNumber,
              Icon(Icons.call, size: 24, color: Color(0xFF00A651)),
              PatternHelper.phone,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.kakaopay,
            "KakaoPay",
            Icon(Icons.chat_bubble, size: AppDimens.w24, color: Color(0xFFFFCC00)),
            Color(0xFFFFCC00),
            FormPayload(
              rootNavKey.currentContext!.l10n.kakaoId,
              Icon(Icons.chat_bubble, size: 24, color: Color(0xFFFFCC00)),
              PatternHelper.wallet_id,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.paypay,
            "PayPay",
            Icon(Icons.local_parking_outlined, size: AppDimens.w24, color: Color(0xFFE30613)),
            Color(0xFFE30613),
            FormPayload(
              rootNavKey.currentContext!.l10n.paypayId,
              Icon(Icons.qr_code, size: 24, color: Color(0xFFE30613)),
              PatternHelper.wallet_id,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.easypaisa,
            "Easypaisa",
            Icon(Icons.account_balance_wallet_rounded, size: AppDimens.w24, color: Color(0xFF00B14F)),
            Color(0xFF00B14F),
            FormPayload(
              rootNavKey.currentContext!.l10n.easypaisaNumber,
              Icon(Icons.call, size: 24, color: Color(0xFF00B14F)),
              PatternHelper.phone,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.sadapay,
            "SadaPay",
            Icon(Icons.credit_card, size: AppDimens.w24, color: Color(0xFF1B2838)),
            Color(0xFF1B2838),
            FormPayload(
              rootNavKey.currentContext!.l10n.sadapayAccount,
              Icon(Icons.call, size: 24, color: Color(0xFF1B2838)),
              PatternHelper.phone_or_id,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.bkash,
            "bKash",
            Icon(Icons.money_outlined, size: AppDimens.w24, color: Color(0xFFf54293)),
            Color(0xFFf54293),
            FormPayload(
              rootNavKey.currentContext!.l10n.bkashNumber,
              Icon(Icons.call, size: 24, color: Color(0xFFf54293)),
              PatternHelper.phone,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.callfin,
            "CallFin",
            Icon(Icons.phone_android, size: AppDimens.w24, color: Color(0xFF00A86B)),
            Color(0xFF00A86B),
            FormPayload(
              rootNavKey.currentContext!.l10n.callfinNumber,
              Icon(Icons.email_sharp, size: 24, color: Color(0xFF00A86B)),
              PatternHelper.phone_or_id,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.revolut,
            "Revolut",
            Assets.cashWithdrawIcons.revolut.image(width: AppDimens.w24),
            Color(0xFF0066FF),
            FormPayload(
              rootNavKey.currentContext!.l10n.revtagIban,
              Icon(Icons.tag, size: 24, color: Color(0xFF0066FF)),
              PatternHelper.email_or_iban,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.monzo,
            "Monzo",
            Assets.cashWithdrawIcons.monzo.image(width: AppDimens.w24),
            Color(0xFF1A2E5A),
            FormPayload(
              rootNavKey.currentContext!.l10n.accountSortcode,
              Icon(Icons.account_balance_sharp, size: 24, color: Color(0xFF1A2E5A)),
              PatternHelper.sort_code_account,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.n26,
            "N26",
            Assets.cashWithdrawIcons.n26.image(width: AppDimens.w24),
            Color(0xFF00C1B2),
            FormPayload(
              rootNavKey.currentContext!.l10n.iban,
              Icon(Icons.account_balance_sharp, size: 24, color: Color(0xFF00C1B2)),
              PatternHelper.iban,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.bunq,
            "Bunq",
            Icon(Icons.savings, size: AppDimens.w24, color: Color(0xFFeb7a8d)),
            Color(0xFFeb7a8d),
            FormPayload(
              rootNavKey.currentContext!.l10n.ibanEmail,
              Icon(Icons.mail, size: 24, color: Color(0xFFeb7a8d)),
              PatternHelper.email_or_iban,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.starlingBank,
            "Starling Bank",
            Assets.cashWithdrawIcons.starlingbank.svg(width: AppDimens.w24),
            Color(0xFF00b9aa),
            FormPayload(
              rootNavKey.currentContext!.l10n.accountNumber,
              Icon(Icons.tag, size: 24, color: Color(0xFF00b9aa)),
              PatternHelper.sort_code_account,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.ideal,
            "iDEAL",
            Assets.cashWithdrawIcons.ideal.svg(width: AppDimens.w24),
            Color(0xFFFFFFFF),
            FormPayload(
              rootNavKey.currentContext!.l10n.iban,
              Icon(Icons.account_balance_sharp, size: 24, color: Color(0xFFFFFFFF)),
              PatternHelper.iban,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.tikkie,
            "Tikkie",
            Assets.cashWithdrawIcons.tikkie.svg(width: AppDimens.w24),
            Color(0xFFff5f00),
            FormPayload(
              rootNavKey.currentContext!.l10n.tikkieLinkNumber,
              Icon(Icons.link, size: 24, color: Color(0xFFff5f00)),
              PatternHelper.link,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.vipps,
            "Vipps",
            Assets.cashWithdrawIcons.vipps.svg(width: AppDimens.w24),
            Color(0xFFff5020),
            FormPayload(
              rootNavKey.currentContext!.l10n.vippsNumber,
              Icon(Icons.call, size: 24, color: Color(0xFFff5f00)),
              PatternHelper.phone,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.mobilePay,
            "MobilePay",
            Assets.cashWithdrawIcons.mobilepay.svg(width: AppDimens.w24),
            Color(0xFF00509b),
            FormPayload(
              rootNavKey.currentContext!.l10n.mobilepayNumber,
              Icon(Icons.call, size: 24, color: Color(0xFF00509b)),
              PatternHelper.phone,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.swish,
            "Swish",
            Assets.cashWithdrawIcons.swish.svg(width: AppDimens.w24),
            Color(0xFF02ab81),
            FormPayload(
              rootNavKey.currentContext!.l10n.swishNumber,
              Icon(Icons.call, size: 24, color: Color(0xFF02ab81)),
              PatternHelper.phone,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.blik,
            "BLIK",
            Assets.cashWithdrawIcons.blik.svg(width: AppDimens.w24),
            Color(0xFFfc342a),
            FormPayload(
              rootNavKey.currentContext!.l10n.blikCode,
              Icon(Icons.tag, size: 24, color: Color(0xFFfc342a)),
              PatternHelper.code,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.lydia,
            "Lydia",
            Assets.cashWithdrawIcons.lydia.svg(width: AppDimens.w24),
            Color(0xFF612670),
            FormPayload(
              rootNavKey.currentContext!.l10n.lydiaNumber,
              Icon(Icons.call, size: 24, color: Color(0xFF612670)),
              PatternHelper.phone,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.paylib,
            "PayLib",
            Assets.cashWithdrawIcons.paylib.svg(width: AppDimens.w24),
            Color(0xFF3c4985),
            FormPayload(
              rootNavKey.currentContext!.l10n.paylibNumber,
              Icon(Icons.call, size: 24, color: Color(0xFF3c4985)),
              PatternHelper.phone,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.twint,
            "Twint",
            Assets.cashWithdrawIcons.twint.svg(width: AppDimens.w24),
            Color(0xFF652786),
            FormPayload(
              rootNavKey.currentContext!.l10n.twintNumber,
              Icon(Icons.call, size: 24, color: Color(0xFF652786)),
              PatternHelper.phone,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.satispay,
            "Satispay",
            Assets.cashWithdrawIcons.satispay.svg(width: AppDimens.w24),
            Color(0xFFff5035),
            FormPayload(
              rootNavKey.currentContext!.l10n.satispayNumber,
              Icon(Icons.call, size: 24, color: Color(0xFFff5035)),
              PatternHelper.phone,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.iyzico,
            "iyzico",
            Assets.cashWithdrawIcons.iyzico.svg(width: AppDimens.w24),
            Color(0xFF2882ff),
            FormPayload(
              rootNavKey.currentContext!.l10n.accountId,
              Icon(Icons.account_circle, size: 24, color: Color(0xFF2882ff)),
              PatternHelper.flexible_id,
            ),
          ),

          // Africa / Middle East
          PurseItem(
            rootNavKey.currentContext!.l10n.mpesa,
            "M-Pesa",
            Assets.cashWithdrawIcons.mpesa.svg(width: AppDimens.w24),
            Color(0xFF009c46),
            FormPayload(
              rootNavKey.currentContext!.l10n.mpesaNumber,
              Icon(Icons.call, size: 24, color: Color(0xFF009c46)),
              PatternHelper.phone,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.opay,
            "OPay",
            Assets.cashWithdrawIcons.opay.svg(width: AppDimens.w24),
            Color(0xFF1DC45A),
            FormPayload(
              rootNavKey.currentContext!.l10n.opayNumber,
              Icon(Icons.call, size: 24, color: Color(0xFF1DC45A)),
              PatternHelper.phone,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.orangeMoney,
            "Orange Money",
            Assets.cashWithdrawIcons.orangemoney.svg(width: AppDimens.w24),
            Color(0xFFFF7900),
            FormPayload(
              rootNavKey.currentContext!.l10n.orangeMoneyNumber,
              Icon(Icons.call, size: 24, color: Color(0xFFFF7900)),
              PatternHelper.phone,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.mtnMobile,
            "MTN Mobile",
            Assets.cashWithdrawIcons.mynmobile.svg(width: AppDimens.w24),
            Color(0xFFFFCC00),
            FormPayload(
              rootNavKey.currentContext!.l10n.mtnMobileNumber,
              Icon(Icons.cell_tower, size: 24, color: Color(0xFFFFCC00)),
              PatternHelper.phone,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.chipperCash,
            "Chipper Cash",
            Assets.cashWithdrawIcons.chippercash.svg(width: AppDimens.w24),
            Color(0xFF0066FF),
            FormPayload(
              rootNavKey.currentContext!.l10n.chipperTag,
              Icon(Icons.alternate_email, size: 24, color: Color(0xFF0066FF)),
              PatternHelper.wallet_id,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.moniepoint,
            "Moniepoint",
            Icon(Icons.dialpad, size: 24, color: Color(0xFFFFCC00)),
            Color(0xFFFFCC00),
            FormPayload(
              rootNavKey.currentContext!.l10n.accountNumber,
              Icon(Icons.tag, size: 24, color: Color(0xFFFFCC00)),
              PatternHelper.numberOnly,
            ),
          ),

          // India / Africa banks
          PurseItem(
            rootNavKey.currentContext!.l10n.baxi,
            "Baxi",
            Assets.cashWithdrawIcons.baxi.svg(width: AppDimens.w24),
            Color(0xFF007BFF),
            FormPayload(
              rootNavKey.currentContext!.l10n.baxiAccount,
              Icon(Icons.tag, size: 24, color: Color(0xFF007BFF)),
              PatternHelper.numberOnly,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.capitecPay,
            "Capitec Pay",
            Assets.cashWithdrawIcons.capitecpay.svg(width: AppDimens.w24),
            Color(0xFF00B14F),
            FormPayload(
              rootNavKey.currentContext!.l10n.idPhone,
              Icon(Icons.account_circle_outlined, size: 24, color: Color(0xFF00B14F)),
              PatternHelper.phone_or_id,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.snapscan,
            "SnapScan",
            Assets.cashWithdrawIcons.snapscan.svg(width: AppDimens.w24),
            Color(0xFF0033A0),
            FormPayload(
              rootNavKey.currentContext!.l10n.snapscanId,
              Icon(Icons.qr_code, size: 24, color: Color(0xFF0033A0)),
              PatternHelper.wallet_id,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.natsWallet,
            "NatsWallet",
            Assets.cashWithdrawIcons.nasswallet.svg(width: AppDimens.w24),
            Color(0xFFF5A623),
            FormPayload(
              rootNavKey.currentContext!.l10n.cardAccount,
              Icon(Icons.compare_arrows_outlined, size: 24, color: Color(0xFFF5A623)),
              PatternHelper.iban_or_account,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.onafriq,
            "Onafriq",
            Assets.cashWithdrawIcons.onafriq.svg(width: AppDimens.w24),
            Color(0xFFE53935),
            FormPayload(
              rootNavKey.currentContext!.l10n.userId,
              Icon(Icons.account_circle_outlined, size: 24, color: Color(0xFFE53935)),
              PatternHelper.flexible_id,
            ),
          ),

          // Middle East
          PurseItem(
            rootNavKey.currentContext!.l10n.stcPay,
            "STC Pay",
            Assets.cashWithdrawIcons.stcpay.svg(width: AppDimens.w24),
            Color(0xFF6A1B9A),
            FormPayload(
              rootNavKey.currentContext!.l10n.stcPayNumber,
              Icon(Icons.call, size: 24, color: Color(0xFF6A1B9A)),
              PatternHelper.phone,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.vodafoneCash,
            "Vodafone Cash",
            Assets.cashWithdrawIcons.vodafonecash.svg(width: AppDimens.w24),
            Color(0xFFE60000),
            FormPayload(
              rootNavKey.currentContext!.l10n.vodafoneNumber,
              Icon(Icons.call, size: 24, color: Color(0xFFE60000)),
              PatternHelper.phone,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.careemPay,
            "Careem Pay",
            Assets.cashWithdrawIcons.careempay.svg(width: AppDimens.w24),
            Color(0xFF00C853),
            FormPayload(
              rootNavKey.currentContext!.l10n.careemNumber,
              Icon(Icons.call, size: 24, color: Color(0xFF00C853)),
              PatternHelper.phone,
            ),
          ),

          // Egypt
          PurseItem(
            rootNavKey.currentContext!.l10n.instapay,
            "InstaPay",
            Assets.cashWithdrawIcons.instapay.svg(width: AppDimens.w24),
            Color(0xFF0070BA),
            FormPayload(
              rootNavKey.currentContext!.l10n.instapayAddress,
              Icon(Icons.alternate_email, size: 24, color: Color(0xFF0070BA)),
              PatternHelper.payment_id,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.myfawry,
            "myfawry",
            Assets.cashWithdrawIcons.myfawry.svg(width: AppDimens.w24),
            Color(0xFFF9B233),
            FormPayload(
              rootNavKey.currentContext!.l10n.fawryNumber,
              Icon(Icons.call, size: 24, color: Color(0xFFF9B233)),
              PatternHelper.phone,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.benefitPay,
            "BenefitPay",
            Assets.cashWithdrawIcons.benefitpay.svg(width: AppDimens.w24),
            Color(0xFF00A3E0),
            FormPayload(
              rootNavKey.currentContext!.l10n.benefitpayNumber,
              Icon(Icons.call, size: 24, color: Color(0xFF00A3E0)),
              PatternHelper.phone,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.meeza,
            "Meeza",
            Assets.cashWithdrawIcons.meeza.svg(width: AppDimens.w24),
            Color(0xFF009639),
            FormPayload(
              rootNavKey.currentContext!.l10n.meezaCardWallet,
              Icon(Icons.credit_card, size: 24, color: Color(0xFF009639)),
              PatternHelper.iban_or_account,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.valu,
            "valU",
            Assets.cashWithdrawIcons.valu.svg(width: AppDimens.w24),
            Color(0xFF0088FF),
            FormPayload(
              rootNavKey.currentContext!.l10n.valuAccount,
              Icon(Icons.call, size: 24, color: Color(0xFF0088FF)),
              PatternHelper.phone_or_id,
            ),
          ),

          // LATAM
          PurseItem(
            rootNavKey.currentContext!.l10n.nubank,
            "Nubank",
            Assets.cashWithdrawIcons.nubank.svg(width: AppDimens.w24),
            Color(0xFF8A05BE),
            FormPayload(
              rootNavKey.currentContext!.l10n.pixpayAccount,
              Icon(Icons.add_box_sharp, size: 24, color: Color(0xFF8A05BE)),
              PatternHelper.pix_key,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.picpay,
            "PicPay",
            Assets.cashWithdrawIcons.picpay.svg(width: AppDimens.w24),
            Color(0xFF21C25E),
            FormPayload(
              rootNavKey.currentContext!.l10n.picpayUsernamePix,
              Icon(Icons.alternate_email, size: 24, color: Color(0xFF21C25E)),
              PatternHelper.pix_key,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.mercadoPago,
            "Mercado Pago",
            Assets.cashWithdrawIcons.mercadopago.svg(width: AppDimens.w24),
            Color(0xFF009EE3),
            FormPayload(
              rootNavKey.currentContext!.l10n.emailCvu,
              Icon(Icons.mail, size: 24, color: Color(0xFF009EE3)),
              PatternHelper.email_or_iban,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.nequi,
            "Nequi",
            Assets.cashWithdrawIcons.nequi.svg(width: AppDimens.w24),
            Color(0xFF6A00FF),
            FormPayload(
              rootNavKey.currentContext!.l10n.nequiNumber,
              Icon(Icons.call, size: 24, color: Color(0xFF6A00FF)),
              PatternHelper.phone,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.daviplata,
            "Daviplata",
            Assets.cashWithdrawIcons.daviplata.svg(width: AppDimens.w24),
            Color(0xFFE30613),
            FormPayload(
              rootNavKey.currentContext!.l10n.daviplataNumber,
              Icon(Icons.call, size: 24, color: Color(0xFFE30613)),
              PatternHelper.phone,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.yape,
            "Yape",
            Assets.cashWithdrawIcons.yape.svg(width: AppDimens.w24),
            Color(0xFF6A1B9A),
            FormPayload(
              rootNavKey.currentContext!.l10n.yapeNumber,
              Icon(Icons.call, size: 24, color: Color(0xFF6A1B9A)),
              PatternHelper.phone,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.plin,
            "Plin",
            Assets.cashWithdrawIcons.plin.svg(width: AppDimens.w24),
            Color(0xFF00AEEF),
            FormPayload(
              rootNavKey.currentContext!.l10n.plinNumber,
              Icon(Icons.call, size: 24, color: Color(0xFF00AEEF)),
              PatternHelper.phone,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.rappiPay,
            "RappiPay",
            Assets.cashWithdrawIcons.rappipay.svg(width: AppDimens.w24),
            Color(0xFFFF441F),
            FormPayload(
              rootNavKey.currentContext!.l10n.rappiAccount,
              Icon(Icons.call, size: 24, color: Color(0xFFFF441F)),
              PatternHelper.phone_or_id,
            ),
          ),

          // South America / Global
          PurseItem(
            rootNavKey.currentContext!.l10n.mach,
            "MACH",
            Assets.cashWithdrawIcons.mach.svg(width: AppDimens.w24),
            Color(0xFFFFD400),
            FormPayload(
              rootNavKey.currentContext!.l10n.machAccount,
              Icon(Icons.account_circle, size: 24, color: Color(0xFFFFD400)),
              PatternHelper.flexible_id,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.prex,
            "Prex",
            Assets.cashWithdrawIcons.prex.svg(width: AppDimens.w24),
            Color(0xFF00AEEF),
            FormPayload(
              rootNavKey.currentContext!.l10n.prexAccount,
              Icon(Icons.tag, size: 24, color: Color(0xFF00AEEF)),
              PatternHelper.flexible_id,
            ),
          ),

          // Australia / NZ
          PurseItem(
            rootNavKey.currentContext!.l10n.payId,
            "PayID",
            Assets.cashWithdrawIcons.payid.svg(width: AppDimens.w24),
            Color(0xFF6C2BD9),
            FormPayload(
              rootNavKey.currentContext!.l10n.payIdEmail,
              Icon(Icons.abc, size: 24, color: Color(0xFF6C2BD9)),
              PatternHelper.email_or_phone,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.commbank,
            "CommBank",
            Assets.cashWithdrawIcons.commbank.svg(width: AppDimens.w24),
            Color(0xFFFFCC00),
            FormPayload(
              rootNavKey.currentContext!.l10n.bsbAccount,
              Icon(Icons.tag, size: 24, color: Color(0xFFFFCC00)),
              PatternHelper.bsb_account,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.westpac,
            "Westpac",
            Assets.cashWithdrawIcons.westpac.svg(width: AppDimens.w24),
            Color(0xFFD50000),
            FormPayload(
              rootNavKey.currentContext!.l10n.bsbAccount,
              Icon(Icons.tag, size: 24, color: Color(0xFFD50000)),
              PatternHelper.bsb_account,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.anz,
            "ANZ",
            Assets.cashWithdrawIcons.anz.svg(width: AppDimens.w24),
            Color(0xFF0072CE),
            FormPayload(
              rootNavKey.currentContext!.l10n.bsbAccount,
              Icon(Icons.tag, size: 24, color: Color(0xFF0072CE)),
              PatternHelper.bsb_account,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.nab,
            "NAB",
            Assets.cashWithdrawIcons.nab.svg(width: AppDimens.w24),
            Color(0xFFC8102E),
            FormPayload(
              rootNavKey.currentContext!.l10n.bsbAccount,
              Icon(Icons.tag, size: 24, color: Color(0xFFC8102E)),
              PatternHelper.bsb_account,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.up,
            "Up",
            Assets.cashWithdrawIcons.up.svg(width: AppDimens.w24),
            Color(0xFFFF6F00),
            FormPayload(
              rootNavKey.currentContext!.l10n.upnamePayId,
              Icon(Icons.alternate_email, size: 24, color: Color(0xFFFF6F00)),
              PatternHelper.email_or_phone,
            ),
          ),

          // Buy now pay later
          PurseItem(
            rootNavKey.currentContext!.l10n.afterpay,
            "Afterpay",
            Assets.cashWithdrawIcons.afterpay.svg(width: AppDimens.w24),
            Color(0xFF00D084),
            FormPayload(
              rootNavKey.currentContext!.l10n.accountEmail,
              Icon(Icons.mail, size: 24, color: Color(0xFF00D084)),
              PatternHelper.email,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.zip,
            "Zip",
            Assets.cashWithdrawIcons.zip.svg(width: AppDimens.w24),
            Color(0xFF00C853),
            FormPayload(
              rootNavKey.currentContext!.l10n.zipId,
              Icon(Icons.account_circle, size: 24, color: Color(0xFF00C853)),
              PatternHelper.flexible_id,
            ),
          ),

          // Banks
          PurseItem(
            rootNavKey.currentContext!.l10n.kiwibank,
            "Kiwibank",
            Assets.cashWithdrawIcons.kiwibank.svg(width: AppDimens.w24),
            Color(0xFF78BE20),
            FormPayload(
              rootNavKey.currentContext!.l10n.accountNumber,
              Icon(Icons.tag, size: 24, color: Color(0xFF78BE20)),
              PatternHelper.numberOnly,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.scotiabank,
            "Scotiabank",
            Assets.cashWithdrawIcons.scotiabank.svg(width: AppDimens.w24),
            Color(0xFFE31837),
            FormPayload(
              rootNavKey.currentContext!.l10n.baseIdAccount,
              Icon(Icons.account_circle, size: 24, color: Color(0xFFE31837)),
              PatternHelper.flexible_id,
            ),
          ),
        ],
      ),

      PurseCategory(
        title: rootNavKey.currentContext!.l10n.crypto,
        dbTitle: "Crypto",
        items: [
          PurseItem(
            rootNavKey.currentContext!.l10n.bitcoin,
            "Bitcoin",
            Assets.cryptoWithdrawIcons.bitcoin.svg(width: AppDimens.w24),
            Color(0xFFF7931A),
            FormPayload(
              rootNavKey.currentContext!.l10n.btcWalletAddress,
              Icon(Icons.wallet_sharp, size: 24, color: Color(0xFFF7931A)),
              PatternHelper.crypto,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.ethereum,
            "Ethereum",
            Assets.cryptoWithdrawIcons.ethereum.svg(width: AppDimens.w24),
            Color(0xFF627EEA),
            FormPayload(
              rootNavKey.currentContext!.l10n.ethWalletAddress,
              Icon(Icons.wallet_sharp, size: 24, color: Color(0xFF627EEA)),
              PatternHelper.crypto,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.usdt,
            "USDT",
            Assets.cryptoWithdrawIcons.usdt.svg(width: AppDimens.w24),
            Color(0xFF26A17B),
            FormPayload(
              rootNavKey.currentContext!.l10n.usdtNetwork,
              Icon(Icons.wallet_sharp, size: 24, color: Color(0xFF26A17B)),
              PatternHelper.crypto,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.usdc,
            "USDC",
            Assets.cryptoWithdrawIcons.usdc.svg(width: AppDimens.w24),
            Color(0xFF2775CA),
            FormPayload(
              rootNavKey.currentContext!.l10n.usdcNetwork,
              Icon(Icons.wallet_sharp, size: 24, color: Color(0xFF2775CA)),
              PatternHelper.crypto,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.binancePay,
            "Binance Pay",
            Assets.cryptoWithdrawIcons.binancepay.svg(width: AppDimens.w24),
            Color(0xFFF3BA2F),
            FormPayload(
              rootNavKey.currentContext!.l10n.binanceIdEmail,
              Icon(Icons.person_outline, size: 24, color: Color(0xFFF3BA2F)),
              PatternHelper.email_or_phone,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.bnb,
            "BNB",
            Assets.cryptoWithdrawIcons.bnb.svg(width: AppDimens.w24),
            Color(0xFFF3BA2F),
            FormPayload(
              rootNavKey.currentContext!.l10n.bep20Address,
              Icon(Icons.wallet_sharp, size: 24, color: Color(0xFFF3BA2F)),
              PatternHelper.crypto,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.litecoin,
            "Litecoin",
            Assets.cryptoWithdrawIcons.litecoin.svg(width: AppDimens.w24),
            Color(0xFF345D9D),
            FormPayload(
              rootNavKey.currentContext!.l10n.ltcWalletAddress,
              Icon(Icons.wallet_sharp, size: 24, color: Color(0xFF345D9D)),
              PatternHelper.crypto,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.tron,
            "Tron (TRX)",
            Assets.cryptoWithdrawIcons.tron.svg(width: AppDimens.w24),
            Color(0xFFFF060A),
            FormPayload(
              rootNavKey.currentContext!.l10n.trxAddress,
              Icon(Icons.wallet_sharp, size: 24, color: Color(0xFFFF060A)),
              PatternHelper.crypto,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.dogecoin,
            "Dogecoin",
            Assets.cryptoWithdrawIcons.dogecoin.svg(width: AppDimens.w24),
            Color(0xFFC2A633),
            FormPayload(
              rootNavKey.currentContext!.l10n.dogeAddress,
              Icon(Icons.wallet_sharp, size: 24, color: Color(0xFFC2A633)),
              PatternHelper.crypto,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.shibaInu,
            "Shiba Inu",
            Assets.cryptoWithdrawIcons.shibainu.svg(width: AppDimens.w24),
            Color(0xFFF28C28),
            FormPayload(
              rootNavKey.currentContext!.l10n.shibAddress,
              Icon(Icons.wallet_sharp, size: 24, color: Color(0xFFF28C28)),
              PatternHelper.crypto,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.solana,
            "Solana",
            Assets.cryptoWithdrawIcons.solana.svg(width: AppDimens.w24),
            Color(0xFF9945FF),
            FormPayload(
              rootNavKey.currentContext!.l10n.solAddress,
              Icon(Icons.wallet_sharp, size: 24, color: Color(0xFF9945FF)),
              PatternHelper.crypto,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.ripple,
            "Ripple (XRP)",
            Assets.cryptoWithdrawIcons.ripple.svg(width: AppDimens.w24),
            Color(0xFF23292F),
            FormPayload(
              rootNavKey.currentContext!.l10n.xrpAddressTag,
              Icon(Icons.wallet_sharp, size: 24, color: Color(0xFF23292F)),
              PatternHelper.crypto_with_tag,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.polygon,
            "Polygon (MATIC)",
            Assets.cryptoWithdrawIcons.polygon.svg(width: AppDimens.w24),
            Color(0xFF8247E5),
            FormPayload(
              rootNavKey.currentContext!.l10n.polygonAddress,
              Icon(Icons.wallet_sharp, size: 24, color: Color(0xFF8247E5)),
              PatternHelper.crypto,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.dash,
            "Dash",
            Assets.cryptoWithdrawIcons.dash.svg(width: AppDimens.w24),
            Color(0xFF008CE7),
            FormPayload(
              rootNavKey.currentContext!.l10n.dashAddress,
              Icon(Icons.wallet_sharp, size: 24, color: Color(0xFF008CE7)),
              PatternHelper.crypto,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.bitcoinCash,
            "Bitcoin Cash",
            Assets.cryptoWithdrawIcons.bitcoincash.svg(width: AppDimens.w24),
            Color(0xFF8DC351),
            FormPayload(
              rootNavKey.currentContext!.l10n.bchAddress,
              Icon(Icons.wallet_sharp, size: 24, color: Color(0xFF8DC351)),
              PatternHelper.crypto,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.perfectMoney,
            "Perfect Money",
            Icon(Icons.local_parking, size: 24, color: Color(0xFF900600)),
            Color(0xFF900600),
            FormPayload(
              rootNavKey.currentContext!.l10n.perfectMoneyAccount,
              Icon(Icons.account_balance_wallet_rounded, size: 24, color: Color(0xFF900600)),
              PatternHelper.flexible_id,
            ),
          ),
        ],
      ),

      PurseCategory(
        title: rootNavKey.currentContext!.l10n.giftCards,
        dbTitle: "Gift Cards",
        items: [
          PurseItem(
            rootNavKey.currentContext!.l10n.googlePlay,
            "Google Play",
            Icon(Icons.play_arrow, size: 24, color: Color(0xFF34A853)),
            Color(0xFF34A853),
            FormPayload(
              rootNavKey.currentContext!.l10n.emailToSendCode,
              Icon(Icons.email, size: 24, color: Color(0xFF34A853)),
              PatternHelper.email,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.appleGiftCard,
            "Apple Gift Card",
            Icon(Icons.apple, size: 24, color: Color(0xFFFFFFFF)),
            Color(0xFFFFFFFF),
            FormPayload(
              rootNavKey.currentContext!.l10n.emailToSendCode,
              Icon(Icons.email, size: 24, color: Color(0xFFFFFFFF)),
              PatternHelper.email,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.steamWallet,
            "Steam Wallet",
            Assets.giftWithdrawIcons.steamwallet.svg(width: AppDimens.w24),
            Color(0xFF34A853),
            FormPayload(
              rootNavKey.currentContext!.l10n.emailToSendCode,
              Icon(Icons.email, size: 24, color: Color(0xFF34A853)),
              PatternHelper.email,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.playstation,
            "PlayStation",
            Assets.giftWithdrawIcons.playstation.svg(width: AppDimens.w24),
            Color(0xFFFFFFFF),
            FormPayload(
              rootNavKey.currentContext!.l10n.emailToSendCode,
              Icon(Icons.email, size: 24, color: Color(0xFFFFFFFF)),
              PatternHelper.email,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.xboxLive,
            "Xbox Live",
            Assets.giftWithdrawIcons.xboxlive.svg(width: AppDimens.w24),
            Color(0xFF1B2838),
            FormPayload(
              rootNavKey.currentContext!.l10n.emailToSendCode,
              Icon(Icons.email, size: 24, color: Color(0xFF1B2838)),
              PatternHelper.email,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.nintendoEshop,
            "Nintendo eShop",
            Assets.giftWithdrawIcons.nintendoEshop.svg(width: AppDimens.w24),
            Color(0xFF00D1B2),
            FormPayload(
              rootNavKey.currentContext!.l10n.emailToSendCode,
              Icon(Icons.email, size: 24, color: Color(0xFF00D1B2)),
              PatternHelper.email,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.razerGold,
            "Razer Gold",
            Assets.giftWithdrawIcons.razergold.svg(width: AppDimens.w24),
            Color(0xFF44D62C),
            FormPayload(
              rootNavKey.currentContext!.l10n.razerIdEmail,
              Icon(Icons.email, size: 24, color: Color(0xFF44D62C)),
              PatternHelper.email_or_phone,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.amazon,
            "Amazon",
            Assets.giftWithdrawIcons.amazon.svg(width: AppDimens.w24),
            Color(0xFFFF9900),
            FormPayload(
              rootNavKey.currentContext!.l10n.emailToSendCode,
              Icon(Icons.email, size: 24, color: Color(0xFFFF9900)),
              PatternHelper.email,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.ebay,
            "eBay",
            Assets.giftWithdrawIcons.ebay.svg(width: AppDimens.w24),
            Color(0xFFE53238),
            FormPayload(
              rootNavKey.currentContext!.l10n.emailToSendCode,
              Icon(Icons.email, size: 24, color: Color(0xFFE53238)),
              PatternHelper.email,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.walmart,
            "Walmart",
            Assets.giftWithdrawIcons.walmart.svg(width: AppDimens.w24),
            Color(0xFF0071CE),
            FormPayload(
              rootNavKey.currentContext!.l10n.emailToSendCode,
              Icon(Icons.email, size: 24, color: Color(0xFF0071CE)),
              PatternHelper.email,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.target,
            "Target",
            Assets.giftWithdrawIcons.target.svg(width: AppDimens.w24),
            Color(0xFFCC0000),
            FormPayload(
              rootNavKey.currentContext!.l10n.emailToSendCode,
              Icon(Icons.email, size: 24, color: Color(0xFFCC0000)),
              PatternHelper.email,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.shien,
            "Shien",
            Assets.giftWithdrawIcons.shien.svg(width: AppDimens.w24),
            Color(0xFFFFFFFF),
            FormPayload(
              rootNavKey.currentContext!.l10n.emailToSendCode,
              Icon(Icons.email, size: 24, color: Color(0xFFFFFFFF)),
              PatternHelper.email,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.sephora,
            "Sephora",
            Assets.giftWithdrawIcons.sephora.svg(width: AppDimens.w24),
            Color(0xFFFFFFFF),
            FormPayload(
              rootNavKey.currentContext!.l10n.emailToSendCode,
              Icon(Icons.email, size: 24, color: Color(0xFFFFFFFF)),
              PatternHelper.email,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.nike,
            "Nike",
            Assets.giftWithdrawIcons.nike.svg(width: AppDimens.w24),
            Color(0xFFFFFFFF),
            FormPayload(
              rootNavKey.currentContext!.l10n.emailToSendCode,
              Icon(Icons.email, size: 24, color: Color(0xFFFFFFFF)),
              PatternHelper.email,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.netflix,
            "Netflix",
            Assets.giftWithdrawIcons.netflix.svg(width: AppDimens.w24),
            Color(0xFFE50914),
            FormPayload(
              rootNavKey.currentContext!.l10n.emailToSendCode,
              Icon(Icons.email, size: 24, color: Color(0xFFE50914)),
              PatternHelper.email,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.spotify,
            "Spotify",
            Assets.giftWithdrawIcons.spotify.svg(width: AppDimens.w24),
            Color(0xFF1DB954),
            FormPayload(
              rootNavKey.currentContext!.l10n.emailToSendCode,
              Icon(Icons.email, size: 24, color: Color(0xFF1DB954)),
              PatternHelper.email,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.disneyPlus,
            "Disney+",
            Assets.giftWithdrawIcons.disney.svg(width: AppDimens.w24),
            Color(0xFF113CCF),
            FormPayload(
              rootNavKey.currentContext!.l10n.emailToSendCode,
              Icon(Icons.email, size: 24, color: Color(0xFF113CCF)),
              PatternHelper.email,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.twitch,
            "Twitch",
            Assets.giftWithdrawIcons.twitch.svg(width: AppDimens.w24),
            Color(0xFF9146FF),
            FormPayload(
              rootNavKey.currentContext!.l10n.emailToSendCode,
              Icon(Icons.email, size: 24, color: Color(0xFF9146FF)),
              PatternHelper.email,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.starbucks,
            "Starbucks",
            Assets.giftWithdrawIcons.starbucks.svg(width: AppDimens.w24),
            Color(0xFF00704A),
            FormPayload(
              rootNavKey.currentContext!.l10n.emailToSendCode,
              Icon(Icons.email, size: 24, color: Color(0xFF00704A)),
              PatternHelper.email,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.uberEats,
            "Uber / Eats",
            Assets.giftWithdrawIcons.ubereats.svg(width: AppDimens.w24),
            Color(0xFFFFFFFF),
            FormPayload(
              rootNavKey.currentContext!.l10n.emailToSendCode,
              Icon(Icons.email, size: 24, color: Color(0xFFFFFFFF)),
              PatternHelper.email,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.doordash,
            "DoorDash",
            Assets.giftWithdrawIcons.doordash.svg(width: AppDimens.w24),
            Color(0xFFFF3008),
            FormPayload(
              rootNavKey.currentContext!.l10n.emailToSendCode,
              Icon(Icons.email, size: 24, color: Color(0xFFFF3008)),
              PatternHelper.email,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.visaPrepaid,
            "Visa Prepaid",
            Assets.giftWithdrawIcons.visaprepaid.svg(width: AppDimens.w24),
            Color(0xFF1A1F71),
            FormPayload(
              rootNavKey.currentContext!.l10n.emailToSendCode,
              Icon(Icons.email, size: 24, color: Color(0xFF1A1F71)),
              PatternHelper.email,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.mastercard,
            "Mastercard",
            Assets.giftWithdrawIcons.mastercard.svg(width: AppDimens.w24),
            Color(0xFFF79E1B),
            FormPayload(
              rootNavKey.currentContext!.l10n.emailToSendCode,
              Icon(Icons.email, size: 24, color: Color(0xFFF79E1B)),
              PatternHelper.email,
            ),
          ),
        ],
      ),

      PurseCategory(
        title: rootNavKey.currentContext!.l10n.game_credits,
        dbTitle: "Game Credits",
        items: [
          PurseItem(
            rootNavKey.currentContext!.l10n.freeFire,
            "Free Fire",
            Assets.gameWithdrawIcons.freefire.svg(width: AppDimens.w24),
            Color(0xFFF5A623),
            FormPayload(
              rootNavKey.currentContext!.l10n.playerIdUid,
              Icon(Icons.videogame_asset_rounded, size: 24, color: Color(0xFFF79E1B)),
              PatternHelper.uid,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.pubgMobile,
            "PUBG Mobile",
            Assets.gameWithdrawIcons.pubgmobile.svg(width: AppDimens.w24),
            Color(0xFFF2A900),
            FormPayload(
              rootNavKey.currentContext!.l10n.characterId,
              Icon(Icons.videogame_asset_rounded, size: 24, color: Color(0xFFF79E1B)),
              PatternHelper.uid,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.codMobile,
            "CoD Mobile",
            Assets.gameWithdrawIcons.codmobile.svg(width: AppDimens.w24),
            Color(0xFFC4C4C4),
            FormPayload(
              rootNavKey.currentContext!.l10n.playerIdUid,
              Icon(Icons.videogame_asset_rounded, size: 24, color: Color(0xFFC4C4C4)),
              PatternHelper.uid,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.fortnite,
            "Fortnite",
            Assets.gameWithdrawIcons.fortnite.svg(width: AppDimens.w24),
            Color(0xFF9146FF),
            FormPayload(
              rootNavKey.currentContext!.l10n.epicGamesUsername,
              Icon(Icons.person, size: 24, color: Color(0xFF9146FF)),
              PatternHelper.ea_id,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.apexLegends,
            "Apex Legends",
            Assets.gameWithdrawIcons.apexLegends.svg(width: AppDimens.w24),
            Color(0xFFFF2D2D),
            FormPayload(
              rootNavKey.currentContext!.l10n.eaIdUsername,
              Icon(Icons.person, size: 24, color: Color(0xFFFF2D2D)),
              PatternHelper.ea_id,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.mobileLegends,
            "Mobile Legends",
            Assets.gameWithdrawIcons.mobilelegends.svg(width: AppDimens.w24),
            Color(0xFF00BFFF),
            FormPayload(
              rootNavKey.currentContext!.l10n.userIdZoneId,
              Icon(Icons.videogame_asset_rounded, size: 24, color: Color(0xFF00BFFF)),
              PatternHelper.uid_zone,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.leagueOfLegends,
            "League of Legends",
            Assets.gameWithdrawIcons.leagueoflegends.svg(width: AppDimens.w24),
            Color(0xFFC89B3C),
            FormPayload(
              rootNavKey.currentContext!.l10n.riotIdNameTag,
              Icon(Icons.videogame_asset_rounded, size: 24, color: Color(0xFFC89B3C)),
              PatternHelper.riot_id,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.brawlStars,
            "Brawl Stars",
            Assets.gameWithdrawIcons.brawlstars.svg(width: AppDimens.w24),
            Color(0xFFFFD700),
            FormPayload(
              rootNavKey.currentContext!.l10n.playerTag,
              Icon(Icons.tag, size: 24, color: Color(0xFFFFD700)),
              PatternHelper.game_tag,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.valorant,
            "Valorant",
            Assets.gameWithdrawIcons.valorant.svg(width: AppDimens.w24),
            Color(0xFFFF4655),
            FormPayload(
              rootNavKey.currentContext!.l10n.riotIdNameTag,
              Icon(Icons.person, size: 24, color: Color(0xFFFF4655)),
              PatternHelper.riot_id,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.genshinImpact,
            "Genshin Impact",
            Assets.gameWithdrawIcons.genshinimpact.svg(width: AppDimens.w24),
            Color(0xFFF28C28),
            FormPayload(
              rootNavKey.currentContext!.l10n.userIdServer,
              Icon(Icons.videogame_asset_rounded, size: 24, color: Color(0xFFF28C28)),
              PatternHelper.uid_zone,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.robux,
            "Robux",
            Assets.gameWithdrawIcons.robux.svg(width: AppDimens.w24),
            Color(0xFF00A2FF),
            FormPayload(
              rootNavKey.currentContext!.l10n.robloxUsername,
              Icon(Icons.person, size: 24, color: Color(0xFF00A2FF)),
              PatternHelper.ea_id,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.minecraft,
            "Minecraft",
            Assets.gameWithdrawIcons.minecraft.svg(width: AppDimens.w24),
            Color(0xFF5C8A3E),
            FormPayload(
              rootNavKey.currentContext!.l10n.xboxGamertagEmail,
              Icon(Icons.mail, size: 24, color: Color(0xFF5C8A3E)),
              PatternHelper.email_or_phone,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.clashOfClans,
            "Clash of Clans",
            Assets.gameWithdrawIcons.clashofclans.svg(width: AppDimens.w24),
            Color(0xFFD4AF37),
            FormPayload(
              rootNavKey.currentContext!.l10n.playerTag,
              Icon(Icons.tag, size: 24, color: Color(0xFFFFD700)),
              PatternHelper.game_tag,
            ),
          ),
          PurseItem(
            rootNavKey.currentContext!.l10n.eaFc,
            "EA FC",
            Assets.gameWithdrawIcons.eafc.svg(width: AppDimens.w24),
            Color(0xFF444444),
            FormPayload(
              rootNavKey.currentContext!.l10n.eaIdPsnXbox,
              Icon(Icons.videogame_asset_rounded, size: 24, color: Color(0xFF444444)),
              PatternHelper.ea_id,
            ),
          ),
        ],
      ),
    ];
  }

  int selectedIndex = 0;

  String? _withdrawType = rootNavKey.currentContext!.l10n.cash;
  String? _withdrawSubType;

  String? get withdrawType => _withdrawType;
  String? get withdrawSubType => _withdrawSubType;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final PageController pageController = PageController();

  void setWithdrawType(String value) {
    _withdrawType = value;
    notifyListeners();
  }

  void setWithdrawSubType(String value) {
    _withdrawSubType = value;
    notifyListeners();
  }

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  void setSelectedIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  final TextEditingController btcWalletAddressController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  String convertedValue = "0.0000";

  void onAmountChanged(String value) {
    final amount = double.tryParse(value) ?? 0;

    final result = amount / RemoteSettingsService.instance.coinToDollarDivider; // 👈 your logic
    convertedValue = result.toStringAsFixed(4);

    notifyListeners();
  }

  @override
  void dispose() {
    pageController.dispose();
    btcWalletAddressController.dispose();
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  void resetWithdrawForm() {
    btcWalletAddressController.clear();
    amountController.clear();
    noteController.clear();

    _withdrawSubType = null;

    convertedValue = "0.0000";

    notifyListeners();
  }

  bool showWithdrawSheet = false;

  void toggleSheet(bool value) {
    showWithdrawSheet = value;
    notifyListeners();
  }

  Future<bool> createWithdraw() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = _db.userModel!;

      final amount = double.tryParse((amountController.text.trim()).toString());

      if (withdrawSubType == null || withdrawSubType!.isEmpty) {
        _error = rootNavKey.currentContext!.l10n.pleaseSelectWithdrawSubType;
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (withdrawType == null || withdrawType!.isEmpty) {
        _error = rootNavKey.currentContext!.l10n.pleaseSelectWithdrawType;
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (btcWalletAddressController.text.trim().isEmpty) {
        _error = rootNavKey.currentContext!.l10n.pleaseEnterWalletAddress;
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (amount == null) {
        _error = rootNavKey.currentContext!.l10n.pleaseEnterValidAmount;
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final minAmount = RemoteSettingsService.instance.minWithdrawAmount;
      if (amount < minAmount) {
        _isLoading = false;
        _error =
            "${rootNavKey.currentContext!.l10n.minimumWithdrawIs}$minAmount ${rootNavKey.currentContext!.l10n.coins}";
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final docRef = _firestore.collection('withdraw').doc();

      await docRef.set({
        'user_id': user.userId,
        'email': btcWalletAddressController.text.trim(),
        'withdraw_type': withdrawType,
        'withdraw_sub_type': withdrawSubType,
        'amount': amount, // ✅ use parsed value
        'note': noteController.text.trim(),
        'status': 'pending',
        'created_at': FieldValue.serverTimestamp(),
        'reason': '',
      });

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Withdraw failed';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Get Withdraw List (Stream)
  Stream<QuerySnapshot> getWithdrawStream() {
    final userId = _db.userModel!.userId;

    return _firestore
        .collection('withdraw')
        .where('user_id', isEqualTo: userId)
        .orderBy('created_at', descending: true)
        .snapshots();
  }
}
