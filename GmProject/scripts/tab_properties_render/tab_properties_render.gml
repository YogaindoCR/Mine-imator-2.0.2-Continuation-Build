/// tab_properties_render()

function tab_properties_render()
{
	// Render setings
	if (project_render_settings = "")
		text = text_get("projectrendersettingscustom")
	else if (text_exists("projectrendersettings" + project_render_settings))
		text = text_get("projectrendersettings" + project_render_settings)
	else
		text = filename_name(project_render_settings)
	
	tab_control_menu()
	draw_button_menu("projectrendersettings", e_menu.LIST, dx, dy, dw, 24, project_render_settings, text, action_project_render_settings)
	tab_next()
	
	if (project_render_settings != "")
		return 0
	
	dy += 8
	
	//Render Engine
	tab_control_togglebutton()
	togglebutton_add("renderenginevanilla", null, false, !project_render_engine, action_project_render_engine, tab.render.tbx_render_engine)
	togglebutton_add("renderengineex", null, true, project_render_engine, action_project_render_engine, tab.render.tbx_render_engine)
	draw_togglebutton("renderengine", dx, dy, true, true)
	tab_next()
	
	// Render distance
	tab_control_dragger()
	draw_dragger("renderdistance", dx, dy, dragger_width, project_render_distance, 1, 1000, 100000, 30000, 1, tab.render.tbx_render_distance, action_project_render_distance, null, true, false, "renderdistancetip")
	tab_next()
	
	// Render samples
	tab_control_dragger()
	draw_dragger("rendersamples", dx, dy, dragger_width, project_render_samples, .5, 1, 256, 24, 1, tab.render.tbx_samples, action_project_render_samples)
	tab_next()
	
	// SSAO
	tab_control_switch()
	
	if (project_render_engine)
			draw_button_collapse("ssao", collapse_map[?"ssao"], action_project_render_ssao, project_render_ssao, "renderhbao", "renderhbaotip") 
		else
			draw_button_collapse("ssao", collapse_map[?"ssao"], action_project_render_ssao, project_render_ssao, "renderssao", "renderssaotip")

	tab_next()
	
	if (project_render_ssao && collapse_map[?"ssao"])
	{
		tab_collapse_start()
		
		if (project_render_engine)
		{
			tab_control_meter()
			draw_meter("renderssaosample", dx, dy, dw, project_render_ssao_samples, 8, 256, 24, 1, tab.render.tbx_ssao_samples, action_project_render_ssao_samples)
			tab_next()
		}
		
		tab_control_dragger()
		draw_dragger("renderssaoradius", dx, dy, dragger_width, project_render_ssao_radius, project_render_ssao_radius / 200, 0, 256, 12, 0, tab.render.tbx_ssao_radius, action_project_render_ssao_radius)
		tab_next()
		
		tab_control_dragger()
		draw_dragger("renderssaopower", dx, dy, dragger_width, round(project_render_ssao_power * 100), .5, 0, no_limit * 100, 100, 1, tab.render.tbx_ssao_power, action_project_render_ssao_power)
		tab_next()
		
		tab_control_color()
		draw_button_color("renderssaocolor", dx, dy, dw, project_render_ssao_color, c_black, false, action_project_render_ssao_color)
		tab_next()
		
		if (project_render_engine)
		{
			tab_control_dragger()
			draw_dragger("renderssaoratio", dx, dy, dragger_width, project_render_ssao_ratio, 0.001, 0.001, 0.900, 0.112, 0, tab.render.tbx_ssao_ratio, action_project_render_ssao_ratio)
			tab_next()
		
			tab_control_dragger()
			draw_dragger("renderssaoratiobalance", dx, dy, dragger_width, project_render_ssao_ratio_balance, 0.001, 0.015, 0.975, 0.350, 0, tab.render.tbx_ssao_ratio_balance, action_project_render_ssao_ratio_balance)
			tab_next()
		}
		
		tab_collapse_end()
	}
	
	// Shadows
	tab_control_switch()
	draw_button_collapse("shadows", collapse_map[?"shadows"], action_project_render_shadows, project_render_shadows, "rendershadows")
	tab_next()
	
	if (project_render_shadows && collapse_map[?"shadows"])
	{
		tab_collapse_start()
		
		tab_control_menu()
		draw_button_menu("rendershadowssunbuffersize", e_menu.LIST, dx, dy, dw, 24, project_render_shadows_sun_buffer_size, text_get("rendershadowsbuffersize" + string(project_render_shadows_sun_buffer_size)) + " (" + string(project_render_shadows_sun_buffer_size) + "x" + string(project_render_shadows_sun_buffer_size) + ")", action_project_render_shadows_sun_buffer_size)
		tab_next()
		
		tab_control_menu()
		draw_button_menu("rendershadowsspotbuffersize", e_menu.LIST, dx, dy, dw, 24, project_render_shadows_spot_buffer_size, text_get("rendershadowsbuffersize" + string(project_render_shadows_spot_buffer_size)) + " (" + string(project_render_shadows_spot_buffer_size) + "x" + string(project_render_shadows_spot_buffer_size) + ")", action_project_render_shadows_spot_buffer_size)
		tab_next()
		
		tab_control_menu()
		draw_button_menu("rendershadowspointbuffersize", e_menu.LIST, dx, dy, dw, 24, project_render_shadows_point_buffer_size, text_get("rendershadowsbuffersize" + string(project_render_shadows_point_buffer_size)) + " (" + string(project_render_shadows_point_buffer_size) + "x" + string(project_render_shadows_point_buffer_size) + ")", action_project_render_shadows_point_buffer_size)
		tab_next()
		
		tab_control_switch()
		draw_switch("rendershadowstransparent", dx, dy, project_render_shadows_transparent, action_project_render_shadows_transparent)
		tab_next()
		
		if (project_render_engine) {
			tab_control_switch()
			draw_dragger("rendershadowsblursample", dx, dy, dragger_width, project_render_shadows_blur_sample, 1, 1, 128, 20, 1, tab.render.tbx_shadows_blur_sample, action_project_render_shadows_blur_sample)
			tab_next()
			
			tab_control_switch()
			draw_dragger("rendershadowsblur", dx, dy, dragger_width, project_render_shadows_blur, (project_render_shadows_blur / 500) + 0.001, 0, 10.000, 1.000, 0.001, tab.render.tbx_shadows_blur, action_project_render_shadows_blur)
			tab_next()
		}
		
		tab_collapse_end()
	}
	
	// Subsurface scattering
	tab_control_switch()
	draw_button_collapse("subsurface", collapse_map[?"subsurface"], null, true, "rendersubsurfacescattering", "rendersubsurfacescatteringtip")
	tab_next()
	
	if (collapse_map[?"subsurface"])
	{
		tab_collapse_start()
		
		if (project_render_engine && setting_advanced_mode) {
			tab_control_switch()
			draw_switch("rendersubsurfacescatterquality2", dx, dy, project_render_subsurface_quality, action_project_render_subsurface_quality, "rendersubsurfacescatterquality2tip")
			tab_next()
			dy += 10
		}
		
		tab_control_meter()
		draw_meter("rendersubsurfacescattersample", dx, dy, dw, project_render_subsurface_samples, 0, 32, 7, 1, tab.render.tbx_subsurface_samples, action_project_render_subsurface_samples)
		tab_next()
		
		if (project_render_engine && setting_advanced_mode) {
			tab_control_dragger()
			draw_dragger("rendersubsurfacescatterstrength", dx, dy, dragger_width, round(project_render_subsurface_strength * 100), 0.1, 0, no_limit, 100, 1, tab.render.tbx_subsurface_strength, action_project_render_subsurface_strength)
			tab_next()
			
			tab_control_dragger()
			draw_dragger("rendersubsurfacescattersharpness", dx, dy, dragger_width, project_render_subsurface_sharpness, 0.01, 0, no_limit, 0.5, 0.01, tab.render.tbx_subsurface_sharpness, action_project_render_subsurface_sharpness)
			tab_next()
			
			tab_control_dragger()
			draw_dragger("rendersubsurfacescatterdesaturation", dx, dy, dragger_width, round(project_render_subsurface_desaturation * 100), 0.1, 0, 100, 0, 1, tab.render.tbx_subsurface_desaturation, action_project_render_subsurface_desaturation, null, true, false, "rendersubsurfacescatterdesaturationtip")
			tab_next()
			
			tab_control_dragger()
			draw_dragger("rendersubsurfacescattercolorthreshold", dx, dy, dragger_width, round(project_render_subsurface_colorthreshold * 100), 0.1, 0, 100, 0, 1, tab.render.tbx_subsurface_colorthreshold, action_project_render_subsurface_colorthreshold, null, true, false, "rendersubsurfacescattercolorthresholdtip")
			tab_next()
		
			dy += 10
		}
		
		tab_control_meter()
		draw_meter("rendersubsurfacescatterhighlight", dx, dy, dw, round(project_render_subsurface_highlight * 100), 0, 100, 50, 1, tab.render.tbx_subsurface_highlight, action_project_render_subsurface_highlight, "rendersubsurfacescatterhighlighttip")
		tab_next()
		
		tab_control_dragger()
		draw_dragger("rendersubsurfacescatterhighlightstrength", dx, dy, dragger_width, round(project_render_subsurface_highlight_strength * 100), 0.1, 0, no_limit, 100, 1, tab.render.tbx_subsurface_highlight_strength, action_project_render_subsurface_highlight_strength)
		tab_next()
		
		if (project_render_engine && setting_advanced_mode) {
			tab_control_dragger()
			draw_dragger("rendersubsurfacescatterhighlightsharpness", dx, dy, dragger_width, project_render_subsurface_highlight_sharpness, 0.01, 0, no_limit, 0.5, 0.01, tab.render.tbx_subsurface_highlight_sharpness, action_project_render_subsurface_highlight_sharpness)
			tab_next()
			
			tab_control_dragger()
			draw_dragger("rendersubsurfacescatterhighlightdesaturation", dx, dy, dragger_width, round(project_render_subsurface_highlight_desaturation * 100), 0.1, 0, 100, 0.1, 1, tab.render.tbx_subsurface_highlight_desaturation, action_project_render_subsurface_highlight_desaturation)
			tab_next()
			
			tab_control_dragger()
			draw_dragger("rendersubsurfacescatterhighlightcolorthreshold", dx, dy, dragger_width, round(project_render_subsurface_highlight_colorthreshold * 100), 0.1, 0, 100, 0.1, 1, tab.render.tbx_subsurface_highlight_colorthreshold, action_project_render_subsurface_highlight_colorthreshold)
			tab_next()
		
			dy += 10
			
			tab_control_meter()
			draw_meter("rendersubsurfacescatterabsorption", dx, dy, dw, round(project_render_subsurface_absorption * 100), 0, 100, 25, 1, tab.render.tbx_subsurface_absorption, action_project_render_subsurface_absorption, "rendersubsurfacescatterabsorptiontip")
			tab_next()
		}
		
		tab_collapse_end()
	}
	
	// Indirect lighting
	tab_control_switch()
	if (project_render_engine) {
			draw_button_collapse("indirect", collapse_map[?"indirect"], action_project_render_indirect, project_render_indirect, "renderindirectgi", "renderindirecttip")
		} else {
			draw_button_collapse("indirect", collapse_map[?"indirect"], action_project_render_indirect, project_render_indirect, "renderindirect", "renderindirecttip")
		}
	tab_next()
	
	if (project_render_indirect && collapse_map[?"indirect"])
	{
		tab_collapse_start()
		
		tab_control_meter()
		draw_meter("renderindirectprecision", dx, dy, dw, round(project_render_indirect_precision * 100), 0, 100, 30, 1, tab.render.tbx_indirect_precision, action_project_render_indirect_precision, "renderindirectprecisiontip")
		tab_next()
		
		tab_control_meter()
		if (!project_render_engine)
			draw_meter("renderindirectblurradius", dx, dy, dw, round(project_render_indirect_blur_radius * 100), 0, 500, 100, 1, tab.render.tbx_indirect_blur_radius, action_project_render_indirect_blur_radius)
		else
			draw_meter("renderindirectblurradius", dx, dy, dw, round(project_render_indirect_blur_radius_gi * 100), 0, 500, 100, 1, tab.render.tbx_indirect_blur_radius_gi, action_project_render_indirect_blur_radius_gi)
		tab_next()
		
		tab_control_dragger()
		draw_dragger("renderindirectstrength", dx, dy, dragger_width, round(project_render_indirect_strength * 100), .5, 0, no_limit * 100, 100, 1, tab.render.tbx_indirect_strength, action_project_render_indirect_strength) 
		tab_next()
		
		if (project_render_engine)
		{
			tab_control_dragger()
			draw_dragger("renderindirectraystep", dx, dy, dragger_width, project_render_indirect_raystep, 0.3, 1, 80, 18, 1, tab.render.tbx_indirect_raystep, action_project_render_indirect_raystep, null, true, false, "renderindirectraysteptip")
			tab_next()
		}
		
		dy += 10
		
		tab_control_switch()
		draw_button_collapse("indirectdenoiser", collapse_map[?"indirectdenoiser"], action_project_render_indirect_denoiser, project_render_indirect_denoiser, "renderindirectdenoiser", "renderindirectdenoisertip")
		tab_next()
		
		if (project_render_indirect_denoiser && collapse_map[?"indirectdenoiser"])
		{
			tab_collapse_start()
		
			dy -= 4
			
			tab_control_dragger()
			draw_dragger("renderindirectdenoiserstrength", dx, dy, dragger_width, project_render_indirect_denoiser_strength, project_render_indirect_denoiser_strength / 400, 1, 300, 100, 1, tab.render.tbx_indirect_denoiser_strength, action_project_render_indirect_denoiser_strength, null, true, false)
			tab_next()
			
			tab_collapse_end()
		}
		
		tab_collapse_end()
	}
	
	// Reflections
	tab_control_switch()
	if (project_render_engine){
			draw_button_collapse("reflections", collapse_map[?"reflections"], action_project_render_reflections, project_render_reflections, "renderreflectionsfull")
		} else {
			draw_button_collapse("reflections", collapse_map[?"reflections"], action_project_render_reflections, project_render_reflections, "renderreflections")
		}
	tab_next()
	
	if (project_render_reflections && collapse_map[?"reflections"])
	{
		tab_collapse_start()
		
		tab_control_meter()
		draw_meter("renderreflectionsprecision", dx, dy, dw, round(project_render_reflections_precision * 100), 0, 100, 30, 1, tab.render.tbx_reflections_precision, action_project_render_reflections_precision, "renderreflectionsprecisiontip") 
		tab_next()
		
		tab_control_meter()
		draw_meter("renderreflectionsfadeamount", dx, dy, dw, round(project_render_reflections_fade_amount * 100), 0, 100, 50, 1, tab.render.tbx_reflections_fade_amount, action_project_render_reflections_fade_amount, "renderreflectionsfadeamounttip") 
		tab_next()
		
		tab_control_dragger()
		draw_dragger("renderreflectionsthickness", dx, dy, dragger_width, project_render_reflections_thickness, 1, .1, no_limit, 1, .1, tab.render.tbx_reflections_thickness, action_project_render_reflections_thickness, null, true, false, "renderreflectionsthicknesstip") 
		tab_next()
		
		tab_collapse_end()
	}
	
	// Glow
	tab_control_switch()
	draw_button_collapse("glow", collapse_map[?"glow"], action_project_render_glow, project_render_glow, "renderglow")
	tab_next()
	
	if (project_render_glow && collapse_map[?"glow"])
	{
		tab_collapse_start()
		
		tab_control_dragger()
		draw_dragger("renderglowradius", dx, dy, dragger_width, round(project_render_glow_radius * 100), .5, 0, no_limit * 100, 100, 1, tab.render.tbx_glow_radius, action_project_render_glow_radius)
		tab_next()
		
		tab_control_dragger()
		draw_dragger("renderglowintensity", dx, dy, dragger_width, round(project_render_glow_intensity * 100), .5, 0, no_limit * 100, 100, 1, tab.render.tbx_glow_intensity, action_project_render_glow_intensity)
		tab_next()
		
		tab_control_switch()
		draw_button_collapse("glow_falloff", collapse_map[?"glow_falloff"], action_project_render_glow_falloff, project_render_glow_falloff, "renderglowfalloff")
		tab_next()
		
		// Secondary glow
		if (project_render_glow_falloff && collapse_map[?"glow_falloff"])
		{
			tab_collapse_start()
			
			tab_control_dragger()
			draw_dragger("renderglowfalloffradius", dx, dy, dragger_width, round(project_render_glow_falloff_radius * 100), .5, 0, no_limit * 100, 200, 1, tab.render.tbx_glow_falloff_radius, action_project_render_glow_falloff_radius)
			tab_next()
			
			tab_control_dragger()
			draw_dragger("renderglowfalloffintensity", dx, dy, dragger_width, round(project_render_glow_falloff_intensity * 100), .5, 0, no_limit * 100, 100, 1, tab.render.tbx_glow_falloff_intensity, action_project_render_glow_falloff_intensity)
			tab_next()
			
			tab_collapse_end(false)
		}
		
		tab_collapse_end()
	}
	
	// AA
	tab_control_switch()
	draw_button_collapse("aa", collapse_map[?"aa"], action_project_render_aa, project_render_aa, "renderaa", "renderaatip")
	tab_next()
	
	if (project_render_aa && collapse_map[?"aa"])
	{
		tab_collapse_start()
		
		tab_control_meter()
		draw_meter("renderaapower", dx, dy, dw, round(project_render_aa_power * 100), 0, 300, 100, 1, tab.render.tbx_aa_power, action_project_render_aa_power)
		tab_next()
		
		tab_collapse_end()
	}
	
	// Texture filtering
	tab_control_switch()
	draw_button_collapse("texfilter", collapse_map[?"texfilter"], action_project_render_texture_filtering, project_render_texture_filtering, "rendertexturefiltering", "rendertexturefilteringtip")
	tab_next()
	
	if (project_render_texture_filtering && collapse_map[?"texfilter"])
	{
		tab_collapse_start()
		
		// Transparent block texture filtering
		tab_control_switch()
		draw_switch("rendertexturefilteringtransparentblocks", dx, dy, project_render_transparent_block_texture_filtering, action_project_render_transparent_block_texture_filtering)
		tab_next()
		
		// Texture filtering level
		tab_control_meter()
		draw_meter("rendertexturefilteringlevel", dx, dy, dw, project_render_texture_filtering_level, 0, 5, 1, 1, tab.render.tbx_texture_filtering_level, action_project_render_texture_filtering_level)
		tab_next()
		
		tab_collapse_end()
	}
	
	// Light management
	tab_control_switch()
	draw_button_collapse("light_management", collapse_map[?"light_management"], null, true, "renderlightmanagement")
	tab_next()
	
	if (collapse_map[?"light_management"])
	{
		tab_collapse_start()
		
		// Tonemapper
		if (project_render_tonemapper == e_tonemapper.REINHARD)  
		    text = text_get("rendertonemapperreinhard")  
		else if (project_render_tonemapper == e_tonemapper.ACES)  
		    text = text_get("rendertonemapperaces")  
		else if (project_render_tonemapper == e_tonemapper.FILMIC)  
		    text = text_get("rendertonemapperfilmic")
		else if (project_render_tonemapper == e_tonemapper.ACES_APPROX)  
		    text = text_get("rendertonemapperacesapprox")  
		else  
		    text = text_get("rendertonemappernone");
		
		tab_control_menu()
		draw_button_menu("rendertonemapper", e_menu.LIST, dx, dy, dw, 24, project_render_tonemapper, text, action_project_render_tonemapper)
		tab_next()
		
		// Exposure
		tab_control_dragger()
		draw_dragger("renderexposure", dx, dy, dragger_width, project_render_exposure, 0.01, 0, no_limit, 1, 0.01, tab.render.tbx_exposure, action_project_render_exposure)
		tab_next()
		
		// Gamma
		tab_control_dragger()
		draw_dragger("rendergamma", dx, dy, dragger_width, project_render_gamma, 0.01, 0, no_limit, 2.2, 0.01, tab.render.tbx_gamma, action_project_render_gamma)
		tab_next()
		
		tab_collapse_end()
	}
	
	// Models and scenery
	tab_control_switch()
	draw_button_collapse("models_scenery", collapse_map[?"models_scenery"], null, true, "rendermodelsscenery")
	tab_next()
	
	if (collapse_map[?"models_scenery"])
	{
		tab_collapse_start()
		
		// Bending style
		tab_control_togglebutton()
		togglebutton_add("renderbendstylerealistic", null, "realistic", project_bend_style = "realistic", action_project_bend_style)
		togglebutton_add("renderbendstyleblocky", null, "blocky", project_bend_style = "blocky", action_project_bend_style)
		draw_togglebutton("renderbendstyle", dx, dy)
		tab_next()
		
		// Opaque leaves
		tab_control_switch()
		draw_switch("renderopaqueleaves", dx, dy, project_render_opaque_leaves, action_project_render_opaque_leaves)
		tab_next()
		
		// Liquid waves
		tab_control_switch()
		draw_switch("renderliquidanimation", dx, dy, project_render_liquid_animation, action_project_render_liquid_animation)
		tab_next()
		
		// Water reflections
		tab_control_switch()
		draw_switch("renderwaterreflections", dx, dy, project_render_water_reflections, action_project_render_water_reflections, "renderwaterreflectionshelp")
		tab_next()
		
		tab_collapse_end()
	}
	
	// Glint settings
	tab_control_switch()
	draw_button_collapse("glint", collapse_map[?"glint"], null, true, "renderglint")
	tab_next()
	
	if (collapse_map[?"glint"])
	{
		tab_collapse_start()
		
		tab_control_dragger()
		draw_dragger("renderglintspeed", dx, dy, dragger_width, round(project_render_glint_speed * 100), 1, 0, no_limit, 100, 1, tab.render.tbx_glint_speed, action_project_render_glint_speed)
		tab_next()
	
		tab_control_dragger()
		draw_dragger("renderglintstrength", dx, dy, dragger_width, round(project_render_glint_strength * 100), 1, 0, no_limit, 100, 1, tab.render.tbx_glint_strength, action_project_render_glint_strength)
		tab_next()
		
		tab_collapse_end()
	}
	
	//Extra Settings
	if (project_render_engine){
		tab_control_switch()
		draw_button_collapse("extrasettings", collapse_map[?"extrasettings"], null, true, "renderextrasettings")
		
		tab_next()
		if (collapse_map[?"extrasettings"])
			{
				tab_collapse_start()
		
				tab_control_meter()
				draw_meter("renderextrasettingsdofsample", dx, dy, dw, project_render_dof_sample, 1, 6, 3, 1, tab.render.tbx_dof_sample, action_project_render_dof_sample)
				tab_next()
		
				tab_control_switch()
				draw_switch("renderextrasettingsdofghostingfix", dx, dy, project_render_dof_ghostingfix, action_project_render_dof_ghostingfix, "renderextrasettingsdofghostingfixtip")
				tab_next()
				
				if (project_render_dof_ghostingfix) {
					tab_collapse_start()
					
					tab_control_dragger()
					draw_dragger("renderextrasettingsdofghostingfixthreshold", dx, dy, dragger_width, round(project_render_dof_ghostingfix_threshold * 100), 1, 0, 100, 75, 0.1, tab.render.tbx_dof_ghostingfix_threshold, action_project_render_dof_ghostingfix_threshold)
					tab_next()
				
					tab_collapse_end()
				}
				
				tab_collapse_end()
			}
	}
	
	//Motion Blur
	tab_control_switch()
	draw_button_collapse("motionblur", collapse_map[?"motionblur"], action_project_render_motionblur, project_render_motionblur, "rendermotionblur", "rendermotionblurtip")
	tab_next()
				
	if (project_render_motionblur && collapse_map[?"motionblur"])
		{
			tab_collapse_start()
			
			tab_control_meter()
			draw_meter("rendermotionblurpower", dx, dy, dw, (project_render_motionblur_power * 100), 1, 99, 10, 1, tab.render.tbx_motionblur_power, action_project_render_motionblur_power)
			tab_next()
		
			tab_collapse_end()
		}
		
		
	// Default emissive
	tab_control_dragger()
	draw_dragger("renderdefaultemissive", dx, dy, dragger_width, round(project_render_block_emissive * 100), 1, 0, no_limit, 100, 1, tab.render.tbx_block_emissive, action_project_render_block_emissive, null, true, false, "renderdefaultemissivetip")
	tab_next()
	
	// Default subsurface
	tab_control_dragger()
	draw_dragger("renderdefaultsubsurfaceradius", dx, dy, dragger_width, project_render_block_subsurface, .1, 0, no_limit, 8, 0.01, tab.render.tbx_block_subsurface_radius, action_project_render_block_subsurface, null, true, false, "renderdefaultsubsurfaceradiustip")
	tab_next()
	
	// Alpha mode
	text = (project_render_alpha_mode = e_alpha_mode.BLEND ? text_get("renderalphamodeblend") : text_get("renderalphamodehashed"));
	tab_control_menu()
	draw_button_menu("renderalphamode", e_menu.LIST, dx, dy, dw, 24, project_render_alpha_mode, text, action_project_render_alpha_mode)
	tab_next()
	
	// Material maps
	tab_control_switch()
	draw_switch("rendermaterialmaps", dx, dy, project_render_material_maps, action_project_render_material_maps, "rendermaterialmapstip")
	tab_next()
	
	tab_control(24)
	
	// Import render settings
	if (draw_button_icon("renderimport", dx, dy, 24, 24, false, icons.SETTINGS_IMPORT, null, false, "tooltipsettingsimport"))
		action_project_render_import()
	
	// Export render settings
	if (draw_button_icon("renderexport", dx + 28, dy, 24, 24, false, icons.SETTINGS_EXPORT, null, false, "tooltipsettingsexport"))
		action_project_render_export()
	
	// Set current render settings as default
	if (draw_button_icon("rendersetdefault", dx + (28 * 2), dy, 24, 24, false, icons.SETTINGS_SETDEFAULT, null, false, "tooltipsettingssetdefault"))
	{
		if (question(text_get("questionsetasdefault")))
			action_project_render_export(render_default_file)
	}
	
	// Reset render settings
	draw_button_icon("renderreset", dx + (28 * 3), dy, 24, 24, false, icons.RESET, action_project_render_reset, false, "tooltipsettingsreset")
	
	tab_next()
}
