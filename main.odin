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

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        rl.EndDrawing()
    }
}
