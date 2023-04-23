shader_type canvas_item;
render_mode unshaded;

uniform vec4 colour : hint_color = vec4(1.0, 0.0, 1.0, 1.0);

void fragment() 
{
	vec4 col = texture(TEXTURE, UV);
	if (col == vec4(1.0, 0.0, 1.0, 1.0))
    	COLOR = colour;
	else
		COLOR = col;
}
 