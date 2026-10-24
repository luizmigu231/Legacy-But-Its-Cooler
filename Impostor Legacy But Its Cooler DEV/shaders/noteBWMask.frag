#pragma header

uniform sampler2D u_bfMask;
uniform sampler2D u_dadMask;

uniform vec2 u_bfPos;
uniform vec2 u_bfSize;

uniform vec2 u_dadPos;
uniform vec2 u_dadSize;

uniform vec2 u_targetPos;
uniform vec2 u_targetSize;

uniform float u_bfFlip;
uniform float u_dadFlip;

float sampleMask(
	sampler2D mask,
	vec2 pos,
	vec2 size,
	vec2 screenPos,
	float flip
)
{
	if (size.x <= 0.0 || size.y <= 0.0)
		return 0.0;

	vec2 uv = (screenPos - pos) / size;

	if (uv.x < 0.0 || uv.x > 1.0 ||
		uv.y < 0.0 || uv.y > 1.0)
		return 0.0;

	if (flip > 0.5)
		uv.x = 1.0 - uv.x;

	return flixel_texture2D(mask, uv).a;
}

void main()
{
	vec4 note = flixel_texture2D(
		bitmap,
		openfl_TextureCoordv
	);

	if (note.a <= 0.001)
	{
		gl_FragColor = note;
		return;
	}

	vec2 screenPos =
		u_targetPos +
		openfl_TextureCoordv * u_targetSize;

	float bf = sampleMask(
		u_bfMask,
		u_bfPos,
		u_bfSize,
		screenPos,
		u_bfFlip
	);

	float dad = sampleMask(
		u_dadMask,
		u_dadPos,
		u_dadSize,
		screenPos,
		u_dadFlip
	);

	float mask = max(bf, dad);

	float whitePart = smoothstep(
		0.05,
		0.35,
		mask
	);

	vec3 finalColor = mix(
		vec3(0.0),
		vec3(1.0),
		whitePart
	);

	gl_FragColor = vec4(
		finalColor,
		note.a
	);
}