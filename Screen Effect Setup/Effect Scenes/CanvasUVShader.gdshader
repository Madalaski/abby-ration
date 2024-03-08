shader_type canvas_item;

uniform vec4 bounds;

void fragment() {
	COLOR = vec4(UV, 0.0, 1.0);
}
