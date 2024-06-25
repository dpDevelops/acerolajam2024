/// @description 
if(!variable_instance_exists(id, "p"))
{
	show_debug_message("ERROR (movement indicator): player reference not set on creation")
	instance_destroy();
}
function UpdateNeighborPositions(){
	for(var i=0;i<6;i++)
	{
		var _hex = axial_neighbor(hex, i);
		neighbor_hex_valid[i] = (hex_is_enabled(_hex) == 1);
		neighbor_hex_positions[i] = hex_to_pixel(_hex,true);
	}
}
image_alpha = 0;
hex = p.hex;
mouse_dir_index = 0;
position = vect2(x,y);
neighbor_hex_positions = [vect2(0,0),vect2(0,0),vect2(0,0),vect2(0,0),vect2(0,0),vect2(0,0)];
neighbor_hex_valid = [0,0,0,0,0,0];
UpdateNeighborPositions();
