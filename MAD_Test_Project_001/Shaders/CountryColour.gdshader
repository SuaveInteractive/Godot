shader_type canvas_item;
render_mode unshaded;

uniform vec4 replacementColour : hint_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 maskColour : hint_color = vec4(1.0, 0.0, 1.0, 1.0);

void fragment() 
{
	vec4 col = texture(TEXTURE, UV);
	if (col.a > 0.0 && col.rgb == maskColour.rgb)
    	COLOR.rgb = replacementColour.rgb;
	else
		COLOR = col;
}
 