package game

import rl "vendor:raylib"

update_editor :: proc() {
    if rl.IsMouseButtonPressed(.LEFT) {
        pos := screen_to_virtual(rl.GetMousePosition())
        tile_pos := screen_to_grid(pos)
        old := g.grid.tiles[tile_pos[0]][tile_pos[1]]
        new : Tile = old == .floor ? .wall : .floor
        set_grid_tile(tile_pos, new)
    }
}
