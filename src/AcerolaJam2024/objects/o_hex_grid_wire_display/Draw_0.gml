/// @description 

shader_set(shWireHex);
SendWireHexVariables();
draw_self();
shader_reset();
var _listsize = is_undefined(global.i_hex_grid.mouse_hex_index) ? -1 : ds_list_size(global.i_hex_grid.hexarr_containers[hex_get_index(grid_id.mouse_hex_coord)]);
// show the current hex cell of the mouse position
draw_set_color(c_white);
draw_set_font(f_default_s);
draw_set_alpha(1);
draw_text(mouse_x,mouse_y+10,
	controls_string+"mse = ["+string(mouse_x)+", "+string(mouse_y)+"]\n"
	+"pos = ["+string(grid_id.mouse_hex_pos[1])+", "+string(grid_id.mouse_hex_pos[2])+"]\n"
	+"hex = ["+string(grid_id.mouse_hex_coord[1])+", "+string(grid_id.mouse_hex_coord[2])+"] ("+string(current_index)+")\n"
	+"container size = ["+string(_listsize)+"]"
	);









