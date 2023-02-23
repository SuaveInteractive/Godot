shader_type canvas_item;

/* 
	https://gdscript.com/solutions/shaders-in-godot/ 
	https://docs.godotengine.org/en/3.3/tutorials/shading/shading_reference/shading_language.html
	https://docs.godotengine.org/en/stable/classes/class_image.html?highlight=FORMAT_L8#enumerations
*/

uniform sampler2D previousTexture;
uniform sampler2D maskTexture;


void fragment() 
{
	// Start with base shade
	vec4 baseShade = vec4(0.5, 0.5, 0.5, 1);
	
	// Get the previous grey colour
	vec4 previousGrey = texture(previousTexture, UV);

	// Get the mask value
	vec4 maskValue = texture(maskTexture, UV);
	
	// Color of the map
	vec4 textureColor = texture(TEXTURE, UV);	
	
	// Calculate what the value should be
	
	COLOR = mix(textureColor, baseShade, maskValue*0.75);
}