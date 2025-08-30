package game

import rl "vendor:raylib"

Player :: struct {
    pos        : Vec2i,
    target_pos : Vec2i,
    interp     : f32,
    moving     : bool,
    facing     : Direction,
    anim       : Animation,
}

Direction :: enum {
    north,
    south,
    west,
    east,
}

move_player_dir :: proc(dir: Direction) {
    if g.player.moving {
        return
    }

    next := g.player.pos

    switch dir {
    case .north:
        if g.player.pos.y > 0 {
            next.y -= 1
        }
    case .south:
        if g.player.pos.y < grid_size-1 {
            next.y += 1
        }
    case .west:
        if g.player.pos.x > 0 {
            next.x -= 1
        }
    case .east:
        if g.player.pos.x < grid_size-1 {
            next.x += 1
        }
    }

    if g.grid.tiles[next.x][next.y] != .wall {
        g.player.target_pos = next
        g.player.interp     = 0
        g.player.moving     = true
        g.player.facing     = dir

        run_anim : Animation_Name
        switch dir {
        case .north: run_anim = .Player_Run_N
        case .south: run_anim = .Player_Run_S
        case .west:  run_anim = .Player_Run_W
        case .east:  run_anim = .Player_Run_E
        }
        g.player.anim = animation_create(run_anim)
    }
}


update_player :: proc() {
    dt := rl.GetFrameTime()

    if !g.player.moving {
        if rl.IsKeyPressed(.UP)    do move_player_dir(.north)
        if rl.IsKeyPressed(.DOWN)  do move_player_dir(.south)
        if rl.IsKeyPressed(.LEFT)  do move_player_dir(.west)
        if rl.IsKeyPressed(.RIGHT) do move_player_dir(.east)
    }

    if g.player.moving {
        speed : f32 = 5.0
        g.player.interp += dt * speed

        if g.player.interp >= 1 {
            g.player.pos = g.player.target_pos
            g.player.moving = false

            idle_anim : Animation_Name
            switch g.player.facing {
            case .north: idle_anim = .Player_Idle_N
            case .south: idle_anim = .Player_Idle_S
            case .west:  idle_anim = .Player_Idle_W
            case .east:  idle_anim = .Player_Idle_E
            }
            g.player.anim = animation_create(idle_anim)
        }
    }

    animation_update(&g.player.anim, dt)
}


draw_player :: proc() {
    start_pos := grid_to_screen_top_left(g.player.pos)
    end_pos   := grid_to_screen_top_left(g.player.target_pos)

    pos := rl.Vector2{
        start_pos.x + (end_pos.x - start_pos.x) * g.player.interp,
        start_pos.y + (end_pos.y - start_pos.y) * g.player.interp,
    }

    animation_draw(g.player.anim, pos)
}
