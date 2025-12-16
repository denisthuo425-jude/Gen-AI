# ---------------------------------
# main.jac
# Project: MindMate Harmony Space
# Edition: Professional Enterprise (Hybrid AI)
# ---------------------------------

import datetime;
import google.generativeai;
import os;
import:py from dotenv { load_dotenv }
load_dotenv();

# ==========================================================
# 🔐 CONFIGURATION
# API Key is loaded from .env file for security.
# ==========================================================
glob API_KEY = os.getenv("GEMINI_API_KEY");


# --- 1. Graph Schema (The Memory) ---
node User { has name: str = "RootUser"; }
node MoodEntry { has mood: str; has timestamp: str; }
node Trigger { has label: str; }

edge HasMood { }
edge CausedBy { }


# --- 2. MoodLogger (The Architect) ---
walker MoodLogger {
    has mood: str;
    has trigger_label: str;

    can log_mood with `root entry {
        try {
            # 1. Create Mood Node
            time_str = str(datetime.datetime.now());
            new_mood = MoodEntry(mood=self.mood, timestamp=time_str);

            # 2. Graph Deduplication (Professional OSP Pattern)
            found_trigger = None;
            for m in [here --> (`?MoodEntry)] {
                for t in [m --> (`?Trigger)] {
                    if t.label == self.trigger_label {
                        found_trigger = t;
                    }
                }
            }

            trigger_node = found_trigger;
            if trigger_node == None {
                trigger_node = Trigger(label=self.trigger_label);
                print("   🧠 [Graph] Learned new trigger:", self.trigger_label);
            } else {
                print("   🧠 [Graph] Deepening existing pattern:", self.trigger_label);
            }

            # 3. Connect Graph
            here ++> new_mood;
            new_mood ++> trigger_node;
            print("   ✅ [System] Data successfully modeled.");

        } except Exception as e {
            print("Error in MoodLogger:", e);
        }
    }
}


# --- 3. PatternDetector (The Analyst) ---
walker PatternDetector {
    has dominant_stressor: str = "None";
    has dominant_mood: str = "Neutral";

    can detect_patterns with `root entry {
        try {
            counts = {};
            last_mood = {}; 

            # Traverse Graph to Aggregate Data
            for m in [here --> (`?MoodEntry)] {
                current_mood = m.mood;
                for t in [m --> (`?Trigger)] {
                    lbl = t.label;
                    if lbl in counts { counts[lbl] = counts[lbl] + 1; }
                    else { counts[lbl] = 1; }
                    last_mood[lbl] = current_mood;
                }
            }

            # Statistical Analysis
            max_count = 0;
            dom_key = "None";
            for key in counts {
                val = counts[key];
                if val > max_count {
                    max_count = val;
                    dom_key = key;
                }
            }
            
            self.dominant_stressor = dom_key;
            if dom_key in last_mood {
                self.dominant_mood = last_mood[dom_key];
            }

        } except Exception as e {
            print("Error in PatternDetector:", e);
        }
    }
}


# --- 4. CopingStrategist (The Hybrid Intelligence) ---
walker CopingStrategist {
    has stressor: str;
    has mood: str;

    can advise with `root entry {
        print(" ");
        print("✨ MindMate AI Insight ✨");
        print("-----------------------");
        
        try {
            # --- STRATEGY A: REAL GEN-AI (Gemini) ---
            if API_KEY != "" and API_KEY != "PASTE_YOUR_GEMINI_API_KEY_HERE" {
                
                # Configure the AI
                google.generativeai.configure(api_key=API_KEY);
                model = google.generativeai.GenerativeModel("gemini-2.0-flash");
                
                # Dynamic Prompt Engineering
                prompt = "I am feeling " + self.mood + " because of " + self.stressor + ". Give me one specific, scientific, 1-sentence coping strategy. Be empathetic but practical.";
                
                response = model.generate_content(prompt);
                
                print("🤖 AI Analysis for:", self.stressor);
                print("👉 Strategy:", response.text);
            
            } else {
                # --- STRATEGY B: FALLBACK RULES (Circuit Breaker) ---
                # This ensures the demo NEVER fails, even if internet is down.
                raise Exception("No API Key configured. Switching to Offline Mode.");
            }

        } except Exception as e {
            # Robust Fallback Logic
            print("⚠️  (Offline Mode Active)");
            
            s = self.stressor.lower();
            if "deadline" in s {
                print("👉 Strategy: Pomodoro Technique (25m Focus / 5m Rest).");
            } elif "work" in s {
                print("👉 Strategy: Boundary Setting. Disconnect after hours.");
            } else {
                print("👉 Strategy: Box Breathing (Inhale 4s, Hold 4s, Exhale 4s).");
            }
        }
        print("-----------------------");
        print(" ");
    }
}


# --- 5. Interactive Client (Enterprise Interface) ---
with entry {
    print(" ");
    print("===========================================");
    print("💙 MindMate Professional v1.0 💙");
    print("   Powered by Jaclang Graph + Google Gemini");
    print("===========================================");
    print("Commands:");
    print("  [Mood] | [Trigger]  -> Log entry (e.g. 'Anxious | Deadlines')");
    print("  report              -> Analyze patterns");
    print("  exit                -> Quit");
    print("-------------------------------------------");

    while True {
        raw_input = input("\n👤 [You]: ");
        clean_input = raw_input.replace("'", "").replace('"', "").strip();

        if clean_input == "exit" {
            print("👋 Session Ended.");
            break;
        }

        if clean_input == "report" {
            detector = root spawn PatternDetector();
            print("📊 Dominant Pattern:", detector.dominant_stressor, "(" + detector.dominant_mood + ")");
            continue;
        }

        if "|" in clean_input {
            parts = clean_input.split("|");
            m_val = parts[0].strip();
            t_val = parts[1].strip();
            
            # 1. Store in Graph (Permanent Memory)
            root spawn MoodLogger(mood=m_val, trigger_label=t_val);
            
            # 2. Analyze Context
            detector = root spawn PatternDetector();
            
            # 3. Generate AI Advice (Hybrid Engine)
            # Only trigger advice if the new log matches the dominant stressor
            if detector.dominant_stressor == t_val {
                 root spawn CopingStrategist(stressor=t_val, mood=m_val);
            }

        } else {
            # Conversational Handling
            print("🤖 [MindMate]: I'm listening. What triggered this feeling?");
            trig_input = input("   ↳ [Trigger]: ");
            
            root spawn MoodLogger(mood=clean_input, trigger_label=trig_input);
            
            # Immediate feedback loop
            root spawn CopingStrategist(stressor=trig_input, mood=clean_input);
        }
    }
}