/// render_generate_sample_kernel(samples)
/// @arg samples

function render_generate_sample_kernel(samples)
{
	var arr;
	
	for (var i = 0; i < samples; i++)
	{
		var xx, yy, zz, mag, scale;
		xx = random_range(-1, 1)
		yy = random_range(-1, 1)
		zz = random_range(0, 1)
		
		// Normalize
		mag = sqrt(xx * xx + yy * yy + zz * zz)
		xx /= mag
		yy /= mag
		zz /= mag
		
		// Exponentiate scale
		scale = i / samples
		scale = lerp(0.01, 1.0, scale * scale)
		xx *= scale
		yy *= scale
		zz *= scale
		
		if (abs(xx) < 0.001)
			xx = 0.001
		
		if (abs(yy) < 0.001)
			yy = 0.001
		
		if (abs(zz) < 0.001)
			zz = 0.001
		
		// Store in array
		arr[i * 3] = xx
		arr[i * 3 + 1] = yy
		arr[i * 3 + 2] = zz
	}
	
	return arr
}
