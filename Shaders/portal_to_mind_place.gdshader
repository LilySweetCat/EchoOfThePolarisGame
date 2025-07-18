shader_type spatial;

uniform vec4 base_color : source_color = vec4(0.2, 0.2, 0.2, 1.0);
uniform vec4 highlight_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

uniform float emission_power = 1.0;

uniform float pulse_speed = 2.0;
uniform float pulse_strength = 0.5;

uniform bool is_active = false;
uniform bool highlight_as_base_color = false;

void fragment() {
    vec4 color = base_color;

	if(highlight_as_base_color){
		color = highlight_color;
	}

    if (is_active) {
        float pulse = sin(TIME * pulse_speed) * 0.5 + 0.5;
        color.rgb = mix(base_color.rgb, highlight_color.rgb, pulse * pulse_strength);
    }

    ALBEDO = color.rgb;
	EMISSION = color.rgb * emission_power;
}
