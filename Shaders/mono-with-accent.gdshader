shader_type spatial;
render_mode unshaded, cull_disabled;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform float desaturation_amount = 1.0; // Полное обесцвечивание

void vertex() {
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

void fragment() {
    vec3 color = texture(screen_texture, SCREEN_UV).rgb;
    float luminance = dot(color, vec3(0.299, 0.587, 0.114)); // Ч/б
    vec3 grayscale = vec3(luminance);

    // Если цвет в красном диапазоне, оставляем его
    if (color.r > 0.7 && color.g < 0.3 && color.b < 0.3) {
        ALBEDO.rgb = color;
    } else {
        ALBEDO.rgb = mix(color, grayscale, desaturation_amount);
    }
}