const String kDefaultGuestName = 'លោក-ទេពសត្យា';

String displayGuestName(String? guestName) {
  final normalized = guestName?.trim();
  if (normalized == null || normalized.isEmpty) {
    return kDefaultGuestName;
  }
  return normalized;
}

String guestNameBannerAsset(String? guestName) {
  final normalized = displayGuestName(guestName);
  return normalized == kDefaultGuestName
      ? 'assets/images/boder.png'
      : 'assets/images/border_name_re.png';
}
