shader_type canvas_item;

uniform int pixel_size = 4;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest_mipmap;

void fragment() {
    vec2 screen_uv = floor(SCREEN_UV * vec2(textureSize(SCREEN_TEXTURE, 0)) / float(pixel_size)) * float(pixel_size) / vec2(textureSize(SCREEN_TEXTURE, 0));
    COLOR = texture(SCREEN_TEXTURE, screen_uv);
}
