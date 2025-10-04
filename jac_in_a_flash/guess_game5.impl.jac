impl GuessGame.start with `root entry {
    print("Welcome to the Number Guessing Game (node-based)!");
    # When spawned at root, move to the first turn node if any
    # Visit outgoing turn nodes from root
    visit [-->];
}

impl GuessGame.process_guess with turn entry {
    # `here` is the current turn node which has correct_number
    print("Guess a number between 1 and 10:");
    guess = int(input());
    if guess == here.correct_number {
        print("Congrats! You guessed the number 🎉");
        disengage;
    } else {
        if guess < here.correct_number {
            print("Too low");
        } else {
            print("Too high");
        }
        # Continue to next turn node
        visit [-->];
    }
}
