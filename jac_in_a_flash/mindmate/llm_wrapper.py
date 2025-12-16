import google.generativeai as genai
import os

from dotenv import load_dotenv
load_dotenv()

API_KEY = os.getenv("GEMINI_API_KEY")

if not API_KEY:
    print("⚠️ WARNING: GEMINI_API_KEY not found in environment variables or .env file.")


import time
import random

class GeminiNC:
    def __init__(self, verbose: bool = False, max_tries: int = 10, **kwargs):
        genai.configure(api_key=API_KEY)
        self.model = genai.GenerativeModel("gemini-flash-latest")

    def infer(self, meaning_in: str | list[dict], **kwargs) -> str:
        max_retries = 5
        base_delay = 2
        
        for attempt in range(max_retries):
            try:
                response = self.model.generate_content(meaning_in)
                return response.text
            except Exception as e:
                error_str = str(e)
                if "429" in error_str or "Quota exceeded" in error_str:
                    if attempt < max_retries - 1:
                        # Parse retry delay from error message if possible, otherwise use exponential backoff
                        sleep_time = base_delay * (2 ** attempt) + random.uniform(0, 1)
                        print(f"Quota exceeded. Retrying in {sleep_time:.2f}s...")
                        time.sleep(sleep_time)
                        continue
                return f"Error: {error_str}"
        return "Error: Max retries exceeded."
