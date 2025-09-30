"""A Number Guessing Game"""
import random;

# Base game object
obj Game {
    has attempts: int, won: bool = False;

    def play;
}

# Subclassed game
obj GuessTheNumberGame (Game) {
    def init;
    override def play;
    def process_guess(guess: int);
}

# Implementations
impl GuessTheNumberGame.init {
    self.attempts = 3;
    self.won = False;
    self.correct_number = random.randint(1, 10);   # ✅ initialize here
}

impl GuessTheNumberGame.play {
    while self.attempts > 0 and not self.won {
        print("Guess a number between 1 and 10: ");
        let guess = int(input());
        self.process_guess(guess);
    }

    if not self.won {
        print("Game over. The number was", self.correct_number);
    }
}

impl GuessTheNumberGame.process_guess {
    if guess == self.correct_number {
        print("Correct! You win!");
        self.won = True;
    } else {
        self.attempts -= 1;
        print("Wrong guess. Attempts left:", self.attempts);
    }
}

# Run the game
with entry {
    game = GuessTheNumberGame();
    game.play();
}
