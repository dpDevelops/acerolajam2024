/// @description 

// create menu functions
function Resume(){
	with(oPauseMenu)
	{
		controlsList[| 0].enabled = false;
		controlsList[| 1].enabled = false;
	
		// get menu to slide out of view
		xTo = hide_pos[1];
		yTo = hide_pos[2];
		// cause the fade out into unpause action
		trans_type = OUT;
	}
}
function ToMenu(){
	with(o_hud_interactables) time_source_started = false;
	with(oPauseMenu)
	{
		controlsList[| 0].enabled = false;
		controlsList[| 1].enabled = false;
	
		if(trans_type != NONE) trans_type = NONE;
	}
}


// Inherit the parent event
event_inherited();


xTo = global.i_camera.x;
yTo = global.i_camera.y;
x = xTo;
y = yTo + global.i_camera.viewHeightHalf;
show_pos = vect2(xTo,yTo);
hide_pos = vect2(xTo,yTo+1.5*global.i_camera.viewHeightHalf);

// set scaling
menu_9s = s_upgrade_menu_9s;
menu_size = vect2(160,120);
menu_half_w = menu_size[1] div 2;
menu_half_h = menu_size[2] div 2;
menu_xscale = menu_size[1] / sprite_get_width(s_upgrade_menu_9s);
menu_yscale = menu_size[2] / sprite_get_height(s_upgrade_menu_9s);

// transition vars
trans = false;
trans_type = IN;
trans_rate = 0.05;
bg_alpha = 0;

// Title
pause_text = "------ PAUSE ------";
var _ind = -1;
var _w = sprite_get_width(s_pause_tomenu);
// resume button
ButtonAdd(-40-(_w div 2),12,id,++_ind,"resume",s_pause_resume,undefined,"",undefined,Resume,[]);
// quit Button
ButtonAdd(40-(_w div 2),12,id,++_ind,"quit",s_pause_tomenu,undefined,"",undefined,ToMenu,[]);



