shader_type spatial;
render_mode unshaded;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D depth_texture : source_color, hint_depth_texture;

void vertex() {
	POSITION = vec4(VERTEX, 1.0);
}

float sampleDepth(vec2 uv)
{
	return texture(depth_texture, uv).x;
}

void fragment() {
	ALBEDO = vec3(sampleDepth(SCREEN_UV));
	
	
	vec2 screen_size = vec2(textureSize(depth_texture, 0));
	
	float px = 0.5/screen_size.x;
	float py = 0.5/screen_size.y;
	
	float d = sampleDepth(SCREEN_UV);
	float du = sampleDepth(SCREEN_UV+vec2(0.0, py));
	float dd = sampleDepth(SCREEN_UV+vec2(0.0, -py));
	float dr = sampleDepth(SCREEN_UV+vec2(px, 0.0));
	float dl = sampleDepth(SCREEN_UV+vec2(-px, 0.0));
	float dq = sampleDepth(SCREEN_UV+vec2(-px, py));
	float de = sampleDepth(SCREEN_UV+vec2(px, py));
	float dz = sampleDepth(SCREEN_UV+vec2(-px, -py));
	float dc = sampleDepth(SCREEN_UV+vec2(px, -py));
	
	float value = 0.0 + abs(abs(abs(d)-abs(du)) - abs(abs(d)-abs(dd))) + abs(abs(abs(d)-abs(dl)) - abs(abs(d)-abs(dr))) + abs(abs(abs(d)-abs(dq)) - abs(abs(d)-abs(dc))) + abs(abs(abs(d)-abs(dz)) - abs(abs(d)-abs(de)));
	ALBEDO = vec3(value);
}
