/// API Endpoints constants
class ApiEndpoints {
  ApiEndpoints._(); // Private constructor to prevent instantiation

  // Base API version
  static const String v1 = '/v1';

  // Events endpoints
  static const String events = '$v1/events';
  static String eventById(String id) => '$v1/events/$id';
  static String joinEvent(String eventId) => '/v1/events/$eventId/joinEvent';
  static String cancelEvent(String eventId) => '/v1/events/$eventId/cancel';
  static String memberStatus(String eventId) =>
      '$v1/events/$eventId/member-status';
  static String eventResults(String eventId) => '$v1/events/$eventId/results';

  // Community endpoints
  static const String communities = '$v1/communities';
  static String communityById(String id) => '$communities/$id';
  static String leaveCommunity(String id) => '$communities/$id/leave';
  static String joinCommunity(String id) => '$communities/$id/join';
  static String communityMemberStatus(String id) =>
      '$v1/communities/$id/member-status';

  static const String tracks = '$v1/tracks';
  static String trackRelatedEvents(String trackId) =>
      '$v1/tracks/$trackId/events/results';
  static String trackRelatedCommunities(String trackId) =>
      '$v1/tracks/$trackId/communities/results';
  static String trackById(String id) => '$v1/tracks/$id';

  // Authentication endpoints
  static const String auth = '$v1/auth';
  static const String authMe = '$auth/me';
  static const String authMeStats = '$auth/me/stats';
  static const String authMePerformanceInsights =
      '$auth/me/performance-insights';
  static const String authMeActiveParticipations =
      '$auth/me/active-participations';
  static const String authMeCompletedEvents = '$auth/me/completed-events';
  static const String authVerify = '$auth/verify';
  static const String authRegister = '$auth/register';
  static const String authLogout = '$auth/logout';
  static const String deleteAccount = '$auth/delete-account';
  static const String guestLogin = '$auth/guestLogin';

  // Challenges
  static const String challenges = '$v1/challenges';
  static String challengeById(String id) => '$challenges/$id';

  // Store
  static const String storeItems = '$v1/ar/items';
  static String storeItemById(String id) => '$storeItems/$id';

  // Content settings (onboarding/home banners)
  static const String settingsContentList = '$v1/settings/content/list';

  // User notifications
  static const String pushNotificationsInbox = '$v1/push-notifications/inbox';
  static const String pushNotificationsReadAll =
      '$pushNotificationsInbox/read-all';
  static String pushNotificationRead(String id) =>
      '$pushNotificationsInbox/$id/read';
  static String pushNotificationDelete(String id) =>
      '$pushNotificationsInbox/$id';

  // Community posts
  static String communityPosts(String communityId) =>
      '$communities/$communityId/community-posts';
  static String communityPostById(String communityId, String id) =>
      '${communityPosts(communityId)}/$id';

  // Feed posts
  static const String feed = '$v1/feed';
  static const String feedMyPosts = '$feed/my-posts';
  static String feedLike(String id) => '$feed/$id/like';
  static String feedComments(String id) => '$feed/$id/comments';
  static String feedCommentById(String id, String commentId) =>
      '$feed/$id/comments/$commentId';
  static const String feedPosts = feed;
  static String feedPostById(String id) => '$feedPosts/$id';
}
