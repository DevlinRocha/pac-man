shader_type canvas_item;

uniform vec4 target_color : source_color = vec4(0, 1, 0, 1);
uniform vec4 new_color : source_color = vec4(1, 0, 1, 1);

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
	if (tex_color.rgb == target_color.rgb) COLOR = new_color;
}
