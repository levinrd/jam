// copied from readme of atlas-builder

package game

import rl "vendor:raylib"

Animation :: struct {
    atlas_anim: Animation_Name,
    current_frame: Texture_Name,
    timer: f32,
}

animation_create :: proc(anim: Animation_Name) -> Animation {
    a := atlas_animations[anim]

    return {
        current_frame = a.first_frame,
        atlas_anim = anim,
        timer = atlas_textures[a.first_frame].duration,
    }
}

animation_update :: proc(a: ^Animation, dt: f32) -> bool {
    a.timer -= dt
    looped := false

    if a.timer <= 0 {
        a.current_frame = Texture_Name(int(a.current_frame) + 1)
        anim := atlas_animations[a.atlas_anim]

        if a.current_frame > anim.last_frame {
            a.current_frame = anim.first_frame
            looped = true
        }

        a.timer = atlas_textures[a.current_frame].duration
    }

    return looped
}

animation_length :: proc(anim: Animation_Name) -> f32 {
    l: f32
    aa := atlas_animations[anim]

    for i in aa.first_frame..=aa.last_frame {
        t := atlas_textures[i]
        l += t.duration
    }

    return l
}

animation_draw :: proc(anim: Animation, pos: rl.Vector2) {
    if anim.current_frame == .None {
        return
    }

    texture := atlas_textures[anim.current_frame]

    // The texture has four offset fields: offset_top, right, bottom and left. The offsets records
    // the distance between the pixels in the atlas and the edge of the original document in the
    // image editing software. Since the atlas is tightly packed, any empty pixels are removed.
    // These offsets can be used to correct for that removal.
    //
    // This can be especially obvious in animations where different frames can have different
    // amounts of empty pixels around it. By adding the offsets everything will look OK.
    //
    // If you ever flip the animation in X or Y direction, then you might need to add the right or
    // bottom offset instead.
    offset_pos := pos + {texture.offset_left, texture.offset_top}

    rl.DrawTextureRec(atlas, texture.rect, offset_pos, rl.WHITE)
}
