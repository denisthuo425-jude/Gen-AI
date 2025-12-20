# MindMate Harmony Space 🧠

MindMate is an AI-powered companion for mental well-being, built with [Jaclang](https://github.com/Jaseci-Labs/jaclang) and Google Gemini.

It features two modes of operation:
1.  **CLI Mode**: A standalone, interactive command-line interface.
2.  **Web App Mode**: A modern web interface built with Streamlit, communicating with a Jaclang backend.

## 📂 Project Structure

-   `mindmate_cli.jac`: The standalone CLI application.
-   `mindmate_api.jac`: The backend API for the Web App.
-   `app.py`: The Streamlit frontend for the Web App.
-   `mindmate_web.jac`: **(Bonus)** Experimental Native Jac-Client Frontend.

## 🚀 How to Run

### Option 1: CLI Mode (Interactive Terminal)

Run the standalone Jac program:

```bash
jac run mindmate_cli.jac
```

Follow the on-screen prompts to log your mood and get AI advice.

### Option 2: Web App Mode (Browser Interface)

This requires two terminal windows.

**Terminal 1: Start the Backend Server**

```bash
jac serve mindmate_api.jac
```
*This starts the Jac server on `http://localhost:8000`.*

**Terminal 2: Start the Frontend**

```bash
streamlit run app.py
```
*This will open the web app in your browser (usually `http://localhost:8501`).*

## 🔑 Configuration

To enable real AI features, you need a Google Gemini API Key.

1.  **Create a `.env` file** in the project root:
    ```bash
    touch .env
    ```
2.  **Add your API Key** to the `.env` file:
    ```env
    GEMINI_API_KEY=your_api_key_here
    ```

> **Note**: The `.env` file is git-ignored to keep your secrets safe. Do not commit it to GitHub.

