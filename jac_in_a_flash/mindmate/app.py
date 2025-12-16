import streamlit as st
import requests

# This points to your running Jac Server
API_URL = "http://localhost:8000"

st.set_page_config(page_title="MindMate Harmony Space", page_icon="🧠", layout="centered")

# Custom CSS for a professional look
st.markdown("""
    <style>
    .stButton>button { width: 100%; border-radius: 8px; }
    .reportview-container { background: #f0f2f6; }
    h1 { color: #2e86de; }
    </style>
""", unsafe_allow_html=True)

st.title("🧠 MindMate Harmony Space")
st.markdown("### *AI Companion for Mental Well-being*")

# --- TAB NAVIGATION ---
tab1, tab2, tab3, tab4, tab5 = st.tabs(["📝 Log Mood", "📊 Insights", "🧘 Advice", "📖 Journal", "📅 Weekly Plan"])

# --- TAB 1: LOGGING ---
with tab1:
    st.write("How are you feeling right now?")
    col1, col2 = st.columns(2)
    with col1:
        mood = st.text_input("Mood", placeholder="e.g. Anxious")
    with col2:
        trigger = st.text_input("Trigger", placeholder="e.g. Deadlines")
    
    if st.button("💾 Log Entry", type="primary"):
        if mood and trigger:
            with st.spinner("Processing Graph Node..."):
                try:
                    payload = {
                        "mood": mood, 
                        "trigger_label": trigger
                    }
                    
                    res = requests.post(f"{API_URL}/walker/MoodLogger", json=payload)
                    
                    if res.status_code == 200:
                        data = res.json()
                        if "reports" in data and len(data["reports"]) > 0:
                            report_data = data["reports"][0]
                            if report_data.get("status") == "error":
                                st.error(f"❌ {report_data.get('message')}")
                            else:
                                st.success(f"✅ {report_data.get('message', 'Logged!')}")
                        else:
                            st.success("✅ Logged successfully.")
                    else:
                        st.error(f"Server Error: {res.status_code}")
                except Exception as e:
                    st.error(f"Connection Failed: {e}")
        else:
            st.warning("Please fill in both fields.")

# --- TAB 2: ANALYSIS ---
with tab2:
    st.write("Analyze your emotional patterns.")
    if st.button("🔍 Generate Report"):
        with st.spinner("Traversing Knowledge Graph..."):
            try:
                res = requests.post(f"{API_URL}/walker/PatternDetector", json={})
                if res.status_code == 200:
                    data = res.json()
                    
                    if "reports" in data and len(data["reports"]) > 0:
                        viz_data = data["reports"][0]
                        dom = viz_data.get("dominant_stressor", "None")
                        
                        st.metric(label="🚨 Dominant Stressor", value=dom)
                        st.write("---")
                        
                        # Visualizing the data
                        counts = viz_data.get("all_counts", {})
                        if counts:
                            st.bar_chart(counts)
                        else:
                            st.write("No patterns detected yet.")
                    else:
                        st.info("No data found yet. Log some moods first!")
                else:
                    st.error("Failed to fetch report.")
            except Exception as e:
                st.error(f"Connection Error: {e}")

# --- TAB 3: AI ADVICE ---
with tab3:
    st.write("Get personalized, generative advice.")
    target = st.text_input("What is bothering you?", placeholder="e.g. Deadlines")
    feeling = st.text_input("Context / Feeling", placeholder="e.g. Stressed")
    
    if st.button("✨ Get AI Strategy"):
        if target and feeling:
            with st.spinner("Consulting Gemini AI..."):
                try:
                    payload = {
                        "stressor": target, 
                        "mood": feeling
                    }
                    
                    res = requests.post(f"{API_URL}/walker/CopingStrategist", json=payload)
                    
                    if res.status_code == 200:
                        data = res.json()
                        if "reports" in data and len(data["reports"]) > 0:
                            report_content = data["reports"][0]
                            if "error" in report_content:
                                st.error(f"Backend Logic Error: {report_content['error']}")
                            else:
                                strategy = report_content.get("strategy", "No strategy found.")
                                st.info(f"**Strategy for {target}:**")
                                st.write(strategy)
                        else:
                            st.warning("AI ran but returned no advice.")
                    else:
                        st.error(f"Server Error: {res.status_code}")
                except Exception as e:
                    st.error(f"Connection Error: {e}")

# --- TAB 4: JOURNAL ---
with tab4:
    st.write("Secure Journaling with Sentiment Analysis")
    journal_text = st.text_area("Dear Diary...", height=150)
    
    col1, col2 = st.columns(2)
    with col1:
        if st.button("💾 Save Entry"):
            if journal_text:
                with st.spinner("Saving..."):
                    try:
                        payload = {"text": journal_text}
                        res = requests.post(f"{API_URL}/walker/JournalLogger", json=payload)
                        if res.status_code == 200:
                            st.success("Entry saved!")
                        else:
                            st.error("Failed to save.")
                    except Exception as e:
                        st.error(f"Error: {e}")
    
    with col2:
        if st.button("🧠 Analyze Sentiment"):
            if journal_text:
                with st.spinner("Analyzing..."):
                    try:
                        payload = {"text": journal_text}
                        res = requests.post(f"{API_URL}/walker/SentimentAnalyzer", json=payload)
                        if res.status_code == 200:
                            data = res.json()
                            if "reports" in data and len(data["reports"]) > 0:
                                score = data["reports"][0].get("score", 0)
                                st.metric("Sentiment Score", f"{score}/10")
                                if score > 5:
                                    st.balloons()
                                elif score < 0:
                                    st.warning("It seems you're having a tough time. Check the Advice tab.")
                            else:
                                st.warning("No score returned.")
                        else:
                            st.error("Failed to analyze.")
                    except Exception as e:
                        st.error(f"Error: {e}")

# --- TAB 5: WEEKLY PLAN ---
with tab5:
    st.write("Generate a weekly plan based on your mood history.")
    if st.button("📅 Generate Plan"):
        with st.spinner("Reviewing your week..."):
            try:
                res = requests.post(f"{API_URL}/walker/WeeklyPlanner", json={})
                if res.status_code == 200:
                    data = res.json()
                    if "reports" in data and len(data["reports"]) > 0:
                        plan = data["reports"][0].get("plan", "No plan generated.")
                        st.markdown("### Your Personalized Plan")
                        st.write(plan)
                    else:
                        st.info("Not enough data to generate a plan.")
                else:
                    st.error("Failed to generate plan.")
            except Exception as e:
                st.error(f"Connection Error: {e}")