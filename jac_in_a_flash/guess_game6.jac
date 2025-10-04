import random;
import byllm.llm;

# Toggle: set to True to attempt calling the configured LLM. Default false so
# the example runs without API keys. To enable, set USE_LLM = True and ensure
# appropriate credentials are available to your byLLM provider (see docs).
glob USE_LLM = False;

glob llm = byllm.llm.Model(model_name="gemini/gemini-2.0-flash", verbose=False);

# give_hint will try the LLM if USE_LLM is True, otherwise fallback to
# deterministic local hints. LLM call is wrapped to fall back safely on any
# error.
def give_hint(guess: int, correct_number: int) -> str {
    if USE_LLM {
        # Simple prompt - replace with richer prompt if desired.
        prompt = f"Player guessed {guess}. The correct number is {correct_number}. Give a short helpful hint (<= 20 chars).";
        resp = llm(prompt);
        # Ensure resp is printable string; fallback otherwise
        if type(resp) == str and resp {
            return resp;
        }
    }

    # Local deterministic fallback
    if guess < correct_number {
        return "Too low";
    } elif guess > correct_number {
        return "Too high";
    } else {
        return "Correct";
    }
}

walker GuessGame {
    # Track the current guess and a secret number per-walker (scale-safe)
    has guess: int, correct_number: int = random.randint(1, 10);

    # Maximum attempts before the walker disengages
    has attempts: int = 5;

    can start with `root entry;
    def process_guess;
}

node turn {
    has correct_number: int = random.randint(1, 10);
}

with entry:__main__ {
    root spawn GuessGame(0);
}
