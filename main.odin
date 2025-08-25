package game

import "core:fmt"
import "core:os"
import rl "vendor:raylib"

Vec2 :: [2]f32
Rect :: rl.Rectangle

screen_width :: 1000
screen_height :: 1000

virtual_screen_width  :: 320
virtual_screen_height :: 320
virtual_ratio : f32 : f32(virtual_screen_width) / f32(virtual_screen_height)

grid_size :: 10

atlas : rl.Texture

main :: proc() {
    rl.SetConfigFlags({.WINDOW_RESIZABLE, .VSYNC_HINT})
    rl.InitWindow(screen_width, screen_height, "Socookie")
    defer rl.CloseWindow()
    rl.SetExitKey(nil)
    rl.SetTargetFPS(60)

    atlas = rl.LoadTexture(TEXTURE_ATLAS_FILENAME)

    world_cam : rl.Camera2D = {
        zoom = 1,
    }

    screen_cam : rl.Camera2D = {
        zoom = 1,
    }

    target : rl.RenderTexture2D = rl.LoadRenderTexture(virtual_screen_width, virtual_screen_height);
    defer rl.UnloadRenderTexture(target);

    source_rec : Rect = { 0, 0, f32(target.texture.width), f32(-target.texture.height) };
    dest_rec : Rect = {
        -virtual_ratio,
        -virtual_ratio,
        screen_width + (virtual_ratio*2),
        screen_height + (virtual_ratio*2),
    }

    origin : Vec2 = { 0, 0 }

    camera_x : f32 = 0
    camera_y : f32 = 0

    grid : Grid
    if !os.exists("level.txt") {
        fill_grid(&grid)
    } else {
        load_grid(&grid, "level.txt")
    }

    player : Player

    for !rl.WindowShouldClose() {
        dt := rl.GetFrameTime()

        screen_cam.target = { camera_x, camera_y }


        update_player(&player, &grid)

        if rl.IsKeyDown(.LEFT_CONTROL) || rl.IsKeyDown(.RIGHT_CONTROL) {
            if rl.IsKeyPressed(.S) {
                save_grid(&grid, "level.txt")
            }
            if rl.IsKeyPressed(.L) {
                load_grid(&grid, "level.txt")
            }
        }

        if rl.IsMouseButtonPressed(.LEFT) {
            pos := screen_to_virtual(rl.GetMousePosition())
            tile_pos := screen_to_grid(pos)
            old := grid.tiles[tile_pos[0]][tile_pos[1]]
            new : Tile = old == .floor ? .wall : .floor
            set_grid_tile(&grid, tile_pos, new)
        }

        rl.BeginTextureMode(target);
        rl.BeginMode2D(world_cam);
        rl.ClearBackground(rl.BLACK)
        update_and_draw_grid(&grid)
        draw_player(&player)
        rl.EndMode2D();
        rl.EndTextureMode();

        window_w := rl.GetScreenWidth()
        window_h := rl.GetScreenHeight()

        scale := f32(min(window_w / virtual_screen_width, window_h / virtual_screen_height))

        draw_w := f32(virtual_screen_width) * scale
        draw_h := f32(virtual_screen_height) * scale

        offset_x := (f32(window_w) - draw_w) * 0.5
        offset_y := (f32(window_h) - draw_h) * 0.5

        dest_rec := rl.Rectangle{
            x = offset_x,
            y = offset_y,
            width = draw_w,
            height = draw_h,
        }

        rl.BeginDrawing()
        rl.ClearBackground({ 20, 20, 120, 255 })
        rl.BeginMode2D(screen_cam);
        rl.DrawTexturePro(target.texture, source_rec, dest_rec, origin, 0, rl.WHITE);
        rl.EndMode2D();
        rl.DrawFPS(10, 10)
        rl.EndDrawing()
    }
}
