/// @description 

draw_set_alpha(image_alpha)
for(var i=0;i<6;i++)
{
	var _pos = neighbor_hex_positions[i];
	var _img = i == mouse_dir_index ? 2 : 1;
	if(!neighbor_hex_valid[i]) _img = 0;
	draw_sprite(s_player_move_indicator, _img, _pos[1], _pos[2]);
}
