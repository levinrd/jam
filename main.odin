package main

import "core:fmt"
import rl "vendor:raylib"

Vec2 :: [2]f32

width :: 1000
height :: 1000

grid_size :: 10

main :: proc() {
    rl.InitWindow(width, height, "Socookie")
    defer rl.CloseWindow()
    rl.SetExitKey(nil)
    rl.SetTargetFPS(60)

    grid : Grid
    fill_grid(&grid)

    for !rl.WindowShouldClose() {
        dt := rl.GetFrameTime()
        mouse_pos : Vec2 = rl.GetMousePosition()

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        rl.DrawFPS(10, 1)
        update_and_draw_grid(&grid)

        if rl.IsMouseButtonPressed(.LEFT) {
            pos := rl.GetMousePosition()
            tile_pos := screen_to_grid(pos)
            old := grid.tiles[tile_pos[0]][tile_pos[1]]
            new : Tile = old == .floor ? .wall : .floor
            set_grid_tile(&grid, tile_pos, new)
        }

        rl.EndDrawing()
    }
}
