/// action_project_render_dof_ghostingfix_threshold(value, add)
/// @arg value
/// @arg add

function action_project_render_dof_ghostingfix_threshold(val, add)
{
	if (!history_undo && !history_redo)
		history_set_var(action_project_render_dof_ghostingfix_threshold, project_render_dof_ghostingfix_threshold, project_render_dof_ghostingfix_threshold * add + val / 100, 1)
	else
		val *= 100
	
	project_render_dof_ghostingfix_threshold = project_render_dof_ghostingfix_threshold * add + val / 100
	render_samples = -1
}
