shader_type canvas_item;

uniform float fade_start : hint_range(0.0, 1.0) = 0.6;
uniform float fade_offset : hint_range(0.0, 1.0) = 0.0;
uniform float fade_end : hint_range(0.0, 1.0) = 1.0;

void fragment() {
    vec4 tex = texture(TEXTURE, UV);

    // UV.y goes from 0 at top to 1 at bottom
    float fade = smoothstep(fade_start, fade_end, UV.y + fade_offset);

    tex.a *= (1.0 - fade);

    COLOR = tex;
}