shader_type spatial;
render_mode unshaded;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D depth_buffer : source_color, hint_depth_texture;

uniform float thickness;
uniform float depth_multiplier;
uniform float depth_bias;

void vertex() {
	POSITION = vec4(VERTEX, 1.0);
}

vec2 getDepth(vec2 screen_uv, sampler2D depth_texture, mat4 inv_projection_matrix)
{
	float raw_depth = texture(depth_texture, screen_uv).x;
	vec3 normalized_device_coordinates = vec3(screen_uv * 2.0 - 1.0, raw_depth);
    vec4 view_space = inv_projection_matrix * vec4(normalized_device_coordinates, 1.0);
	view_space.xyz /= view_space.w;
	return vec2(-view_space.z, raw_depth);
}

float sobel_depth(float centre, float left, float right, float up, float down)
{
	return abs(left - centre) + abs(right - centre) + abs(up - centre) +  abs(down-centre);
}

float sobel_sample(vec2 uv, sampler2D depth_texture, vec3 offset, mat4 ipjm)
{
    float pixelCenter = getDepth(uv, depth_texture, ipjm).x;
    float pixelLeft   = getDepth(uv - offset.xz, depth_texture, ipjm).x;
    float pixelRight  = getDepth(uv + offset.xz, depth_texture, ipjm).x;
    float pixelUp     = getDepth(uv + offset.zy, depth_texture, ipjm).x;
    float pixelDown   = getDepth(uv - offset.zy, depth_texture, ipjm).x;

    return sobel_depth(pixelCenter, pixelLeft, pixelRight, pixelUp, pixelDown);
}

void fragment() {
	vec2 screen_size = vec2(textureSize(screen_texture, 0));
	vec3 offset = vec3(1.0 / screen_size.x, 1.0 / screen_size.y, 0.0) * thickness;
	float sobel = sobel_sample(SCREEN_UV, depth_buffer, offset, INV_PROJECTION_MATRIX);
	sobel = pow(abs(clamp(sobel, 0, 1) * depth_multiplier), depth_bias);

	ALBEDO = vec3(sobel);
}
