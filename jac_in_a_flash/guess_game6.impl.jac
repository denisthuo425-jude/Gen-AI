impl GuessGame.start {
    print("Welcome to the Number Guessing Game!");
    attempts_msg = f"You have {self.attempts} attempts.";
    print(attempts_msg);

    # Input validation loop
    while True {
        print("Guess a number between 1 and 10:");
        raw = input();
        if raw.isdigit() {
            self.guess = int(raw);
            break;
        } else {
            print("That's not a valid number. Please enter digits only.");
        }
    }
    self.process_guess();
}

impl GuessGame.process_guess {
    # Compare guess
    if self.guess == self.correct_number {
        print("Congrats! You guessed the number 🎉");
        disengage;
    }

    # Wrong guess path
    self.attempts = self.attempts - 1;
    hint = give_hint(self.guess, self.correct_number);
    print("Wrong guess! Hint:", hint);

    if self.attempts <= 0 {
        print(f"Out of attempts. The number was {self.correct_number}.");
        disengage;
    }

    # Ask again with validation
    while True {
        print(f"Try again ({self.attempts} attempts left):");
        raw = input();
        if raw.isdigit() {
            self.guess = int(raw);
            break;
        } else {
            print("That's not a valid number. Please enter digits only.");
        }
    }

    # Recurse to check the new guess
    self.process_guess();
}
