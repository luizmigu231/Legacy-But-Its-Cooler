	#pragma header

	void main()
	{
		vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);

		// Alpha completamente intacto
		if (color.a <= 0.0)
		{
			gl_FragColor = vec4(0.0);
			return;
		}

		float brightness = (color.r + color.g + color.b) / 3.0;

		// Negro -> blanco
		// Gris -> gris
		// Blanco -> negro
		float value = 1.0 - brightness;

		gl_FragColor = vec4(value, value, value, color.a);
	}