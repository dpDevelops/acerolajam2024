/// @description run game

//--// get inputs
mouse_action = handle_mouse(global.game_state);
action = handle_keys(global.game_state);

//--// parse inputs
menu_next_item = action[$ "menu_next_item"];
menu_prev_item = action[$ "menu_prev_item"];
menu_next_tab = action[$ "menu_next_tab"];
menu_prev_tab = action[$ "menu_prev_tab"];
menu_scroll_up = mouse_action[$ "menu_scroll_up"];
menu_scroll_down = mouse_action[$ "menu_scroll_down"];
menu_open_command = action[$ "menu_open_command"];
menu_close_command = action[$ "menu_close_command"];

escape = action[$ "escape"];
player_move_command = mouse_action[$ "player_move_command"];
player_focus_command = mouse_action[$ "player_focus_command"];
camera_pan = action[$ "camera_pan"];
camera_fast_pan = action[$ "camera_fast_pan"];
camera_zoomout = mouse_action[$ "camera_zoomout"];
camera_zoomin = mouse_action[$ "camera_zoomin"];

//--// execute inputs
if(!is_undefined(menu_next_item)){ show_debug_message("menu next item"); }
if(!is_undefined(menu_prev_item)){ show_debug_message("menu prev item"); }
if(!is_undefined(menu_next_tab)){ show_debug_message("menu next tab"); }
if(!is_undefined(menu_prev_tab)){ show_debug_message("menu prev tab"); }
if(!is_undefined(menu_scroll_up)){ show_debug_message("menu scroll up"); }
if(!is_undefined(menu_scroll_down)){ show_debug_message("menu scroll down"); }
if(!is_undefined(menu_open_command)){
	show_debug_message("menu open command");
	instance_create_depth(0,0,UPPERDEPTH,menu_open_command.value);
}
if(!is_undefined(menu_close_command))
{
	show_debug_message("menu close command");
	if(ds_stack_size(menu_stack) == 0){} else {
		var _menu = ds_stack_top(menu_stack);
		if(_menu.closable){
			instance_destroy(ds_stack_pop(menu_stack));
		}
	}
}
if(!is_undefined(camera_pan)){
	var _val = other.camera_pan.value;
	with(global.i_camera)
	{
		var _vect = vect2(_val[0], _val[1]);
		var _vect = vect_multr(vect_norm(_vect), spd);
		xTo += _vect[1];
		yTo += _vect[2];
	}
} else if(!is_undefined(camera_fast_pan)){
	var _val = other.camera_fast_pan.value;
	with(global.i_camera)
	{
		var _vect = vect2(_val[0], _val[1]);
		var _vect = vect_multr(vect_norm(_vect), spdFast);
		xTo += _vect[1];
		yTo += _vect[2];
	}
}
if(!is_undefined(player_move_command)){
	global.i_player.Move(other.player_move_command.value);
}
if(!is_undefined(player_focus_command)){
	var _tgt = player_focus_command.value;
	if(_tgt != noone) && (_tgt.faction == FACTION_PLAYER) _tgt = noone;
	global.i_player.ai.focus_target = _tgt; 
	with(o_player_focus) instance_destroy();
	if(_tgt != noone) instance_create_depth(_tgt.position[1], _tgt.position[2],UPPERDEPTH+20,o_player_focus);
}
var _zoom = !is_undefined(camera_zoomout) + 2*!is_undefined(camera_zoomin);
if(_zoom > 0)
{
	if(alarm[1] == -1)
	{
		alarm[1] = zoom_delay_time;
		if(_zoom == 1){
			view_zoom = view_zoom == 0.5 ? 1 : 2; // zoom out
		} else {
			view_zoom = view_zoom == 2 ? 1 : 0.5; // zoom in
		}
		with(global.i_camera)
		{
			camera_set_view_size(cam, global.i_engine.idealWidth*global.i_engine.view_zoom, global.i_engine.idealHeight*global.i_engine.view_zoom);
			viewWidthHalf = round(0.5*camera_get_view_width(cam));
			viewHeightHalf = round(0.5*camera_get_view_height(cam));	
			camera_set_view_pos(cam, x-viewWidthHalf, y-viewHeightHalf);
		}
	}
}
if(!is_undefined(escape)){
	show_debug_message("ESCAPE ACTION");
}
if(keyboard_check_pressed(ord("I"))) instance_create_depth(0,0,UPPERDEPTH,oDefeatMenu);

// game update loop
if(global.game_state != GameStates.PAUSE)
{
	with(pEntity)
	{ // detemine whether the entity should be drawn or not
		if(object_index == oPlayer) && (global.player_dead)
		{
			visible = false;
		}else{
			EntityVisibility();
		}
		if(global.game_state = GameStates.PLAY)
		{
			// update fighters (this mainly handles attack cooldowns)
			if(!is_undefined(fighter)) fighter.Update();

			// perform ai actions
			if(!is_undefined(ai)) ai.Update();
		}
		// do the general update
		Update();
	}
	
	// refresh enemies_in_range for all fighters
	if(recalc_enemies_in_range)
	{
		recalc_enemies_in_range = false;
		with(pEntity)
		{
			if(!is_undefined(fighter)) fighter.FindEnemies();
			if(object_index == oBush){ CheckForPlayer() }
		}
	}
}
