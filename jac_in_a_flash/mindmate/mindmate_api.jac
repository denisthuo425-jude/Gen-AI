# ---------------------------------
# mindmate_api.jac
# Project: MindMate Harmony Space
# Status: Final Robust (Dual-Mode Data Entry)
# ---------------------------------

import datetime;
import llm_wrapper;

glob llm = llm_wrapper.GeminiNC();

# --- 1. Graph Schema ---
node User { has name: str = "RootUser"; }
node MoodEntry { has mood: str; has timestamp: str; }
node Trigger { has label: str; }
node JournalEntry { has text: str; has timestamp: str; }
node Activity { has name: str; has type: str; }

edge HasMood { }
edge CausedBy { }
edge HasJournal { }
edge Recommended { }

# --- 2. MoodLogger ---
walker MoodLogger {
    has mood: str = "";
    has trigger_label: str = "";

    can log_mood with `root entry {
        try {
            # 1. Validation
            if self.mood == "" or self.trigger_label == "" {
                report {"status": "error", "message": "Missing mood or trigger data."};
                disengage;
            }

            time_str = str(datetime.datetime.now());
            new_mood = MoodEntry(mood=self.mood, timestamp=time_str);

            found_trigger = None;
            for m in [here --> (`?MoodEntry)] {
                for t in [m --> (`?Trigger)] {
                    if t.label == self.trigger_label {
                        found_trigger = t;
                    }
                }
            }

            trigger_node = found_trigger;
            msg = "";
            if trigger_node == None {
                trigger_node = Trigger(label=self.trigger_label);
                msg = "New Trigger Created: " + self.trigger_label;
            } else {
                msg = "Existing Trigger Reused: " + self.trigger_label;
            }

            here ++> new_mood;
            new_mood ++> trigger_node;
            
            report {"status": "success", "message": msg};

        } except Exception as e {
            report {"status": "error", "message": str(e)};
        }
    }
}

# --- 3. PatternDetector ---
walker PatternDetector {
    has dominant_stressor: str = "None";

    can detect_patterns with `root entry {
        try {
            counts = {};
            for m in [here --> (`?MoodEntry)] {
                for t in [m --> (`?Trigger)] {
                    lbl = t.label;
                    if lbl in counts { counts[lbl] = counts[lbl] + 1; }
                    else { counts[lbl] = 1; }
                }
            }

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
            
            report {
                "dominant_stressor": dom_key,
                "all_counts": counts
            };

        } except Exception as e {
            report {"error": str(e)};
        }
    }
}

# --- 4. CopingStrategist (Generative Agent) ---
walker CopingStrategist {
    has stressor: str = "";
    has mood: str = "";

    can run_advice with `root entry {
        try {
            if self.stressor == "" {
                report {"error": "No stressor provided."};
                disengage;
            }
            
            prompt = "You are an empathetic mental health assistant. Provide a simple, actionable, and comforting 1-sentence coping strategy. Avoid jargon. Context: I am feeling " + self.mood + " because of " + self.stressor;
            strategy = llm.infer(meaning_in=prompt, kwargs={});
            
            report {"stressor": self.stressor, "strategy": strategy};

        } except Exception as e {
            report {"error": str(e)};
        }
    }
}

# --- 5. SentimentAnalyzer (Analytical Agent) ---
walker SentimentAnalyzer {
    has text: str = "";

    can run_analysis with `root entry {
        try {
            prompt = "Analyze the sentiment of the text. Return a score from -10 (very negative) to 10 (very positive). Return ONLY the number. Text: " + self.text;
            result = llm.infer(meaning_in=prompt, kwargs={});
            score = 0;
            try {
                score = int(result);
            } except Exception {
                score = 0;
            }
            report {"text": self.text, "score": score};
        } except Exception as e {
            report {"error": str(e)};
        }
    }
}

# --- 6. WeeklyPlanner (Planner Agent) ---
walker WeeklyPlanner {

    has mood_history: list = [];

    can run_plan with `root entry {
        try {
            # Gather history
            history = [];
            for m in [here --> (`?MoodEntry)] {
                history.append(m.mood);
            }
            
            # Limit to last 7
            if len(history) > 7 {
                history = history[-7:];
            }
            
            self.mood_history = history;
            
            prompt = "Based on the user's mood history, generate a simple 3-point weekly plan to improve their well-being. Format as a list. History: " + str(self.mood_history);
            weekly_plan = llm.infer(meaning_in=prompt, kwargs={});
            
            report {"plan": weekly_plan};

        } except Exception as e {
            report {"error": str(e)};
        }
    }
}

# --- 7. JournalLogger ---
walker JournalLogger {
    has text: str = "";

    can log_journal with `root entry {
        try {
            time_str = str(datetime.datetime.now());
            entry = JournalEntry(text=self.text, timestamp=time_str);
            here ++> entry;
            report {"status": "success", "message": "Journal entry logged."};
        } except Exception as e {
            report {"error": str(e)};
        }
    }
}