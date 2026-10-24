#pragma header

// Adjust Color filter adapted from Rozebud / Andrey-Postelzhuks.
// Kept as the only fragment shader used by the cafeteria stage.

uniform float hue;
uniform float saturation;
uniform float brightness;
uniform float contrast;

const vec3 grayscaleValues = vec3(0.3098039215686275, 0.607843137254902, 0.0823529411764706);
const float e = 2.718281828459045;

vec3 applyHueRotate(vec3 aColor, float aHue)
{
	float angle = radians(aHue);

	mat3 m1 = mat3(0.213, 0.213, 0.213, 0.715, 0.715, 0.715, 0.072, 0.072, 0.072);
	mat3 m2 = mat3(0.787, -0.213, -0.213, -0.715, 0.285, -0.715, -0.072, -0.072, 0.928);
	mat3 m3 = mat3(-0.213, 0.143, -0.787, -0.715, 0.140, 0.715, 0.928, -0.283, 0.072);
	mat3 m = m1 + cos(angle) * m2 + sin(angle) * m3;

	return m * aColor;
}

vec3 applySaturation(vec3 aColor, float value)
{
	if (value > 0.0)
		value *= 3.0;

	value = 1.0 + (value / 100.0);
	vec3 grayscale = vec3(dot(aColor, grayscaleValues));
	return clamp(mix(grayscale, aColor, value), 0.0, 1.0);
}

vec3 applyContrast(vec3 aColor, float value)
{
	value = 1.0 + (value / 100.0);

	if (value > 1.0)
	{
		value = (((0.00852259 * pow(e, 4.76454 * (value - 1.0))) * 1.01) - 0.0086078159) * 10.0;
		value += 1.0;
	}

	return clamp((aColor - 0.25) * value + 0.25, 0.0, 1.0);
}

vec3 applyHSBCEffect(vec3 color)
{
	color += brightness / 255.0;
	color = applyHueRotate(color, hue);
	color = applyContrast(color, contrast);
	color = applySaturation(color, saturation);
	return clamp(color, 0.0, 1.0);
}

void main()
{
	vec4 textureColor = flixel_texture2D(bitmap, openfl_TextureCoordv);

	if (textureColor.a <= 0.0)
	{
		gl_FragColor = vec4(0.0);
		return;
	}

	// Undo premultiplied alpha before applying the color correction.
	vec3 unpremultipliedColor = clamp(textureColor.rgb / textureColor.a, 0.0, 1.0);
	vec3 outColor = applyHSBCEffect(unpremultipliedColor);

	gl_FragColor = vec4(outColor * textureColor.a, textureColor.a);
}
