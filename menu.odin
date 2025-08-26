package game

import rl "vendor:raylib"

Menu_Action :: enum {
    none,
    play,
    quit,
}

play_button_rect : rl.Rectangle = {
    x = 100,
    y = 200,
    width = 120,
    height = 40,
}

quit_button_rect : rl.Rectangle = {
    x = 100,
    y = 260,
    width = 120,
    height = 40,
}

menu_update_and_draw :: proc() -> Menu_Action {
    rl.ClearBackground({ 30, 30, 60, 255 })

    // Draw title
    rl.DrawTexturePro(
        atlas,
        atlas_textures[.Title].rect,
        rl.Rectangle{ 100, 10, 265, 128 },
        rl.Vector2{0,0},
        0,
        rl.WHITE,
    )

    // --- Play Button ---
    rl.DrawRectangleRec(play_button_rect, { 200, 200, 200, 255 })
    rl.DrawRectangleLinesEx(play_button_rect, 2, rl.BLACK)
    rl.DrawText("Play",
        cast(i32)(play_button_rect.x + 30),
        cast(i32)(play_button_rect.y + 10),
        20,
        rl.BLACK)

    // --- Quit Button ---
    rl.DrawRectangleRec(quit_button_rect, { 200, 200, 200, 255 })
    rl.DrawRectangleLinesEx(quit_button_rect, 2, rl.BLACK)
    rl.DrawText("Quit",
        cast(i32)(quit_button_rect.x + 30),
        cast(i32)(quit_button_rect.y + 10),
        20,
        rl.BLACK)

    if rl.IsMouseButtonPressed(.LEFT) {
        mouse := rl.GetMousePosition()
        if rl.CheckCollisionPointRec(mouse, play_button_rect) {
            return .play
        }
        if rl.CheckCollisionPointRec(mouse, quit_button_rect) {
            return .quit
        }
    }

    return .none
}
