import from mindmate_api { MoodLogger }

with entry {
    print("🌱 Seeding Graph Data...");
    
    # Sample Data
    data = [
        {"mood": "Anxious", "trigger": "Deadlines"},
        {"mood": "Stressed", "trigger": "Work"},
        {"mood": "Happy", "trigger": "Exercise"},
        {"mood": "Anxious", "trigger": "Deadlines"},
        {"mood": "Calm", "trigger": "Meditation"},
        {"mood": "Stressed", "trigger": "Deadlines"},
        {"mood": "Sad", "trigger": "Rain"}
    ];

    for item in data {
        MoodLogger(mood=item["mood"], trigger_label=item["trigger"]) spawn root;
        print("   Logged:", item["mood"], "|", item["trigger"]);
    }
    
    print("✅ Seeding Complete!");
}
