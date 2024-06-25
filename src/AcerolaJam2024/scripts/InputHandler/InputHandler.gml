/*
    the input handlers need to run inside of the engine, or else the variable references will be out of scope
*/
double_click_time = 3;
double_click_timer = -1;

//--// MOUSE HANDLERS //--//
function handle_mouse(game_state){
	switch(global.game_state)
	{
		case GameStates.PLAY:
			if(ds_stack_size(menu_stack) == 0){
				return handle_default_mouse();
			} else {
				return handle_menu_mouse();
			}
			break;
		case GameStates.PAUSE:
			return handle_default_mouse();
			break;
		case GameStates.VICTORY:
			return handle_default_mouse();
			break;
		case GameStates.DEFEAT:
			return handle_default_mouse();
			break;
	}
}

function handle_default_mouse(){
	// left mouse
	if(mouse_check_button_released(mb_left)){
		return { player_focus_command : new Command("player_focus_command",global.mouse_focus,0,0) }
	} else if mouse_check_button_pressed(mb_left){}

	// right mouse (allow player to move)
	if(global.i_player.move_timer <= 0) && (mouse_check_button(mb_right)){
		if(!array_equals(global.i_hex_grid.mouse_hex_coord, global.i_player.hex))
		{
			return { player_move_command : new Command(
								"player_move_command", 
								point_direction(global.i_player.x, global.i_player.y,mouse_x,mouse_y),
								0, 0) }
		}
	} else if(mouse_check_button_pressed(mb_right)){}

    return {}
}
function handle_menu_mouse(){
	// middle mouse / wheel
	if(mouse_check_button_pressed(mb_middle)){
        return {}
    } else if(mouse_wheel_up()){
        return { menu_scroll_up : new Command("menu_up",true,0,0) }
    } else if(mouse_wheel_down()){
		return { menu_scroll_down : new Command("menu_down",true,0,0) }
    } 
    return {}
}

//--// KEYBOARD HANDLERS //--//
function handle_keys(game_state){
	switch(game_state)
	{
		case GameStates.PLAY:
			if(ds_stack_size(menu_stack) > 0)
			{
				return handle_menu_keys();
			} else {
				return handle_play_keys();
			}
			break;
		case GameStates.PAUSE:
			return handle_pause_keys();
			break;
		case GameStates.VICTORY:
			return handle_play_keys();
			break;
		case GameStates.DEFEAT:
			return handle_play_keys();
			break;
	}
}

function handle_play_keys(){
    // pause
    if(keyboard_check_pressed(vk_escape))
    {
		return {  }
		return { escape : new Command("escape",true,0,0) }
	}
    // camera pan
    var _move = [keyboard_check(ord("D")) - keyboard_check(ord("A")), keyboard_check(ord("S")) - keyboard_check(ord("W"))];
    var _fast_pan = keyboard_check(vk_shift);
    if(_move[0] != 0) || (_move[1] != 0) 
    {
        if(_fast_pan){
            return { camera_fast_pan : new Command("camera_fast_pan",_move,0,0) };
        } else {
            return { camera_pan : new Command("camera_pan",_move,0,0) };
        }
    }
    return {}
}
function handle_menu_keys(){
	// menu next item
	if(keyboard_check_pressed(ord("S"))){ return {menu_next_item : new Command("next_item",true,0,0)} }
	// menu previous item
	if(keyboard_check_pressed(ord("W"))){ return {menu_prev_item : new Command("prev_item",true,0,0)} }
	// menu next tab
	if(keyboard_check_pressed(ord("D"))){ return {menu_next_tab : new Command("next_tab",true,0,0)} }
	// menu previous tab
	if(keyboard_check_pressed(ord("A"))){ return {menu_prev_tab : new Command("prev_tab",true,0,0)} }	
	// close the menu if possible
	if(keyboard_check_pressed(vk_escape)){ return {menu_close_command : new Command("menu_close",true,0,0)} }
	// return nothing
	return {}
}
function handle_pause_keys(){
    // unpause
    if(keyboard_check_pressed(vk_escape))
    {
		return { }
		return {escape : new Command("escape",true,0,0)}
	}
	return {}
}
