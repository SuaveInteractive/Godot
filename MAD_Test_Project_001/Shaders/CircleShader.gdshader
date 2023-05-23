shader_type canvas_item;

uniform float longRangeRadar : hint_range(0.0, 1.0);
uniform float mediumRangeRadar : hint_range(0.0, 1.0);
uniform float shortRangeRadar : hint_range(0.0, 1.0);
uniform float visualRange : hint_range(0.0, 1.0);

uniform vec4 longRangeColor : hint_color;
uniform vec4 mediumRangeColor : hint_color;
uniform vec4 shortRangeColor : hint_color;
uniform vec4 visualRangeColor : hint_color;

void fragment() 
{
	if (distance(UV, vec2(0.5
	,0.5)) < visualRange/2.0) 
		COLOR = vec4(visualRangeColor);
	else if (distance(UV, vec2(0.5,0.5)) < shortRangeRadar/2.0) 
		COLOR = vec4(shortRangeColor);
	else if (distance(UV, vec2(0.5,0.5)) < mediumRangeRadar/2.0) 
		COLOR = vec4(mediumRangeColor);
	else if (distance(UV, vec2(0.5,0.5)) < longRangeRadar/2.0) 
		COLOR = vec4(longRangeColor);
	else 
		COLOR = vec4(0.0);
}
