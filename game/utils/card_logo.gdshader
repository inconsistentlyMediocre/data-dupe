shader_type canvas_item;

uniform vec4 origin:source_color;
uniform vec4 blue:source_color;
uniform vec4 red:source_color;
uniform vec4 green:source_color;

void fragment() {
	vec4 colors[3] = vec4[](
		blue,
		red,
		green
	);
	vec4 current_pixel = texture(TEXTURE, UV);
	if (current_pixel == origin) {
		COLOR = origin;
	}
	
	float cycle = sin(TIME * 1.0);
	vec4 final_color = mix(COLOR, colors[0], ((cycle >= 0.0) ? abs(cycle) : 0.0));
	final_color = mix(COLOR, colors[1], ((cycle >= 0.0) ? abs(cycle) : 0.0));
	
	
	
	if (current_pixel == origin) {
		COLOR = final_color;
	}
	
	
	
}