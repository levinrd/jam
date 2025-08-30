package game

import "core:fmt"
import "core:os"
import rl "vendor:raylib"

Vec2 :: [2]f32
Vec2i :: [2]int
Rect :: rl.Rectangle

screen_width : i32 = 1000
screen_height : i32 = 1000

virtual_screen_width  :: 320
virtual_screen_height :: 320
virtual_ratio : f32 : f32(virtual_screen_width) / f32(virtual_screen_height)

grid_size :: 10

atlas : rl.Texture

Game_State :: enum {
    menu,
    playing,
}

Game :: struct {
    player: Player,
    grid: Grid,
    state: Game_State,
    dt: f32
}
g : Game

main :: proc() {
    rl.SetConfigFlags({.WINDOW_RESIZABLE, .VSYNC_HINT})
    rl.InitWindow(screen_width, screen_height, "Socookie")
    defer rl.CloseWindow()
    rl.SetExitKey(nil)
    rl.SetTargetFPS(60)

    g = {
        grid = {},
        player = {
            pos = { 0, 0 },
            anim = animation_create(.Player_Idle_S)
        },
        state = .menu,
    }

    init_editor()

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
        f32(screen_width) + (virtual_ratio*2),
        f32(screen_height) + (virtual_ratio*2),
    }

    origin : Vec2 = { 0, 0 }

    camera_x : f32 = 0
    camera_y : f32 = 0

    if !os.exists("level.txt") {
        fill_grid()
    } else {
        load_grid("level.txt")
    }

    for !rl.WindowShouldClose() {

        g.dt = rl.GetFrameTime()
        screen_width = rl.GetScreenWidth()
        screen_height = rl.GetScreenHeight()

        rl.BeginDrawing()
        defer rl.EndDrawing()

        switch g.state {
        case .menu:
            action := menu_update_and_draw()
            #partial switch action {
            case .play:
                g.state = .playing
            case .quit:
                rl.CloseWindow()
            }

        case .playing:

            if rl.IsKeyPressed(.ESCAPE) {
                g.state = .menu
                continue
            }

            screen_cam.target = { camera_x, camera_y }

            update_player()

            if rl.IsKeyDown(.LEFT_CONTROL) || rl.IsKeyDown(.RIGHT_CONTROL) {
                if rl.IsKeyPressed(.S) {
                    save_grid("level.txt")
                }
                if rl.IsKeyPressed(.L) {
                    load_grid("level.txt")
                }
            }

            update_editor()

            rl.BeginTextureMode(target)
            rl.BeginMode2D(world_cam)
            rl.ClearBackground(rl.BLACK)
            update_and_draw_grid()
            draw_player()
            rl.EndMode2D()
            rl.EndTextureMode()

            scale := f32(min(screen_width / virtual_screen_width, screen_height / virtual_screen_height))

            draw_w := f32(virtual_screen_width) * scale
            draw_h := f32(virtual_screen_height) * scale

            offset_x := (f32(screen_width) - draw_w) * 0.5
            offset_y := (f32(screen_height) - draw_h) * 0.5

            dest_rec := rl.Rectangle{
                x = offset_x,
                y = offset_y,
                width = draw_w,
                height = draw_h,
            }

            rl.ClearBackground({ 20, 20, 120, 255 })
            rl.BeginMode2D(screen_cam)
            rl.DrawTexturePro(target.texture, source_rec, dest_rec, origin, 0, rl.WHITE)
            rl.EndMode2D()
            rl.DrawFPS(10, 10)
            draw_editor()
        }
    }
}
