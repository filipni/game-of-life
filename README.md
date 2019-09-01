# Game of Life
This is a game where you create cool patterns by placing "cells" in a grid. The cells multiply based on a few simple rules:

1. Any live cell with fewer than two live neighbours dies, as if by underpopulation.
2. Any live cell with two or three live neighbours lives on to the next generation.
3. Any live cell with more than three live neighbours dies, as if by overpopulation.
4. Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.

For more information about the game, checkout the [Wikipedia article](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life).

## Dependencies
* [gtkada](https://github.com/AdaCore/gtkada)
