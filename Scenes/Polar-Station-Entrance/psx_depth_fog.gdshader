// Linear Depth Shader written by absentSpaghetti
//
// This shader is a part of my tutorial/learning Github repository: https://github.com/absentSpaghetti/Shader-Basics-With-Spaghetti
// Feel free to use, edit and share this shader according to your needs
//
// MIT License
//
// prerequisites:

shader_type spatial;
render_mode unshaded, cull_disabled;

uniform sampler2D DEPTH_TEXTURE : hint_depth_texture, filter_linear_mipmap;
uniform sampler2D TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform vec3 fog_color : source_color = vec3(0.5, 0.5, 0.5);
uniform float fog_start = 5.0;
uniform float fog_end = 15.0;

void vertex() {
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

void fragment() {
	// Расстояние от камеры
    float depth = texture(DEPTH_TEXTURE, SCREEN_UV).x;
	#if CURRENT_RENDERER == RENDERER_COMPATIBILITY
		vec3 ndc = vec3(SCREEN_UV, depth) * 2.0 - 1.0;
	#else
	vec3 ndc = vec3(SCREEN_UV * 2.0 - 1.0, depth);
	#endif

	vec4 view = INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
	view.xyz /= view.w;
	float linear_depth = -view.z;

	vec4 world = INV_VIEW_MATRIX * INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
  	vec3 world_position = world.xyz / world.w;

	//ALBEDO.rgb = vec3(fract(linear_depth));

    // Линейный туман
    float fog_factor = smoothstep(fog_start, fog_end, abs(linear_depth));
    vec3 color = texture(TEXTURE, SCREEN_UV).rgb;
    ALBEDO.rgb = mix(color, fog_color, fog_factor);
}