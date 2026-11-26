import '../../../Core/Constants/Enums/alert_enums.dart';
import '../../../Core/Utils/external_link.dart';
import '../Alert/app_toast.dart';
import 'run_action.dart';

Future<void> openLinkOrCopy(String url, String copiedMessage) async {
  if (!await openExternalLink(url)) {
    AppToast.show(copiedMessage, tone: UiAlertTone.info);
  }
}

Future<void> openDownload(
  Future<String?> Function() resolve, {
  required String missingMessage,
  required String copiedMessage,
  required String failure,
}) => runAction(() async {
  final url = await resolve();
  if (url == null || url.isEmpty) {
    AppToast.show(missingMessage, tone: UiAlertTone.warning);
    return;
  }
  await openLinkOrCopy(url, copiedMessage);
}, failure: failure);
