shader_type canvas_item;

uniform float intensity = 0.5;
uniform float smoothness = 0.5;
uniform vec4 vignette_color : source_color = vec4(0, 0, 0, 1);

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
    vec2 uv = SCREEN_UV * 2.0 - 1.0;
    float dist = length(uv);
    float vignette = smoothstep(intensity, intensity - smoothness, dist);
    COLOR = mix(texture(SCREEN_TEXTURE, SCREEN_UV), vignette_color, vignette);
}
