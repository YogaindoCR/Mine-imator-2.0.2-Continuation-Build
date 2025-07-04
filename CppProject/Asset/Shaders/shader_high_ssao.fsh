#define SAMPLES 12

varying vec2 vTexCoord;

uniform sampler2D uDepthBuffer;
uniform sampler2D uNormalBuffer;
uniform sampler2D uEmissiveBuffer;
uniform sampler2D uNoiseBuffer;
uniform sampler2D uMaskBuffer;

uniform float uNormalBufferScale;

uniform float uNear;
uniform float uFar;

uniform mat4 uProjMatrix;
uniform mat4 uProjMatrixInv;

uniform vec2 uScreenSize;
uniform float uNoiseSize;

uniform vec3 uKernel[SAMPLES];
uniform float uRadius;
uniform float uPower;
uniform vec4 uColor;

// Get depth
float unpackValue(vec4 c)
{
    return dot(c.rgb, vec3(1.0, 0.003921569, 0.00001538));
}

// Get normal Value
vec3 unpackNormal(vec4 c)
{
	return (c.rgb / uNormalBufferScale) * 2.0 - 1.0;
}

// Transform linear depth to exponential depth
float transformDepth(float depth)
{
	return (uFar - (uNear * uFar) / (depth * (uFar - uNear) + uNear)) / (uFar - uNear);
}

// Reconstruct a position from a screen space coordinate and (linear) depth
vec3 posFromBuffer(vec2 coord, float depth)
{
	vec4 pos = uProjMatrixInv * vec4(coord.x * 2.0 - 1.0, 1.0 - coord.y * 2.0, transformDepth(depth), 1.0);
	return pos.xyz / pos.w;
}

vec3 unpackNormalBlueNoise(vec4 c)
{
	return normalize(vec3(c.r, c.g, c.b * 0.5));
}

float getSSAOstrength(vec2 uv)
{
	float emissive = unpackValue(texture2D(uEmissiveBuffer, uv)) * 255.0;
	float mask = texture2D(uMaskBuffer, uv).r;
	return (1.0 - clamp(emissive, 0.0, 1.0)) * mask;
}

void main()
{
	// Perform alpha test to ignore background
	if (texture2D(uDepthBuffer, vTexCoord).a < 1.0)
		discard;
	
	// Get view space origin
	float originDepth = unpackValue(texture2D(uDepthBuffer,vTexCoord));
	vec3 origin = posFromBuffer(vTexCoord, originDepth);
	
	// Get scaled radius
	float sampleRadius = uRadius * (1.0 - originDepth);
	
	// Get normal
	vec3 normal = unpackNormal(texture2D(uNormalBuffer, vTexCoord));
	
	// Random vector from noise
	vec2 noiseScale = uScreenSize / uNoiseSize;
	vec3 randVec	= unpackNormalBlueNoise(texture2D(uNoiseBuffer, vTexCoord * noiseScale));

	// Construct kernel basis matrix
	vec3 tangent = normalize(randVec - normal * dot(randVec, normal));
	vec3 bitangent = cross(normal, tangent);
	mat3 kernelBasis = mat3(tangent, bitangent, normal);
	
	// Calculate occlusion factor
	float occlusion = 0.0;
	for (int i = 0; i < SAMPLES; i++)
	{
		// Get sample position
		vec3 samplePos = origin + (kernelBasis * uKernel[i]) * sampleRadius;
		
		// Project sample position
		vec4 sampleScreen = uProjMatrix * vec4(samplePos, 1.0);
		vec2 sampleCoord = (sampleScreen.xy / sampleScreen.w) * 0.5 + 0.5;
		sampleCoord.y = 1.0 - sampleCoord.y;
		
		// Get sample depth
		float sampleDepth = posFromBuffer(sampleCoord, unpackValue(texture2D(uDepthBuffer, sampleCoord))).z;
		
		// Get sample strength
		float sampleStrength = getSSAOstrength(sampleCoord);
		
		// Sample normal
		vec3 sampleNormal = unpackNormal(texture2D(uNormalBuffer, sampleCoord));
		
		// Add occlusion if checks succeed
		float bias = originDepth * 50.0;
		float depthCheck = (sampleDepth <= (samplePos.z - bias)) ? 1.0 : 0.0;
		float rangeCheck = smoothstep(0.0, 1.0, sampleRadius / abs(origin.z - sampleDepth));
		float angleCheck = clamp((1.0 - dot(sampleNormal, normal)) * 2.0, 0.0, 1.0);
		occlusion += depthCheck * rangeCheck * sampleStrength * angleCheck;
	}
	
	// Raise to power
	occlusion = clamp(1.0 - pow(max(0.0, 1.0 - occlusion / float(SAMPLES)), uPower), 0.0, 1.0);
	
	// Apply strength
	occlusion *= getSSAOstrength(vTexCoord);
	occlusion = clamp(occlusion, 0.0, 1.0);
	
	// Mix
	gl_FragColor = mix(vec4(1.0), uColor, occlusion);
}