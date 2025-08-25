package game

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

move_player_dir :: proc(dir: Direction) {
    next := g.player.pos

    switch dir {
    case .up:
        if g.player.pos.y > 0 {
            next.y -= 1
        }
    case .down:
        if g.player.pos.y < grid_size-1 {
            next.y += 1
        }
    case .left:
        if g.player.pos.x > 0 {
            next.x -= 1
        }
    case .right:
        if g.player.pos.x < grid_size-1 {
            next.x += 1
        }
    }

    if g.grid.tiles[next.x][next.y] != .wall {
        g.player.pos = next
    }
}

update_player :: proc() {
    if rl.IsKeyPressed(.UP)    do move_player_dir(.up)
    if rl.IsKeyPressed(.DOWN)  do move_player_dir(.down)
    if rl.IsKeyPressed(.LEFT)  do move_player_dir(.left)
    if rl.IsKeyPressed(.RIGHT) do move_player_dir(.right)
}

draw_player :: proc() {
    grid_pos := grid_to_screen_center(g.player.pos)
    rl.DrawCircle(cast(i32)grid_pos.x, cast(i32)grid_pos.y, tile_w/2, rl.RED)

    /* rl.DrawTextureRec(atlas, atlas_textures[.Cookie].rect, grid_pos, rl.WHITE) */
}
