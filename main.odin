package main

import rl "vendor:raylib"

Vec2 :: [2]f32

width :: 1280
height :: 720

Tile :: enum {
    floor,
    wall,
}

Grid :: struct {
    tiles: [10][10]Tile,
}

main :: proc() {
    rl.InitWindow(width, height, "Socookie")
    defer rl.CloseWindow()
    rl.SetExitKey(nil)
    rl.SetTargetFPS(60)

    for !rl.WindowShouldClose() {
        dt := rl.GetFrameTime()

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        rl.DrawFPS(10, 10)
        rl.EndDrawing()
    }
}
