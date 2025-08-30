package game

import rl "vendor:raylib"

tile_w :: virtual_screen_width / grid_size
tile_h :: virtual_screen_height / grid_size

Tile :: enum {
    floor,
    wall,
    cookie,
}

draw_tile :: proc(pos: Vec2, tile: Tile) {
    switch tile {
    case .floor:
        rl.DrawRectangle(
            cast(i32)pos.x,
            cast(i32)pos.y,
            tile_w, tile_h,
            rl.BLACK,
        )

    case .wall:
        rl.DrawTextureRec(
            atlas,
            atlas_textures[.Wall].rect,
            rl.Vector2{ pos.x, pos.y },
            rl.WHITE,
        )

    case .cookie:
        rl.DrawTextureRec(
            atlas,
            atlas_textures[.Cookie].rect,
            rl.Vector2{ pos.x, pos.y },
            rl.WHITE,
        )
    }
}

draw_tile_in_grid :: proc(grid_pos: Vec2i, tile: Tile) {
    pos := Vec2{
        f32(grid_pos[0] * tile_w),
        f32(grid_pos[1] * tile_h),
    }
    draw_tile(pos, tile)
}
