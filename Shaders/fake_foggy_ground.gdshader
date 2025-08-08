shader_type spatial;
render_mode unshaded, blend_mix;

uniform sampler2D noise_texture;

void fragment() {
	vec4 base_texture = texture(noise_texture, UV);
	ALBEDO.rgb = base_texture.rgb;
	ALPHA = base_texture.a;
}