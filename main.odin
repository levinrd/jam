package game

import "core:fmt"
import "core:os"
import rl "vendor:raylib"

Vec2 :: [2]f32
Rect :: rl.Rectangle

width :: 1000
height :: 1000

grid_size :: 10

atlas : rl.Texture

main :: proc() {
    rl.InitWindow(width, height, "Socookie")
    defer rl.CloseWindow()
    rl.SetExitKey(nil)
    rl.SetTargetFPS(60)

    atlas = rl.LoadTexture(TEXTURE_ATLAS_FILENAME)

    grid : Grid
    if !os.exists("level.txt") {
        fill_grid(&grid)
    } else {
        load_grid(&grid, "level.txt")
    }

    player : Player

    for !rl.WindowShouldClose() {
        dt := rl.GetFrameTime()
        mouse_pos : Vec2 = rl.GetMousePosition()
        update_player(&player, &grid)

        if rl.IsKeyDown(.LEFT_CONTROL) || rl.IsKeyDown(.RIGHT_CONTROL) {
            if rl.IsKeyPressed(.S) {
                save_grid(&grid, "level.txt")
            }
            if rl.IsKeyPressed(.L) {
                load_grid(&grid, "level.txt")
            }
        }

        if rl.IsMouseButtonPressed(.LEFT) {
            pos := rl.GetMousePosition()
            tile_pos := screen_to_grid(pos)
            old := grid.tiles[tile_pos[0]][tile_pos[1]]
            new : Tile = old == .floor ? .wall : .floor
            set_grid_tile(&grid, tile_pos, new)
        }

        rl.BeginDrawing()
        rl.ClearBackground(rl.WHITE)
        update_and_draw_grid(&grid)
        draw_player(&player)
        rl.DrawFPS(10, 10)
        rl.EndDrawing()
    }
}
