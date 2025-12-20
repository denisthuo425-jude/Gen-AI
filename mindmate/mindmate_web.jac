import:py from jac_cloud.core.architype { NodeAnchor }
import:py from jac_cloud.plugin.jaseci { Jac }

# Re-using the same schema would be ideal, but for a standalone demo 
# let's define a minimal self-contained version to avoid import complexity errors.

glob API_KEY = ""; # Loaded from env in real hybrid setup

walker Backend {
    can fetch_advice with `root entry {
        report {"message": "Take a deep breath. You are doing great!", "strategy": "Box Breathing"};
    }
}

client node MindMateUI {
    has data: dict = {"message": "Welcome to MindMate Web", "strategy": "..."};

    can update_ui(new_data: dict) {
        self.data = new_data;
    }

    can render {
        return <div style="font-family: sans-serif; padding: 20px; max-width: 600px; margin: 0 auto; background: #f4f6f8; border-radius: 12px;">
            <h1 style="color: #2e86de;">🧠 MindMate Web</h1>
            <div style="background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                <h3>Current Vibe Check</h3>
                <p><strong>Advice:</strong> {self.data["message"]}</p>
                <p><strong>Strategy:</strong> {self.data["strategy"]}</p>
                
                <button onClick={self.get_advice} style="background: #2e86de; color: white; border: none; padding: 10px 20px; border-radius: 6px; cursor: pointer; font-size: 16px;">
✨ Get Fresh Advice</button>
            </div>
        </div>;
    }

    can get_advice {
        spawn Backend() walk via anchor then (resp) {
            self.update_ui(resp);
        };
    }
}

with entry:client {
    root spawn MindMateUI();
}
