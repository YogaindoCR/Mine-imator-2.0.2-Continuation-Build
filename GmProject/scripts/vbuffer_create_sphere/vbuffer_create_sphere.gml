/// vbuffer_create_sphere(radius, tex1, tex2, detail, smooth, invert)
/// @arg radius
/// @arg tex1
/// @arg tex2
/// @arg detail
/// @arg smooth
/// @arg invert

function vbuffer_create_sphere(rad, tex1, tex2, detail, smooth, invert)
{
	vbuffer_start()
	
	//tex1[X] += 0.25
	//tex2[X] += 0.25
	
	var i = 0;
	repeat (detail)
	{
		var ip, j;
		ip = i
		i += 1 / detail
		j = 0
		
		repeat (detail - 2)
		{
			var jp;
			jp = j
			j += 1 / (detail - 2)
			
			var texsize, texmid, n;
			texsize = point2D_sub(tex2, tex1)
			texmid = point2D_add(tex1, vec2_mul(texsize, 0.5))
			n = negate(invert)
			
			var n1x, n1y, n1z, n2x, n2y, n2z, n3x, n3y, n3z, n4x, n4y, n4z;
			var x1, y1, z1, x2, y2, z2, x3, y3, z3, x4, y4, z4;
			n1x = -sin(ip * pi * 2) * sin(jp * pi)
			n1y = cos(ip * pi * 2) * sin(jp * pi)
			n1z = -cos(jp * pi)
			n2x = -sin(ip * pi * 2) * sin(j * pi)
			n2y = cos(ip * pi * 2) * sin(j * pi)
			n2z = -cos(j * pi)
			n3x = -sin(i * pi * 2) * sin(jp * pi)
			n3y = cos(i * pi * 2) * sin(jp * pi)
			n3z = -cos(jp * pi)
			n4x = -sin(i * pi * 2) * sin(j * pi)
			n4y = cos(i * pi * 2) * sin(j * pi)
			n4z = -cos(j * pi)
			
			x1 = n1x * rad
			y1 = n1y * rad
			z1 = n1z * rad
			x2 = n2x * rad
			y2 = n2y * rad
			z2 = n2z * rad
			x3 = n3x * rad
			y3 = n3y * rad
			z3 = n3z * rad
			x4 = n4x * rad
			y4 = n4y * rad
			z4 = n4z * rad
			
			var t1z, t2z, t3z, t4z;
			t1z = n1z
			t2z = n2z
			t3z = n3z
			t4z = n4z
			if (!smooth)
			{
				var normx, normy, normz;
				normx = (n1x + n2x + n3x + n4x) / 4
				normy = (n1y + n2y + n3y + n4y) / 4
				normz = (n1z + n2z + n3z + n4z) / 4
				
				n1x = normx
				n2x = normx
				n3x = normx
				n4x = normx
				n1y = normy
				n2y = normy
				n3y = normy
				n4y = normy
				n1z = normz
				n2z = normz
				n3z = normz
				n4z = normz
			}
		
			if (jp > 0) 
			{
				if (invert)
				{
					vertex_add(x3, y3, z3, n3x * n, n3y * n, n3z * n, tex2[X] - i * texsize[X], texmid[Y] - t3z * (texsize[Y] / 2))
					vertex_add(x1, y1, z1, n1x * n, n1y * n, n1z * n, tex2[X] - ip * texsize[X], texmid[Y] - t1z * (texsize[Y] / 2))
					vertex_add(x4, y4, z4, n4x * n, n4y * n, n4z * n, tex2[X] - i * texsize[X], texmid[Y] - t4z * (texsize[Y] / 2))
				}
				else
				{
					vertex_add(x1, y1, z1, n1x * n, n1y * n, n1z * n, tex2[X] - ip * texsize[X], texmid[Y] - t1z * (texsize[Y] / 2))
					vertex_add(x3, y3, z3, n3x * n, n3y * n, n3z * n, tex2[X] - i * texsize[X], texmid[Y] - t3z * (texsize[Y] / 2))
					vertex_add(x4, y4, z4, n4x * n, n4y * n, n4z * n, tex2[X] - i * texsize[X], texmid[Y] - t4z * (texsize[Y] / 2))
				}
			}
			if (j < 1)
			{
				if (invert)
				{
					vertex_add(x4, y4, z4, n4x * n, n4y * n, n4z * n, tex2[X] - i * texsize[X], texmid[Y] - t4z * (texsize[Y] / 2))
					vertex_add(x1, y1, z1, n1x * n, n1y * n, n1z * n, tex2[X] - ip * texsize[X], texmid[Y] - t1z * (texsize[Y] / 2))
					vertex_add(x2, y2, z2, n2x * n, n2y * n, n2z * n, tex2[X] - ip * texsize[X], texmid[Y] - t2z * (texsize[Y] / 2))
				}
				else
				{
					vertex_add(x1, y1, z1, n1x * n, n1y * n, n1z * n, tex2[X] - ip * texsize[X], texmid[Y] - t1z * (texsize[Y] / 2))
					vertex_add(x4, y4, z4, n4x * n, n4y * n, n4z * n, tex2[X] - i * texsize[X], texmid[Y] - t4z * (texsize[Y] / 2))
					vertex_add(x2, y2, z2, n2x * n, n2y * n, n2z * n, tex2[X] - ip * texsize[X], texmid[Y] - t2z * (texsize[Y] / 2))
				}
			}
		}
	}
	
	return vbuffer_done()
}
