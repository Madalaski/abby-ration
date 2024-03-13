shader_type canvas_item;

uniform float progress;
uniform float power;

void fragment() {
	vec2 coords = (UV - vec2(0.5)) * 2.0;
	float value = (mix(0.0, -1.0, progress) - coords.y) * progress;
	value = -min(value, 0);
	if (abs(coords.x) < pow(value, power))
	{
		COLOR = vec4(0.0, 0.0, 1.0, 1.0);
	}
	else
	{
		coords.x -= sign(coords.x) * pow(value, power);

		vec2 new_uv = (coords + vec2(1.0)) * 0.5;
		COLOR = vec4(new_uv, 0.0, 1.0);
	}
}
