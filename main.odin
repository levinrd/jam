package main

import rl "vendor:raylib"

Vec2 :: [2]f32

width :: 1280
height :: 720

Game :: struct {
    level: [dynamic]Grid,
    player: Player,
}
g: ^Game

Player :: struct {
    pos: Vec2
}

TileType :: enum {
    floor,
    wall,
}

Tile :: struct {
    tt: TileType,
}

Grid :: struct {
    tiles: [10][10]Tile,
}

main :: proc() {
    rl.InitWindow(width, height, "Socookie")
    defer rl.CloseWindow()
    rl.SetExitKey(nil)

    g : Game = {
        player = {
            pos = {}
        },
    }

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()

        rl.EndDrawing()
    }
}
