/// @description 

/*

draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_font(f_default_L);
var _arr = ["PLAY", "PAUSE", "VICTORY", "DEFEAT"];
var _str = "GAME STATE: " + _arr[global.game_state];
var _stack = ds_stack_top(menu_stack)
if(!is_undefined(_stack)) && (instance_exists(_stack)){
	_str += "\nCURR MENU: "+ object_get_name(ds_stack_top(menu_stack).object_index);
} else {
	_str += "\nCURR MENU: NONE"
}
_str += "\nPlayer Focus: "+ string(global.i_player.ai.focus_target);
draw_text(0, 8, _str);

