shader_type canvas_item;

/* 
	https://gdscript.com/solutions/shaders-in-godot/ 
	https://docs.godotengine.org/en/3.3/tutorials/shading/shading_reference/shading_language.html
	https://docs.godotengine.org/en/stable/classes/class_image.html?highlight=FORMAT_L8#enumerations
*/

uniform sampler2D mask;

void fragment() 
{
	COLOR = texture(TEXTURE, UV);	
	float grey = 0.21 * COLOR.r + 0.71 * COLOR.g + 0.07 * COLOR.b;
	vec3 greyMultiplier = vec3(grey);
	
	COLOR.rgb = mix(COLOR.rgb, greyMultiplier, texture(mask, UV).r);
}