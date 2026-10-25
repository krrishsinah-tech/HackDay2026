import json
import os

l10n_file = '/Users/jeetganguly/Documents/Notes/To Do/umeed/web/l10n_bundle.json'
with open(l10n_file, 'r', encoding='utf-8') as f:
    l10n_bundle = json.load(f)

schemes_file = '/Users/jeetganguly/Documents/Notes/To Do/umeed/assets/data/mock_schemes.json'
with open(schemes_file, 'r', encoding='utf-8') as f:
    mock_schemes = json.load(f)

# Serialize data for JavaScript injection
l10n_js = json.dumps(l10n_bundle, ensure_ascii=False)
schemes_js = json.dumps(mock_schemes, ensure_ascii=False)

audio_file = '/Users/jeetganguly/Documents/Notes/To Do/umeed/web/audio/embedded_audio.json'
embedded_audio = {}
if os.path.exists(audio_file):
    with open(audio_file, 'r', encoding='utf-8') as f:
        embedded_audio = json.load(f)
embedded_audio_js = json.dumps(embedded_audio, ensure_ascii=False)

# Aesthetic SVG Icon (large and small)
svg_icon_large = '''<svg viewBox="0 0 100 100" fill="none" xmlns="http://www.w3.org/2000/svg" class="w-full h-full drop-shadow-2xl">
  <defs>
    <linearGradient id="umeedGrad" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#FF9E3B"/>
      <stop offset="45%" stop-color="#F28C28"/>
      <stop offset="100%" stop-color="#C85A00"/>
    </linearGradient>
    <radialGradient id="sunGlow" cx="50%" cy="50%" r="50%">
      <stop offset="0%" stop-color="#FFF3B0" stop-opacity="0.9"/>
      <stop offset="60%" stop-color="#FFAE42" stop-opacity="0.35"/>
      <stop offset="100%" stop-color="#F28C28" stop-opacity="0"/>
    </radialGradient>
    <linearGradient id="goldShine" x1="0%" y1="0%" x2="100%" y2="0%">
      <stop offset="0%" stop-color="#FFE082"/>
      <stop offset="50%" stop-color="#FFF9C4"/>
      <stop offset="100%" stop-color="#FFD54F"/>
    </linearGradient>
  </defs>
  <!-- Background Squircle with Saffron-Gold Gradient -->
  <rect x="2" y="2" width="96" height="96" rx="28" fill="url(#umeedGrad)"/>
  <rect x="2" y="2" width="96" height="96" rx="28" stroke="rgba(255,255,255,0.45)" stroke-width="2.5"/>
  <rect x="5.5" y="5.5" width="89" height="89" rx="25" stroke="#FFE082" stroke-opacity="0.35" stroke-width="1"/>
  
  <!-- Ambient Sunburst Glow -->
  <circle cx="50" cy="50" r="34" fill="url(#sunGlow)"/>

  <!-- Diya / Lotus Base of Hope -->
  <path d="M 26 69 Q 50 83 74 69 Q 50 75 26 69 Z" fill="url(#goldShine)" filter="drop-shadow(0 2px 4px rgba(0,0,0,0.15))"/>

  <!-- Devanagari 'उ' Calligraphic Letter with Crisp White Form -->
  <!-- Top Shirorekha Bar -->
  <path d="M 31 23 C 31 21.5, 32.5 20, 34 20 L 66 20 C 67.5 20, 69 21.5, 69 23 C 69 24.5, 67.5 26, 66 26 L 34 26 C 32.5 26, 31 24.5, 31 23 Z" fill="#FFFFFF"/>
  <!-- Upper Loop -->
  <path d="M 35 26 C 46 25, 62 27, 62 38 C 62 45, 54 47.5, 45 47.5" stroke="#FFFFFF" stroke-width="7.5" stroke-linecap="round" fill="none"/>
  <!-- Lower Sweep Loop extending forward -->
  <path d="M 45 47.5 C 58 47.5, 66 51, 66 62 C 66 73, 49 77, 31 71" stroke="#FFFFFF" stroke-width="7.5" stroke-linecap="round" fill="none"/>

  <!-- Radiant Hope Spark / Star at Top-Right -->
  <path d="M 72 17 Q 75 11 78 17 Q 84 20 78 23 Q 75 29 72 23 Q 66 20 72 17 Z" fill="#FFF9C4" filter="drop-shadow(0 0 4px rgba(255,255,255,0.9))"/>
  <circle cx="75" cy="20" r="2" fill="#FFFFFF"/>
</svg>'''

svg_icon_small = '''<svg viewBox="0 0 100 100" fill="none" xmlns="http://www.w3.org/2000/svg" class="w-full h-full">
  <defs>
    <linearGradient id="umeedGradSm" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#FF9E3B"/>
      <stop offset="50%" stop-color="#F28C28"/>
      <stop offset="100%" stop-color="#C85A00"/>
    </linearGradient>
  </defs>
  <rect x="2" y="2" width="96" height="96" rx="28" fill="url(#umeedGradSm)"/>
  <rect x="2" y="2" width="96" height="96" rx="28" stroke="rgba(255,255,255,0.4)" stroke-width="2.5"/>
  <path d="M 28 69 Q 50 82 72 69 Q 50 74 28 69 Z" fill="#FFE082"/>
  <path d="M 31 23 C 31 21.5, 32.5 20, 34 20 L 66 20 C 67.5 20, 69 21.5, 69 23 C 69 24.5, 67.5 26, 66 26 L 34 26 C 32.5 26, 31 24.5, 31 23 Z" fill="#FFFFFF"/>
  <path d="M 35 26 C 46 25, 62 27, 62 38 C 62 45, 54 47.5, 45 47.5" stroke="#FFFFFF" stroke-width="7.5" stroke-linecap="round" fill="none"/>
  <path d="M 45 47.5 C 58 47.5, 66 51, 66 62 C 66 73, 49 77, 31 71" stroke="#FFFFFF" stroke-width="7.5" stroke-linecap="round" fill="none"/>
  <path d="M 72 17 Q 75 11 78 17 Q 84 20 78 23 Q 75 29 72 23 Q 66 20 72 17 Z" fill="#FFF9C4"/>
</svg>'''

