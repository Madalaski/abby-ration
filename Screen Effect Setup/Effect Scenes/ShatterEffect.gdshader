shader_type spatial;

uniform float frame = 0.0;
uniform sampler2D normals : filter_nearest;
uniform sampler2D offsets : filter_nearest;

void vertex() {
	vec2 coords = vec2(UV2.x, frame);
	vec3 normal = texture(normals, coords).rgb;
	vec3 offset = texture(offsets, coords).rgb;
	offset.y = -offset.y;
	
	NORMAL = 2.0 * (normal - vec3(0.5));
	VERTEX += offset;
}

void fragment() {
	ALBEDO = vec3(UV, 0.0);
}
