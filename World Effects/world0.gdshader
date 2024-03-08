shader_type spatial;
render_mode unshaded;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D depth_texture : hint_depth_texture, repeat_disable, filter_nearest;

uniform sampler2D color_remapping;
uniform sampler2D noise_texture;

void vertex() {
	POSITION = vec4(VERTEX, 1.0);
}

float sample_depth(vec2 uv)
{
	return texture(depth_texture, uv).x;
}

float get_outline(vec2 uv)
{
	vec2 screen_size = vec2(textureSize(depth_texture, 0));
	
	float px = 0.5/screen_size.x;
	float py = 0.5/screen_size.y;
	
	float d = sample_depth(uv);
	float du = sample_depth(uv+vec2(0.0, py));
	float dd = sample_depth(uv+vec2(0.0, -py));
	float dr = sample_depth(uv+vec2(px, 0.0));
	float dl = sample_depth(uv+vec2(-px, 0.0));
	float dq = sample_depth(uv+vec2(-px, py));
	float de = sample_depth(uv+vec2(px, py));
	float dz = sample_depth(uv+vec2(-px, -py));
	float dc = sample_depth(uv+vec2(px, -py));
	
	return 0.0 + abs(abs(abs(d)-abs(du)) - abs(abs(d)-abs(dd))) + abs(abs(abs(d)-abs(dl)) - abs(abs(d)-abs(dr))) + abs(abs(abs(d)-abs(dq)) - abs(abs(d)-abs(dc))) + abs(abs(abs(d)-abs(dz)) - abs(abs(d)-abs(de)));
}

void fragment() {
	vec3 start_color = texture(screen_texture, SCREEN_UV).xyz;
	
	start_color *= 1.0 - get_outline(SCREEN_UV);
	
	vec3 final_color = start_color;
	final_color.r = texture(color_remapping, vec2(final_color.r, 0.5)).r;
	final_color.b = texture(color_remapping, vec2(final_color.b, 0.5)).b;
	final_color.g = texture(color_remapping, vec2(final_color.g, 0.5)).g;
	
	ALBEDO = final_color;
}
