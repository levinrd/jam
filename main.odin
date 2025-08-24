package main

import "core:fmt"
import rl "vendor:raylib"

Vec2 :: [2]f32

width :: 1000
height :: 1000

grid_size :: 10

tile_w :: width / grid_size
tile_h :: height / grid_size

Tile :: enum {
    floor,
    wall,
}

Grid :: struct {
    tiles: [grid_size][grid_size]Tile,
}

main :: proc() {
    rl.InitWindow(width, height, "Socookie")
    defer rl.CloseWindow()
    rl.SetExitKey(nil)
    rl.SetTargetFPS(60)

    grid : Grid

    for i in 0..<grid_size {
        for j in 0..<grid_size {
            if (i + j) % 2 == 0 {
                grid.tiles[i][j] = .wall
            }
        }
    }

    for !rl.WindowShouldClose() {
        dt := rl.GetFrameTime()

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        rl.DrawFPS(10, 10)
        for i in 0..<grid_size {
            for j in 0..<grid_size {
                color : rl.Color = grid.tiles[i][j] == .floor ? rl.BLUE : rl.BLACK
                rl.DrawRectangle(cast(i32)i * tile_w, cast(i32)j * tile_h, tile_w, tile_h, color)
            }
        }

        rl.EndDrawing()
    }
}
