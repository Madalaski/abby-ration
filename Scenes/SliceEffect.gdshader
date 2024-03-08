shader_type canvas_item;

uniform vec2 position = vec2(0.5, 0.5);
uniform float rotation = 0.0;

uniform sampler2D videoTexture : filter_nearest;
uniform sampler2D screenshot : filter_nearest;

vec2 rotate(vec2 xy, float _rotation) {
	float _cos = cos(_rotation);
	float _sin = sin(_rotation);
	return vec2(
		_cos * xy.x - _sin * xy.y,
		_cos * xy.y + _sin * xy.x 
	);
}

void fragment() {
	float y_factor = float(textureSize(videoTexture, 0).x) / float(textureSize(screenshot, 0).x);
	vec2 relative_pos = SCREEN_UV - position;
	relative_pos.y /= y_factor;
	vec3 video_color = texture(videoTexture, (rotate(relative_pos, rotation) + vec2(1.0)) * 0.5).rgb;
	vec2 local_pos = rotate((video_color.xy - vec2(0.5)) * 2.0, -rotation);
	local_pos.y *= y_factor;
	float alpha = video_color.z;
	vec2 new_screen_pos = position + local_pos;
	vec3 final_color = texture(screenshot, new_screen_pos).rgb;
	COLOR = vec4(final_color, 1.0 - video_color.b);
}