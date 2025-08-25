package main

import rl "vendor:raylib"

Player :: struct {
   pos : [2]int,
}

Direction :: enum {
    up,
    down,
    left,
    right,
}

move_player_dir :: proc(player: ^Player, dir: Direction) {
    switch dir {
    case .up:
        if player.pos.y > 0 {
            player.pos.y -= 1
        }
    case .down:
        if player.pos.y < grid_size-1 {
            player.pos.y += 1
        }
    case .left:
        if player.pos.x > 0 {
            player.pos.x -= 1
        }
    case .right:
        if player.pos.x < grid_size-1 {
            player.pos.x += 1
        }
    }
}

update_player :: proc(player: ^Player) {
    if rl.IsKeyPressed(.UP)    do move_player_dir(player, .up)
    if rl.IsKeyPressed(.DOWN)  do move_player_dir(player, .down)
    if rl.IsKeyPressed(.LEFT)  do move_player_dir(player, .left)
    if rl.IsKeyPressed(.RIGHT) do move_player_dir(player, .right)
}

draw_player :: proc(player: ^Player) {
    rl.DrawCircle((cast(i32)player.pos[0] * tile_w) + tile_w/2, (cast(i32)player.pos[1] * tile_h) + tile_h/2, tile_w/2, rl.RED)
}
