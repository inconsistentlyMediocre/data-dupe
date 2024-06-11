shader_type canvas_item;

uniform vec4 origin:source_color;
uniform vec4 new:source_color;
uniform vec4 dark:source_color;

void fragment() {
	vec4 current_pixel = texture(TEXTURE, UV);
	if (current_pixel == origin) {
		COLOR = dark;
	}
	
	float cycle = sin(TIME * 1.0);
	vec4 final_color = mix(COLOR, new, (((cycle >= 0.0) || (true)) ? abs(cycle) : 0.0));
	
	if (current_pixel == origin) {
		COLOR = final_color;
	}
	
	
	
}