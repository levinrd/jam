package main

import rl "vendor:raylib"

Player :: struct {
   pos : [2]int,
}

move_player_to :: proc(player: ^Player, pos: [2]int) {
    player.pos = pos
}

update_player :: proc(player: ^Player) {
    if rl.IsKeyPressed(.UP) {
        if player.pos.y > 0 {
            player.pos.y -= 1
        }
    }
    if rl.IsKeyPressed(.DOWN) {
        if player.pos.y < grid_size-1 {
            player.pos.y += 1
        }
    }
    if rl.IsKeyPressed(.LEFT) {
        if player.pos.x > 0 {
            player.pos.x -= 1
        }
    }
    if rl.IsKeyPressed(.RIGHT) {
        if player.pos.x < grid_size-1 {
            player.pos.x += 1
        }
    }
}

draw_player :: proc(player: ^Player) {
    rl.DrawCircle((cast(i32)player.pos[0] * tile_w) + tile_w/2, (cast(i32)player.pos[1] * tile_h) + tile_h/2, tile_w/2, rl.RED)
}
