shader_type spatial;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform vec3 color_tint : source_color;

void vertex() {
	POSITION = vec4(VERTEX, 1.0);
}

void fragment() {
	ALBEDO = mix(texture(screen_texture, SCREEN_UV).rgb, color_tint, 0.2);
}
