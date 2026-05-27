import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_cash/db/app_db.dart';
import 'package:daily_cash/di/injector.dart';
import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/wallet_module/model/wallet_models.dart';
import 'package:daily_cash/gen/assets.gen.dart';
import 'package:daily_cash/routes/app_router.dart';
import 'package:daily_cash/utils/app_size.dart';
import 'package:daily_cash/utils/regex_helper.dart';
import 'package:daily_cash/utils/remote_config.dart';
import 'package:flutter/material.dart';

class WalletProvider extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final _db = Injector.instance<AppDB>();

  List<WalletCategory> getWalletCategories(BuildContext context) {
    return [
      WalletCategory(
        title: rootNavKey.currentContext!.l10n.cash,
        dbTitle: "Cash",
        items: [
          WalletItem(
            rootNavKey.currentContext!.l10n.paypal,
            "PayPal",
            Icon(Icons.paypal, size: AppSize.w24, color: Color(0xFF2559ca)),
            Color(0xFF2559ca),
            FormData(
              rootNavKey.currentContext!.l10n.enterPaypalEmail,
              Icon(Icons.payment, size: AppSize.w24, color: Color(0xFF2559ca)),
              RegexHelper.email,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.wise,
            "Wise",
            Icon(Icons.flag_outlined, size: AppSize.w24, color: Color(0xFF00aeff)),
            Color(0xFF00aeff),
            FormData(
              rootNavKey.currentContext!.l10n.emailIban,
              Icon(Icons.account_balance_sharp, size: 24, color: Color(0xFF00aeff)),
              RegexHelper.email_or_iban,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.payoneer,
            "Payoneer",
            Icon(Icons.repeat_on_sharp, size: AppSize.w24, color: Color(0xFFff4000)),
            Color(0xFFff4000),
            FormData(
              rootNavKey.currentContext!.l10n.payoneerEmail,
              Icon(Icons.email_sharp, size: 24, color: Color(0xFFff4000)),
              RegexHelper.email,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.skrill,
            "Skrill",
            Icon(Icons.local_play_sharp, size: AppSize.w24, color: Color(0xFFb82986)),
            Color(0xFFb82986),
            FormData(
              rootNavKey.currentContext!.l10n.skrillEmail,
              Icon(Icons.email_sharp, size: 24, color: Color(0xFFb82986)),
              RegexHelper.email,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.applePay,
            "Apple Pay",
            Icon(Icons.apple, size: AppSize.w24, color: Color(0xFFFFFFFF)),
            Color(0xFFFFFFFF),
            FormData(
              rootNavKey.currentContext!.l10n.appleId,
              Icon(Icons.phone_android_sharp, size: 24, color: Color(0xFFFFFFFF)),
              RegexHelper.email_or_phone,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.googleWallet,
            "Google Wallet",
            Assets.cashWithdrawIcons.icGooglewallet.image(width: AppSize.w24),
            Color(0xFF3a7af2),
            FormData(
              rootNavKey.currentContext!.l10n.googlePayNumber,
              Icon(Icons.email_sharp, size: 24, color: Color(0xFF3a7af2)),
              RegexHelper.email_or_phone,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.samsungWallet,
            "Samsung Wallet",
            Icon(Icons.phone_android, size: AppSize.w24, color: Color(0xFF43a546)),
            Color(0xFF43a546),
            FormData(
              rootNavKey.currentContext!.l10n.samsungPayId,
              Icon(Icons.email_sharp, size: 24, color: Color(0xFF43a546)),
              RegexHelper.alphanumeric,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.wellsFargo,
            "Wells Fargo",
            Icon(Icons.account_balance_outlined, size: AppSize.w24, color: Color(0xFFf68819)),
            Color(0xFFf68819),
            FormData(
              rootNavKey.currentContext!.l10n.accountNumber,
              Icon(Icons.account_balance_sharp, size: 24, color: Color(0xFFf68819)),
              RegexHelper.iban_or_account,
            ),
          ),

          // Europe / Asia wallets
          WalletItem(
            rootNavKey.currentContext!.l10n.alipay,
            "Alipay",
            Assets.cashWithdrawIcons.icAlipay.svg(width: AppSize.w24),
            Color(0xFF166bff),
            FormData(
              rootNavKey.currentContext!.l10n.alipayId,
              Icon(Icons.qr_code, size: 24, color: Color(0xFF166bff)),
              RegexHelper.wallet_id,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.wechatPay,
            "WeChat Pay",
            Icon(Icons.wechat, size: AppSize.w24, color: Color(0xFF009e5f)),
            Color(0xFF009e5f),
            FormData(
              rootNavKey.currentContext!.l10n.wechatId,
              Icon(Icons.message, size: 24, color: Color(0xFF009e5f)),
              RegexHelper.wallet_id,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.upi,
            "UPI",
            Icon(Icons.qr_code_2, size: AppSize.w24, color: Color(0xFFFF7900)),
            Color(0xFFFF7900),
            FormData(
              rootNavKey.currentContext!.l10n.upiId,
              Icon(Icons.alternate_email, size: 24, color: Color(0xFFFF7900)),
              RegexHelper.upi,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.phonepe,
            "PhonePe",
            Icon(Icons.local_parking_outlined, size: AppSize.w24, color: Color(0xFF6F2C91)),
            Color(0xFF6F2C91),
            FormData(
              rootNavKey.currentContext!.l10n.phonepeNumber,
              Icon(Icons.call, size: 24, color: Color(0xFF6F2C91)),
              RegexHelper.phone,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.paytm,
            "Paytm",
            Icon(Icons.credit_card, size: AppSize.w24, color: Color(0xFF00AEEF)),
            Color(0xFF00AEEF),
            FormData(
              rootNavKey.currentContext!.l10n.paytmNumber,
              Icon(Icons.call, size: 24, color: Color(0xFF00AEEF)),
              RegexHelper.phone,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.gcash,
            "GCash",
            Icon(Icons.wallet, size: AppSize.w24, color: Color(0xFF0066FF)),
            Color(0xFF0066FF),
            FormData(
              rootNavKey.currentContext!.l10n.gcashNumber,
              Icon(Icons.call, size: 24, color: Color(0xFF0066FF)),
              RegexHelper.phone,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.grabpay,
            "GrabPay",
            Icon(Icons.local_taxi_rounded, size: AppSize.w24, color: Color(0xFF00A651)),
            Color(0xFF00A651),
            FormData(
              rootNavKey.currentContext!.l10n.grabRegisteredNumber,
              Icon(Icons.call, size: 24, color: Color(0xFF00A651)),
              RegexHelper.phone,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.kakaopay,
            "KakaoPay",
            Icon(Icons.chat_bubble, size: AppSize.w24, color: Color(0xFFFFCC00)),
            Color(0xFFFFCC00),
            FormData(
              rootNavKey.currentContext!.l10n.kakaoId,
              Icon(Icons.chat_bubble, size: 24, color: Color(0xFFFFCC00)),
              RegexHelper.wallet_id,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.paypay,
            "PayPay",
            Icon(Icons.local_parking_outlined, size: AppSize.w24, color: Color(0xFFE30613)),
            Color(0xFFE30613),
            FormData(
              rootNavKey.currentContext!.l10n.paypayId,
              Icon(Icons.qr_code, size: 24, color: Color(0xFFE30613)),
              RegexHelper.wallet_id,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.easypaisa,
            "Easypaisa",
            Icon(Icons.account_balance_wallet_rounded, size: AppSize.w24, color: Color(0xFF00B14F)),
            Color(0xFF00B14F),
            FormData(
              rootNavKey.currentContext!.l10n.easypaisaNumber,
              Icon(Icons.call, size: 24, color: Color(0xFF00B14F)),
              RegexHelper.phone,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.sadapay,
            "SadaPay",
            Icon(Icons.credit_card, size: AppSize.w24, color: Color(0xFF1B2838)),
            Color(0xFF1B2838),
            FormData(
              rootNavKey.currentContext!.l10n.sadapayAccount,
              Icon(Icons.call, size: 24, color: Color(0xFF1B2838)),
              RegexHelper.phone_or_id,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.bkash,
            "bKash",
            Icon(Icons.money_outlined, size: AppSize.w24, color: Color(0xFFf54293)),
            Color(0xFFf54293),
            FormData(
              rootNavKey.currentContext!.l10n.bkashNumber,
              Icon(Icons.call, size: 24, color: Color(0xFFf54293)),
              RegexHelper.phone,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.callfin,
            "CallFin",
            Icon(Icons.phone_android, size: AppSize.w24, color: Color(0xFF00A86B)),
            Color(0xFF00A86B),
            FormData(
              rootNavKey.currentContext!.l10n.callfinNumber,
              Icon(Icons.email_sharp, size: 24, color: Color(0xFF00A86B)),
              RegexHelper.phone_or_id,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.revolut,
            "Revolut",
            Assets.cashWithdrawIcons.icRevolut.image(width: AppSize.w24),
            Color(0xFF0066FF),
            FormData(
              rootNavKey.currentContext!.l10n.revtagIban,
              Icon(Icons.tag, size: 24, color: Color(0xFF0066FF)),
              RegexHelper.email_or_iban,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.monzo,
            "Monzo",
            Assets.cashWithdrawIcons.icMonzo.image(width: AppSize.w24),
            Color(0xFF1A2E5A),
            FormData(
              rootNavKey.currentContext!.l10n.accountSortcode,
              Icon(Icons.account_balance_sharp, size: 24, color: Color(0xFF1A2E5A)),
              RegexHelper.sort_code_account,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.n26,
            "N26",
            Assets.cashWithdrawIcons.icN26.image(width: AppSize.w24),
            Color(0xFF00C1B2),
            FormData(
              rootNavKey.currentContext!.l10n.iban,
              Icon(Icons.account_balance_sharp, size: 24, color: Color(0xFF00C1B2)),
              RegexHelper.iban,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.bunq,
            "Bunq",
            Icon(Icons.savings, size: AppSize.w24, color: Color(0xFFeb7a8d)),
            Color(0xFFeb7a8d),
            FormData(
              rootNavKey.currentContext!.l10n.ibanEmail,
              Icon(Icons.mail, size: 24, color: Color(0xFFeb7a8d)),
              RegexHelper.email_or_iban,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.starlingBank,
            "Starling Bank",
            Assets.cashWithdrawIcons.icStarlingbank.svg(width: AppSize.w24),
            Color(0xFF00b9aa),
            FormData(
              rootNavKey.currentContext!.l10n.accountNumber,
              Icon(Icons.tag, size: 24, color: Color(0xFF00b9aa)),
              RegexHelper.sort_code_account,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.ideal,
            "iDEAL",
            Assets.cashWithdrawIcons.icIdeal.svg(width: AppSize.w24),
            Color(0xFFFFFFFF),
            FormData(
              rootNavKey.currentContext!.l10n.iban,
              Icon(Icons.account_balance_sharp, size: 24, color: Color(0xFFFFFFFF)),
              RegexHelper.iban,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.tikkie,
            "Tikkie",
            Assets.cashWithdrawIcons.icTikkie.svg(width: AppSize.w24),
            Color(0xFFff5f00),
            FormData(
              rootNavKey.currentContext!.l10n.tikkieLinkNumber,
              Icon(Icons.link, size: 24, color: Color(0xFFff5f00)),
              RegexHelper.link,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.vipps,
            "Vipps",
            Assets.cashWithdrawIcons.icVipps.svg(width: AppSize.w24),
            Color(0xFFff5020),
            FormData(
              rootNavKey.currentContext!.l10n.vippsNumber,
              Icon(Icons.call, size: 24, color: Color(0xFFff5f00)),
              RegexHelper.phone,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.mobilePay,
            "MobilePay",
            Assets.cashWithdrawIcons.icMobilepay.svg(width: AppSize.w24),
            Color(0xFF00509b),
            FormData(
              rootNavKey.currentContext!.l10n.mobilepayNumber,
              Icon(Icons.call, size: 24, color: Color(0xFF00509b)),
              RegexHelper.phone,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.swish,
            "Swish",
            Assets.cashWithdrawIcons.icSwish.svg(width: AppSize.w24),
            Color(0xFF02ab81),
            FormData(
              rootNavKey.currentContext!.l10n.swishNumber,
              Icon(Icons.call, size: 24, color: Color(0xFF02ab81)),
              RegexHelper.phone,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.blik,
            "BLIK",
            Assets.cashWithdrawIcons.icBlik.svg(width: AppSize.w24),
            Color(0xFFfc342a),
            FormData(
              rootNavKey.currentContext!.l10n.blikCode,
              Icon(Icons.tag, size: 24, color: Color(0xFFfc342a)),
              RegexHelper.code,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.lydia,
            "Lydia",
            Assets.cashWithdrawIcons.icLydia.svg(width: AppSize.w24),
            Color(0xFF612670),
            FormData(
              rootNavKey.currentContext!.l10n.lydiaNumber,
              Icon(Icons.call, size: 24, color: Color(0xFF612670)),
              RegexHelper.phone,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.paylib,
            "PayLib",
            Assets.cashWithdrawIcons.icPaylib.svg(width: AppSize.w24),
            Color(0xFF3c4985),
            FormData(
              rootNavKey.currentContext!.l10n.paylibNumber,
              Icon(Icons.call, size: 24, color: Color(0xFF3c4985)),
              RegexHelper.phone,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.twint,
            "Twint",
            Assets.cashWithdrawIcons.icTwint.svg(width: AppSize.w24),
            Color(0xFF652786),
            FormData(
              rootNavKey.currentContext!.l10n.twintNumber,
              Icon(Icons.call, size: 24, color: Color(0xFF652786)),
              RegexHelper.phone,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.satispay,
            "Satispay",
            Assets.cashWithdrawIcons.icSatispay.svg(width: AppSize.w24),
            Color(0xFFff5035),
            FormData(
              rootNavKey.currentContext!.l10n.satispayNumber,
              Icon(Icons.call, size: 24, color: Color(0xFFff5035)),
              RegexHelper.phone,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.iyzico,
            "iyzico",
            Assets.cashWithdrawIcons.icIyzico.svg(width: AppSize.w24),
            Color(0xFF2882ff),
            FormData(
              rootNavKey.currentContext!.l10n.accountId,
              Icon(Icons.account_circle, size: 24, color: Color(0xFF2882ff)),
              RegexHelper.flexible_id,
            ),
          ),

          // Africa / Middle East
          WalletItem(
            rootNavKey.currentContext!.l10n.mpesa,
            "M-Pesa",
            Assets.cashWithdrawIcons.icMpesa.svg(width: AppSize.w24),
            Color(0xFF009c46),
            FormData(
              rootNavKey.currentContext!.l10n.mpesaNumber,
              Icon(Icons.call, size: 24, color: Color(0xFF009c46)),
              RegexHelper.phone,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.opay,
            "OPay",
            Assets.cashWithdrawIcons.icOpay.svg(width: AppSize.w24),
            Color(0xFF1DC45A),
            FormData(
              rootNavKey.currentContext!.l10n.opayNumber,
              Icon(Icons.call, size: 24, color: Color(0xFF1DC45A)),
              RegexHelper.phone,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.orangeMoney,
            "Orange Money",
            Assets.cashWithdrawIcons.icOrangemoney.svg(width: AppSize.w24),
            Color(0xFFFF7900),
            FormData(
              rootNavKey.currentContext!.l10n.orangeMoneyNumber,
              Icon(Icons.call, size: 24, color: Color(0xFFFF7900)),
              RegexHelper.phone,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.mtnMobile,
            "MTN Mobile",
            Assets.cashWithdrawIcons.icMynmobile.svg(width: AppSize.w24),
            Color(0xFFFFCC00),
            FormData(
              rootNavKey.currentContext!.l10n.mtnMobileNumber,
              Icon(Icons.cell_tower, size: 24, color: Color(0xFFFFCC00)),
              RegexHelper.phone,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.chipperCash,
            "Chipper Cash",
            Assets.cashWithdrawIcons.icChippercash.svg(width: AppSize.w24),
            Color(0xFF0066FF),
            FormData(
              rootNavKey.currentContext!.l10n.chipperTag,
              Icon(Icons.alternate_email, size: 24, color: Color(0xFF0066FF)),
              RegexHelper.wallet_id,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.moniepoint,
            "Moniepoint",
            Icon(Icons.dialpad, size: 24, color: Color(0xFFFFCC00)),
            Color(0xFFFFCC00),
            FormData(
              rootNavKey.currentContext!.l10n.accountNumber,
              Icon(Icons.tag, size: 24, color: Color(0xFFFFCC00)),
              RegexHelper.numberOnly,
            ),
          ),

          // India / Africa banks
          WalletItem(
            rootNavKey.currentContext!.l10n.baxi,
            "Baxi",
            Assets.cashWithdrawIcons.icBaxi.svg(width: AppSize.w24),
            Color(0xFF007BFF),
            FormData(
              rootNavKey.currentContext!.l10n.baxiAccount,
              Icon(Icons.tag, size: 24, color: Color(0xFF007BFF)),
              RegexHelper.numberOnly,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.capitecPay,
            "Capitec Pay",
            Assets.cashWithdrawIcons.icCapitecpay.svg(width: AppSize.w24),
            Color(0xFF00B14F),
            FormData(
              rootNavKey.currentContext!.l10n.idPhone,
              Icon(Icons.account_circle_outlined, size: 24, color: Color(0xFF00B14F)),
              RegexHelper.phone_or_id,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.snapscan,
            "SnapScan",
            Assets.cashWithdrawIcons.icSnapscan.svg(width: AppSize.w24),
            Color(0xFF0033A0),
            FormData(
              rootNavKey.currentContext!.l10n.snapscanId,
              Icon(Icons.qr_code, size: 24, color: Color(0xFF0033A0)),
              RegexHelper.wallet_id,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.natsWallet,
            "NatsWallet",
            Assets.cashWithdrawIcons.icNasswallet.svg(width: AppSize.w24),
            Color(0xFFF5A623),
            FormData(
              rootNavKey.currentContext!.l10n.cardAccount,
              Icon(Icons.compare_arrows_outlined, size: 24, color: Color(0xFFF5A623)),
              RegexHelper.iban_or_account,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.onafriq,
            "Onafriq",
            Assets.cashWithdrawIcons.icOnafriq.svg(width: AppSize.w24),
            Color(0xFFE53935),
            FormData(
              rootNavKey.currentContext!.l10n.userId,
              Icon(Icons.account_circle_outlined, size: 24, color: Color(0xFFE53935)),
              RegexHelper.flexible_id,
            ),
          ),

          // Middle East
          WalletItem(
            rootNavKey.currentContext!.l10n.stcPay,
            "STC Pay",
            Assets.cashWithdrawIcons.icStcpay.svg(width: AppSize.w24),
            Color(0xFF6A1B9A),
            FormData(
              rootNavKey.currentContext!.l10n.stcPayNumber,
              Icon(Icons.call, size: 24, color: Color(0xFF6A1B9A)),
              RegexHelper.phone,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.vodafoneCash,
            "Vodafone Cash",
            Assets.cashWithdrawIcons.icVodafonecash.svg(width: AppSize.w24),
            Color(0xFFE60000),
            FormData(
              rootNavKey.currentContext!.l10n.vodafoneNumber,
              Icon(Icons.call, size: 24, color: Color(0xFFE60000)),
              RegexHelper.phone,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.careemPay,
            "Careem Pay",
            Assets.cashWithdrawIcons.icCareempay.svg(width: AppSize.w24),
            Color(0xFF00C853),
            FormData(
              rootNavKey.currentContext!.l10n.careemNumber,
              Icon(Icons.call, size: 24, color: Color(0xFF00C853)),
              RegexHelper.phone,
            ),
          ),

          // Egypt
          WalletItem(
            rootNavKey.currentContext!.l10n.instapay,
            "InstaPay",
            Assets.cashWithdrawIcons.icInstapay.svg(width: AppSize.w24),
            Color(0xFF0070BA),
            FormData(
              rootNavKey.currentContext!.l10n.instapayAddress,
              Icon(Icons.alternate_email, size: 24, color: Color(0xFF0070BA)),
              RegexHelper.payment_id,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.myfawry,
            "myfawry",
            Assets.cashWithdrawIcons.icMyfawry.svg(width: AppSize.w24),
            Color(0xFFF9B233),
            FormData(
              rootNavKey.currentContext!.l10n.fawryNumber,
              Icon(Icons.call, size: 24, color: Color(0xFFF9B233)),
              RegexHelper.phone,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.benefitPay,
            "BenefitPay",
            Assets.cashWithdrawIcons.icBenefitpay.svg(width: AppSize.w24),
            Color(0xFF00A3E0),
            FormData(
              rootNavKey.currentContext!.l10n.benefitpayNumber,
              Icon(Icons.call, size: 24, color: Color(0xFF00A3E0)),
              RegexHelper.phone,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.meeza,
            "Meeza",
            Assets.cashWithdrawIcons.icMeeza.svg(width: AppSize.w24),
            Color(0xFF009639),
            FormData(
              rootNavKey.currentContext!.l10n.meezaCardWallet,
              Icon(Icons.credit_card, size: 24, color: Color(0xFF009639)),
              RegexHelper.iban_or_account,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.valu,
            "valU",
            Assets.cashWithdrawIcons.icValu.svg(width: AppSize.w24),
            Color(0xFF0088FF),
            FormData(
              rootNavKey.currentContext!.l10n.valuAccount,
              Icon(Icons.call, size: 24, color: Color(0xFF0088FF)),
              RegexHelper.phone_or_id,
            ),
          ),

          // LATAM
          WalletItem(
            rootNavKey.currentContext!.l10n.nubank,
            "Nubank",
            Assets.cashWithdrawIcons.icNubank.svg(width: AppSize.w24),
            Color(0xFF8A05BE),
            FormData(
              rootNavKey.currentContext!.l10n.pixpayAccount,
              Icon(Icons.add_box_sharp, size: 24, color: Color(0xFF8A05BE)),
              RegexHelper.pix_key,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.picpay,
            "PicPay",
            Assets.cashWithdrawIcons.icPicpay.svg(width: AppSize.w24),
            Color(0xFF21C25E),
            FormData(
              rootNavKey.currentContext!.l10n.picpayUsernamePix,
              Icon(Icons.alternate_email, size: 24, color: Color(0xFF21C25E)),
              RegexHelper.pix_key,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.mercadoPago,
            "Mercado Pago",
            Assets.cashWithdrawIcons.icMercadopago.svg(width: AppSize.w24),
            Color(0xFF009EE3),
            FormData(
              rootNavKey.currentContext!.l10n.emailCvu,
              Icon(Icons.mail, size: 24, color: Color(0xFF009EE3)),
              RegexHelper.email_or_iban,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.nequi,
            "Nequi",
            Assets.cashWithdrawIcons.icNequi.svg(width: AppSize.w24),
            Color(0xFF6A00FF),
            FormData(
              rootNavKey.currentContext!.l10n.nequiNumber,
              Icon(Icons.call, size: 24, color: Color(0xFF6A00FF)),
              RegexHelper.phone,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.daviplata,
            "Daviplata",
            Assets.cashWithdrawIcons.icDaviplata.svg(width: AppSize.w24),
            Color(0xFFE30613),
            FormData(
              rootNavKey.currentContext!.l10n.daviplataNumber,
              Icon(Icons.call, size: 24, color: Color(0xFFE30613)),
              RegexHelper.phone,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.yape,
            "Yape",
            Assets.cashWithdrawIcons.icYape.svg(width: AppSize.w24),
            Color(0xFF6A1B9A),
            FormData(
              rootNavKey.currentContext!.l10n.yapeNumber,
              Icon(Icons.call, size: 24, color: Color(0xFF6A1B9A)),
              RegexHelper.phone,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.plin,
            "Plin",
            Assets.cashWithdrawIcons.icPlin.svg(width: AppSize.w24),
            Color(0xFF00AEEF),
            FormData(
              rootNavKey.currentContext!.l10n.plinNumber,
              Icon(Icons.call, size: 24, color: Color(0xFF00AEEF)),
              RegexHelper.phone,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.rappiPay,
            "RappiPay",
            Assets.cashWithdrawIcons.icRappipay.svg(width: AppSize.w24),
            Color(0xFFFF441F),
            FormData(
              rootNavKey.currentContext!.l10n.rappiAccount,
              Icon(Icons.call, size: 24, color: Color(0xFFFF441F)),
              RegexHelper.phone_or_id,
            ),
          ),

          // South America / Global
          WalletItem(
            rootNavKey.currentContext!.l10n.mach,
            "MACH",
            Assets.cashWithdrawIcons.icMach.svg(width: AppSize.w24),
            Color(0xFFFFD400),
            FormData(
              rootNavKey.currentContext!.l10n.machAccount,
              Icon(Icons.account_circle, size: 24, color: Color(0xFFFFD400)),
              RegexHelper.flexible_id,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.prex,
            "Prex",
            Assets.cashWithdrawIcons.icPrex.svg(width: AppSize.w24),
            Color(0xFF00AEEF),
            FormData(
              rootNavKey.currentContext!.l10n.prexAccount,
              Icon(Icons.tag, size: 24, color: Color(0xFF00AEEF)),
              RegexHelper.flexible_id,
            ),
          ),

          // Australia / NZ
          WalletItem(
            rootNavKey.currentContext!.l10n.payId,
            "PayID",
            Assets.cashWithdrawIcons.icPayid.svg(width: AppSize.w24),
            Color(0xFF6C2BD9),
            FormData(
              rootNavKey.currentContext!.l10n.payIdEmail,
              Icon(Icons.abc, size: 24, color: Color(0xFF6C2BD9)),
              RegexHelper.email_or_phone,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.commbank,
            "CommBank",
            Assets.cashWithdrawIcons.icCommbank.svg(width: AppSize.w24),
            Color(0xFFFFCC00),
            FormData(
              rootNavKey.currentContext!.l10n.bsbAccount,
              Icon(Icons.tag, size: 24, color: Color(0xFFFFCC00)),
              RegexHelper.bsb_account,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.westpac,
            "Westpac",
            Assets.cashWithdrawIcons.icWestpac.svg(width: AppSize.w24),
            Color(0xFFD50000),
            FormData(
              rootNavKey.currentContext!.l10n.bsbAccount,
              Icon(Icons.tag, size: 24, color: Color(0xFFD50000)),
              RegexHelper.bsb_account,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.anz,
            "ANZ",
            Assets.cashWithdrawIcons.icAnz.svg(width: AppSize.w24),
            Color(0xFF0072CE),
            FormData(
              rootNavKey.currentContext!.l10n.bsbAccount,
              Icon(Icons.tag, size: 24, color: Color(0xFF0072CE)),
              RegexHelper.bsb_account,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.nab,
            "NAB",
            Assets.cashWithdrawIcons.icNab.svg(width: AppSize.w24),
            Color(0xFFC8102E),
            FormData(
              rootNavKey.currentContext!.l10n.bsbAccount,
              Icon(Icons.tag, size: 24, color: Color(0xFFC8102E)),
              RegexHelper.bsb_account,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.up,
            "Up",
            Assets.cashWithdrawIcons.icUp.svg(width: AppSize.w24),
            Color(0xFFFF6F00),
            FormData(
              rootNavKey.currentContext!.l10n.upnamePayId,
              Icon(Icons.alternate_email, size: 24, color: Color(0xFFFF6F00)),
              RegexHelper.email_or_phone,
            ),
          ),

          // Buy now pay later
          WalletItem(
            rootNavKey.currentContext!.l10n.afterpay,
            "Afterpay",
            Assets.cashWithdrawIcons.icAfterpay.svg(width: AppSize.w24),
            Color(0xFF00D084),
            FormData(
              rootNavKey.currentContext!.l10n.accountEmail,
              Icon(Icons.mail, size: 24, color: Color(0xFF00D084)),
              RegexHelper.email,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.zip,
            "Zip",
            Assets.cashWithdrawIcons.icZip.svg(width: AppSize.w24),
            Color(0xFF00C853),
            FormData(
              rootNavKey.currentContext!.l10n.zipId,
              Icon(Icons.account_circle, size: 24, color: Color(0xFF00C853)),
              RegexHelper.flexible_id,
            ),
          ),

          // Banks
          WalletItem(
            rootNavKey.currentContext!.l10n.kiwibank,
            "Kiwibank",
            Assets.cashWithdrawIcons.icKiwibank.svg(width: AppSize.w24),
            Color(0xFF78BE20),
            FormData(
              rootNavKey.currentContext!.l10n.accountNumber,
              Icon(Icons.tag, size: 24, color: Color(0xFF78BE20)),
              RegexHelper.numberOnly,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.scotiabank,
            "Scotiabank",
            Assets.cashWithdrawIcons.icScotiabank.svg(width: AppSize.w24),
            Color(0xFFE31837),
            FormData(
              rootNavKey.currentContext!.l10n.baseIdAccount,
              Icon(Icons.account_circle, size: 24, color: Color(0xFFE31837)),
              RegexHelper.flexible_id,
            ),
          ),
        ],
      ),

      WalletCategory(
        title: rootNavKey.currentContext!.l10n.crypto,
        dbTitle: "Crypto",
        items: [
          WalletItem(
            rootNavKey.currentContext!.l10n.bitcoin,
            "Bitcoin",
            Assets.cryptoWithdrawIcons.icBitcoin.svg(width: AppSize.w24),
            Color(0xFFF7931A),
            FormData(
              rootNavKey.currentContext!.l10n.btcWalletAddress,
              Icon(Icons.wallet_sharp, size: 24, color: Color(0xFFF7931A)),
              RegexHelper.crypto,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.ethereum,
            "Ethereum",
            Assets.cryptoWithdrawIcons.icEthereum.svg(width: AppSize.w24),
            Color(0xFF627EEA),
            FormData(
              rootNavKey.currentContext!.l10n.ethWalletAddress,
              Icon(Icons.wallet_sharp, size: 24, color: Color(0xFF627EEA)),
              RegexHelper.crypto,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.usdt,
            "USDT",
            Assets.cryptoWithdrawIcons.icUsdt.svg(width: AppSize.w24),
            Color(0xFF26A17B),
            FormData(
              rootNavKey.currentContext!.l10n.usdtNetwork,
              Icon(Icons.wallet_sharp, size: 24, color: Color(0xFF26A17B)),
              RegexHelper.crypto,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.usdc,
            "USDC",
            Assets.cryptoWithdrawIcons.icUsdc.svg(width: AppSize.w24),
            Color(0xFF2775CA),
            FormData(
              rootNavKey.currentContext!.l10n.usdcNetwork,
              Icon(Icons.wallet_sharp, size: 24, color: Color(0xFF2775CA)),
              RegexHelper.crypto,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.binancePay,
            "Binance Pay",
            Assets.cryptoWithdrawIcons.icBinancepay.svg(width: AppSize.w24),
            Color(0xFFF3BA2F),
            FormData(
              rootNavKey.currentContext!.l10n.binanceIdEmail,
              Icon(Icons.person_outline, size: 24, color: Color(0xFFF3BA2F)),
              RegexHelper.email_or_phone,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.bnb,
            "BNB",
            Assets.cryptoWithdrawIcons.icBnb.svg(width: AppSize.w24),
            Color(0xFFF3BA2F),
            FormData(
              rootNavKey.currentContext!.l10n.bep20Address,
              Icon(Icons.wallet_sharp, size: 24, color: Color(0xFFF3BA2F)),
              RegexHelper.crypto,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.litecoin,
            "Litecoin",
            Assets.cryptoWithdrawIcons.icLitecoin.svg(width: AppSize.w24),
            Color(0xFF345D9D),
            FormData(
              rootNavKey.currentContext!.l10n.ltcWalletAddress,
              Icon(Icons.wallet_sharp, size: 24, color: Color(0xFF345D9D)),
              RegexHelper.crypto,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.tron,
            "Tron (TRX)",
            Assets.cryptoWithdrawIcons.icTron.svg(width: AppSize.w24),
            Color(0xFFFF060A),
            FormData(
              rootNavKey.currentContext!.l10n.trxAddress,
              Icon(Icons.wallet_sharp, size: 24, color: Color(0xFFFF060A)),
              RegexHelper.crypto,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.dogecoin,
            "Dogecoin",
            Assets.cryptoWithdrawIcons.icDogecoin.svg(width: AppSize.w24),
            Color(0xFFC2A633),
            FormData(
              rootNavKey.currentContext!.l10n.dogeAddress,
              Icon(Icons.wallet_sharp, size: 24, color: Color(0xFFC2A633)),
              RegexHelper.crypto,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.shibaInu,
            "Shiba Inu",
            Assets.cryptoWithdrawIcons.icShibainu.svg(width: AppSize.w24),
            Color(0xFFF28C28),
            FormData(
              rootNavKey.currentContext!.l10n.shibAddress,
              Icon(Icons.wallet_sharp, size: 24, color: Color(0xFFF28C28)),
              RegexHelper.crypto,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.solana,
            "Solana",
            Assets.cryptoWithdrawIcons.icSolana.svg(width: AppSize.w24),
            Color(0xFF9945FF),
            FormData(
              rootNavKey.currentContext!.l10n.solAddress,
              Icon(Icons.wallet_sharp, size: 24, color: Color(0xFF9945FF)),
              RegexHelper.crypto,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.ripple,
            "Ripple (XRP)",
            Assets.cryptoWithdrawIcons.icRipple.svg(width: AppSize.w24),
            Color(0xFF23292F),
            FormData(
              rootNavKey.currentContext!.l10n.xrpAddressTag,
              Icon(Icons.wallet_sharp, size: 24, color: Color(0xFF23292F)),
              RegexHelper.crypto_with_tag,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.polygon,
            "Polygon (MATIC)",
            Assets.cryptoWithdrawIcons.icPolygon.svg(width: AppSize.w24),
            Color(0xFF8247E5),
            FormData(
              rootNavKey.currentContext!.l10n.polygonAddress,
              Icon(Icons.wallet_sharp, size: 24, color: Color(0xFF8247E5)),
              RegexHelper.crypto,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.dash,
            "Dash",
            Assets.cryptoWithdrawIcons.icDash.svg(width: AppSize.w24),
            Color(0xFF008CE7),
            FormData(
              rootNavKey.currentContext!.l10n.dashAddress,
              Icon(Icons.wallet_sharp, size: 24, color: Color(0xFF008CE7)),
              RegexHelper.crypto,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.bitcoinCash,
            "Bitcoin Cash",
            Assets.cryptoWithdrawIcons.icBitcoincash.svg(width: AppSize.w24),
            Color(0xFF8DC351),
            FormData(
              rootNavKey.currentContext!.l10n.bchAddress,
              Icon(Icons.wallet_sharp, size: 24, color: Color(0xFF8DC351)),
              RegexHelper.crypto,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.perfectMoney,
            "Perfect Money",
            Icon(Icons.local_parking, size: 24, color: Color(0xFF900600)),
            Color(0xFF900600),
            FormData(
              rootNavKey.currentContext!.l10n.perfectMoneyAccount,
              Icon(Icons.account_balance_wallet_rounded, size: 24, color: Color(0xFF900600)),
              RegexHelper.flexible_id,
            ),
          ),
        ],
      ),

      WalletCategory(
        title: rootNavKey.currentContext!.l10n.giftCards,
        dbTitle: "Gift Cards",
        items: [
          WalletItem(
            rootNavKey.currentContext!.l10n.googlePlay,
            "Google Play",
            Icon(Icons.play_arrow, size: 24, color: Color(0xFF34A853)),
            Color(0xFF34A853),
            FormData(
              rootNavKey.currentContext!.l10n.emailToSendCode,
              Icon(Icons.email, size: 24, color: Color(0xFF34A853)),
              RegexHelper.email,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.appleGiftCard,
            "Apple Gift Card",
            Icon(Icons.apple, size: 24, color: Color(0xFFFFFFFF)),
            Color(0xFFFFFFFF),
            FormData(
              rootNavKey.currentContext!.l10n.emailToSendCode,
              Icon(Icons.email, size: 24, color: Color(0xFFFFFFFF)),
              RegexHelper.email,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.steamWallet,
            "Steam Wallet",
            Assets.giftWithdrawIcons.icSteamwallet.svg(width: AppSize.w24),
            Color(0xFF34A853),
            FormData(
              rootNavKey.currentContext!.l10n.emailToSendCode,
              Icon(Icons.email, size: 24, color: Color(0xFF34A853)),
              RegexHelper.email,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.playstation,
            "PlayStation",
            Assets.giftWithdrawIcons.icPlaystation.svg(width: AppSize.w24),
            Color(0xFFFFFFFF),
            FormData(
              rootNavKey.currentContext!.l10n.emailToSendCode,
              Icon(Icons.email, size: 24, color: Color(0xFFFFFFFF)),
              RegexHelper.email,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.xboxLive,
            "Xbox Live",
            Assets.giftWithdrawIcons.icXboxlive.svg(width: AppSize.w24),
            Color(0xFF1B2838),
            FormData(
              rootNavKey.currentContext!.l10n.emailToSendCode,
              Icon(Icons.email, size: 24, color: Color(0xFF1B2838)),
              RegexHelper.email,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.nintendoEshop,
            "Nintendo eShop",
            Assets.giftWithdrawIcons.icNintendoEshop.svg(width: AppSize.w24),
            Color(0xFF00D1B2),
            FormData(
              rootNavKey.currentContext!.l10n.emailToSendCode,
              Icon(Icons.email, size: 24, color: Color(0xFF00D1B2)),
              RegexHelper.email,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.razerGold,
            "Razer Gold",
            Assets.giftWithdrawIcons.icRazergold.svg(width: AppSize.w24),
            Color(0xFF44D62C),
            FormData(
              rootNavKey.currentContext!.l10n.razerIdEmail,
              Icon(Icons.email, size: 24, color: Color(0xFF44D62C)),
              RegexHelper.email_or_phone,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.amazon,
            "Amazon",
            Assets.giftWithdrawIcons.icAmazon.svg(width: AppSize.w24),
            Color(0xFFFF9900),
            FormData(
              rootNavKey.currentContext!.l10n.emailToSendCode,
              Icon(Icons.email, size: 24, color: Color(0xFFFF9900)),
              RegexHelper.email,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.ebay,
            "eBay",
            Assets.giftWithdrawIcons.icEbay.svg(width: AppSize.w24),
            Color(0xFFE53238),
            FormData(
              rootNavKey.currentContext!.l10n.emailToSendCode,
              Icon(Icons.email, size: 24, color: Color(0xFFE53238)),
              RegexHelper.email,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.walmart,
            "Walmart",
            Assets.giftWithdrawIcons.icWalmart.svg(width: AppSize.w24),
            Color(0xFF0071CE),
            FormData(
              rootNavKey.currentContext!.l10n.emailToSendCode,
              Icon(Icons.email, size: 24, color: Color(0xFF0071CE)),
              RegexHelper.email,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.target,
            "Target",
            Assets.giftWithdrawIcons.icTarget.svg(width: AppSize.w24),
            Color(0xFFCC0000),
            FormData(
              rootNavKey.currentContext!.l10n.emailToSendCode,
              Icon(Icons.email, size: 24, color: Color(0xFFCC0000)),
              RegexHelper.email,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.shien,
            "Shien",
            Assets.giftWithdrawIcons.icShien.svg(width: AppSize.w24),
            Color(0xFFFFFFFF),
            FormData(
              rootNavKey.currentContext!.l10n.emailToSendCode,
              Icon(Icons.email, size: 24, color: Color(0xFFFFFFFF)),
              RegexHelper.email,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.sephora,
            "Sephora",
            Assets.giftWithdrawIcons.icSephora.svg(width: AppSize.w24),
            Color(0xFFFFFFFF),
            FormData(
              rootNavKey.currentContext!.l10n.emailToSendCode,
              Icon(Icons.email, size: 24, color: Color(0xFFFFFFFF)),
              RegexHelper.email,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.nike,
            "Nike",
            Assets.giftWithdrawIcons.icNike.svg(width: AppSize.w24),
            Color(0xFFFFFFFF),
            FormData(
              rootNavKey.currentContext!.l10n.emailToSendCode,
              Icon(Icons.email, size: 24, color: Color(0xFFFFFFFF)),
              RegexHelper.email,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.netflix,
            "Netflix",
            Assets.giftWithdrawIcons.icNetflix.svg(width: AppSize.w24),
            Color(0xFFE50914),
            FormData(
              rootNavKey.currentContext!.l10n.emailToSendCode,
              Icon(Icons.email, size: 24, color: Color(0xFFE50914)),
              RegexHelper.email,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.spotify,
            "Spotify",
            Assets.giftWithdrawIcons.icSpotify.svg(width: AppSize.w24),
            Color(0xFF1DB954),
            FormData(
              rootNavKey.currentContext!.l10n.emailToSendCode,
              Icon(Icons.email, size: 24, color: Color(0xFF1DB954)),
              RegexHelper.email,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.disneyPlus,
            "Disney+",
            Assets.giftWithdrawIcons.icDisney.svg(width: AppSize.w24),
            Color(0xFF113CCF),
            FormData(
              rootNavKey.currentContext!.l10n.emailToSendCode,
              Icon(Icons.email, size: 24, color: Color(0xFF113CCF)),
              RegexHelper.email,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.twitch,
            "Twitch",
            Assets.giftWithdrawIcons.icTwitch.svg(width: AppSize.w24),
            Color(0xFF9146FF),
            FormData(
              rootNavKey.currentContext!.l10n.emailToSendCode,
              Icon(Icons.email, size: 24, color: Color(0xFF9146FF)),
              RegexHelper.email,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.starbucks,
            "Starbucks",
            Assets.giftWithdrawIcons.icStarbucks.svg(width: AppSize.w24),
            Color(0xFF00704A),
            FormData(
              rootNavKey.currentContext!.l10n.emailToSendCode,
              Icon(Icons.email, size: 24, color: Color(0xFF00704A)),
              RegexHelper.email,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.uberEats,
            "Uber / Eats",
            Assets.giftWithdrawIcons.icUbereats.svg(width: AppSize.w24),
            Color(0xFFFFFFFF),
            FormData(
              rootNavKey.currentContext!.l10n.emailToSendCode,
              Icon(Icons.email, size: 24, color: Color(0xFFFFFFFF)),
              RegexHelper.email,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.doordash,
            "DoorDash",
            Assets.giftWithdrawIcons.icDoordash.svg(width: AppSize.w24),
            Color(0xFFFF3008),
            FormData(
              rootNavKey.currentContext!.l10n.emailToSendCode,
              Icon(Icons.email, size: 24, color: Color(0xFFFF3008)),
              RegexHelper.email,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.visaPrepaid,
            "Visa Prepaid",
            Assets.giftWithdrawIcons.icVisaprepaid.svg(width: AppSize.w24),
            Color(0xFF1A1F71),
            FormData(
              rootNavKey.currentContext!.l10n.emailToSendCode,
              Icon(Icons.email, size: 24, color: Color(0xFF1A1F71)),
              RegexHelper.email,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.mastercard,
            "Mastercard",
            Assets.giftWithdrawIcons.icMastercard.svg(width: AppSize.w24),
            Color(0xFFF79E1B),
            FormData(
              rootNavKey.currentContext!.l10n.emailToSendCode,
              Icon(Icons.email, size: 24, color: Color(0xFFF79E1B)),
              RegexHelper.email,
            ),
          ),
        ],
      ),

      WalletCategory(
        title: rootNavKey.currentContext!.l10n.game_credits,
        dbTitle: "Game Credits",
        items: [
          WalletItem(
            rootNavKey.currentContext!.l10n.freeFire,
            "Free Fire",
            Assets.gameWithdrawIcons.icFreefire.svg(width: AppSize.w24),
            Color(0xFFF5A623),
            FormData(
              rootNavKey.currentContext!.l10n.playerIdUid,
              Icon(Icons.videogame_asset_rounded, size: 24, color: Color(0xFFF79E1B)),
              RegexHelper.uid,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.pubgMobile,
            "PUBG Mobile",
            Assets.gameWithdrawIcons.icPubgmobile.svg(width: AppSize.w24),
            Color(0xFFF2A900),
            FormData(
              rootNavKey.currentContext!.l10n.characterId,
              Icon(Icons.videogame_asset_rounded, size: 24, color: Color(0xFFF79E1B)),
              RegexHelper.uid,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.codMobile,
            "CoD Mobile",
            Assets.gameWithdrawIcons.icCodmobile.svg(width: AppSize.w24),
            Color(0xFFC4C4C4),
            FormData(
              rootNavKey.currentContext!.l10n.playerIdUid,
              Icon(Icons.videogame_asset_rounded, size: 24, color: Color(0xFFC4C4C4)),
              RegexHelper.uid,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.fortnite,
            "Fortnite",
            Assets.gameWithdrawIcons.icFortnite.svg(width: AppSize.w24),
            Color(0xFF9146FF),
            FormData(
              rootNavKey.currentContext!.l10n.epicGamesUsername,
              Icon(Icons.person, size: 24, color: Color(0xFF9146FF)),
              RegexHelper.ea_id,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.apexLegends,
            "Apex Legends",
            Assets.gameWithdrawIcons.icApexLegends.svg(width: AppSize.w24),
            Color(0xFFFF2D2D),
            FormData(
              rootNavKey.currentContext!.l10n.eaIdUsername,
              Icon(Icons.person, size: 24, color: Color(0xFFFF2D2D)),
              RegexHelper.ea_id,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.mobileLegends,
            "Mobile Legends",
            Assets.gameWithdrawIcons.icMobilelegends.svg(width: AppSize.w24),
            Color(0xFF00BFFF),
            FormData(
              rootNavKey.currentContext!.l10n.userIdZoneId,
              Icon(Icons.videogame_asset_rounded, size: 24, color: Color(0xFF00BFFF)),
              RegexHelper.uid_zone,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.leagueOfLegends,
            "League of Legends",
            Assets.gameWithdrawIcons.icLeagueoflegends.svg(width: AppSize.w24),
            Color(0xFFC89B3C),
            FormData(
              rootNavKey.currentContext!.l10n.riotIdNameTag,
              Icon(Icons.videogame_asset_rounded, size: 24, color: Color(0xFFC89B3C)),
              RegexHelper.riot_id,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.brawlStars,
            "Brawl Stars",
            Assets.gameWithdrawIcons.icBrawlstars.svg(width: AppSize.w24),
            Color(0xFFFFD700),
            FormData(
              rootNavKey.currentContext!.l10n.playerTag,
              Icon(Icons.tag, size: 24, color: Color(0xFFFFD700)),
              RegexHelper.game_tag,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.valorant,
            "Valorant",
            Assets.gameWithdrawIcons.icValorant.svg(width: AppSize.w24),
            Color(0xFFFF4655),
            FormData(
              rootNavKey.currentContext!.l10n.riotIdNameTag,
              Icon(Icons.person, size: 24, color: Color(0xFFFF4655)),
              RegexHelper.riot_id,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.genshinImpact,
            "Genshin Impact",
            Assets.gameWithdrawIcons.icGenshinimpact.svg(width: AppSize.w24),
            Color(0xFFF28C28),
            FormData(
              rootNavKey.currentContext!.l10n.userIdServer,
              Icon(Icons.videogame_asset_rounded, size: 24, color: Color(0xFFF28C28)),
              RegexHelper.uid_zone,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.robux,
            "Robux",
            Assets.gameWithdrawIcons.icRobux.svg(width: AppSize.w24),
            Color(0xFF00A2FF),
            FormData(
              rootNavKey.currentContext!.l10n.robloxUsername,
              Icon(Icons.person, size: 24, color: Color(0xFF00A2FF)),
              RegexHelper.ea_id,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.minecraft,
            "Minecraft",
            Assets.gameWithdrawIcons.icMinecraft.svg(width: AppSize.w24),
            Color(0xFF5C8A3E),
            FormData(
              rootNavKey.currentContext!.l10n.xboxGamertagEmail,
              Icon(Icons.mail, size: 24, color: Color(0xFF5C8A3E)),
              RegexHelper.email_or_phone,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.clashOfClans,
            "Clash of Clans",
            Assets.gameWithdrawIcons.icClashofclans.svg(width: AppSize.w24),
            Color(0xFFD4AF37),
            FormData(
              rootNavKey.currentContext!.l10n.playerTag,
              Icon(Icons.tag, size: 24, color: Color(0xFFFFD700)),
              RegexHelper.game_tag,
            ),
          ),
          WalletItem(
            rootNavKey.currentContext!.l10n.eaFc,
            "EA FC",
            Assets.gameWithdrawIcons.icEafc.svg(width: AppSize.w24),
            Color(0xFF444444),
            FormData(
              rootNavKey.currentContext!.l10n.eaIdPsnXbox,
              Icon(Icons.videogame_asset_rounded, size: 24, color: Color(0xFF444444)),
              RegexHelper.ea_id,
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

    final result = amount / RemoteConfigService.instance.coinToDollarDivider; // 👈 your logic
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

      final minAmount = RemoteConfigService.instance.minWithdrawAmount;
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
