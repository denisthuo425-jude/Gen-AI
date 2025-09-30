Jac in a Flash 🚀

This project follows the Jac in a Flash tutorial
 to learn the Jac programming language.
We start with a simple Python game and gradually evolve it into a fully object-spatial Jac implementation.

Each step introduces new Jac features while keeping the game logic the same.

📚 Steps Overview
Step 0 – Python version

A standard Python program that implements a "guess the number" game.
File: guess_game.py

Step 1 – Direct Jac translation

Line-for-line translation of Python into Jac.

Introduces obj, def, and Jac syntax basics.
File: guess_game1.jac

Step 2 – Declaring fields with has

Moves attributes into the class body using has.
File: guess_game2.jac

Step 3 – Separating interface and implementation

Uses impl to split object signatures from method bodies.
File:
guess_game3.jac

Step 4 – Walking the graph

Re-imagines the game using Jac’s object-spatial architecture.

Walkers (walker) visit nodes (node) through edges.
File:
guess_game4.jac

Step 5 – Scale-agnostic approach

Demonstrates how Jac code can seamlessly run locally or scale to the cloud.

jac serve filename.jac turns walkers into HTTP endpoints.
File:
guess_game5.jac


Step 6 – AI-Enhanced Gameplay

Integrates byLLM to provide intelligent hints instead of static “too high / too low” feedback.
File:
guess_game6.jac

