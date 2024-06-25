/// @description 


bbox[0] = camera_get_view_x(view_camera[0]) + x;
bbox[1] = camera_get_view_y(view_camera[0]) + y;


if(ds_stack_size(global.i_engine.menu_stack) == 0)
{
	if(image_alpha != 1) image_alpha = min(1, image_alpha+0.08);
} else {
	if(image_alpha != 0) image_alpha = 0;
}

with(oLevelManager)
{
	// get the time string from the level manager
	other.time_string = "TIME LEFT: " + timer_minutes_string + ":" + timer_seconds_string; // + "." + timer_milliseconds_string;
}