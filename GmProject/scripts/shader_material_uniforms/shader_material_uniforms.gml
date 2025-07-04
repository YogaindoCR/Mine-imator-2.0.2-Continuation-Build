/// shader_material_uniforms()
/// @desc Adds timeline material uniforms

function shader_material_uniforms()
{
	// Render setting
	new_shader_uniform("uDefaultEmissive")
	new_shader_uniform("uDefaultSubsurface")
	
	// Material textures
	new_shader_sampler("uTextureMaterial")
	new_shader_sampler("uTextureNormal")
	new_shader_uniform("uMaterialFormat")
	
	// Surface
	new_shader_uniform("uRoughness")
	new_shader_uniform("uMetallic")
	new_shader_uniform("uEmissive")
	
	// Subsurface
	new_shader_uniform("uSSS")
	new_shader_uniform("uSSSStrength")
	new_shader_uniform("uSSSRadius")
	new_shader_uniform("uSSSColor")
	new_shader_uniform("uSSSSharpness")
	new_shader_uniform("uSSSDesaturation")
	new_shader_uniform("uSSSColorThreshold")
	new_shader_uniform("uSSSHighlight")
	new_shader_uniform("uSSSHighlightStrength")
	new_shader_uniform("uSSSHighlightSharpness")
	new_shader_uniform("uSSSHighlightDesaturation")
	new_shader_uniform("uSSSHighlightColorThreshold")
	new_shader_uniform("uSSSHighQuality")
	new_shader_uniform("uAbsorption")
	
	// Other
	new_shader_uniform("uIsWater")
	new_shader_uniform("uUseNormalMap")
}