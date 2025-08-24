package main

import rl "vendor:raylib"

Player :: struct {
   pos : [2]int,
}

move_player_to :: proc(player : ^Player, grid : ^Grid, pos :[2]int) {
    player.pos[0] = pos[0]
    player.pos[1] = pos[1]

}

update_and_draw_player :: proc(player : ^Player) {
    //Update

    //Draw
    rl.DrawCircle(((cast(i32)player.pos[0] * tile_w) + tile_w/2), ((cast(i32)player.pos[1] * tile_h) + tile_h/2), tile_w/2, rl.RED)
}