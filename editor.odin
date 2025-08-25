package game

import rl "vendor:raylib"

editor_on := false

update_editor :: proc() {
    if rl.IsKeyPressed(.TAB) do editor_on =! editor_on
    if editor_on {
        if rl.IsMouseButtonPressed(.LEFT) {
            pos := screen_to_virtual(rl.GetMousePosition())
            tile_pos := screen_to_grid(pos)
            old := g.grid.tiles[tile_pos[0]][tile_pos[1]]
            new : Tile = old == .floor ? .wall : .floor
            set_grid_tile(tile_pos, new)
        }
    }
}

draw_editor :: proc() {
    if editor_on {
        rl.DrawText("EDITOR", 10, 30, 20, rl.RED)
    }
}
