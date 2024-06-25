/// @description 

if(global.game_state == GameStates.PAUSE) exit;

if(!array_equals(p.hex,hex))
{
	hex = p.hex;
	position = hex_to_pixel(hex,true);
	x = position[1]; y = position[2];
	UpdateNeighborPositions();
}
// see if the level is progressing
var _active = false;
var _fade_rate = 0.05;
with(o_hud_interactables)
{
	if(time_source_started){ _active = true }
}
// fade in and out based on active status
if(_active)
{
	if(image_alpha != 1) image_alpha = min(1,image_alpha + _fade_rate);
} else {
	if(image_alpha != 0) image_alpha = max(0,image_alpha - _fade_rate);
}

// get index value pointing toward mouse pointer
var _dir = point_direction(x,y,mouse_x,mouse_y)+30;
if(_dir >= 360) _dir -= 360; _dir = _dir div 60;
mouse_dir_index = _dir == 6 ? 0 : _dir;

