function CheckNodeChange(_entity){
	with(_entity)
	{
		// this function is assumed to be run inside of a unit entity
		// will update current node as position changes
		var _new_hex = undefined;
		var _new_index = undefined;
		var _new_list = undefined;
		var _old_hex = undefined;
		var _old_index = undefined;
		var _old_list = undefined;
		
		with(global.i_hex_grid)
		{
			_new_hex = pixel_to_hex(other.position);
			_new_index = hex_get_index(_new_hex);
		}
		
		// leave script unless the node location has changed
		if(is_undefined(_new_index)) || (array_equals(_new_hex, hex)) return false;
	
		// get necessary data
		with(global.i_hex_grid)
		{
			_old_hex = other.hex;
			_old_index = hex_get_index(_old_hex);
			_old_list = hexarr_containers[_old_index];
			_new_list = hexarr_containers[_new_index];
		}
		
		//add to new list
		ds_list_add(_new_list, id)
		//remove from old list
		ds_list_delete(_old_list, ds_list_find_index(_old_list, id));
		
		// update hex references
		hex_prev = _old_hex;
		hex = _new_hex;
		
		// run fighter update (get index numbers for all hex nodes in range)
		if(!is_undefined(fighter))
		{
			with(global.i_hex_grid)
			{
				// get hexes in range
				other.nodes_in_range = hex_in_radius(other.hex, other.fighter.range);
			}
		}
		// indicate that the hex node has changed, in order to recalc enemies for fighters
		with(global.i_engine){ 
			if(!recalc_enemies_in_range) recalc_enemies_in_range = true; 
		}
		return true;
	}
}
