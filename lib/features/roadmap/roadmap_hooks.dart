/// Roadmap Hooks & Extension Points for Umeed
/// These stubs establish the interfaces and architecture for future expansion.

abstract class FamilyModeHook {
  /// Allows checking and aggregating schemes for multiple household members in one session
  Future<void> addFamilyMember({required String name, required String relation, required int age});
}

abstract class TollFreeIVRHook {
  /// Interface to hook telephony IVR gateways (e.g. Exotel, Twilio Indic IVR)
  /// allowing users without smartphones to complete intake over a regular phone call
  Future<void> handleIncomingPhoneCall({required String callerNumber, required String audioStreamUrl});
}

abstract class CommunityPartnerHook {
  /// "Help someone else" mode enabling Gram Panchayats, CSC operators, and volunteers
  /// to run intake sessions on behalf of community members
  Future<void> registerPartnerSession({required String operatorId, required String villageCode});
}

abstract class SmsVoiceReminderHook {
  /// Scheduled voice calls and SMS alerts for upcoming scheme application deadlines
  Future<void> scheduleDeadlineAlert({required String phoneNumber, required String schemeName, required DateTime deadline});
}
