import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:golden_price/core/constants/cons.dart';
import 'package:golden_price/core/routes/app_route.dart';

/// Gets past the Cloudflare Turnstile challenge on endpoints like idx.co.id.
///
/// The user solves the challenge once in a visible WebView; the resulting
/// `cf_clearance` cookie is saved and sent by Dio afterwards. The clearance
/// is bound to the user agent, so Dio must always send [userAgent].
class CloudflareSession {
  static const userAgent =
      'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 '
      '(KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36';

  static const _cookieKey = 'cf_cookie';

  static Future<dynamic>? _pending;

  /// Headers to attach to Dio requests for the protected host.
  static Map<String, String> headers() {
    final cookie = log.getString(_cookieKey);
    return {
      'User-Agent': userAgent,
      if (cookie != null && cookie.isNotEmpty) 'Cookie': cookie,
    };
  }

  /// Opens [url] in a WebView so the user can solve the challenge.
  /// Returns the decoded JSON body, or null if the user closed the page.
  static Future<dynamic> solve(String url) {
    // Several widgets may hit the 403 at once; show only one page.
    return _pending ??= _push(url).whenComplete(() => _pending = null);
  }

  static Future<dynamic> _push(String url) async {
    final navigator = Go.navigatorKey.currentState;
    if (navigator == null) return null;
    final data = await showDialog<dynamic>(
      context: navigator.context,
      barrierDismissible: false,
      builder: (_) => _ChallengeDialog(url: url),
    );
    if (data != null) await _saveCookies(url);
    return data;
  }

  static Future<void> _saveCookies(String url) async {
    final cookies = await CookieManager.instance().getCookies(url: WebUri(url));
    final header = cookies.map((c) => '${c.name}=${c.value}').join('; ');
    await log.setString(_cookieKey, header);
  }
}

class _ChallengeDialog extends StatefulWidget {
  const _ChallengeDialog({required this.url});

  final String url;

  @override
  State<_ChallengeDialog> createState() => _ChallengeDialogState();
}

class _ChallengeDialogState extends State<_ChallengeDialog> {
  Timer? _poller;
  bool _done = false;

  @override
  void dispose() {
    _poller?.cancel();
    super.dispose();
  }

  void _startPolling(InAppWebViewController controller) {
    // The challenge page reloads itself once solved, so keep polling
    // until the body parses as JSON.
    _poller ??= Timer.periodic(const Duration(milliseconds: 500), (_) async {
      if (_done) return;
      try {
        final body = await controller.evaluateJavascript(
          source: 'document.body ? document.body.innerText : ""',
        );
        if (body is! String) return;
        final trimmed = body.trim();
        if (!trimmed.startsWith('[') && !trimmed.startsWith('{')) return;
        final data = jsonDecode(trimmed);
        _done = true;
        if (mounted) Navigator.of(context).pop(data);
      } catch (_) {
        // Page is navigating or body is not JSON yet; try again.
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      clipBehavior: Clip.antiAlias,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: SizedBox(
        height: 480,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 4, 4),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Verifikasi IDX',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: InAppWebView(
                initialUrlRequest: URLRequest(url: WebUri(widget.url)),
                initialSettings: InAppWebViewSettings(
                  javaScriptEnabled: true,
                  // Look like regular mobile Chrome instead of an embedded
                  // WebView: no "; wv" in the UA and no
                  // X-Requested-With: <package> header.
                  userAgent: CloudflareSession.userAgent,
                  requestedWithHeaderOriginAllowList: {},
                ),
                onLoadStop: (controller, _) => _startPolling(controller),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
