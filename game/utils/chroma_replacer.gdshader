shader_type canvas_item;

uniform vec4 origin:source_color;
uniform vec4 new:source_color;
uniform vec4 white:source_color;
uniform vec4 black:source_color;
uniform float weight:hint_range(0.0, 1.0, 0.01) = 0.75;

void fragment() {
	vec4 current_pixel = texture(TEXTURE, UV);
	if (current_pixel == origin) {
		COLOR = new;
	} else {
		if (current_pixel != white && current_pixel != black){
			COLOR *= mix(current_pixel, vec4(new.rgb, current_pixel.a), weight);
		}
		
	}
}