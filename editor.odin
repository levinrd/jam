package game

import rl "vendor:raylib"

Editor :: struct {
    ct: Tile,
    on: bool
}

editor : Editor

init_editor :: proc() {
    editor = {
        ct = .floor,
        on = false,
    }
}

update_editor :: proc() {
    if rl.IsKeyPressed(.TAB) do editor.on =! editor.on
    if rl.IsKeyPressed(.ONE) do editor.ct = .floor
    if rl.IsKeyPressed(.TWO) do editor.ct = .wall
    if rl.IsKeyPressed(.THREE) do editor.ct = .cookie
    if editor.on {
        if rl.IsMouseButtonPressed(.LEFT) {
            pos := screen_to_virtual(rl.GetMousePosition())
            tile_pos := screen_to_grid(pos)
            set_grid_tile(tile_pos, editor.ct)
        }
    }
}

draw_editor :: proc() {
    if editor.on {
        rl.DrawText("EDITOR", 10, 30, 20, rl.RED)
        draw_tile({f32(screen_width - tile_w), 0}, editor.ct)
    }
}
