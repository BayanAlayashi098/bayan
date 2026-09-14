class Validators {
  static String? url(String? value) {
    if (value == null || value.trim().isEmpty) return 'Enter a URL';

    final text = value.trim();
    final uri = Uri.tryParse(
      text.startsWith('http://') || text.startsWith('https://')
          ? text
          : 'https://$text',
    );

    if (uri == null || uri.host.isEmpty) return 'Enter a valid URL';
    return null;
  }
}
