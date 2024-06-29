# Tic-Tac-Toe Game (O - X)
- This is a simple Tic Tac Toe game implemented in Flutter. 
- It allows players to play against each other or Computer opponent.
- The game supports grid sizes of 3x3, 4x4, and 5x5.

## Features
- Choose to play against another player or the Computer
- Select grid size (3x3, 4x4, 5x5)
- Save game history for replay
- Display game board
- Check for a winner


## How to Play
- Select game settings (opponent and grid size) in the Settings screen
- Tap on a cell on the game board to make a move
- The game will alternate between players until there is a winner or a draw
- View game history on the Replay screen

## Design and Algorithm
- The game board is represented by a 2D array
- The Computer opponent uses a simple algorithm to make moves:
    - If the Computer can win in the next move, it will make that move
    - If the player can win in the next move, the Computer will block that move
    - Otherwise, the Computer will make a random move

