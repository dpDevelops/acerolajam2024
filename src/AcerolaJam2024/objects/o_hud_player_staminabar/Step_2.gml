/// @description 

bbox[0] = camera_get_view_x(view_camera[0]) + x;
bbox[1] = camera_get_view_y(view_camera[0]) + y;
bbox[2] = bbox[0]+width;
bbox[3] = bbox[1]+height;

if(ds_stack_size(global.i_engine.menu_stack) == 0)
{
	if(image_alpha != 1) image_alpha = min(1, image_alpha+0.08);
} else {
	if(image_alpha != 0) image_alpha = 0;
}

var p_move = global.i_player.move_timer;
var p_move_set = global.i_player.move_timer_set_point;

p_stamina = clamp(100*(1-(p_move/p_move_set)),0,100);

color = p_stamina == 100 ? color_max : color_norm;
