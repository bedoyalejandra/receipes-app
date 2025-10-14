String formatDateTime(DateTime date) {
  final now = DateTime.now();
  final diff = now.difference(date);

  if (diff.inDays == 0) {
    return 'Today';
  } else if (diff.inDays == 1) {
    return 'Yesterday';
  } else if (diff.inDays < 7) {
    return '${diff.inDays} days ago';
  } else if (diff.inDays < 30) {
    final weeks = diff.inDays ~/ 7;
    return weeks == 1 ? '1 week ago' : '${weeks} weeks ago';
  } else if (diff.inDays < 365) {
    final months = diff.inDays ~/ 30;
    return months == 1 ? '1 month ago' : '${months} months ago';
  } else {
    final years = diff.inDays ~/ 365;
    return years == 1 ? '1 year ago' : '${years} years ago';
  }
}
