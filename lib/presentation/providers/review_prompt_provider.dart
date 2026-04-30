import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _successfulCalculationsKey = 'review_successful_calculations';
const _resultEngagementKey = 'review_result_engagement';
const _lastReviewRequestKey = 'review_last_request_at';
const _lastErrorAtKey = 'review_last_error_at';

final reviewPromptControllerProvider = Provider<ReviewPromptController>((ref) {
  return ReviewPromptController(InAppReview.instance);
});

class ReviewPromptController {
  ReviewPromptController(this._inAppReview);

  final InAppReview _inAppReview;

  Future<void> recordSuccessfulCalculation() async {
    final preferences = await SharedPreferences.getInstance();
    final count = preferences.getInt(_successfulCalculationsKey) ?? 0;
    await preferences.setInt(_successfulCalculationsKey, count + 1);
    await _maybeRequestReview(preferences);
  }

  Future<void> recordResultEngagement() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_resultEngagementKey, true);
    await _maybeRequestReview(preferences);
  }

  Future<void> markError() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt(
      _lastErrorAtKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<void> requestReviewNow() async {
    if (await _inAppReview.isAvailable()) {
      await _inAppReview.requestReview();
    }
  }

  Future<void> _maybeRequestReview(SharedPreferences preferences) async {
    final count = preferences.getInt(_successfulCalculationsKey) ?? 0;
    final engaged = preferences.getBool(_resultEngagementKey) ?? false;
    final lastRequest = preferences.getInt(_lastReviewRequestKey);
    final lastError = preferences.getInt(_lastErrorAtKey);
    final now = DateTime.now();

    if (count < 5 || !engaged) {
      return;
    }

    if (lastRequest != null &&
        now
                .difference(DateTime.fromMillisecondsSinceEpoch(lastRequest))
                .inDays <
            90) {
      return;
    }

    if (lastError != null &&
        now.difference(DateTime.fromMillisecondsSinceEpoch(lastError)).inDays <
            7) {
      return;
    }

    if (!await _inAppReview.isAvailable()) {
      return;
    }

    await _inAppReview.requestReview();
    await preferences.setInt(_lastReviewRequestKey, now.millisecondsSinceEpoch);
    await preferences.setInt(_successfulCalculationsKey, 0);
    await preferences.setBool(_resultEngagementKey, false);
  }
}
