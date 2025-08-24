package main

import rl "vendor:raylib"

tile_w :: width / grid_size
tile_h :: height / grid_size

Tile :: enum {
    floor,
    wall,
}

Grid :: struct {
    tiles : [grid_size][grid_size]Tile,
}

init_grid :: proc(grid: ^Grid) {
    for i in 0..<grid_size {
        for j in 0..<grid_size {
            if (i + j) % 2 == 0 {
                grid.tiles[i][j] = .wall
            }
        }
    }
}

update_and_draw_grid :: proc(grid: ^Grid) {
    for i in 0..<grid_size {
        for j in 0..<grid_size {
            color : rl.Color = grid.tiles[i][j] == .floor ? rl.BLUE : rl.BLACK
            rl.DrawRectangle(cast(i32)i * tile_w, cast(i32)j * tile_h, tile_w, tile_h, color)
        }
    }
}

screen_to_grid :: proc(screen_pos: Vec2) -> [2]int {
    return [2]int {
        cast(int)(screen_pos.x) / tile_w,
        cast(int)(screen_pos.y) / tile_h,
    }
}


set_grid_tile :: proc(grid: ^Grid, tile_pos: [2]int, tile: Tile) {
    x := tile_pos[0]
    y := tile_pos[1]
    if x >= 0 && x < grid_size && y >= 0 && y < grid_size {
        grid.tiles[x][y] = tile
    }
}
