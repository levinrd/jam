package game

import "core:fmt"
import "core:os"
import "core:strings"
import rl "vendor:raylib"

tile_w :: virtual_screen_width / grid_size
tile_h :: virtual_screen_height / grid_size

Tile :: enum {
    floor,
    wall,
    cookie,
}

Grid :: struct {
    tiles : [grid_size][grid_size]Tile,
}

fill_grid :: proc() {
    for i in 0..<grid_size {
        for j in 0..<grid_size {
            /* if (i + j) % 2 == 0 { */
            /*     grid.tiles[i][j] = .wall */
            /* } */
            g.grid.tiles[i][j] = .floor
        }
    }
    g.grid.tiles[8][8] = .cookie
}

update_and_draw_grid :: proc() {
    for i in 0..<grid_size {
        for j in 0..<grid_size {
            pos : Vec2 = { f32(i * tile_w), f32(j * tile_h) }
            switch g.grid.tiles[i][j] {
            case .floor:
                rl.DrawRectangle(cast(i32)i * tile_w, cast(i32)j * tile_h, tile_w, tile_h, rl.BLACK)
            case .wall:
                rl.DrawTextureRec(atlas, atlas_textures[.Wall].rect, pos, rl.WHITE)
            case .cookie:
                rl.DrawTextureRec(atlas, atlas_textures[.Cookie].rect, pos, rl.WHITE)
            }
        }
    }
}

screen_to_grid :: proc(screen_pos: Vec2) -> [2]int {
    return [2]int {
        cast(int)(screen_pos.x) / tile_w,
        cast(int)(screen_pos.y) / tile_h,
    }
}

screen_to_virtual :: proc(pos: rl.Vector2) -> Vec2 {
    window_w := rl.GetScreenWidth()
    window_h := rl.GetScreenHeight()

    scale := f32(min(window_w / virtual_screen_width, window_h / virtual_screen_height))
    draw_w := f32(virtual_screen_width) * scale
    draw_h := f32(virtual_screen_height) * scale

    offset_x := (f32(window_w) - draw_w) * 0.5
    offset_y := (f32(window_h) - draw_h) * 0.5

    vx := (pos.x - offset_x) / scale
    vy := (pos.y - offset_y) / scale

    return Vec2{vx, vy}
}

grid_to_screen_top_left :: proc(grid_pos: [2]int) -> Vec2 {
    return Vec2 {
        cast(f32)grid_pos.x * tile_w,
        cast(f32)grid_pos.y * tile_h,
    }
}

grid_to_screen_center :: proc(grid_pos: [2]int) -> Vec2 {
    return Vec2{
        cast(f32)grid_pos[0] * tile_w + tile_w/2,
        cast(f32)grid_pos[1] * tile_h + tile_h/2,
    }
}

set_grid_tile :: proc(tile_pos: [2]int, tile: Tile) {
    x := tile_pos[0]
    y := tile_pos[1]
    if x >= 0 && x < grid_size && y >= 0 && y < grid_size {
        g.grid.tiles[x][y] = tile
    }
}

save_grid :: proc(filepath: string) {
    buf := strings.builder_make()

    for j in 0..<grid_size {
        for i in 0..<grid_size {
            tile := g.grid.tiles[i][j]
            if tile == .floor {
                strings.write_byte(&buf, '*')
            } else {
                strings.write_byte(&buf, 'x')
            }
        }
        strings.write_byte(&buf, '\n')
    }

    data := strings.to_string(buf)

    ok := os.write_entire_file(filepath, transmute([]byte)data)
    if !ok {
        fmt.eprintln("ERROR: Could not write file", filepath)
    }
}

load_grid :: proc(filepath: string) {
    contents, ok := os.read_entire_file(filepath)
    if !ok {
        fmt.eprintln("ERROR: Could not read file", filepath)
        return
    }

    text := string(contents)
    lines := strings.split_lines(text)

    for j in 0..<min(grid_size, len(lines)) {
        line := lines[j]
        for i in 0..<min(grid_size, len(line)) {
            ch := line[i]
            if ch == 'x' {
                g.grid.tiles[i][j] = .wall
            } else {
                g.grid.tiles[i][j] = .floor
            }
        }
    }
}
