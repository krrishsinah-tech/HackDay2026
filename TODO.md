# Umeed (उम्मीद) - Implementation Checklist & Production Readiness (TODO.md)

This document tracks all external integrations, real data feeds, API credentials, and native-speaker translation reviews required before moving Umeed to production.

---

## 1. Native-Speaker Linguistic Review (20 Locales)
Full production-ready human translation is currently completed for **English (`en`)**, **Hindi (`hi`)**, and **Marathi (`mr`)**. The remaining 20 Scheduled Languages have full key parity in `/assets/l10n/*.json` with fallback chains, but require native-speaker verification:

- [ ] **Assamese (`as`)**: Native review for civic terms (Gram Panchayat, Patta, DBT).
- [ ] **Bengali (`bn`)**: Native review for West Bengal / Tripura administrative terms.
- [ ] **Bodo (`brx`)**: Native review in Devanagari script for Bodoland territorial areas.
- [ ] **Dogri (`doi`)**: Native review for Jammu & Kashmir region phrasing.
- [ ] **Gujarati (`gu`)**: Review for revenue terminology (7/12 extract / Satbara).
- [ ] **Kannada (`kn`)**: Native review for Karnataka revenue / welfare terms.
- [ ] **Kashmiri (`ks`)**: Perso-Arabic script review, RTL alignment, and Kashmiri vowel diacritics.
- [ ] **Konkani (`kok`)**: Goa & Coastal Karnataka phrasing review.
- [ ] **Maithili (`mai`)**: Devanagari script review for Bihar / Mithila region.
- [ ] **Malayalam (`ml`)**: Kerala administrative terms & complex ligature rendering check.
- [ ] **Manipuri / Meitei (`mni`)**: Review Meitei Mayek script glyph compatibility on target devices.
- [ ] **Nepali (`ne`)**: Review for Sikkim and North Bengal civic vocabulary.
- [ ] **Odia (`or`)**: Review for Odisha panchayat & revenue terminology.
- [ ] **Punjabi (`pa`)**: Gurmukhi script review for agricultural terms.
- [ ] **Sanskrit (`sa`)**: Classical orthography & conjunct rendering review.
- [ ] **Santali (`sat`)**: Review Ol Chiki script rendering on Android/iOS font stacks.
- [ ] **Sindhi (`sd`)**: Perso-Arabic extended alphabet review (52 characters) & RTL layout.
- [ ] **Tamil (`ta`)**: Tamil Nadu state welfare & revenue terms review.
- [ ] **Telugu (`te`)**: Andhra Pradesh & Telangana civic welfare terminology review.
- [ ] **Urdu (`ur`)**: Nastaliq font rendering, RTL alignment, and Urdu civic terms review.

---

## 2. Real API Credentials & Service Integrations

### Bhashini (National Language Translation Mission - MeitY)
The application currently runs on a high-fidelity `MockBhashiniService` simulating live ASR waveforms, audio synthesis, and simplification. To switch to live Government of India Bhashini APIs:
- [ ] Sign up at [Bhashini ULCA Portal](https://bhashini.gov.in/ulca) or Dhruva API gateway.
- [ ] Obtain:
  - `BHASHINI_USER_ID`: Authorized user ID from MeitY.
  - `BHASHINI_ULCA_API_KEY`: ULCA pipeline authorization key.
  - `BHASHINI_INFERENCE_API_KEY`: Compute pipeline token.
- [ ] Configure `BhashiniServiceImpl` endpoints:
  - Pipeline Discovery: `POST https://dhruva-api.bhashini.gov.in/services/inference/pipeline`
  - Compute ASR: 16kHz Mono WAV base64 audio payload.
  - Compute NMT: Source to target ISO-639 codes.
  - Compute TTS: Audio output format (MP3/WAV).

### Firebase / Supabase Backend
- [ ] **Authentication**: Phone Number SMS OTP integration (e.g., Firebase Auth or Twilio).
- [ ] **Database**: Cloud Firestore / PostgreSQL tables for `users`, `profiles`, `submissions`, and `schemes`.
- [ ] **Audio Storage**: Encrypted cloud bucket for user voice recordings with strict 30-day lifecycle auto-delete rule.
- [ ] **Cloud Functions / Workers**:
  - Cron trigger for daily queue balancing & next-day slot assignment.
  - Push notification triggers when helper marks ticket as completed.

### Scheme Data Sync (myScheme / Ministry Webhooks)
Mock schemes in `assets/data/mock_schemes.json` are marked with `"mock": true`.
- [ ] Replace mock schemes with official API sync from [myScheme Open Data / API](https://www.myscheme.gov.in) or automated RSS/scraper pipeline.
- [ ] Set up scheduled nightly refresh worker to update the `last_checked` field.
- [ ] Verify actual state-level income criteria, subsidy brackets, and required document variations across state governments.

---

## 3. Production Hardening & Compliance
- [ ] **Legal & Compliance**: Finalize Terms of Service and Privacy Policy ensuring compliance with India's **Digital Personal Data Protection (DPDP) Act 2023**.
- [ ] **Audio Encryption**: Implement AES-256 client-side encryption for voice recordings before upload.
- [ ] **Accessibility (A11y)**: Test screen reader focus traversal on actual Android devices with TalkBack and iOS devices with VoiceOver across Indic scripts.
- [ ] **Offline Sync**: Verify SQLite caching for full offline dashboard availability in low-connectivity rural belts.
