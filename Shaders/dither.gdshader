shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest_mipmap;

float bayer2(vec2 pos) {
    int x = int(mod(pos.x, 2.0));
    int y = int(mod(pos.y, 2.0));
    return float((x ^ y) * 255) / 255.0;
}

void fragment() {
    vec4 col = texture(SCREEN_TEXTURE, SCREEN_UV);
    float threshold = bayer2(FRAGCOORD.xy);
    col.rgb = floor(col.rgb * 4.0 + threshold) / 4.0;
    COLOR = col;
}