html_content = f'''<!DOCTYPE html>
<html lang="hi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Umeed (उम्मीद) · आपकी उम्मीद, हमारी ज़िम्मेदारी</title>
  <script src="https://www.gstatic.com/antigravity/web/dev/tailwindcss.min.js"></script>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Domine:wght@600;700;800&family=Nunito+Sans:wght@400;600;700;800;900&display=swap" rel="stylesheet">
  <style>
    body {{
      font-family: 'Nunito Sans', sans-serif;
      background: linear-gradient(135deg, #FAF6EE 0%, #F5EEDC 100%);
      color: #12263A;
      min-height: 100vh;
    }}
    h1, h2, h3, .font-heading {{
      font-family: 'Domine', serif;
    }}
    .pulse-glow {{
      box-shadow: 0 0 25px rgba(242, 140, 40, 0.5);
      animation: pulse-glow-kf 2s infinite ease-in-out;
    }}
    @keyframes pulse-glow-kf {{
      0%, 100% {{ transform: scale(1); box-shadow: 0 0 20px rgba(242, 140, 40, 0.4); }}
      50% {{ transform: scale(1.06); box-shadow: 0 0 32px rgba(242, 140, 40, 0.7); }}
    }}
    .wave-bar {{
      transition: height 0.15s ease-in-out;
    }}
    .glass-card {{
      background: rgba(255, 255, 255, 0.94);
      backdrop-filter: blur(12px);
      border: 1px solid rgba(226, 221, 211, 0.9);
    }}
    .slide-up {{
      animation: slideUp 0.3s cubic-bezier(0.16, 1, 0.3, 1) forwards;
    }}
    @keyframes slideUp {{
      from {{ transform: translateY(16px); opacity: 0; }}
      to {{ transform: translateY(0); opacity: 1; }}
    }}
    .pop-in {{
      animation: popIn 0.3s cubic-bezier(0.34, 1.56, 0.64, 1) forwards;
    }}
    @keyframes popIn {{
      from {{ transform: scale(0.92); opacity: 0; }}
      to {{ transform: scale(1); opacity: 1; }}
    }}
    /* Custom scrollbar */
    ::-webkit-scrollbar {{
      width: 6px;
      height: 6px;
    }}
    ::-webkit-scrollbar-track {{
      background: #FAF6EE;
    }}
    ::-webkit-scrollbar-thumb {{
      background: #D4CBBB;
      border-radius: 4px;
    }}
    ::-webkit-scrollbar-thumb:hover {{
      background: #F28C28;
    }}
  </style>
</head>
<body class="p-2 sm:p-4 md:p-6 flex items-center justify-center min-h-screen">

  <!-- Main Mobile-First Application Container (Max width 420px) -->
  <div class="w-full max-w-md mx-auto bg-white rounded-[32px] shadow-2xl overflow-hidden border-2 border-[#E2DDD3] min-h-[780px] flex flex-col relative">

    <!-- Live Voice Audio Indicator Toast (Appears when voice is speaking) -->
    <div id="voice-speaking-toast" class="hidden absolute top-14 left-4 right-4 bg-[#0B1830] text-white px-4 py-2.5 rounded-2xl shadow-2xl z-30 flex items-center justify-between border-2 border-[#F28C28] pop-in">
      <div class="flex items-center space-x-2 text-xs font-bold">
        <span class="w-2.5 h-2.5 rounded-full bg-[#F28C28] animate-ping"></span>
        <span id="voice-toast-text">आवाज़ सुनाई दे रही है... (Voice Playing)</span>
      </div>
      <button onclick="stopVoice()" class="text-xs bg-red-600 hover:bg-red-700 text-white font-bold px-2.5 py-1 rounded-lg">
        रोकें (Stop)
      </button>
    </div>

    <!-- Top App Header with Aesthetic Emblem -->
    <header class="bg-gradient-to-r from-[#0B1830] via-[#12263A] to-[#0B1830] text-[#FAF6EE] px-4 py-3 flex items-center justify-between shadow-md z-20">
      <div class="flex items-center space-x-2.5 cursor-pointer" onclick="navigateTo('screen-welcome')" title="Umeed Home">
        <!-- Modern Aesthetic Umeed Emblem -->
        <div class="w-10 h-10 shrink-0">
          {svg_icon_small}
        </div>
        <div>
          <div class="font-heading font-bold text-base leading-tight flex items-center space-x-1.5">
            <span class="tracking-wide">Umeed</span>
            <span class="text-[#F28C28]">·</span>
            <span class="text-sm font-normal text-white/90">उम्मीद</span>
          </div>
          <div class="text-[10px] text-[#F28C28] font-bold tracking-wider uppercase">आपकी उम्मीद, हमारी ज़िम्मेदारी</div>
        </div>
      </div>
      <div class="flex items-center space-x-1.5">
        <button onclick="navigateTo('screen-language')" class="p-2 rounded-xl bg-white/10 hover:bg-[#F28C28] text-white transition text-xs font-bold flex items-center space-x-1" title="Change Language">
          <span>🌐</span>
          <span class="hidden sm:inline">भाषा</span>
        </button>
        <button onclick="toggleAllScreensDrawer()" class="p-2 rounded-xl bg-white/10 hover:bg-[#F28C28] text-white transition text-xs font-bold flex items-center space-x-1" title="All Screens Menu">
          <span>≡</span>
          <span class="hidden sm:inline">Menu</span>
        </button>
        <button onclick="navigateTo('screen-settings')" class="p-2 rounded-xl bg-white/10 hover:bg-[#F28C28] text-white transition text-xs" title="Settings">
          ⚙️
        </button>
      </div>
    </header>

    <!-- Global Persistent Home Navigation Bar (Visible on all screens except Welcome) -->
    <div id="home-breadcrumb-bar" class="hidden bg-[#FAF6EE] border-b border-[#E2DDD3] px-4 py-2 flex items-center justify-between text-xs font-bold z-10">
      <button onclick="navigateTo('screen-welcome')" class="text-[#F28C28] hover:text-[#0B1830] flex items-center space-x-1 transition font-bold" id="btn-global-back-home">
        <span>🏠</span>
        <span id="label-back-home">← Back to Home</span>
      </button>
      <div class="flex items-center space-x-1.5">
        <button onclick="stopVoice()" class="bg-red-50 border border-red-200 text-red-600 hover:bg-red-600 hover:text-white px-2 py-0.5 rounded-full text-[10px] font-bold transition flex items-center space-x-0.5" title="Switch off voice">
          <span>⏹️</span>
          <span>Mute Voice</span>
        </button>
        <span id="current-language-pill" onclick="navigateTo('screen-language')" class="cursor-pointer bg-white border border-[#E2DDD3] px-2.5 py-0.5 rounded-full text-[#0B1830] font-semibold text-[11px] hover:border-[#F28C28]">
          हिन्दी (Hindi)
        </span>
        <span id="label-mode-indicator" onclick="toggleModeSwitch()" class="cursor-pointer bg-[#0B1830] text-white px-2 py-0.5 rounded-full text-[10px] font-bold">
          🎤 Voice
        </span>
      </div>
    </div>

    <!-- Application Body Screens Container -->
    <main class="flex-1 flex flex-col p-4 sm:p-5 bg-[#FAF6EE] overflow-y-auto relative">

      <!-- ========================================== -->
      <!-- SCREEN 1: WELCOME SCREEN (Easy, Aesthetic, Eye-Grabbing, No Clutter) -->
      <!-- ========================================== -->
      <section id="screen-welcome" class="app-screen flex-1 flex flex-col justify-between py-2 slide-up">
        
        <!-- Centerpiece Eye-Grabbing Hero with Aesthetic Umeed Icon -->
        <div class="text-center my-auto">
          <!-- Aesthetic Pulsing Umeed Emblem with Warm Aura -->
          <div class="relative w-28 h-28 mx-auto mb-4">
            <div class="absolute inset-0 rounded-[34px] bg-[#F28C28] opacity-35 blur-xl animate-pulse"></div>
            <div class="relative w-28 h-28 rounded-[30px] shadow-2xl overflow-hidden hover:scale-105 transition duration-300">
              {svg_icon_large}
            </div>
          </div>

          <!-- Brand Title -->
          <h1 class="text-3xl sm:text-4xl font-extrabold text-[#0B1830] font-heading tracking-tight" id="txt-welcome-brand">
            उम्मीद · UMEED
          </h1>
          <p class="text-xs sm:text-sm text-[#3D4C5C] font-semibold mt-1" id="txt-welcome-tagline">
            Speak your problem. We find your scheme.
          </p>
          
          <!-- Pure Slogan: "आपकी उम्मीद, हमारी ज़िम्मेदारी" (No Black Box, Pure Dignity) -->
          <div class="my-5 text-center px-2">
            <h2 class="text-2xl sm:text-[28px] font-black font-heading text-[#0B1830] leading-tight tracking-tight">
              आपकी उम्मीद, हमारी ज़िम्मेदारी
            </h2>
            <div class="text-sm sm:text-base text-[#F28C28] font-black mt-1.5 tracking-wide">
              "Aapki Umeed, Hamari Zimmedaari"
            </div>
            <div class="text-xs text-[#3D4C5C] font-semibold mt-1">
              Your Hope, Our Responsibility · 100% Free Civic Aid
            </div>
          </div>

          <!-- Prominent & Friendly Voice Welcome Card (User can immediately hear voice!) -->
          <div class="my-4">
            <button id="btn-welcome-audio" onclick="speakWelcomePledge()" class="w-full py-3.5 px-4 bg-white hover:bg-[#FFF9EE] border-2 border-[#F28C28] rounded-2xl shadow-lg flex items-center justify-between transition hover:scale-[1.01] group">
              <div class="flex items-center space-x-3.5">
                <div id="welcome-audio-icon" class="w-12 h-12 rounded-2xl bg-gradient-to-tr from-[#F28C28] to-[#FFA742] text-white flex items-center justify-center text-2xl shadow-md group-hover:rotate-6 transition">
                  🔊
                </div>
                <div class="text-left">
                  <div class="font-black text-sm text-[#0B1830] flex items-center space-x-1.5">
                    <span id="welcome-audio-title">आवाज़ में सुनें (Listen in Voice)</span>
                    <span class="text-[10px] bg-[#1F9D6B]/15 text-[#1F9D6B] px-2 py-0.5 rounded-full font-bold">Loud & Clear</span>
                  </div>
                  <div id="welcome-audio-desc" class="text-xs text-[#3D4C5C] font-medium mt-0.5">धीमी एवं स्पष्ट आवाज़ में स्वागत संदेश</div>
                </div>
              </div>
              <span id="welcome-audio-pill" class="text-xs font-black text-[#F28C28] bg-[#F28C28]/10 px-3 py-1.5 rounded-xl group-hover:bg-[#F28C28] group-hover:text-white transition shadow-sm">
                सुनें ➔
              </span>
            </button>
          </div>
        </div>

        <!-- Easy, Eye-Grabbing Primary Action & Simple Trust Footer -->
        <div class="pt-2">
          <button onclick="navigateTo('screen-language')" class="w-full py-4 bg-gradient-to-r from-[#F28C28] via-[#FF9838] to-[#F28C28] hover:from-[#e07b18] hover:to-[#e07b18] text-white font-black rounded-2xl text-lg shadow-xl hover:shadow-2xl hover:scale-[1.02] transition flex items-center justify-center space-x-2">
            <span id="txt-btn-select-lang">शुरू करें · Get Started</span>
            <span class="text-2xl">➔</span>
          </button>
          
          <!-- Simple Trust Row -->
          <div class="mt-3.5 flex items-center justify-center space-x-3 text-[11px] text-[#3D4C5C] font-bold">
            <span class="flex items-center space-x-1 text-[#1F9D6B]">
              <span>✓</span>
              <span>22 भाषाएं</span>
            </span>
            <span>•</span>
            <span class="flex items-center space-x-1 text-[#F28C28]">
              <span>✓</span>
              <span>100% निःशुल्क</span>
            </span>
            <span>•</span>
            <span class="flex items-center space-x-1 text-[#0B1830]">
              <span>✓</span>
              <span>सुरक्षित एवं गोपनीय</span>
            </span>
          </div>

          <div class="text-center mt-2">
            <button onclick="navigateTo('screen-consent')" class="text-[11px] text-[#3D4C5C]/80 hover:text-[#F28C28] underline font-semibold">
              गोपनीयता नीति (30-दिन स्वतः विलोपन)
            </button>
          </div>
        </div>
      </section>

      <!-- ========================================== -->
      <!-- SCREEN 2: PRIVACY & CONSENT (Step 1) -->
      <!-- ========================================== -->
      <section id="screen-consent" class="app-screen hidden flex-1 flex flex-col justify-between slide-up">
        <div>
          <div class="flex items-center justify-between mb-3 text-xs text-[#3D4C5C] font-bold">
            <button onclick="navigateTo('screen-welcome')" class="text-[#F28C28] flex items-center space-x-1">
              <span>🏠</span>
              <span>Back to Home</span>
            </button>
            <span class="bg-[#1F9D6B]/15 text-[#1F9D6B] px-2.5 py-0.5 rounded-full">Step 1 of 6</span>
          </div>

          <div class="w-12 h-12 rounded-2xl bg-[#0B1830] text-[#F28C28] text-2xl flex items-center justify-center mx-auto mb-3 shadow">
            🛡️
          </div>

          <h2 class="text-2xl font-bold text-[#0B1830] font-heading text-center mb-1" id="consent-heading">
            आपकी गोपनीयता और सहमति
          </h2>
          <p class="text-xs text-[#3D4C5C] text-center mb-4">Privacy & Data Protection Policy</p>

          <div class="bg-white border border-[#E2DDD3] rounded-2xl p-4 shadow-sm text-xs text-[#12263A] leading-relaxed space-y-3 mb-4">
            <p id="consent-body-text">
              हम केवल आपको सही सरकारी योजनाओं से जोड़ने के लिए न्यूनतम जानकारी एकत्र करते हैं। वॉयस रिकॉर्डिंग 30 दिनों के लिए सुरक्षित रखी जाती है और फिर स्वचालित रूप से हटा दी जाती है। आप सेटिंग्स से कभी भी अपना डेटा हटा सकते हैं।
            </p>
            <div class="p-2.5 bg-[#FAF6EE] rounded-xl border border-[#E2DDD3] space-y-1.5 font-semibold text-[11px]">
              <div class="flex items-center space-x-2 text-[#1F9D6B]">
                <span>✓</span>
                <span>30 दिनों में वॉयस रिकॉर्डिंग स्वतः नष्ट (Auto-Purge)</span>
              </div>
              <div class="flex items-center space-x-2 text-[#1F9D6B]">
                <span>✓</span>
                <span>कोई बायोमेट्रिक OTP, पासवर्ड या बैंक पिन नहीं पूछा जाता</span>
              </div>
              <div class="flex items-center space-x-2 text-[#1F9D6B]">
                <span>✓</span>
                <span>निजी कंपनियों या विज्ञापनों को डेटा बिक्री पूर्णतः निषेध</span>
              </div>
            </div>
          </div>

          <button onclick="speakConsentTerms()" class="w-full py-2 bg-white border border-[#F28C28]/50 text-[#F28C28] font-bold text-xs rounded-xl flex items-center justify-center space-x-1 hover:bg-[#F28C28] hover:text-white transition shadow-sm mb-3">
            <span>🔊</span>
            <span id="btn-consent-listen">शर्तें आवाज़ में सुनें (Listen Terms)</span>
          </button>
        </div>

        <div class="pt-3 border-t border-[#E2DDD3]">
          <button onclick="navigateTo('screen-language')" class="w-full py-3.5 bg-[#F28C28] text-white font-extrabold rounded-2xl text-sm shadow flex items-center justify-center space-x-2 hover:bg-[#e07b18] transition">
            <span id="btn-consent-agree">मैं सहमत हूँ और आगे बढ़ें (I Agree)</span>
            <span>➔</span>
          </button>
        </div>
      </section>

      <!-- ========================================== -->
      <!-- SCREEN 3: 23 LANGUAGES GRID WITH SEARCH (Step 2) -->
      <!-- ========================================== -->
      <section id="screen-language" class="app-screen hidden flex-1 flex flex-col justify-between slide-up">
        <div>
          <div class="flex items-center justify-between mb-2">
            <div>
              <h2 class="text-xl font-bold text-[#0B1830] font-heading" id="txt-lang-heading">अपनी भाषा चुनें</h2>
              <p class="text-xs text-[#3D4C5C]">Choose language to translate full app:</p>
            </div>
            <button onclick="navigateTo('screen-welcome')" class="px-3 py-1 bg-white border border-[#E2DDD3] text-[#0B1830] font-bold text-xs rounded-xl shadow-sm">
              🏠 Home
            </button>
          </div>

          <!-- Quick Search Filter for Languages -->
          <div class="my-2">
            <input type="text" id="lang-search-input" onkeyup="filterLanguages()" placeholder="🔍 Search language / भाषा खोजें..." class="w-full p-2.5 bg-white border border-[#E2DDD3] rounded-xl text-xs font-semibold focus:outline-none focus:border-[#F28C28] shadow-sm">
          </div>

          <div class="grid grid-cols-2 gap-2 overflow-y-auto max-h-[420px] pr-1 mt-1.5" id="language-grid-container">
            <!-- Populated by JS for all 23 languages -->
          </div>
        </div>

        <div class="pt-3 border-t border-[#E2DDD3] flex items-center justify-between">
          <button onclick="navigateTo('screen-welcome')" class="px-3 py-2 text-xs font-bold text-[#3D4C5C] hover:text-[#0B1830]">
            ← Back to Home
          </button>
          <button onclick="navigateTo('screen-mode')" class="px-5 py-2.5 bg-[#F28C28] text-white font-bold rounded-xl text-xs shadow hover:bg-[#e07b18]">
            Continue ➔
          </button>
        </div>
      </section>

      <!-- ========================================== -->
      <!-- SCREEN 4: VOICE VS TEXT MODE SELECTION (Step 3) -->
      <!-- ========================================== -->
      <section id="screen-mode" class="app-screen hidden flex-1 flex flex-col justify-between slide-up">
        <div>
          <div class="flex items-center justify-between text-xs text-[#3D4C5C] mb-2">
            <button onclick="navigateTo('screen-welcome')" class="text-[#F28C28] font-bold flex items-center space-x-1">
              <span>🏠</span>
              <span>Back to Home</span>
            </button>
            <span id="badge-mode-lang" class="font-bold text-[#0B1830] bg-white border border-[#E2DDD3] px-2 py-0.5 rounded-full">Language: हिन्दी</span>
          </div>

          <h2 id="mode-screen-heading" class="text-2xl font-bold text-[#0B1830] font-heading text-center mb-1">
            आप उम्मीद का उपयोग कैसे करेंगे?
          </h2>
          <div class="bg-[#F28C28]/10 border border-[#F28C28]/30 rounded-2xl p-2.5 mb-4 flex items-center justify-between">
            <span id="mode-audio-prompt-text" class="text-xs font-bold text-[#0B1830] pr-2">
              "बोलने के लिए नारंगी बटन दबाएं, या लिखने के लिए नीला बटन दबाएं।"
            </span>
            <button onclick="speakModePrompt()" class="p-1 text-base shrink-0" title="Listen Audio">🔊</button>
          </div>

          <!-- Voice Mode Big Card -->
          <div onclick="selectAppMode('voice')" class="cursor-pointer bg-gradient-to-br from-[#F28C28] to-[#FF9B38] text-white rounded-3xl p-4 sm:p-5 mb-3.5 shadow-xl hover:scale-[1.02] transition border-4 border-transparent hover:border-white">
            <div class="flex justify-between items-start mb-2.5">
              <span id="badge-voice-rec" class="bg-white text-[#F28C28] font-black text-xs px-3 py-1 rounded-full uppercase tracking-wider shadow">
                धीमी आवाज़ · Recommended
              </span>
              <div class="w-11 h-11 rounded-2xl bg-white/20 flex items-center justify-center text-2xl shadow-inner">
                🎙️
              </div>
            </div>
            <h3 id="card-voice-title" class="text-xl font-extrabold font-heading mb-1">आवाज़ मोड (Voice Mode)</h3>
            <p id="card-voice-desc" class="text-white/95 text-xs font-semibold mb-3 leading-relaxed">
              "आप बोलिए। हम धीरे-धीरे आसान शब्दों में पूछेंगे, आप बोलकर जवाब दीजिए।"
            </p>
            <div class="flex justify-end">
              <span class="bg-white text-[#F28C28] font-bold text-xs px-4 py-1.5 rounded-xl flex items-center space-x-1 shadow">
                <span id="btn-voice-start">बोलकर शुरू करें</span>
                <span>➔</span>
              </span>
            </div>
          </div>

          <!-- Text Mode Big Card -->
          <div onclick="selectAppMode('text')" class="cursor-pointer bg-[#0B1830] text-white rounded-3xl p-4 sm:p-5 shadow-xl hover:scale-[1.02] transition border-4 border-[#1F9D6B]">
            <div class="flex justify-between items-start mb-2.5">
              <span id="badge-text-rec" class="bg-[#1F9D6B] text-white font-black text-xs px-3 py-1 rounded-full uppercase tracking-wider shadow">
                पढ़ने-लिखने वालों के लिए
              </span>
              <div class="w-11 h-11 rounded-2xl bg-white/10 flex items-center justify-center text-2xl">
                💬
              </div>
            </div>
            <h3 id="card-text-title" class="text-xl font-extrabold font-heading mb-1">लिखकर मोड (Text Mode)</h3>
            <p id="card-text-desc" class="text-white/80 text-xs font-semibold mb-3 leading-relaxed">
              "आसान फॉर्म में अपनी जानकारी पढ़कर टाइप करें।"
            </p>
            <div class="flex justify-end">
              <span class="bg-[#1F9D6B] text-white font-bold text-xs px-4 py-1.5 rounded-xl flex items-center space-x-1 shadow">
                <span id="btn-text-start">लिखकर शुरू करें</span>
                <span>➔</span>
              </span>
            </div>
          </div>
        </div>

        <div class="pt-3 border-t border-[#E2DDD3] flex items-center justify-between">
          <button onclick="navigateTo('screen-welcome')" class="px-3 py-1.5 text-xs font-bold text-[#3D4C5C]">
            ← Back to Home
          </button>
          <button onclick="navigateTo('screen-language')" class="px-3 py-1.5 text-xs font-bold text-[#F28C28]">
            Change Language 🌐
          </button>
        </div>
      </section>

      <!-- ========================================== -->
      <!-- SCREEN 5: INTAKE QUESTIONS (13 Questions & Sector Focus) (Step 4) -->
      <!-- ========================================== -->
      <section id="screen-intake" class="app-screen hidden flex-1 flex flex-col justify-between slide-up">
        <div>
          <!-- Top bar with Back to Home & Dedicated Stop Voice Button -->
          <div class="flex items-center justify-between text-xs text-[#3D4C5C] mb-2 font-bold">
            <button onclick="navigateTo('screen-welcome')" class="text-[#F28C28] flex items-center space-x-1">
              <span>🏠</span>
              <span>Home</span>
            </button>
            <span id="question-progress-label">सवाल 1 / 13</span>
            <div class="flex items-center space-x-2">
              <button onclick="speakCurrentQuestion()" class="text-[#F28C28] flex items-center space-x-0.5" title="Repeat Voice">
                <span>🔊</span>
                <span>Repeat</span>
              </button>
              <button onclick="stopVoice()" class="text-red-500 hover:text-red-700 flex items-center space-x-0.5" title="Switch off voice">
                <span>⏹️</span>
                <span>Stop</span>
              </button>
            </div>
          </div>

          <!-- Progress bar -->
          <div class="w-full bg-[#E2DDD3] h-2 rounded-full overflow-hidden mb-3">
            <div id="progress-bar-fill" class="bg-[#F28C28] h-full transition-all duration-300 w-[8%]"></div>
          </div>

          <!-- Question Box -->
          <div class="glass-card rounded-2xl p-4 border border-[#E2DDD3] shadow-sm mb-3">
            <h3 id="current-question-text" class="text-lg font-bold text-[#0B1830] font-heading mb-2">
              आपका शुभ नाम क्या है?
            </h3>
            <div class="flex items-center justify-between mt-2.5 text-xs">
              <button onclick="toggleSpeechSpeed()" class="text-[#1C3A56] font-bold" id="btn-speed">🐢 Pacing: Calm (0.78x)</button>
              <button onclick="showWhyAsked()" class="text-[#F28C28] font-bold" id="btn-why-asked">❓ Why asked?</button>
            </div>
          </div>

          <!-- Voice Container -->
          <div id="voice-intake-container" class="space-y-3">
            <div class="bg-white border border-[#E2DDD3] rounded-2xl p-2.5 flex items-center justify-center space-x-1.5 h-14 shadow-inner" id="waveform-box">
              <div class="w-1.5 bg-[#F28C28] rounded-full wave-bar h-3"></div>
              <div class="w-1.5 bg-[#F28C28] rounded-full wave-bar h-7"></div>
              <div class="w-1.5 bg-[#F28C28] rounded-full wave-bar h-11"></div>
              <div class="w-1.5 bg-[#F28C28] rounded-full wave-bar h-5"></div>
              <div class="w-1.5 bg-[#F28C28] rounded-full wave-bar h-9"></div>
              <div class="w-1.5 bg-[#F28C28] rounded-full wave-bar h-12"></div>
              <div class="w-1.5 bg-[#F28C28] rounded-full wave-bar h-7"></div>
              <div class="w-1.5 bg-[#F28C28] rounded-full wave-bar h-4"></div>
            </div>

            <div class="bg-white border border-[#E2DDD3] rounded-2xl p-3 min-h-[70px] shadow-sm">
              <div class="text-[10px] font-bold uppercase tracking-wider text-[#3D4C5C] mb-1">Live Voice Transcript:</div>
              <div id="live-transcript-text" class="text-xs sm:text-sm text-[#0B1830] font-semibold italic">माइक का बटन दबाकर आराम से बोलें...</div>
            </div>

            <div class="text-center pt-0.5">
              <button id="btn-mic" onclick="toggleRecording()" class="w-16 h-16 rounded-full bg-[#F28C28] text-white text-2xl shadow-xl flex items-center justify-center mx-auto hover:opacity-90 transition">
                🎤
              </button>
              <div id="mic-status-label" class="text-xs font-bold text-[#3D4C5C] mt-1.5">बोलने के लिए टैप करें (Tap to Speak)</div>
            </div>
          </div>

          <!-- Text Container -->
          <div id="text-intake-container" class="hidden space-y-2.5">
            <input type="text" id="text-input-field" class="w-full p-3 bg-white border border-[#E2DDD3] rounded-2xl text-sm font-semibold focus:outline-none focus:border-[#F28C28] shadow-sm" placeholder="Type your answer...">
            <div id="choice-chips-container" class="space-y-1.5 max-h-[220px] overflow-y-auto pr-1"></div>
          </div>
        </div>

        <!-- Footer with Back/Next and Instant Voice Switch Off -->
        <div class="flex items-center justify-between pt-2.5 border-t border-[#E2DDD3] mt-2">
          <button onclick="prevQuestion()" id="btn-prev" class="px-3 py-1.5 text-xs font-bold text-[#3D4C5C]">← Back</button>
          <div class="flex space-x-2">
            <button onclick="skipQuestion()" id="btn-skip" class="px-3 py-1.5 text-xs font-bold text-[#3D4C5C]">Skip</button>
            <button onclick="nextQuestion()" class="px-5 py-2 bg-[#F28C28] hover:bg-[#e07b18] text-white font-bold rounded-xl text-xs shadow">Next ➔</button>
          </div>
        </div>
      </section>

      <!-- ========================================== -->
      <!-- SCREEN 6: VOICE HELP DESK HANDOFF & BUSY DAY QUEUE (Step 5) -->
      <!-- ========================================== -->
      <section id="screen-handoff" class="app-screen hidden flex-1 flex flex-col justify-between slide-up">
        <div>
          <div class="flex items-center justify-between text-xs text-[#3D4C5C] mb-2 font-bold">
            <button onclick="navigateTo('screen-welcome')" class="text-[#F28C28] flex items-center space-x-1">
              <span>🏠</span>
              <span>Home</span>
            </button>
            <span class="bg-[#1F9D6B]/20 text-[#1F9D6B] px-2.5 py-0.5 rounded-full">Civic Handoff</span>
          </div>

          <div class="text-center py-2 mb-3">
            <div class="w-14 h-14 rounded-2xl bg-gradient-to-tr from-[#1F9D6B] to-[#34D399] text-white text-3xl flex items-center justify-center mx-auto mb-2 shadow-lg">
              🎧
            </div>
            <h2 class="text-xl font-bold text-[#0B1830] font-heading">आपकी रिकॉर्डिंग सहायक तक पहुँच गई है</h2>
            <p class="text-xs text-[#3D4C5C] mt-1">A verified civic helper is reviewing your voice intake</p>
          </div>

          <!-- Busy Day Box -->
          <div class="bg-white border-2 border-[#F28C28] rounded-2xl p-4 shadow-sm mb-3">
            <div class="flex items-center justify-between mb-1.5">
              <span class="text-xs font-bold text-[#F28C28] uppercase tracking-wider flex items-center space-x-1">
                <span>⚠️</span>
                <span>कतार की स्थिति (Live Queue)</span>
              </span>
              <span class="text-xs font-bold bg-[#FAF6EE] px-2 py-0.5 rounded-lg border border-[#E2DDD3]">कतार संख्या: #4</span>
            </div>
            <div class="text-xs text-[#12263A] leading-relaxed mb-3">
              आज सहायता केंद्र पर अधिक नागरिक जुड़े हैं। हमने आपके लिए एक निश्चित स्लॉट आरक्षित किया है:
            </div>
            <div class="bg-[#FAF6EE] p-3 rounded-xl border border-[#E2DDD3] text-xs font-bold text-[#0B1830] space-y-1">
              <div class="text-[#1F9D6B]">✓ निश्चित समय: कल सुबह 10:30 बजे (Confirmed Slot)</div>
              <div class="text-[#3D4C5C] font-normal">सहायक: सविता शर्मा (वरिष्ठ जन-सहायक, 8 वर्ष अनुभव)</div>
            </div>
          </div>

          <!-- SMS Notification Confirmation -->
          <div class="bg-white border border-[#E2DDD3] rounded-2xl p-3.5 shadow-sm text-xs space-y-1.5">
            <div class="font-bold text-[#0B1830] flex items-center space-x-1.5">
              <span>📱</span>
              <span>एसएमएस एवं कॉल अलर्ट सक्रिय:</span>
            </div>
            <div class="text-[#3D4C5C]">
              कॉल आने से 15 मिनट पहले आपको एसएमएस और फोन पर सूचना दी जाएगी ताकि आप तैयार रहें।
            </div>
          </div>
        </div>

        <div class="pt-3 border-t border-[#E2DDD3] space-y-2">
          <button onclick="navigateTo('screen-output-lang')" class="w-full py-3.5 bg-[#F28C28] text-white font-extrabold rounded-2xl text-sm shadow hover:bg-[#e07b18] transition flex items-center justify-center space-x-1.5">
            <span>योजना का सारांश देखें (Proceed to Gist)</span>
            <span>➔</span>
          </button>
          <button onclick="navigateTo('screen-welcome')" class="w-full py-2 bg-transparent text-xs font-bold text-[#3D4C5C] hover:text-[#0B1830]">
            ← Back to Home
          </button>
        </div>
      </section>

      <!-- ========================================== -->
      <!-- SCREEN 7: CHOOSE OUTPUT GIST LANGUAGE (Step 6) -->
      <!-- ========================================== -->
      <section id="screen-output-lang" class="app-screen hidden flex-1 flex flex-col justify-between slide-up">
        <div>
          <div class="flex items-center justify-between mb-2">
            <button onclick="navigateTo('screen-welcome')" class="text-xs font-bold text-[#F28C28] flex items-center space-x-1">
              <span>🏠</span>
              <span>Home</span>
            </button>
            <span class="text-xs font-bold text-[#1F9D6B]">Language for Summary</span>
          </div>

          <div class="text-center py-2 mb-2">
            <div class="w-12 h-12 rounded-2xl bg-[#F28C28]/15 text-[#F28C28] text-2xl flex items-center justify-center mx-auto mb-1.5">
              ✨
            </div>
            <h2 class="text-xl font-bold text-[#0B1830] font-heading">योजना का सरल सारांश किस भाषा में चाहते हैं?</h2>
            <p class="text-xs text-[#3D4C5C] mt-0.5">In which language do you want the AI scheme summary & voice?</p>
          </div>

          <div class="grid grid-cols-2 gap-2 max-h-[360px] overflow-y-auto pr-1" id="output-lang-grid">
            <!-- Populated by JS for all 23 languages -->
          </div>
        </div>

        <div class="pt-3 border-t border-[#E2DDD3] flex items-center justify-between">
          <button onclick="navigateTo('screen-intake')" class="px-3 py-2 text-xs font-bold text-[#3D4C5C]">
            ← Back to Intake
          </button>
          <button onclick="generateAiGist()" class="px-6 py-2.5 bg-[#F28C28] text-white font-extrabold rounded-2xl text-xs sm:text-sm shadow-lg flex items-center space-x-1.5 hover:bg-[#e07b18]">
            <span>Generate Gist</span>
            <span>➔</span>
          </button>
        </div>
      </section>

      <!-- ========================================== -->
      <!-- SCREEN 8: AI PLAIN-LANGUAGE GIST & HEAR IT OUT (Step 7) -->
      <!-- ========================================== -->
      <section id="screen-gist" class="app-screen hidden flex-1 flex flex-col justify-between slide-up">
        <div class="overflow-y-auto pr-1">
          <!-- Top bar with Back to Home -->
          <div class="flex items-center justify-between text-xs text-[#3D4C5C] mb-2 font-bold">
            <button onclick="navigateTo('screen-welcome')" class="text-[#F28C28] flex items-center space-x-1">
              <span>🏠</span>
              <span>Home</span>
            </button>
            <span id="gist-lang-tag" class="bg-[#0B1830] text-white px-2.5 py-0.5 rounded-full text-[11px] font-bold">HINDI GIST</span>
            <button onclick="navigateTo('screen-output-lang')" class="text-[#F28C28]">Change Language 🌐</button>
          </div>

          <!-- Top Scheme Card -->
          <div class="bg-gradient-to-r from-[#0B1830] to-[#1C3A56] text-white rounded-2xl p-3.5 mb-3 shadow-md">
            <div class="text-[10px] text-[#F28C28] font-black uppercase tracking-wider mb-0.5">Top Matched Scheme for You:</div>
            <h2 id="gist-scheme-name" class="text-xl font-bold font-heading">PM Kisan Samman Nidhi</h2>
            <p id="gist-scheme-ministry" class="text-[11px] text-white/80 mt-0.5">Ministry of Agriculture & Farmers Welfare</p>
          </div>

          <!-- PROMINENT "HEAR IT OUT" BUTTON (USER REQUIREMENT) -->
          <button onclick="toggleGistAudio()" id="btn-hear-it-out" class="w-full py-3.5 bg-gradient-to-r from-[#F28C28] to-[#FF9B38] hover:from-[#e07b18] hover:to-[#e07b18] text-white font-black rounded-2xl text-sm sm:text-base shadow-lg flex items-center justify-center space-x-2 mb-3 transition">
            <span id="hear-icon" class="text-xl">🔊</span>
            <span id="hear-label">आवाज़ में पूरा सारांश सुनें (Hear It Out)</span>
          </button>

          <!-- AI Plain-Language Gist Bullets Box -->
          <div class="bg-white border-2 border-[#1F9D6B] rounded-2xl p-4 shadow-sm mb-3">
            <div class="flex items-center space-x-2 text-[#1F9D6B] font-bold text-sm mb-2">
              <span>✨</span>
              <span id="gist-card-title">सरल शब्दों में योजना का विवरण:</span>
            </div>
            <div class="space-y-2 text-xs text-[#12263A] leading-relaxed font-medium" id="gist-bullets-container">
              <!-- Bullets populated dynamically by JS based on preferred output language -->
            </div>
            <div class="mt-3 p-2.5 bg-[#FAF6EE] rounded-xl text-xs font-bold text-[#1F9D6B] border border-[#E2DDD3]" id="gist-benefit-box">
              सीधा लाभ: ₹6,000 हर साल बैंक खाते में (3 किश्तों में)
            </div>
          </div>

          <!-- INTERACTIVE HELP DESK QUERY BOX (USER REQUIREMENT) -->
          <div class="bg-white border-2 border-[#F28C28] rounded-2xl p-3.5 shadow-sm mb-3">
            <div class="flex items-center space-x-2 text-[#0B1830] font-bold text-xs sm:text-sm mb-1">
              <span class="text-lg">🎧</span>
              <span>हेल्प डेस्क से सवाल पूछें (Query Help Desk)</span>
            </div>
            <p class="text-[11px] text-[#3D4C5C] mb-2">योजना को लेकर कोई भी शंका हो तो यहाँ पूछें, सहायक तुरंत उत्तर देंगे:</p>
            
            <div class="flex space-x-2 mb-2">
              <input type="text" id="help-desk-query-input" class="flex-1 p-2 bg-[#FAF6EE] border border-[#E2DDD3] rounded-xl text-xs font-semibold focus:outline-none focus:border-[#F28C28]" placeholder="अपना सवाल लिखें या बोलें...">
              <button onclick="submitHelpDeskQuery()" class="px-3.5 py-2 bg-[#0B1830] text-white font-bold text-xs rounded-xl hover:bg-[#F28C28] transition">
                पूछें ➔
              </button>
            </div>

            <div class="flex flex-wrap gap-1.5 text-[10px] mb-2 font-semibold">
              <button onclick="setSampleQuery('क्या बिना ज़मीन के पट्टे के भी लाभ मिलेगा?')" class="px-2.5 py-1 bg-[#FAF6EE] border border-[#E2DDD3] rounded-lg text-[#0B1830] hover:border-[#F28C28]">
                📄 भूमि अभिलेख / खतौनी अनुपलब्ध होने पर प्रक्रिया?
              </button>
              <button onclick="setSampleQuery('पैसा आने में कितना समय लगेगा?')" class="px-2.5 py-1 bg-[#FAF6EE] border border-[#E2DDD3] rounded-lg text-[#0B1830] hover:border-[#F28C28]">
                ⏱️ प्रत्यक्ष लाभ हस्तांतरण (DBT) समय-सीमा?
              </button>
              <button onclick="setSampleQuery('बैंक खाते में आधार और डीबीटी लिंक कैसे करें?')" class="px-2.5 py-1 bg-[#FAF6EE] border border-[#E2DDD3] rounded-lg text-[#0B1830] hover:border-[#F28C28]">
                🏦 बैंक खाते में आधार एवं DBT लिंकिंग प्रक्रिया?
              </button>
              <button onclick="setSampleQuery('निकटतम जन सेवा केंद्र का पता कैसे मिलेगा?')" class="px-2.5 py-1 bg-[#FAF6EE] border border-[#E2DDD3] rounded-lg text-[#0B1830] hover:border-[#F28C28]">
                🏛️ निकटतम CSC जन सेवा केंद्र एवं अधिकृत खिड़की?
              </button>
            </div>

            <div id="help-desk-answer-box" class="hidden mt-2 p-2.5 bg-[#1F9D6B]/15 text-[#0B1830] rounded-xl text-xs border border-[#1F9D6B]/30">
              <div class="font-bold text-[#1F9D6B] mb-1 flex items-center space-x-1">
                <span>✓</span>
                <span>जन-सहायक का उत्तर:</span>
              </div>
              <div id="help-desk-answer-text" class="leading-relaxed font-semibold"></div>
            </div>
          </div>
        </div>

        <!-- Action Bottom Buttons -->
        <div class="pt-2 flex space-x-2">
          <button onclick="navigateTo('screen-dashboard')" class="flex-1 py-2.5 bg-white border-2 border-[#0B1830] text-[#0B1830] font-bold rounded-xl text-xs">
            सभी योजनाएं देखें (Dashboard)
          </button>
          <button onclick="navigateTo('screen-journey')" class="flex-1 py-2.5 bg-[#F28C28] text-white font-bold rounded-xl text-xs shadow hover:bg-[#e07b18]">
            आवेदन करें (Apply Now) ➔
          </button>
        </div>
      </section>

      <!-- ========================================== -->
      <!-- SCREEN 9: 3-TIER RANKED DASHBOARD (Step 8) -->
      <!-- ========================================== -->
      <section id="screen-dashboard" class="app-screen hidden flex-1 flex flex-col slide-up">
        <div class="flex items-center justify-between mb-2">
          <div>
            <h2 class="text-xl font-bold text-[#0B1830] font-heading">Your Best Options, Ranked</h2>
            <p class="text-xs text-[#3D4C5C]">Ranked by Benefit Size, Qualification & Ease</p>
          </div>
          <button onclick="navigateTo('screen-welcome')" class="px-3 py-1 bg-white border border-[#E2DDD3] text-[#0B1830] font-bold text-xs rounded-xl shadow-sm">
            🏠 Home
          </button>
        </div>

        <!-- Category Filter Chips -->
        <div class="flex space-x-1.5 overflow-x-auto pb-2 mb-2 text-xs">
          <button onclick="filterDashboard('all')" class="chip-filter active px-3 py-1 bg-[#0B1830] text-white rounded-full font-bold whitespace-nowrap text-[11px]">All</button>
          <button onclick="filterDashboard('farming')" class="chip-filter px-3 py-1 bg-white border border-[#E2DDD3] text-[#3D4C5C] rounded-full font-semibold whitespace-nowrap text-[11px]">🌾 Agriculture</button>
          <button onclick="filterDashboard('health')" class="chip-filter px-3 py-1 bg-white border border-[#E2DDD3] text-[#3D4C5C] rounded-full font-semibold whitespace-nowrap text-[11px]">🏥 Health</button>
          <button onclick="filterDashboard('housing')" class="chip-filter px-3 py-1 bg-white border border-[#E2DDD3] text-[#3D4C5C] rounded-full font-semibold whitespace-nowrap text-[11px]">🏠 Housing</button>
          <button onclick="filterDashboard('business')" class="chip-filter px-3 py-1 bg-white border border-[#E2DDD3] text-[#3D4C5C] rounded-full font-semibold whitespace-nowrap text-[11px]">💼 Business</button>
          <button onclick="filterDashboard('pension')" class="chip-filter px-3 py-1 bg-white border border-[#E2DDD3] text-[#3D4C5C] rounded-full font-semibold whitespace-nowrap text-[11px]">👵 Pension</button>
        </div>

        <!-- Schemes List (Ranked Top 3 & others) -->
        <div class="space-y-3 overflow-y-auto flex-1 pr-1" id="schemes-list-container">
          <!-- Populated by JS -->
        </div>

        <div class="pt-2 text-center border-t border-[#E2DDD3] mt-2 flex items-center justify-between text-[11px] text-[#3D4C5C]">
          <span>🔄 Data verified: 24 Oct 2026</span>
          <button onclick="navigateTo('screen-compare')" class="text-[#F28C28] font-bold">⚖️ Compare Schemes</button>
        </div>
      </section>

      <!-- ========================================== -->
      <!-- SCREEN 10: SCHEME DETAILS SCREEN (Step 9) -->
      <!-- ========================================== -->
      <section id="screen-detail" class="app-screen hidden flex-1 flex flex-col justify-between slide-up">
        <div class="overflow-y-auto pr-1">
          <div class="flex items-center justify-between text-xs text-[#3D4C5C] mb-2 font-bold">
            <button onclick="navigateTo('screen-dashboard')" class="text-[#F28C28] flex items-center space-x-1">
              <span>← Back to Dashboard</span>
            </button>
            <button onclick="navigateTo('screen-welcome')" class="text-[#3D4C5C]">🏠 Home</button>
          </div>

          <!-- Scheme Header -->
          <div class="bg-gradient-to-r from-[#0B1830] to-[#1C3A56] text-white rounded-2xl p-4 mb-3 shadow">
            <div class="flex justify-between items-start mb-1">
              <span id="detail-rank-badge" class="bg-[#F28C28] text-white text-[10px] font-black uppercase px-2 py-0.5 rounded-full">#1 BEST MATCH</span>
              <span id="detail-benefit-amount" class="text-sm font-black text-[#1F9D6B]">₹6,000 / year</span>
            </div>
            <h2 id="detail-scheme-title" class="text-xl font-bold font-heading">PM Kisan Samman Nidhi</h2>
            <p id="detail-ministry" class="text-xs text-white/80 mt-0.5">Ministry of Agriculture and Farmers Welfare</p>
          </div>

          <!-- Big Orange Listen Button -->
          <button onclick="speakCurrentSchemeDetails()" class="w-full py-3 bg-[#F28C28] hover:bg-[#e07b18] text-white font-black rounded-xl text-xs sm:text-sm shadow flex items-center justify-center space-x-2 mb-3 transition">
            <span>🔊</span>
            <span>योजना की पूरी जानकारी सुनें (Listen Scheme Details)</span>
          </button>

          <!-- Plain Words First Box -->
          <div class="bg-white border-2 border-[#1F9D6B] rounded-2xl p-3.5 shadow-sm mb-3">
            <div class="text-xs font-bold text-[#1F9D6B] uppercase tracking-wider mb-1 flex items-center space-x-1">
              <span>💡</span>
              <span>सरल शब्दों में विवरण (Plain Words First)</span>
            </div>
            <p id="detail-plain-words" class="text-xs text-[#12263A] leading-relaxed">
              यदि आपके परिवार के पास खेती योग्य ज़मीन है, तो सरकार बीज, खाद और ज़रूरी खर्चों के लिए हर 4 महीने में ₹2,000 सीधे आपके बैंक खाते में भेजती है।
            </p>
          </div>

          <!-- Collapsible Official Gazette Text -->
          <div class="bg-white border border-[#E2DDD3] rounded-2xl p-3 shadow-sm mb-3">
            <button onclick="toggleOfficialText()" class="w-full flex items-center justify-between text-xs font-bold text-[#0B1830]">
              <span class="flex items-center space-x-1">
                <span>📜</span>
                <span>आधिकारिक सरकारी राजपत्र विवरण (Official Gazette Text)</span>
              </span>
              <span id="official-text-toggle-icon">▼</span>
            </button>
            <div id="detail-official-text-box" class="hidden mt-2 pt-2 border-t border-[#E2DDD3] text-[11px] text-[#3D4C5C] leading-relaxed font-mono bg-gray-50 p-2.5 rounded-xl">
              The Pradhan Mantri Kisan Samman Nidhi (PM-KISAN) is a Central Sector scheme to provide income support to all landholding farmers' families in the country to supplement their financial needs for procuring various inputs related to agriculture and allied activities.
            </div>
          </div>

          <!-- Eligibility Checklist -->
          <div class="bg-white border border-[#E2DDD3] rounded-2xl p-3.5 shadow-sm mb-3 text-xs">
            <div class="font-bold text-[#0B1830] mb-2 flex items-center space-x-1">
              <span>✓</span>
              <span>आपकी पात्रता (Your Matched Eligibility):</span>
            </div>
            <div class="space-y-1.5 text-[11px] text-[#12263A]">
              <div class="flex items-center space-x-2 text-[#1F9D6B]">
                <span>✓</span>
                <span>व्यवसाय: किसान / कृषि मज़दूर मान्य है</span>
              </div>
              <div class="flex items-center space-x-2 text-[#1F9D6B]">
                <span>✓</span>
                <span>वार्षिक आय: ₹3,00,000 सीमा के अंतर्गत</span>
              </div>
              <div class="flex items-center space-x-2 text-[#1F9D6B]">
                <span>✓</span>
                <span>क्षेत्र: ग्रामीण एवं शहरी दोनों क्षेत्रों के लिए मान्य</span>
              </div>
            </div>
          </div>

          <!-- Required Documents -->
          <div class="bg-white border border-[#E2DDD3] rounded-2xl p-3.5 shadow-sm mb-3 text-xs">
            <div class="font-bold text-[#0B1830] mb-2 flex items-center space-x-1">
              <span>📄</span>
              <span>ज़रूरी दस्तावेज़ (Required Documents):</span>
            </div>
            <div class="space-y-2 text-[11px]" id="detail-docs-list">
              <!-- Populated by JS -->
            </div>
          </div>
        </div>

        <!-- Action Bottom Buttons -->
        <div class="pt-2 flex space-x-2">
          <button onclick="navigateTo('screen-compare')" class="flex-1 py-2.5 bg-white border border-[#0B1830] text-[#0B1830] font-bold rounded-xl text-xs">
            ⚖️ Compare
          </button>
          <button onclick="navigateTo('screen-journey')" class="flex-1 py-2.5 bg-[#F28C28] text-white font-bold rounded-xl text-xs shadow hover:bg-[#e07b18]">
            Apply Now (4-Stage) ➔
          </button>
        </div>
      </section>

      <!-- ========================================== -->
      <!-- SCREEN 11: SIDE-BY-SIDE SCHEME COMPARE (Step 10) -->
      <!-- ========================================== -->
      <section id="screen-compare" class="app-screen hidden flex-1 flex flex-col justify-between slide-up">
        <div class="overflow-y-auto pr-1">
          <div class="flex items-center justify-between text-xs text-[#3D4C5C] mb-2 font-bold">
            <button onclick="navigateTo('screen-dashboard')" class="text-[#F28C28] flex items-center space-x-1">
              <span>← Back to Dashboard</span>
            </button>
            <button onclick="navigateTo('screen-welcome')" class="text-[#3D4C5C]">🏠 Home</button>
          </div>

          <h2 class="text-xl font-bold text-[#0B1830] font-heading mb-1 text-center">Side-by-Side Scheme Compare</h2>
          <p class="text-xs text-[#3D4C5C] text-center mb-3">Compare benefits, ease & requirements directly</p>

          <!-- Dropdowns to pick schemes -->
          <div class="grid grid-cols-2 gap-2 mb-3">
            <div>
              <label class="text-[10px] font-bold text-[#3D4C5C] block mb-1">Scheme A:</label>
              <select id="compare-select-a" onchange="renderComparison()" class="w-full p-2 bg-white border border-[#E2DDD3] rounded-xl text-xs font-semibold">
                <option value="pm_kisan">PM Kisan Samman Nidhi</option>
                <option value="ayushman_bharat">Ayushman Bharat (PM-JAY)</option>
                <option value="pm_awas_rural">PMAY - Gramin Housing</option>
                <option value="pm_svanidhi">PM SVANidhi</option>
              </select>
            </div>
            <div>
              <label class="text-[10px] font-bold text-[#3D4C5C] block mb-1">Scheme B:</label>
              <select id="compare-select-b" onchange="renderComparison()" class="w-full p-2 bg-white border border-[#E2DDD3] rounded-xl text-xs font-semibold">
                <option value="ayushman_bharat">Ayushman Bharat (PM-JAY)</option>
                <option value="pm_kisan">PM Kisan Samman Nidhi</option>
                <option value="pm_awas_rural">PMAY - Gramin Housing</option>
                <option value="pm_svanidhi">PM SVANidhi</option>
              </select>
            </div>
          </div>

          <!-- Comparison Table Card -->
          <div class="bg-white border border-[#E2DDD3] rounded-2xl p-3 shadow-sm text-xs space-y-3" id="compare-table-content">
            <!-- Populated by JS -->
          </div>
        </div>

        <div class="pt-3 border-t border-[#E2DDD3] flex space-x-2">
          <button onclick="navigateTo('screen-dashboard')" class="flex-1 py-2.5 bg-white border border-[#0B1830] text-[#0B1830] font-bold rounded-xl text-xs">
            Back to Dashboard
          </button>
          <button onclick="navigateTo('screen-journey')" class="flex-1 py-2.5 bg-[#F28C28] text-white font-bold rounded-xl text-xs shadow hover:bg-[#e07b18]">
            Proceed to Apply ➔
          </button>
        </div>
      </section>

      <!-- ========================================== -->
      <!-- SCREEN 12: 4-STAGE JOURNEY & HELP DESK LOCK GATE (Step 11) -->
      <!-- ========================================== -->
      <section id="screen-journey" class="app-screen hidden flex-1 flex flex-col justify-between slide-up">
        <div class="overflow-y-auto pr-1">
          <div class="flex items-center justify-between text-xs text-[#3D4C5C] mb-2 font-bold">
            <button onclick="navigateTo('screen-welcome')" class="text-[#F28C28] flex items-center space-x-1">
              <span>🏠</span>
              <span>Home</span>
            </button>
            <button onclick="navigateTo('screen-gist')" class="text-[#F28C28]">← Back to Gist</button>
          </div>

          <!-- Help Desk Lock Gate (Step 1 of Journey) -->
          <div id="help-desk-lock-gate" class="bg-white border-2 border-[#F28C28] rounded-2xl p-4 sm:p-5 text-center shadow mb-3">
            <div class="text-3xl mb-1.5">🔒</div>
            <h3 class="text-base sm:text-lg font-bold text-[#0B1830]">Documents Locked Until Help Desk Consultation</h3>
            <p class="text-xs text-[#3D4C5C] my-2.5 leading-relaxed">
              We connect you with a verified civic helper first so you don't waste trips to government offices with incorrect papers.
            </p>
            <button onclick="unlockViaHelper()" class="w-full py-2.5 bg-[#F28C28] text-white font-bold rounded-xl text-xs sm:text-sm mb-2 shadow hover:bg-[#e07b18]">
              Talk to a Civic Helper 🎧
            </button>
            <button onclick="unlockDirectly()" class="text-xs text-[#1C3A56] font-bold underline">
              I already understand, skip to document checklist
            </button>
          </div>

          <!-- Unlocked 4-Stage Stepper -->
          <div id="unlocked-stepper" class="hidden space-y-3">
            <div class="p-2.5 bg-[#1F9D6B]/15 text-[#1F9D6B] rounded-xl text-xs font-bold flex items-center space-x-1.5">
              <span>🔓</span>
              <span>Documents Unlocked! Follow the 4-Stage Stepper:</span>
            </div>

            <!-- Stage 1: Prepare -->
            <div class="bg-white border border-[#E2DDD3] rounded-2xl p-3.5 shadow-sm text-xs space-y-2">
              <div class="font-bold text-sm text-[#0B1830] flex items-center justify-between">
                <span>1. Prepare: Document Checklist</span>
                <span class="text-[10px] bg-[#1F9D6B]/15 text-[#1F9D6B] px-2 py-0.5 rounded-full font-bold">Ready</span>
              </div>
              <label class="flex items-center space-x-2 cursor-pointer">
                <input type="checkbox" checked class="text-[#1F9D6B] rounded">
                <span><b>Aadhaar Card:</b> Front & back photo</span>
              </label>
              <label class="flex items-center space-x-2 cursor-pointer">
                <input type="checkbox" checked class="text-[#1F9D6B] rounded">
                <span><b>Land Patta / Khatauni:</b> Farmland record</span>
              </label>
              <label class="flex items-center space-x-2 cursor-pointer">
                <input type="checkbox" class="text-[#1F9D6B] rounded">
                <span><b>Bank Passbook:</b> IFSC code visible</span>
              </label>
            </div>

            <!-- Stage 2: Verify -->
            <div class="bg-white border border-[#E2DDD3] rounded-2xl p-3.5 shadow-sm text-xs">
              <div class="font-bold text-sm text-[#0B1830] mb-1 flex items-center justify-between">
                <span>2. Verify (Helper Check)</span>
                <span class="text-[10px] bg-[#F28C28]/15 text-[#F28C28] px-2 py-0.5 rounded-full font-bold">Free</span>
              </div>
              <p class="text-[#3D4C5C]">Civic desk confirms your papers before submitting so your application isn't rejected.</p>
            </div>

            <!-- Stage 3: Apply -->
            <div class="bg-white border border-[#E2DDD3] rounded-2xl p-3.5 shadow-sm text-xs">
              <div class="font-bold text-sm text-[#0B1830] mb-1 flex items-center justify-between">
                <span>3. Apply (Official Window)</span>
                <span class="text-[10px] bg-[#0B1830] text-white px-2 py-0.5 rounded-full font-bold">No Proxy</span>
              </div>
              <p class="text-[#3D4C5C] mb-2">Direct handoff to official government portal with zero fee:</p>
              <a href="https://pmkisan.gov.in" target="_blank" class="inline-block px-3 py-1.5 bg-[#FAF6EE] border border-[#E2DDD3] rounded-lg text-xs font-bold text-[#F28C28] hover:border-[#F28C28]">
                Open https://pmkisan.gov.in ↗
              </a>
            </div>

            <!-- Stage 4: Track -->
            <div class="bg-white border border-[#E2DDD3] rounded-2xl p-3.5 shadow-sm text-xs">
              <div class="font-bold text-sm text-[#0B1830] mb-1">4. Track</div>
              <p class="text-[#3D4C5C]">SMS & voice status alerts enabled automatically on your registered mobile number.</p>
            </div>
          </div>
        </div>

        <div class="pt-2 flex space-x-2">
          <button onclick="navigateTo('screen-dashboard')" class="flex-1 py-2.5 bg-white border border-[#0B1830] text-[#0B1830] font-bold rounded-xl text-xs">
            Back to Schemes
          </button>
          <button onclick="navigateTo('screen-helpdesk-console')" class="flex-1 py-2.5 bg-[#0B1830] text-white font-bold rounded-xl text-xs shadow">
            Civic Helper Console 💻
          </button>
        </div>
      </section>

      <!-- ========================================== -->
      <!-- SCREEN 13: CIVIC HELPER CONSOLE (/helpdesk) (Step 12) -->
      <!-- ========================================== -->
      <section id="screen-helpdesk-console" class="app-screen hidden flex-1 flex flex-col justify-between slide-up">
        <div class="overflow-y-auto pr-1">
          <div class="flex items-center justify-between text-xs text-[#3D4C5C] mb-2 font-bold">
            <button onclick="navigateTo('screen-welcome')" class="text-[#F28C28] flex items-center space-x-1">
              <span>🏠</span>
              <span>Home</span>
            </button>
            <span class="bg-[#0B1830] text-white px-2 py-0.5 rounded-full text-[10px]">ADMIN / HELPER CONSOLE</span>
          </div>

          <h2 class="text-xl font-bold text-[#0B1830] font-heading mb-1">Civic Helper Dashboard</h2>
          <p class="text-xs text-[#3D4C5C] mb-3">Live citizen intake queue & verification triage</p>

          <!-- Queue Table -->
          <div class="space-y-2 mb-3">
            <div class="bg-white border border-[#E2DDD3] rounded-xl p-3 shadow-sm text-xs">
              <div class="flex justify-between items-center mb-1">
                <span class="font-bold text-[#0B1830]">Ramesh Kumar (Farmer, 42y)</span>
                <span class="px-2 py-0.5 rounded-full text-[10px] font-bold bg-red-100 text-red-700">Urgent</span>
              </div>
              <div class="text-[11px] text-[#3D4C5C] mb-2">Scheme: PM Kisan · Lang: Hindi · Need: Farming grant</div>
              <div class="flex space-x-2">
                <button onclick="alert('Calling citizen at +91 98765 43210 via secure PBX...')" class="px-2.5 py-1 bg-[#1F9D6B] text-white font-bold text-[11px] rounded-lg">
                  📞 Call Citizen
                </button>
                <button onclick="speakText('रमेश कुमार जी की कागज़ात जांच प्रारंभ हुई।', 'hi')" class="px-2.5 py-1 bg-[#FAF6EE] border border-[#E2DDD3] text-[#0B1830] font-semibold text-[11px] rounded-lg">
                  Verify Docs
                </button>
              </div>
            </div>

            <div class="bg-white border border-[#E2DDD3] rounded-xl p-3 shadow-sm text-xs">
              <div class="flex justify-between items-center mb-1">
                <span class="font-bold text-[#0B1830]">Sunita Devi (Weaver, 38y)</span>
                <span class="px-2 py-0.5 rounded-full text-[10px] font-bold bg-amber-100 text-amber-700">Moderate</span>
              </div>
              <div class="text-[11px] text-[#3D4C5C] mb-2">Scheme: PM Vishwakarma · Lang: Hindi</div>
              <div class="flex space-x-2">
                <button onclick="alert('Calling Sunita Devi...')" class="px-2.5 py-1 bg-[#1F9D6B] text-white font-bold text-[11px] rounded-lg">
                  📞 Call Citizen
                </button>
                <button class="px-2.5 py-1 bg-[#FAF6EE] border border-[#E2DDD3] text-[#0B1830] font-semibold text-[11px] rounded-lg">
                  Verify Docs
                </button>
              </div>
            </div>
          </div>
        </div>

        <div class="pt-3 border-t border-[#E2DDD3]">
          <button onclick="navigateTo('screen-welcome')" class="w-full py-2.5 bg-[#0B1830] text-white font-bold rounded-xl text-xs">
            ← Back to Home
          </button>
        </div>
      </section>

      <!-- ========================================== -->
      <!-- SCREEN 14: SETTINGS & PRIVACY (Step 13) -->
      <!-- ========================================== -->
      <section id="screen-settings" class="app-screen hidden flex-1 flex flex-col justify-between slide-up">
        <div class="space-y-3">
          <div class="flex items-center justify-between text-xs text-[#3D4C5C] font-bold">
            <button onclick="navigateTo('screen-welcome')" class="text-[#F28C28] flex items-center space-x-1">
              <span>🏠</span>
              <span>Back to Home</span>
            </button>
            <span class="text-[#0B1830]">Settings & Privacy</span>
          </div>

          <div class="bg-white border border-[#E2DDD3] rounded-2xl p-4 shadow-sm text-xs">
            <h3 class="font-bold text-sm text-[#0B1830] mb-1.5">30-Day Auto Retention Policy</h3>
            <p class="text-[#3D4C5C] leading-relaxed">
              All voice recordings and transcripts automatically purge after 30 days. No biometric OTPs, passwords, or credit card info are ever collected.
            </p>
          </div>

          <div class="bg-white border border-[#E2DDD3] rounded-2xl p-4 shadow-sm text-xs">
            <h3 class="font-bold text-sm text-[#0B1830] mb-1.5">Local Cache & Device Storage</h3>
            <p class="text-[#3D4C5C] leading-relaxed">
              Session Profile: Active<br>
              Language: <span id="settings-lang-display">Hindi (हिन्दी)</span><br>
              Voice Pacing: 0.78x (Calm & Humanized)
            </p>
          </div>

          <div class="p-3 bg-white border border-[#E2DDD3] rounded-xl text-[11px] text-[#3D4C5C] text-center leading-relaxed">
            Disclaimer: Umeed is an informational and civic guidance aid. Final eligibility is determined solely by the respective government ministry.
          </div>
        </div>

        <div class="pt-3">
          <button onclick="deleteMyData()" class="w-full py-3.5 bg-red-600 hover:bg-red-700 text-white font-bold rounded-2xl text-xs sm:text-sm shadow">
            🗑️ Delete My Data (Permanent Wipe)
          </button>
        </div>
      </section>

    </main>

    <!-- ========================================== -->
    <!-- SLIDE-OUT ALL-SCREENS DRAWER / QUICK NAVIGATOR -->
    <!-- ========================================== -->
    <div id="all-screens-drawer" class="hidden fixed inset-0 bg-black/60 backdrop-blur-sm z-50 flex justify-end">
      <div class="bg-white w-4/5 max-w-xs h-full p-4 overflow-y-auto shadow-2xl flex flex-col justify-between pop-in">
        <div>
          <div class="flex items-center justify-between pb-3 border-b border-[#E2DDD3] mb-3">
            <div class="font-heading font-bold text-base text-[#0B1830] flex items-center space-x-1.5">
              <span>📋</span>
              <span>All App Screens (14)</span>
            </div>
            <button onclick="toggleAllScreensDrawer()" class="text-gray-400 hover:text-gray-700 text-lg font-bold">✕</button>
          </div>

          <div class="text-[11px] text-[#3D4C5C] mb-2 font-semibold">Jump to any screen directly:</div>

          <div class="space-y-1 text-xs">
            <div class="text-[10px] font-bold text-[#F28C28] uppercase tracking-wider pt-1">Onboarding</div>
            <button onclick="navigateFromDrawer('screen-welcome')" class="w-full text-left p-2 rounded-lg hover:bg-[#FAF6EE] flex items-center space-x-2 font-semibold">
              <span>🏠</span><span>Welcome & Slogan</span>
            </button>
            <button onclick="navigateFromDrawer('screen-consent')" class="w-full text-left p-2 rounded-lg hover:bg-[#FAF6EE] flex items-center space-x-2 font-semibold">
              <span>🛡️</span><span>Privacy & Consent</span>
            </button>
            <button onclick="navigateFromDrawer('screen-language')" class="w-full text-left p-2 rounded-lg hover:bg-[#FAF6EE] flex items-center space-x-2 font-semibold">
              <span>🌐</span><span>23 Languages Grid</span>
            </button>

            <div class="text-[10px] font-bold text-[#F28C28] uppercase tracking-wider pt-2">Intake Flow</div>
            <button onclick="navigateFromDrawer('screen-mode')" class="w-full text-left p-2 rounded-lg hover:bg-[#FAF6EE] flex items-center space-x-2 font-semibold">
              <span>🎙️</span><span>Voice vs Text Mode</span>
            </button>
            <button onclick="navigateFromDrawer('screen-intake')" class="w-full text-left p-2 rounded-lg hover:bg-[#FAF6EE] flex items-center space-x-2 font-semibold">
              <span>✍️</span><span>13 Questions & Sector Focus</span>
            </button>
            <button onclick="navigateFromDrawer('screen-handoff')" class="w-full text-left p-2 rounded-lg hover:bg-[#FAF6EE] flex items-center space-x-2 font-semibold">
              <span>🎧</span><span>Help Desk Handoff Queue</span>
            </button>

            <div class="text-[10px] font-bold text-[#F28C28] uppercase tracking-wider pt-2">Gist & Advice</div>
            <button onclick="navigateFromDrawer('screen-output-lang')" class="w-full text-left p-2 rounded-lg hover:bg-[#FAF6EE] flex items-center space-x-2 font-semibold">
              <span>🗣️</span><span>Gist Language Selector</span>
            </button>
            <button onclick="navigateFromDrawer('screen-gist')" class="w-full text-left p-2 rounded-lg hover:bg-[#FAF6EE] flex items-center space-x-2 font-semibold">
              <span>✨</span><span>AI Plain Gist & "Hear It Out"</span>
            </button>

            <div class="text-[10px] font-bold text-[#F28C28] uppercase tracking-wider pt-2">Discovery & Details</div>
            <button onclick="navigateFromDrawer('screen-dashboard')" class="w-full text-left p-2 rounded-lg hover:bg-[#FAF6EE] flex items-center space-x-2 font-semibold">
              <span>📊</span><span>3-Tier Ranked Dashboard</span>
            </button>
            <button onclick="navigateFromDrawer('screen-detail')" class="w-full text-left p-2 rounded-lg hover:bg-[#FAF6EE] flex items-center space-x-2 font-semibold">
              <span>🔍</span><span>Scheme Details (Plain + Official)</span>
            </button>
            <button onclick="navigateFromDrawer('screen-compare')" class="w-full text-left p-2 rounded-lg hover:bg-[#FAF6EE] flex items-center space-x-2 font-semibold">
              <span>⚖️</span><span>Side-by-Side Scheme Compare</span>
            </button>

            <div class="text-[10px] font-bold text-[#F28C28] uppercase tracking-wider pt-2">Execution & Admin</div>
            <button onclick="navigateFromDrawer('screen-journey')" class="w-full text-left p-2 rounded-lg hover:bg-[#FAF6EE] flex items-center space-x-2 font-semibold">
              <span>🔒</span><span>4-Stage Stepper & Locked Gate</span>
            </button>
            <button onclick="navigateFromDrawer('screen-helpdesk-console')" class="w-full text-left p-2 rounded-lg hover:bg-[#FAF6EE] flex items-center space-x-2 font-semibold">
              <span>💻</span><span>Civic Helper Console</span>
            </button>
            <button onclick="navigateFromDrawer('screen-settings')" class="w-full text-left p-2 rounded-lg hover:bg-[#FAF6EE] flex items-center space-x-2 font-semibold">
              <span>⚙️</span><span>Settings (Delete My Data)</span>
            </button>
          </div>
        </div>

        <div class="pt-3 border-t border-[#E2DDD3]">
          <button onclick="toggleAllScreensDrawer()" class="w-full py-2 bg-[#0B1830] text-white font-bold rounded-xl text-xs">
            Close Menu
          </button>
        </div>
      </div>
    </div>

  </div>

  <!-- Embedded All 23 Localization JSON and 16 Schemes -->
  <script>
    const allL10n = {l10n_js};
    const allSchemes = {schemes_js};
    const embeddedAudio = {embedded_audio_js};

    // State Variables
    let currentMode = 'voice';
    let currentLang = 'hi';
    let selectedOutputLang = 'hi';
    let currentQuestionIdx = 0;
    let isRecording = false;
    let speechSpeed = 0.78; // Calm, humanized slower voice
    let userAnswers = {{}};
    let isGistSpeaking = false;
    let currentViewingSchemeId = 'pm_kisan';
    let cachedVoices = [];

    // 23 Scheduled Languages + English
    const languages = [
      {{ code: 'hi', name: 'Hindi', native: 'हिन्दी', voice: 'hi-IN' }},
      {{ code: 'en', name: 'English', native: 'English', voice: 'en-IN' }},
      {{ code: 'mr', name: 'Marathi', native: 'मराठी', voice: 'mr-IN' }},
      {{ code: 'bn', name: 'Bengali', native: 'বাংলা', voice: 'bn-IN' }},
      {{ code: 'ta', name: 'Tamil', native: 'தமிழ்', voice: 'ta-IN' }},
      {{ code: 'te', name: 'Telugu', native: 'తెలుగు', voice: 'te-IN' }},
      {{ code: 'gu', name: 'Gujarati', native: 'ગુજરાતી', voice: 'gu-IN' }},
      {{ code: 'kn', name: 'Kannada', native: 'ಕನ್ನಡ', voice: 'kn-IN' }},
      {{ code: 'pa', name: 'Punjabi', native: 'ਪੰਜਾਬੀ', voice: 'pa-IN' }},
      {{ code: 'ml', name: 'Malayalam', native: 'മലയാളം', voice: 'ml-IN' }},
      {{ code: 'or', name: 'Odia', native: 'ଓଡ଼ିଆ', voice: 'hi-IN' }},
      {{ code: 'as', name: 'Assamese', native: 'অসমীয়া', voice: 'bn-IN' }},
      {{ code: 'ur', name: 'Urdu', native: 'اردو', voice: 'ur-IN', rtl: true }},
      {{ code: 'mai', name: 'Maithili', native: 'मैथिली', voice: 'hi-IN' }},
      {{ code: 'sat', name: 'Santali', native: 'ᱥᱟᱱᱛᱟᱲᱤ', voice: 'hi-IN' }},
      {{ code: 'ks', name: 'Kashmiri', native: 'कॉशुर / كٲشُر', voice: 'ur-IN', rtl: true }},
      {{ code: 'ne', name: 'Nepali', native: 'नेपाली', voice: 'ne-NP' }},
      {{ code: 'kok', name: 'Konkani', native: 'कोंकणी', voice: 'mr-IN' }},
      {{ code: 'sd', name: 'Sindhi', native: 'سنڌي / सिन्धी', voice: 'ur-IN', rtl: true }},
      {{ code: 'doi', name: 'Dogri', native: 'डोगरी', voice: 'hi-IN' }},
      {{ code: 'mni', name: 'Manipuri', native: 'মৈতৈলোন্', voice: 'bn-IN' }},
      {{ code: 'brx', name: 'Bodo', native: "बर'/बड़ो", voice: 'hi-IN' }},
      {{ code: 'sa', name: 'Sanskrit', native: 'संस्कृतम्', voice: 'hi-IN' }}
    ];

    const questionsKeys = [
      'q_name', 'q_age', 'q_gender', 'q_state', 'q_area', 'q_caste',
      'q_income', 'q_occupation', 'q_education', 'q_disability', 'q_family', 'q_need', 'q_sector_focus'
    ];

    const sampleAnswers = {{
      q_name: 'Ramesh Kumar',
      q_age: '42',
      q_gender: 'पुरुष',
      q_state: 'Maharashtra',
      q_area: 'गाँव',
      q_caste: 'OBC',
      q_income: '₹1.5 Lakh',
      q_occupation: 'किसान (Farmer)',
      q_education: '10वीं पास',
      q_disability: 'नहीं',
      q_family: '5',
      q_need: 'खेती (Farming)',
      q_sector_focus: '🌾 कृषि एवं किसान कल्याण (Agriculture)'
    }};

    // ==========================================
    // VOICE SYSTEM INITIALIZATION & DIAGNOSTICS
    // ==========================================
    function initVoices() {{
      if ('speechSynthesis' in window) {{
        cachedVoices = window.speechSynthesis.getVoices();
        console.log("SpeechSynthesis voices loaded:", cachedVoices.length);
      }}
    }}

    if ('speechSynthesis' in window) {{
      initVoices();
      window.speechSynthesis.onvoiceschanged = initVoices;
    }}

    let isWelcomeSpeaking = false;

    function showVoiceToast(active, message = "आवाज़ सुनाई दे रही है...") {{
      const toast = document.getElementById('voice-speaking-toast');
      const textEl = document.getElementById('voice-toast-text');
      if (toast && textEl) {{
        textEl.innerText = message;
        if (active) toast.classList.remove('hidden');
        else toast.classList.add('hidden');
      }}
    }}

    // ==========================================
    // BULLETPROOF DUAL-ENGINE AUDIO SYSTEM
    // 1. Crystal-Clear Native AAC Spoken Audio via HTML5 <audio>
    // 2. High-Fidelity Local Voice Stream
    // 3. Native Browser SpeechSynthesis Fallback
    // ==========================================
    window._activeAudioElement = null;

    function stopVoice() {{
      // 1. Instantly stop HTML5 Audio
      if (window._activeAudioElement) {{
        try {{
          window._activeAudioElement.pause();
          window._activeAudioElement.currentTime = 0;
        }} catch(e) {{}}
        window._activeAudioElement = null;
      }}

      // 2. Instantly stop SpeechSynthesis
      try {{
        if ('speechSynthesis' in window) {{
          window.speechSynthesis.cancel();
        }}
      }} catch(e) {{}}

      showVoiceToast(false);
      window._currentActiveUtterance = null;
      if (typeof isWelcomeSpeaking !== 'undefined' && isWelcomeSpeaking) {{
        isWelcomeSpeaking = false;
        updateWelcomeAudioButton(false);
      }}
      if (typeof isGistSpeaking !== 'undefined' && isGistSpeaking) {{
        isGistSpeaking = false;
        const hearLabel = document.getElementById('hear-label');
        const hearIcon = document.getElementById('hear-icon');
        if (hearLabel) hearLabel.innerText = "आवाज़ में पूरा सारांश सुनें (Hear It Out)";
        if (hearIcon) hearIcon.innerText = "🔊";
      }}
    }}

    function speakText(text, langCode = currentLang, onDone = null) {{
      stopVoice();

      // Check if we have pre-rendered crystal-clear AAC voice clip
      let audioKey = null;
      const lower = text.toLowerCase();
      if (text.includes('नमस्ते') || text.includes('स्वागत') || text.includes('Welcome') || text.includes('উম্মিদে') || text.includes('வரவேற்கிறோம்') || text.includes('స్వాగతం')) {{
        audioKey = 'welcome_' + langCode;
        if (!embeddedAudio[audioKey]) audioKey = 'welcome_hi';
      }} else if (text.includes('न्यूनतम आवश्यक जानकारी') || text.includes('न्यूनतम जानकारी') || text.includes('गोपनीयता नीति') || text.includes('डेटा संरक्षण') || lower.includes('consent')) {{
        audioKey = 'consent_hi';
      }} else if (text.includes('नारंगी बटन') || text.includes('नीला बटन') || text.includes('बोलने के लिए')) {{
        audioKey = 'mode_hi';
      }} else if (text.includes('शुभ नाम') || text.includes('पूरा नाम') || lower.includes('name')) {{
        audioKey = 'q_name_hi';
      }} else if (text.includes('उम्र') || text.includes('आयु') || lower.includes('age')) {{
        audioKey = 'q_age_hi';
      }} else if (text.includes('लिंग') || lower.includes('gender')) {{
        audioKey = 'q_gender_hi';
      }} else if (text.includes('राज्य') || lower.includes('state')) {{
        audioKey = 'q_state_hi';
      }} else if (text.includes('गाँव') || text.includes('शहर') || lower.includes('area') || lower.includes('rural')) {{
        audioKey = 'q_area_hi';
      }} else if (text.includes('वर्ग') || text.includes('जाति') || lower.includes('caste') || lower.includes('category')) {{
        audioKey = 'q_caste_hi';
      }} else if (text.includes('आय') || lower.includes('income')) {{
        audioKey = 'q_income_hi';
      }} else if (text.includes('व्यवसाय') || text.includes('आजीविका') || lower.includes('occupation')) {{
        audioKey = 'q_occupation_hi';
      }} else if (text.includes('योग्यता') || text.includes('शिक्षा') || lower.includes('education')) {{
        audioKey = 'q_education_hi';
      }} else if (text.includes('दिव्यांग') || lower.includes('disability')) {{
        audioKey = 'q_disability_hi';
      }} else if (text.includes('सदस्य') || lower.includes('family')) {{
        audioKey = 'q_family_hi';
      }} else if (text.includes('सहायता की आवश्यकता') || lower.includes('need')) {{
        audioKey = 'q_need_hi';
      }} else if (text.includes('क्षेत्र में') || lower.includes('sector')) {{
        audioKey = 'q_sector_focus_hi';
      }} else if (text.includes('किसान परिवार') || text.includes('6,000') || text.includes('६,০০০') || text.includes('6000') || text.includes('সারসংক্ষেপ') || text.includes('சுருக்கம்') || text.includes('సారాంశం') || lower.includes('gist')) {{
        const outLang = (typeof selectedOutputLang !== 'undefined' ? selectedOutputLang : langCode);
        audioKey = 'gist_' + outLang;
        if (!embeddedAudio[audioKey]) audioKey = 'gist_hi';
      }}

      // TIER 1: Play Embedded High-Fidelity AAC Audio (Guaranteed 100% Sound via HTML5 Audio)
      if (audioKey && embeddedAudio && embeddedAudio[audioKey]) {{
        try {{
          const audio = new Audio(embeddedAudio[audioKey]);
          audio.volume = 1.0;
          window._activeAudioElement = audio;

          showVoiceToast(true, "🔊 स्पष्ट आवाज़ चल रही है (Loud & Clear)...");

          audio.onended = () => {{
            showVoiceToast(false);
            window._activeAudioElement = null;
            if (onDone) onDone();
          }};

          audio.onerror = (e) => {{
            console.warn("Audio element error, falling back to Web Speech:", e);
            playNativeSpeech(text, langCode, onDone);
          }};

          const playPromise = audio.play();
          if (playPromise !== undefined) {{
            playPromise.then(() => {{
              // Audio playing loud and clear!
            }}).catch(err => {{
              console.warn("Audio play() blocked, trying native speech:", err);
              playNativeSpeech(text, langCode, onDone);
            }});
          }}

          // Also trigger local audio endpoint if accessible
          try {{
            fetch(`/api/speak?text=${{encodeURIComponent(text)}}&voice=${{langCode === 'en' ? 'Rishi' : 'Lekha'}}`).catch(() => {{}});
          }} catch(e) {{}}

          return;
        }} catch(e) {{
          console.warn("Failed to play embedded audio:", e);
        }}
      }}

      // TIER 2: Browser Native Web Speech API Fallback
      playNativeSpeech(text, langCode, onDone);
    }}

    function playNativeSpeech(text, langCode, onDone) {{
      if (!('speechSynthesis' in window)) {{
        if (onDone) onDone();
        return;
      }}

      try {{
        window.speechSynthesis.cancel();
        if (window.speechSynthesis.paused) {{
          window.speechSynthesis.resume();
        }}
      }} catch(e) {{}}

      const utterance = new SpeechSynthesisUtterance(text);
      window._currentActiveUtterance = utterance; // Retain global reference against GC

      utterance.rate = speechSpeed || 0.82;
      utterance.pitch = 1.0;
      utterance.volume = 1.0;

      const langObj = languages.find(l => l.code === langCode) || languages[0];
      const targetTag = (langObj && langObj.voice) ? langObj.voice : 'hi-IN';
      utterance.lang = targetTag;

      const voices = window.speechSynthesis.getVoices();
      if (voices && voices.length > 0) {{
        const targetTagUnderscore = targetTag.replace('-', '_');
        let matched = voices.find(v => 
          v.lang === targetTag || 
          v.lang === targetTagUnderscore ||
          v.lang.toLowerCase() === targetTag.toLowerCase()
        );

        if (!matched) {{
          if (langCode === 'hi') matched = voices.find(v => v.name.includes('Lekha') || v.lang.startsWith('hi'));
          else if (langCode === 'bn') matched = voices.find(v => v.name.includes('Piya') || v.lang.startsWith('bn'));
          else if (langCode === 'ta') matched = voices.find(v => v.name.includes('Vani') || v.lang.startsWith('ta'));
          else if (langCode === 'te') matched = voices.find(v => v.name.includes('Geeta') || v.lang.startsWith('te'));
          else if (langCode === 'kn') matched = voices.find(v => v.name.includes('Soumya') || v.lang.startsWith('kn'));
          else if (langCode === 'en') matched = voices.find(v => v.name.includes('Aman') || v.name.includes('Rishi') || v.lang.includes('IN'));
        }}

        if (matched) {{
          utterance.voice = matched;
          utterance.lang = matched.lang;
        }}
      }}

      utterance.onstart = () => {{
        showVoiceToast(true, `🔊 "${{langObj.native}}" आवाज़ चल रही है...`);
      }};

      utterance.onend = () => {{
        showVoiceToast(false);
        window._currentActiveUtterance = null;
        if (onDone) onDone();
      }};

      utterance.onerror = (err) => {{
        console.warn("Speech error:", err);
        showVoiceToast(false);
        window._currentActiveUtterance = null;
        if (onDone) onDone();
      }};

      window.speechSynthesis.speak(utterance);
    }}

    function speakWelcomePledge() {{
      if (isWelcomeSpeaking) {{
        stopVoice();
        return;
      }}
      isWelcomeSpeaking = true;
      updateWelcomeAudioButton(true);
      speakText(
        'नमस्ते! उम्मीद में आपका स्वागत है। आपकी उम्मीद, हमारी ज़िम्मेदारी। आप बोलकर या लिखकर अपनी समस्या बता सकते हैं, हम आपको सही सरकारी योजना से जोड़ेंगे। शुरू करने के लिए नीचे दिए गए बटन को दबाएं।',
        'hi',
        () => {{
          isWelcomeSpeaking = false;
          updateWelcomeAudioButton(false);
        }}
      );
    }}

    function updateWelcomeAudioButton(speaking) {{
      const btn = document.getElementById('btn-welcome-audio');
      const icon = document.getElementById('welcome-audio-icon');
      const title = document.getElementById('welcome-audio-title');
      const desc = document.getElementById('welcome-audio-desc');
      const pill = document.getElementById('welcome-audio-pill');
      if (!btn) return;

      if (speaking) {{
        btn.classList.add('border-[#1F9D6B]', 'bg-emerald-50/50');
        btn.classList.remove('border-[#F28C28]', 'bg-white');
        if (icon) icon.innerHTML = '<span class="text-2xl animate-pulse">🔊</span>';
        if (title) title.innerText = 'आवाज़ चल रही है (Playing)';
        if (desc) desc.innerText = 'रोकने के लिए पुनः दबाएं (Tap to Stop)';
        if (pill) {{
          pill.innerText = '⏹️ रोकें';
          pill.className = 'text-xs font-black text-red-600 bg-red-100 px-3 py-1.5 rounded-xl shadow-sm';
        }}
      }} else {{
        btn.classList.remove('border-[#1F9D6B]', 'bg-emerald-50/50');
        btn.classList.add('border-[#F28C28]', 'bg-white');
        if (icon) icon.innerHTML = '<span class="text-2xl">🔊</span>';
        if (title) title.innerText = 'आवाज़ में सुनें (Listen in Voice)';
        if (desc) desc.innerText = 'धीमी एवं स्पष्ट आवाज़ में स्वागत संदेश';
        if (pill) {{
          pill.innerText = 'सुनें ➔';
          pill.className = 'text-xs font-black text-[#F28C28] bg-[#F28C28]/10 px-3 py-1.5 rounded-xl group-hover:bg-[#F28C28] group-hover:text-white transition shadow-sm';
        }}
      }}
    }}

    function speakConsentTerms() {{
      const dict = allL10n[currentLang] || allL10n['hi'] || allL10n['en'];
      speakText(dict.consent_body || "हम केवल आपको सही सरकारी योजनाओं से जोड़ने के लिए न्यूनतम जानकारी एकत्र करते हैं।", currentLang);
    }}

    function speakModePrompt() {{
      const dict = allL10n[currentLang] || allL10n['hi'] || allL10n['en'];
      speakText(dict.mode_audio_prompt || "बोलने के लिए नारंगी बटन दबाएं, या लिखने के लिए नीला बटन दबाएं।", currentLang);
    }}

    // ==========================================
    // NAVIGATION WITH AUTOMATIC VOICE SWITCH-OFF
    // ==========================================
    function navigateTo(id) {{
      // Turn off voice when switching back, forward, or home
      stopVoice();

      document.querySelectorAll('.app-screen').forEach(el => el.classList.add('hidden'));
      const target = document.getElementById(id);
      if (target) {{
        target.classList.remove('hidden');
      }}
      
      const breadcrumb = document.getElementById('home-breadcrumb-bar');
      if (id === 'screen-welcome') {{
        breadcrumb.classList.add('hidden');
      }} else {{
        breadcrumb.classList.remove('hidden');
      }}
      window.scrollTo(0, 0);
    }}

    function toggleAllScreensDrawer() {{
      stopVoice();
      const drawer = document.getElementById('all-screens-drawer');
      drawer.classList.toggle('hidden');
    }}

    function navigateFromDrawer(id) {{
      stopVoice();
      toggleAllScreensDrawer();
      navigateTo(id);
    }}

    // ==========================================
    // DYNAMIC LANGUAGE SWITCHER FOR ALL 23 LANGUAGES
    // ==========================================
    function setAppLanguage(code) {{
      stopVoice();
      currentLang = code;
      selectedOutputLang = code;
      const dict = allL10n[code] || allL10n['hi'] || allL10n['en'];
      const langObj = languages.find(l => l.code === code) || languages[0];

      // RTL handling
      if (langObj.rtl) {{
        document.documentElement.dir = 'rtl';
      }} else {{
        document.documentElement.dir = 'ltr';
      }}

      // Update Pills & Labels
      document.getElementById('current-language-pill').innerText = `${{langObj.native}} (${{langObj.name}})`;
      document.getElementById('badge-mode-lang').innerText = `Language: ${{langObj.native}}`;
      document.getElementById('settings-lang-display').innerText = `${{langObj.name}} (${{langObj.native}})`;

      if (dict.backHome) document.getElementById('label-back-home').innerText = dict.backHome;

      // Update Mode Screen
      if (dict.mode_selection_title) document.getElementById('mode-screen-heading').innerText = dict.mode_selection_title;
      if (dict.mode_audio_prompt) document.getElementById('mode-audio-prompt-text').innerText = `"${{dict.mode_audio_prompt}}"`;
      if (dict.mode_voice_badge) document.getElementById('badge-voice-rec').innerText = dict.mode_voice_badge;
      if (dict.mode_voice_title) document.getElementById('card-voice-title').innerText = dict.mode_voice_title;
      if (dict.mode_voice_subtitle) document.getElementById('card-voice-desc').innerText = `"${{dict.mode_voice_subtitle}}"`;
      if (dict.switch_to_voice) document.getElementById('btn-voice-start').innerText = dict.switch_to_voice;
      if (dict.mode_text_badge) document.getElementById('badge-text-rec').innerText = dict.mode_text_badge;
      if (dict.mode_text_title) document.getElementById('card-text-title').innerText = dict.mode_text_title;
      if (dict.mode_text_subtitle) document.getElementById('card-text-desc').innerText = `"${{dict.mode_text_subtitle}}"`;
      if (dict.switch_to_text) document.getElementById('btn-text-start').innerText = dict.switch_to_text;

      // Update Consent Screen
      if (dict.consent_title) document.getElementById('consent-heading').innerText = dict.consent_title;
      if (dict.consent_body) document.getElementById('consent-body-text').innerText = dict.consent_body;
      if (dict.consent_agree) document.getElementById('btn-consent-agree').innerText = `${{dict.consent_agree}} ➔`;

      // Navigate to screen FIRST, then speak confirmation cleanly
      navigateTo('screen-mode');
      speakText(`आपने चुना ${{langObj.native}}`, code);
    }}

    // Populate Languages Grids
    const langContainer = document.getElementById('language-grid-container');
    const outLangContainer = document.getElementById('output-lang-grid');

    function renderLanguageGrid(filterText = '') {{
      langContainer.innerHTML = '';
      const filtered = languages.filter(l => 
        l.name.toLowerCase().includes(filterText.toLowerCase()) || 
        l.native.includes(filterText)
      );

      filtered.forEach(l => {{
        const tile = document.createElement('div');
        tile.className = 'cursor-pointer bg-white border border-[#E2DDD3] hover:border-[#F28C28] rounded-2xl p-2.5 sm:p-3 flex flex-col justify-between shadow-sm transition hover:scale-[1.02]';
        tile.onclick = () => setAppLanguage(l.code);
        tile.innerHTML = `
          <div class="flex justify-between items-center mb-1">
            <span class="text-xs text-[#3D4C5C] font-semibold">${{l.name}}</span>
            ${{l.rtl ? '<span class="text-[10px] bg-[#1F9D6B]/20 text-[#1F9D6B] px-1 rounded font-bold">RTL</span>' : ''}}
          </div>
          <div class="text-base font-bold text-[#0B1830] font-heading">${{l.native}}</div>
        `;
        langContainer.appendChild(tile);
      }});
    }}

    function filterLanguages() {{
      const text = document.getElementById('lang-search-input').value;
      renderLanguageGrid(text);
    }}

    languages.forEach(l => {{
      // Screen 7 Output Gist Language Tile
      const outTile = document.createElement('div');
      outTile.className = 'cursor-pointer bg-white border border-[#E2DDD3] hover:border-[#F28C28] rounded-xl p-2 shadow-sm text-center transition hover:scale-[1.02]';
      outTile.id = `out-tile-${{l.code}}`;
      outTile.onclick = () => {{
        selectedOutputLang = l.code;
        document.querySelectorAll('#output-lang-grid > div').forEach(d => d.classList.remove('border-[#F28C28]', 'bg-[#F28C28]/15', 'shadow-md'));
        outTile.classList.add('border-[#F28C28]', 'bg-[#F28C28]/15', 'shadow-md');
        speakText(l.native, l.code);
      }};
      outTile.innerHTML = `
        <div class="font-bold text-sm text-[#0B1830]">${{l.native}}</div>
        <div class="text-[11px] text-[#3D4C5C]">${{l.name}}</div>
      `;
      outLangContainer.appendChild(outTile);
    }});

    // ==========================================
    // DASHBOARD RENDERING (Ranked #1, #2, #3 Tiers)
    // ==========================================
    function renderDashboardSchemes(filter = 'all') {{
      const container = document.getElementById('schemes-list-container');
      container.innerHTML = '';

      let schemes = allSchemes;
      if (filter === 'farming') schemes = allSchemes.filter(s => s.id.includes('kisan') || s.ministry.includes('Agriculture'));
      if (filter === 'health') schemes = allSchemes.filter(s => s.id.includes('ayushman') || s.ministry.includes('Health'));
      if (filter === 'housing') schemes = allSchemes.filter(s => s.id.includes('awas') || s.ministry.includes('Housing') || s.ministry.includes('Rural'));
      if (filter === 'business') schemes = allSchemes.filter(s => s.id.includes('svanidhi') || s.id.includes('vishwakarma') || s.id.includes('mudra') || s.id.includes('egp'));
      if (filter === 'pension') schemes = allSchemes.filter(s => s.id.includes('pension'));

      schemes.forEach((s, idx) => {{
        const card = document.createElement('div');
        let rankBadge = `#${{idx + 1}} Good Match`;
        let borderColor = '#4A6572';
        let badgeBg = '#4A6572';

        if (idx === 0) {{
          rankBadge = '🥇 #1 Best Match';
          borderColor = '#F28C28';
          badgeBg = '#F28C28';
        }} else if (idx === 1) {{
          rankBadge = '🥈 #2 Better Match';
          borderColor = '#1F9D6B';
          badgeBg = '#1F9D6B';
        }} else if (idx === 2) {{
          rankBadge = '🥉 #3 Good Match';
          borderColor = '#4A6572';
          badgeBg = '#4A6572';
        }}

        card.className = 'cursor-pointer bg-white border-2 rounded-2xl p-4 shadow-sm hover:shadow-md transition';
        card.style.borderColor = borderColor;
        card.innerHTML = `
          <div class="flex justify-between items-center mb-1.5">
            <span class="text-xs font-bold text-white px-2.5 py-0.5 rounded-full" style="background-color: ${{badgeBg}}">${{rankBadge}}</span>
            <span class="text-xs font-bold text-[#1F9D6B]">₹${{s.benefit_amount.toLocaleString('en-IN')}}</span>
          </div>
          <div class="text-base font-bold text-[#0B1830] font-heading" onclick="openSchemeDetail('${{s.id}}')">${{s.name}}</div>
          <div class="text-xs text-[#3D4C5C] mb-2">${{s.ministry}}</div>
          <div class="text-xs font-semibold text-[#12263A] bg-[#FAF6EE] p-2 rounded-xl mb-2 flex items-center space-x-1">
            <span class="text-[#1F9D6B]">✓</span>
            <span>${{s.simplified_text.substring(0, 90)}}...</span>
          </div>
          <div class="flex items-center justify-between text-xs pt-1 border-t border-[#E2DDD3]">
            <button onclick="openSchemeDetail('${{s.id}}')" class="text-[#F28C28] font-bold hover:underline">Details & Gazette ➔</button>
            <button onclick="navigateTo('screen-gist')" class="text-[#1F9D6B] font-bold hover:underline">View AI Gist ➔</button>
          </div>
        `;
        container.appendChild(card);
      }});
    }}

    function filterDashboard(cat) {{
      document.querySelectorAll('.chip-filter').forEach(c => {{
        c.classList.remove('bg-[#0B1830]', 'text-white');
        c.classList.add('bg-white', 'text-[#3D4C5C]');
      }});
      event.target.classList.add('bg-[#0B1830]', 'text-white');
      event.target.classList.remove('bg-white', 'text-[#3D4C5C]');
      renderDashboardSchemes(cat);
    }}

    // ==========================================
    // SCHEME DETAILS & COLLAPSED GAZETTE ACCORDION
    // ==========================================
    function openSchemeDetail(id) {{
      stopVoice();
      currentViewingSchemeId = id;
      const s = allSchemes.find(sc => sc.id === id) || allSchemes[0];

      document.getElementById('detail-scheme-title').innerText = s.name;
      document.getElementById('detail-ministry').innerText = s.ministry;
      document.getElementById('detail-benefit-amount').innerText = `₹${{s.benefit_amount.toLocaleString('en-IN')}} / benefit`;
      document.getElementById('detail-plain-words').innerText = s.simplified_text;
      document.getElementById('detail-official-text-box').innerText = s.official_text;

      // Render docs
      const docsList = document.getElementById('detail-docs-list');
      docsList.innerHTML = '';
      if (s.documents_required) {{
        s.documents_required.forEach(d => {{
          const docRow = document.createElement('div');
          docRow.className = 'p-2 bg-[#FAF6EE] border border-[#E2DDD3] rounded-xl';
          docRow.innerHTML = `
            <div class="font-bold text-[#0B1830]">${{d.name}}</div>
            <div class="text-[10px] text-[#3D4C5C]">${{d.photo_hint || ''}} · ${{d.plain_reason || ''}}</div>
          `;
          docsList.appendChild(docRow);
        }});
      }}

      navigateTo('screen-detail');
      speakText(`${{s.name}}. ${{s.simplified_text}}`, currentLang);
    }}

    function toggleOfficialText() {{
      const box = document.getElementById('detail-official-text-box');
      const icon = document.getElementById('official-text-toggle-icon');
      if (box.classList.contains('hidden')) {{
        box.classList.remove('hidden');
        icon.innerText = '▲';
      }} else {{
        box.classList.add('hidden');
        icon.innerText = '▼';
      }}
    }}

    function speakCurrentSchemeDetails() {{
      const s = allSchemes.find(sc => sc.id === currentViewingSchemeId) || allSchemes[0];
      speakText(`${{s.name}}. ${{s.simplified_text}}. लाभ राशि ${{s.benefit_amount}} रुपये।`, currentLang);
    }}

    // ==========================================
    // SIDE-BY-SIDE COMPARE ENGINE
    // ==========================================
    function renderComparison() {{
      const idA = document.getElementById('compare-select-a').value;
      const idB = document.getElementById('compare-select-b').value;
      const sA = allSchemes.find(s => s.id === idA) || allSchemes[0];
      const sB = allSchemes.find(s => s.id === idB) || allSchemes[1];

      const table = document.getElementById('compare-table-content');
      table.innerHTML = `
        <div class="grid grid-cols-2 gap-2 text-center pb-2 border-b border-[#E2DDD3]">
          <div class="font-bold text-[#F28C28] text-sm">${{sA.name}}</div>
          <div class="font-bold text-[#1F9D6B] text-sm">${{sB.name}}</div>
        </div>
        <div class="grid grid-cols-2 gap-2 pb-2 border-b border-[#E2DDD3]">
          <div>
            <div class="text-[10px] text-[#3D4C5C] uppercase">Benefit Amount:</div>
            <div class="font-bold text-sm text-[#0B1830]">₹${{sA.benefit_amount.toLocaleString('en-IN')}}</div>
          </div>
          <div>
            <div class="text-[10px] text-[#3D4C5C] uppercase">Benefit Amount:</div>
            <div class="font-bold text-sm text-[#0B1830]">₹${{sB.benefit_amount.toLocaleString('en-IN')}}</div>
          </div>
        </div>
        <div class="grid grid-cols-2 gap-2 pb-2 border-b border-[#E2DDD3]">
          <div>
            <div class="text-[10px] text-[#3D4C5C] uppercase">Ease Score:</div>
            <div class="font-bold text-sm text-[#1F9D6B]">${{Math.round(sA.ease_score * 100)}}% Easy</div>
          </div>
          <div>
            <div class="text-[10px] text-[#3D4C5C] uppercase">Ease Score:</div>
            <div class="font-bold text-sm text-[#1F9D6B]">${{Math.round(sB.ease_score * 100)}}% Easy</div>
          </div>
        </div>
        <div class="grid grid-cols-2 gap-2">
          <div>
            <div class="text-[10px] text-[#3D4C5C] uppercase">Who gets it:</div>
            <div class="text-[11px] text-[#12263A]">${{sA.simplified_text.substring(0, 110)}}...</div>
          </div>
          <div>
            <div class="text-[10px] text-[#3D4C5C] uppercase">Who gets it:</div>
            <div class="text-[11px] text-[#12263A]">${{sB.simplified_text.substring(0, 110)}}...</div>
          </div>
        </div>
      `;
    }}

    // ==========================================
    // INTAKE QUESTIONS LOGIC (13 Questions)
    // ==========================================
    function selectAppMode(mode) {{
      stopVoice();
      currentMode = mode;
      document.getElementById('label-mode-indicator').innerText = mode === 'voice' ? '🎤 Voice' : '💬 Text';
      navigateTo('screen-intake');
      renderCurrentQuestion();
    }}

    function toggleModeSwitch() {{
      stopVoice();
      selectAppMode(currentMode === 'voice' ? 'text' : 'voice');
    }}

    function renderCurrentQuestion() {{
      const key = questionsKeys[currentQuestionIdx];
      const dict = allL10n[currentLang] || allL10n['hi'] || allL10n['en'];
      let qText = dict[key];

      if (!qText && key === 'q_sector_focus') {{
        qText = "आपको किस मुख्य क्षेत्र में सरकारी मदद चाहिए? (Which primary sector do you need help in?)";
      }}
      if (!qText) qText = "Question " + (currentQuestionIdx + 1);

      document.getElementById('question-progress-label').innerText = `Question ${{currentQuestionIdx + 1}} of ${{questionsKeys.length}}`;
      document.getElementById('progress-bar-fill').style.width = `${{((currentQuestionIdx + 1) / questionsKeys.length) * 100}}%`;
      document.getElementById('current-question-text').innerText = qText;

      if (currentMode === 'voice') {{
        document.getElementById('voice-intake-container').classList.remove('hidden');
        document.getElementById('text-intake-container').classList.add('hidden');
        document.getElementById('live-transcript-text').innerText = userAnswers[key] || 'माइक का बटन दबाकर आराम से बोलें...';
        speakCurrentQuestion();
      }} else {{
        document.getElementById('voice-intake-container').classList.add('hidden');
        document.getElementById('text-intake-container').classList.remove('hidden');
        const inputField = document.getElementById('text-input-field');
        const chipsContainer = document.getElementById('choice-chips-container');
        chipsContainer.innerHTML = '';

        if (key === 'q_gender' || key === 'q_area' || key === 'q_caste' || key === 'q_income' || key === 'q_occupation' || key === 'q_education' || key === 'q_disability' || key === 'q_need' || key === 'q_sector_focus' || key === 'q_state' || key === 'q_family' || key === 'q_age') {{
          inputField.classList.add('hidden');
          chipsContainer.classList.remove('hidden');

          let options = [];
          if (key === 'q_gender') {{
            options = [
              'महिला / स्त्री नागरिक (Female Citizen)',
              'पुरुष नागरिक (Male Citizen)',
              'तृतीय लिंग / अन्य (Transgender / Other Gender)',
              'गोपनीय (Prefer Not to Disclose)'
            ];
          }} else if (key === 'q_area') {{
            options = [
              'ग्रामीण क्षेत्र / ग्राम पंचायत (Rural / Gram Panchayat)',
              'शहरी क्षेत्र / नगर पालिका / निगम (Urban / Municipal Area)',
              'अर्ध-शहरी क्षेत्र (Semi-Urban / Peri-Urban Area)'
            ];
          }} else if (key === 'q_caste') {{
            options = [
              'सामान्य वर्ग (General / Unreserved Category)',
              'अन्य पिछड़ा वर्ग (OBC - Non-Creamy Layer)',
              'अन्य पिछड़ा वर्ग (OBC - Creamy Layer)',
              'अनुसूचित जाति (Scheduled Caste - SC)',
              'अनुसूचित जनजाति (Scheduled Tribe - ST)',
              'आर्थिक रूप से कमजोर वर्ग (Economically Weaker Section - EWS)',
              'विशेष रूप से कमजोर जनजातीय समूह (PVTG Category)'
            ];
          }} else if (key === 'q_income') {{
            options = [
              '₹1,00,000 से कम (Below ₹1 Lakh · BPL / Antyodaya Category)',
              '₹1,00,000 - ₹2,50,000 (Low Income Group - LIG)',
              '₹2,50,000 - ₹5,00,000 (Middle Income Group - MIG I)',
              '₹5,00,000 - ₹8,00,000 (Middle Income Group - MIG II)',
              '₹8,00,000 से अधिक (Above ₹8 Lakh · Non-EWS Category)'
            ];
          }} else if (key === 'q_occupation') {{
            options = [
              '🌾 कृषि एवं संबद्ध कार्य (Farmer / Landholder)',
              '🌱 खेतिहर मजदूर एवं ग्रामीण श्रमिक (Agricultural Labourer)',
              '🧱 असंगठित निर्माण श्रमिक (Unorganized Construction Worker)',
              '🔨 पारंपरिक शिल्पकार एवं दस्तकार (Traditional Artisan / PM Vishwakarma)',
              '🛒 स्ट्रीट वेंडर एवं फेरीवाला (Street Vendor / Micro-Retailer)',
              '🏭 लघु व्यापारी एवं सूक्ष्म उद्यमी (Micro-Enterprise Owner / MSME Trader)',
              '💼 स्व-रोजगार एवं सेवा प्रदाता (Self-Employed / Skilled Service Provider)',
              '🏠 गृहणी एवं परिवार देखभालकर्ता (Homemaker / Family Caregiver)',
              '🎓 विद्यार्थी एवं प्रतियोगी अभ्यर्थी (Student / Competitive Aspirant)',
              '👴 सेवानिवृत्त एवं वरिष्ठ नागरिक (Senior Citizen / Superannuated)'
            ];
          }} else if (key === 'q_education') {{
            options = [
              'साक्षर / अनौपचारिक प्राथमिक शिक्षा (Literate / Non-Formal Primary)',
              'उच्च प्राथमिक (Middle School - Up to 8th Standard)',
              'माध्यमिक (Secondary - 10th Standard Matriculation)',
              'उच्चतर माध्यमिक (Higher Secondary - 12th Standard Intermediate)',
              'तकनीकी / आईटीआई / डिप्लोमा (Technical ITI / Polytechnic Diploma)',
              'स्नातक उपाधि (Graduate / Bachelor Degree)',
              'स्नातकोत्तर एवं शोध (Post-Graduate / Professional / Doctorate Degree)'
            ];
          }} else if (key === 'q_disability') {{
            options = [
              'नहीं, परिवार में कोई दिव्यांग सदस्य नहीं हैं (No PwD Dependent in Family)',
              'हाँ, 40% या अधिक दिव्यांगता (Certified Divyangjan · UDID Cardholder)',
              'हाँ, वरिष्ठ नागरिक विशिष्ट देखभाल आवश्यकता (Senior Citizen High Support Need)'
            ];
          }} else if (key === 'q_family') {{
            options = [
              '1 से 2 सदस्य (1-2 Members · Small Household)',
              '3 से 4 सदस्य (3-4 Members · Standard Family)',
              '5 से 6 सदस्य (5-6 Members · Joint Family)',
              '7 या अधिक सदस्य (7+ Members · Extended Family)'
            ];
          }} else if (key === 'q_age') {{
            options = [
              '18 वर्ष से कम (Below 18 Years · Minor/Student)',
              '18 से 35 वर्ष (18-35 Years · Youth / Young Citizen)',
              '36 से 59 वर्ष (36-59 Years · Working Adult / Family Head)',
              '60 वर्ष या अधिक (60+ Years · Senior Citizen)'
            ];
          }} else if (key === 'q_state') {{
            options = [
              'उत्तर प्रदेश (Uttar Pradesh)',
              'महाराष्ट्र (Maharashtra)',
              'बिहार (Bihar)',
              'पश्चिम बंगाल (West Bengal)',
              'मध्य प्रदेश (Madhya Pradesh)',
              'तमिलनाडु (Tamil Nadu)',
              'राजस्थान (Rajasthan)',
              'कर्नाटक (Karnataka)',
              'गुजरात (Gujarat)',
              'आंध्र प्रदेश (Andhra Pradesh)',
              'ओडिशा (Odisha)',
              'तेलंगाना (Telangana)',
              'केरल (Kerala)',
              'झारखंड (Jharkhand)',
              'असम (Assam)',
              'पंजाब (Punjab)',
              'छत्तीसगढ़ (Chhattisgarh)',
              'हरियाणा (Haryana)',
              'दिल्ली (NCT Delhi)',
              'अन्य राज्य / केंद्र शासित प्रदेश (Other State/UT)'
            ];
          }} else if (key === 'q_need') {{
            options = [
              '💵 प्रत्यक्ष नकद हस्तांतरण एवं आय सहायता (Direct Benefit Transfer - DBT)',
              '🌾 कृषि इनपुट सब्सिडी, बीज एवं उपकरण (Agricultural Seed & Machine Subsidy)',
              '🏥 निःशुल्क स्वास्थ्य सुरक्षा एवं चिकित्सा (Free Inpatient Health Insurance / Ayushman)',
              '🏠 पक्के आवास निर्माण हेतु वित्तीय अनुदान (Pucca Housing Assistance - PMAY)',
              '💼 व्यवसाय प्रारंभ / विस्तार हेतु संपार्श्विक-मुक्त ऋण (Collateral-Free MUDRA Loan)',
              '🎓 उच्च शिक्षा छात्रवृत्ति एवं कौशल प्रशिक्षण (Higher Education Scholarship & Skill Training)',
              '👵 सामाजिक सुरक्षा मासिक पेंशन (Social Security Pension Scheme)'
            ];
          }} else if (key === 'q_sector_focus') {{
            options = [
              '🌾 कृषि, सहकारिता एवं किसान कल्याण (Ministry of Agriculture & Farmers Welfare)',
              '💰 वित्तीय समावेशन, ऋण एवं बैंकिंग सेवाएं (Financial Services, Banking & Mudra)',
              '🏥 लोक स्वास्थ्य, परिवार कल्याण एवं आयुष्मान (Health, Family Welfare & Ayushman)',
              '🏠 ग्रामीण एवं शहरी जन-आवास विकास (Housing, Urban Affairs & Rural Development)',
              '📚 विद्यालयी व उच्च शिक्षा तथा छात्रवृत्ति (School, Higher Education & Scholarships)',
              '💼 कौशल विकास, उद्यमिता एवं रोज़गार (Skill Development & Entrepreneurship)',
              '👵 सामाजिक न्याय, अधिकारिता एवं पेंशन (Social Justice, Empowerment & Pensions)',
              '🛡️ महिला सशक्तिकरण एवं बाल विकास (Women Empowerment & Child Development)'
            ];
          }}

          options.forEach(opt => {{
            const btn = document.createElement('button');
            btn.className = 'w-full py-3 px-3.5 bg-white border border-[#E2DDD3] hover:border-[#F28C28] hover:bg-[#FFF9EE] rounded-2xl text-left text-xs font-bold text-[#0B1830] flex justify-between items-center shadow-sm transition hover:scale-[1.01] group';
            btn.innerHTML = `<span class="pr-2 leading-relaxed">${{opt}}</span><span class="text-[#F28C28] group-hover:translate-x-1 transition text-sm">➔</span>`;
            btn.onclick = () => {{
              userAnswers[key] = opt;
              nextQuestion();
            }};
            chipsContainer.appendChild(btn);
          }});
        }} else {{
          inputField.classList.remove('hidden');
          chipsContainer.classList.add('hidden');
          inputField.value = userAnswers[key] || '';
          inputField.placeholder = "उदा. रमेश कुमार / Ramesh Kumar...";
          inputField.focus();
        }}
      }}
    }}

    function speakCurrentQuestion() {{
      const key = questionsKeys[currentQuestionIdx];
      const dict = allL10n[currentLang] || allL10n['hi'] || allL10n['en'];
      let qText = dict[key] || "Question";
      speakText(qText, currentLang);
    }}

    function toggleSpeechSpeed() {{
      speechSpeed = speechSpeed === 0.78 ? 1.0 : 0.78;
      document.getElementById('btn-speed').innerText = `🐢 Pacing: ${{speechSpeed === 0.78 ? 'Calm (0.78x)' : 'Normal (1.0x)'}}`;
      speakCurrentQuestion();
    }}

    function showWhyAsked() {{
      alert("विभिन्न सरकारी योजनाओं में विशेष अनुदान एवं पात्रता सत्यापन के लिए यह जानकारी मांगी जाती है।");
      speakText("विभिन्न सरकारी योजनाओं में विशेष पात्रता के लिए यह जानकारी आवश्यक है।", currentLang);
    }}

    function toggleRecording() {{
      stopVoice();
      isRecording = !isRecording;
      const btn = document.getElementById('btn-mic');
      const label = document.getElementById('mic-status-label');
      const transcript = document.getElementById('live-transcript-text');
      const key = questionsKeys[currentQuestionIdx];

      if (isRecording) {{
        btn.classList.add('pulse-glow', 'bg-red-600');
        label.innerText = 'सुन रहे हैं... (Listening, tap to finish)';
        transcript.innerText = 'आपकी आवाज़ रिकॉर्ड की जा रही है...';
      }} else {{
        btn.classList.remove('pulse-glow', 'bg-red-600');
        label.innerText = 'बोलने के लिए टैप करें (Tap to Speak)';
        const sample = sampleAnswers[key] || 'उत्तर दर्ज किया गया';
        transcript.innerText = `"${{sample}}" (टेक 1 सुरक्षित)`;
        userAnswers[key] = sample;
      }}
    }}

    // SWITCH OFF VOICE WHEN MOVING FORWARD OR BACKWARD
    function nextQuestion() {{
      stopVoice();
      if (currentQuestionIdx < questionsKeys.length - 1) {{
        currentQuestionIdx++;
        renderCurrentQuestion();
      }} else {{
        // Output language choice screen
        navigateTo('screen-output-lang');
        const defaultTile = document.getElementById(`out-tile-${{selectedOutputLang}}`);
        if (defaultTile) defaultTile.click();
      }}
    }}

    function prevQuestion() {{
      stopVoice();
      if (currentQuestionIdx > 0) {{
        currentQuestionIdx--;
        renderCurrentQuestion();
      }}
    }}

    function skipQuestion() {{
      stopVoice();
      nextQuestion();
    }}

    // ==========================================
    // AI PLAIN-LANGUAGE GIST & HEAR IT OUT
    // ==========================================
    function generateAiGist() {{
      stopVoice();
      const bulletsContainer = document.getElementById('gist-bullets-container');
      bulletsContainer.innerHTML = '';

      let bullets = [];
      let gistTitle = "सरल शब्दों में सारांश:";
      let benefitText = "सीधा लाभ: ₹6,000 हर साल बैंक खाते में (3 किश्तों में)";
      const langObj = languages.find(l => l.code === selectedOutputLang) || languages[0];

      document.getElementById('gist-lang-tag').innerText = `${{langObj.name.toUpperCase()}} GIST (${{langObj.native}})`;

      if (selectedOutputLang === 'hi') {{
        bullets = [
          "यह योजना आपके जैसे किसान परिवार को बिना किसी दलाली के सीधे आर्थिक मदद देती है।",
          "हर 4 महीने में ₹2,000 सीधे आपके बैंक खाते में आएंगे (साल भर में कुल ₹6,000)।",
          "कागज़ात: आपको केवल आधार कार्ड, खतौनी/पट्टा और बैंक पासबुक की ज़रूरत होगी।",
          "जन-सहायक आपकी अर्जी की निःशुल्क जांच करेगा ताकि आवेदन में कोई गलती न हो।"
        ];
        gistTitle = "एआई द्वारा आसान भाषा में सारांश:";
      }} else if (selectedOutputLang === 'mr') {{
        bullets = [
          "ही योजना तुमच्या शेतकरी कुटुंबाला थेट बँक खात्यात आर्थिक मदत देते.",
          "दर चार महिन्यांनी ₹2,000 प्रमाणे वर्षाला एकूण ₹6,000 खात्यात जमा होतील.",
          "कागदपत्रे: फक्त आधार कार्ड, सातबारा आणि बँक पासबुक लागेल.",
          "मदतनीस तुमची कागदपत्रे तपासून अधिकृत खिडकीकडे योग्य मार्गदर्शन करतील."
        ];
        gistTitle = "एआय द्वारे सोप्या शब्दांत सारांश:";
        benefitText = "थेट लाभ: ₹6,000 दरवर्षी बँक खात्यात";
      }} else if (selectedOutputLang === 'bn') {{
        bullets = [
          "এই যোজনাটি আপনার মতো কৃষক পরিবারকে সরাসরি ব্যাঙ্ক অ্যাকাউন্টে আর্থিক সহায়তা প্রদান করে।",
          "প্রতি চার মাস অন্তর ₹২,০০০ করে বছরে মোট ₹৬,০০০ সরাসরি ব্যাঙ্কে জমা হবে।",
          "প্রয়োজনীয় নথিপত্র: শুধুমাত্র আধার কার্ড, জমির খতিয়ান/পাট্টা এবং ব্যাঙ্ক পাসবই।",
          "জনসহায়ক কোনো দালাল ছাড়াই বিনামূল্যে আপনার আবেদন প্রক্রিয়াটি নিশ্চিত করবেন।"
        ];
        gistTitle = "সহজ ভাষায় এআই সারাংশ:";
        benefitText = "সরাসরি লাভ: বছরে ₹৬,০০০ ব্যাঙ্ক অ্যাকাউন্টে";
      }} else if (selectedOutputLang === 'ta') {{
        bullets = [
          "இந்தத் திட்டம் உங்களைப் போன்ற விவசாயக் குடும்பத்திற்கு நேரடியாக வங்கிக் கணக்கில் உதவி வழங்குகிறது.",
          "ஒவ்வொரு 4 மாதங்களுக்கும் ₹2,000 வீதம் ஆண்டுக்கு மொத்தம் ₹6,000 வழங்கப்படும்.",
          "தேவையான ஆவணங்கள்: ஆதார் அட்டை, நிலப் பட்டா மற்றும் வங்கி பாஸ்புக் நகல் மட்டுமே.",
          "இடைத்தரகர் இல்லாமல் நேரடியாக விண்ணப்பிக்க எங்கள் மக்கள் உதவியாளர் வழிகாட்டுவார்."
        ];
        gistTitle = "எளிய தமிழில் AI சுருக்கம்:";
        benefitText = "நேரடிப் பயன்: ஆண்டுக்கு ₹6,000 வங்கிக் கணக்கில்";
      }} else if (selectedOutputLang === 'te') {{
        bullets = [
          "ఈ పథకం మీలాంటి రైతు కుటుంబానికి నేరుగా బ్యాంకు ఖాతాలో ఆర్థిక సహాయం అందిస్తుంది.",
          "ప్రతి 4 నెలలకు ₹2,000 చొప్పున సంవత్సరానికి మొత్తం ₹6,000 నేరుగా అందుతాయి.",
          "కావాల్సిన పత్రాలు: ఆధార్ కార్డు, భూమి పట్టా మరియు బ్యాంకు పాస్‌బుక్ మాత్రమే.",
          "దళారులు లేకుండా ఉచితంగా దరఖాస్తు చేసుకోవడానికి మా సహాయకుడు మీకు సహాయం చేస్తారు."
        ];
        gistTitle = "సులభమైన తెలుగులో AI సారాంశం:";
        benefitText = "ప్రత్యక్ష ప్రయోజనం: సంవత్సరానికి ₹6,000 బ్యాంకు ఖాతాలో";
      }} else if (selectedOutputLang === 'gu') {{
        bullets = [
          "આ યોજના તમારા જેવા ખેડૂત પરિવારને વચેટિયા વગર સીધી આર્થિક સહાય આપે છે.",
          "દર 4 મહિને ₹2,000 સીધા તમારા બેંક ખાતામાં જમા થશે (વાર્ષિક ₹6,000).",
          "દસ્તાવેજો: ફક્ત આધાર कार्ड, જમીનનો સાતબારા અને બેંક પાસબુક.",
          "જન-સહાયક તમારી અરજીની મફત ચકાસણી કરશે જેથી કોઈ ભૂલ ન થાય."
        ];
        gistTitle = "સરળ ગુજરાતીમાં AI સારાંશ:";
        benefitText = "સીધો લાભ: વાર્ષિક ₹6,000 બેંક ખાતામાં";
      }} else if (selectedOutputLang === 'pa') {{
        bullets = [
          "ਇਹ ਸਕੀਮ ਕਿਸਾਨ ਪਰਿਵਾਰ ਨੂੰ ਬਿਨਾਂ ਕਿਸੇ ਵਿਚੋਲੇ ਦੇ ਸਿੱਧੀ ਮਾਲੀ ਮਦਦ ਦਿੰਦੀ ਹੈ।",
          "ਹਰ 4 ਮਹੀਨੇ ਬਾਅਦ ₹2,000 ਸਿੱਧੇ ਤੁਹਾਡੇ ਬੈਂਕ ਖਾਤੇ ਵਿੱਚ ਆਉਣਗੇ (ਸਾਲ ਦੇ ਕੁੱਲ ₹6,000)।",
          "ਕਾਗਜ਼ਾਤ: ਸਿਰਫ਼ ਆਧਾਰ ਕਾਰਡ, ਫ਼ਰਦ/ਪੱਟਾ ਅਤੇ ਬੈਂਕ ਪਾਸਬੁੱਕ।",
          "ਸਾਡੇ ਜਨ-ਸਹਾਇਕ ਵੱਲੋਂ ਬਿਨਾਂ ਕਿਸੇ ਫ਼ੀਸ ਦੇ ਤੁਹਾਡੀ ਮਦਦ ਕੀਤੀ ਜਾਵੇਗੀ।"
        ];
        gistTitle = "ਸਰਲ ਪੰਜਾਬੀ ਵਿੱਚ AI ਸਾਰ:";
        benefitText = "ਸਿੱਧਾ ਲਾਭ: ₹6,000 ਸਾਲਾਨਾ ਬੈਂਕ ਖਾਤੇ ਵਿੱਚ";
      }} else {{
        bullets = [
          "Direct income support of ₹6,000 annually credited in 3 equal installments of ₹2,000.",
          "Money is deposited directly into your bank account without any middlemen.",
          "Documents required: Aadhaar card, Farmland record (Patta), and Bank Passbook.",
          "Civic Help Desk verifies your details free of charge before applying."
        ];
        gistTitle = "AI Plain-Language Summary:";
        benefitText = "Direct Benefit: ₹6,000 per year directly to bank account";
      }}

      document.getElementById('gist-card-title').innerText = gistTitle;
      document.getElementById('gist-benefit-box').innerText = benefitText;

      bullets.forEach(b => {{
        const p = document.createElement('p');
        p.className = 'flex items-start space-x-2';
        p.innerHTML = `<span class="text-[#1F9D6B] font-bold">👉</span><span>${{b}}</span>`;
        bulletsContainer.appendChild(p);
      }});

      navigateTo('screen-gist');
      // Speak immediately in preferred output language
      speakGistSummary();
    }}

    function toggleGistAudio() {{
      if (isGistSpeaking) {{
        stopVoice();
      }} else {{
        speakGistSummary();
      }}
    }}

    function speakGistSummary() {{
      const bullets = Array.from(document.querySelectorAll('#gist-bullets-container p')).map(p => p.innerText.replace('👉', '').trim()).join('. ');
      const benefit = document.getElementById('gist-benefit-box').innerText;
      const fullText = `${{bullets}}. ${{benefit}}.`;

      isGistSpeaking = true;
      document.getElementById('hear-label').innerText = "आवाज़ रोकें (Stop Listening)";
      document.getElementById('hear-icon').innerText = "⏹️";
      speakText(fullText, selectedOutputLang);
    }}

    // ==========================================
    // INTERACTIVE HELP DESK QUERY BOX
    // ==========================================
    function setSampleQuery(q) {{
      document.getElementById('help-desk-query-input').value = q;
      submitHelpDeskQuery();
    }}

    function submitHelpDeskQuery() {{
      const q = document.getElementById('help-desk-query-input').value.trim();
      if (!q) return;

      const answerBox = document.getElementById('help-desk-answer-box');
      const answerText = document.getElementById('help-desk-answer-text');

      let reply = "जन-सहायक परामर्श: चिंता न करें! आप बिना किसी बिचौलिए के सीधे आवेदन कर सकते हैं। हमारा जन-सहायक आपकी पात्रता एवं कागज़ात जांचने में पूर्ण निःशुल्क सहायता करेगा।";

      if (q.includes("पट्टा") || q.includes("ज़मीन") || q.includes("कागज़ात") || q.includes("land") || q.includes("खतौनी")) {{
        reply = "जन-सहायक परामर्श: यदि आपके पास अद्यतन खतौनी या भू-अभिलेख उपलब्ध नहीं है, तो आप अपने ग्राम पंचायत सचिव अथवा पटवारी से निःशुल्क प्रमाणित नकल प्राप्त कर सकते हैं। अधिकृत खिड़की आपके आवेदन को अग्रसारित करने में पूर्ण सहयोग करेगी।";
      }} else if (q.includes("समय") || q.includes("टाइम") || q.includes("time") || q.includes("DBT") || q.includes("किश्त")) {{
        reply = "जन-सहायक परामर्श: जन-सहायक द्वारा सत्यापन एवं पोर्टल स्वीकृति के उपरांत पहली किश्त 15 से 30 कार्य दिवसों के भीतर सीधे आपके आधार-संबद्ध बैंक खाते में जमा हो जाती है।";
      }} else if (q.includes("आधार") || q.includes("बैंक") || q.includes("link") || q.includes("लिंक")) {{
        reply = "जन-सहायक परामर्श: बैंक खाते में आधार एवं NPCI मैपिंग सक्रिय होना आवश्यक है। अपनी बैंक शाखा अथवा डाकघर (IPPB) में जाकर आधार सीडिंग फॉर्म निःशुल्क जमा करें।";
      }} else if (q.includes("केंद्र") || q.includes("CSC") || q.includes("खिड़की") || q.includes("पता")) {{
        reply = "जन-सहायक परामर्श: आपके निकटतम ग्राम पंचायत भवन अथवा वार्ड विकास केंद्र पर जन-सहायक अधिकृत खिड़की उपलब्ध है, जहाँ बिना किसी शुल्क के दस्तावेज़ जांच व अर्जी जमा की जाती है।";
      }}

      answerText.innerText = reply;
      answerBox.classList.remove('hidden');
      speakText(reply, selectedOutputLang);
    }}

    function unlockViaHelper() {{
      speakText('हेल्प डेस्क सहायक से संपर्क स्थापित हुआ। आपकी दस्तावेज़ सूची अब खुल गई है।', selectedOutputLang);
      document.getElementById('help-desk-lock-gate').classList.add('hidden');
      document.getElementById('unlocked-stepper').classList.remove('hidden');
    }}

    function unlockDirectly() {{
      stopVoice();
      document.getElementById('help-desk-lock-gate').classList.add('hidden');
      document.getElementById('unlocked-stepper').classList.remove('hidden');
    }}

    function deleteMyData() {{
      stopVoice();
      if (confirm("Are you sure? This will delete your profile and purge all cached voice recordings.")) {{
        userAnswers = {{}};
        alert("All personal data erased.");
        navigateTo('screen-welcome');
      }}
    }}

    // Initialize Dashboard and Comparisons on Load
    renderDashboardSchemes();
    renderComparison();
    renderLanguageGrid();
  </script>
</body>
</html>
'''

# Write to web/index.html
with open('/Users/jeetganguly/Documents/Notes/To Do/umeed/web/index.html', 'w', encoding='utf-8') as f:
    f.write(html_content)

# Write to brain artifact umeed_app.html
with open('/Users/jeetganguly/.gemini/antigravity/brain/27b1b772-30da-42a0-9ce6-ca578c2c92c0/umeed_app.html', 'w', encoding='utf-8') as f:
    f.write(html_content)

print("Successfully regenerated web/index.html and artifact umeed_app.html!")
