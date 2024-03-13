shader_type spatial;
render_mode unshaded;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform sampler2D color_remapping : repeat_disable, filter_nearest;
uniform bool pixelate;
uniform vec2 pixel_size;
uniform bool outline;
uniform sampler2D outline_texture : repeat_disable, filter_nearest;
uniform bool wiggle;
uniform sampler2D wiggle_texture;
uniform float wiggle_amount;
uniform vec2 wiggle_speed;
uniform bool noise;
uniform sampler2D noise_texture;
uniform float noise_amount;
uniform vec2 noise_speed;

void vertex() {
	POSITION = vec4(VERTEX, 1.0);
}

void fragment() {
	vec2 uv = SCREEN_UV;

	if (pixelate)
	{
		uv.x = floor(uv.x * pixel_size.x) / pixel_size.x;
		uv.y = floor(uv.y * pixel_size.y) / pixel_size.y;
	}

	vec3 color = texture(screen_texture, uv).xyz;

	if (wiggle)
	{
		uv += (texture(wiggle_texture, uv + (wiggle_speed * TIME)).xy - vec2(0.5)) * wiggle_amount;
	}

	if (outline)
	{
		float outline_value = texture(outline_texture, uv).x;
		color *= 1.0 - round(outline_value);
	}

	if (noise)
	{
		color += (texture(noise_texture, uv + (noise_speed * TIME)).xyz - vec3(0.5)) * noise_amount;
	}

	vec3 final_color = color;
	final_color.r = texture(color_remapping, vec2(final_color.r, 0.5)).r;
	final_color.g = texture(color_remapping, vec2(final_color.g, 0.5)).g;
	final_color.b = texture(color_remapping, vec2(final_color.b, 0.5)).b;

	ALBEDO = final_color;
}
