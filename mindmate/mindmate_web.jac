import jsx_client;
import:py from byllm.lib { Model }

# --- 1. CONFIGURATION ---
glob llm = Model(model_name="gemini/gemini-2.0-flash", verbose=True);

# --- 2. BACKEND LOGIC (Native byLLM) ---
def generate_strategy_llm(stressor: str, mood: str) -> str by llm(
    context=["You are an empathetic mental health assistant.", 
             "Provide a simple, actionable, and comforting 1-sentence coping strategy.", 
             "Avoid jargon."]
);

# --- 3. BACKEND WALKER ---
walker Backend {
    can get_strategy(mood: str, stressor: str) {
        if mood == "" or stressor == "" {
            report {"strategy": "Please tell me how you feel first!"};
        } else {
            strat = generate_strategy_llm(stressor, mood);
            report {"strategy": strat};
        }
    }
}

# --- 4. FRONTEND CLIENT (React-Style) ---
client node MindMateApp {
    has data: dict = {
        "mood": "",
        "stressor": "",
        "strategy": "Your AI advice will appear here...",
        "loading": False
    };

    # UI Events
    can set_mood(e: dict) { self.data["mood"] = e["target"]["value"]; self.render(); }
    can set_stressor(e: dict) { self.data["stressor"] = e["target"]["value"]; self.render(); }

    can get_advice_click(e: dict) {
        self.data["loading"] = True;
        self.data["strategy"] = "Thinking...";
        self.render();

        spawn Backend() walk via anchor then (resp) {
            self.data["loading"] = False;
            self.data["strategy"] = resp["strategy"];
            self.render();
        };
    }

    # Render View
    can render() -> jsx_client.JSX {
        return jsx_client.div(
            {"style": "font-family: Arial; max-width: 600px; margin: 40px auto; padding: 20px; background: #f8f9fa; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);"},
            
            jsx_client.h1({"style": "color: #2e86de; text-align: center;"}, "🧠 MindMate Web"),
            jsx_client.p({"style": "text-align: center; color: #666;"}, "Native Jac-Client Edition"),
            
            jsx_client.div(
                {"style": "margin-bottom: 20px;"},
                jsx_client.label({"style": "display: block; margin-bottom: 8px; font-weight: bold;"}, "Current Mood"),
                jsx_client.input({
                    "type": "text", 
                    "placeholder": "e.g. Anxious", 
                    "value": self.data["mood"],
                    "onChange": self.set_mood,
                    "style": "width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 6px;"
                })
            ),

            jsx_client.div(
                {"style": "margin-bottom: 20px;"},
                jsx_client.label({"style": "display: block; margin-bottom: 8px; font-weight: bold;"}, "Stressor / Trigger"),
                jsx_client.input({
                    "type": "text", 
                    "placeholder": "e.g. Work Deadlines", 
                    "value": self.data["stressor"],
                    "onChange": self.set_stressor,
                    "style": "width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 6px;"
                })
            ),

            jsx_client.button({
                "onClick": self.get_advice_click,
                "disabled": self.data["loading"],
                "style": "width: 100%; padding: 12px; background: #2e86de; color: white; border: none; border-radius: 6px; font-size: 16px; cursor: pointer;"
            }, "✨ Get AI Strategy"),

            jsx_client.div(
                {"style": "margin-top: 30px; padding: 20px; background: white; border-radius: 8px; border-left: 5px solid #2e86de;"},
                jsx_client.h3({"style": "margin-top: 0;"}, "💡 Coping Strategy"),
                jsx_client.p({"style": "font-size: 1.1em; line-height: 1.5;"}, self.data["strategy"])
            )
        );
    }
}

with entry:client {
    root spawn MindMateApp();
}
