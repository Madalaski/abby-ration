shader_type canvas_item;

uniform sampler2D videoTexture;
uniform sampler2D screenshot;

void fragment() {
	vec3 video_color = texture(videoTexture, SCREEN_UV).rgb;
	vec3 final_color = texture(screenshot, video_color.xy).rgb;
	//vec2 projection = project(normalize(direction), project);
	//ALBEDO = vec3(SCREEN_UV, 0.0);
	COLOR = vec4(final_color, video_color.b);
}
