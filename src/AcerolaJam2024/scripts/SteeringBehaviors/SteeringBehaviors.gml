function EntityMovement(){
	// this function is assumed to be run inside of a unit entity
	// will update current node as position changes

	var _col_list = ds_list_create();
	with(global.i_hex_grid)
	{	// copy the container for the current hex node in order to check collisions later
		var _hex_index = hex_get_index(other.hex); 
		if(!is_undefined(_hex_index)){ ds_list_copy(_col_list, hexarr_containers[_hex_index]) }
	}
	// calculate velocity
	velocity = vect2(
		0.08*(xTo-position[1]),
		0.08*(yTo-position[2]));
	// track onto goal position                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
	position[1] += velocity[1];
	position[2] += velocity[2];

	// collide with all entities within the same node
	for(var i=0;i<ds_list_size(_col_list);i++) EnforceMinDistance(_col_list[| i]);

	// update position
	x = position[1];
	y = position[2];
	
	ds_list_destroy(_col_list);
}
function BushMovement(){
	// this function is assumed to be run inside of a unit entity
	// will update current node as position changes

	var _col_list = ds_list_create();
	with(global.i_hex_grid)
	{	// copy the container for the current hex node in order to check collisions later
		var _hex_index = hex_get_index(other.hex); 
		if(!is_undefined(_hex_index)){ ds_list_copy(_col_list, hexarr_containers[_hex_index]) }
	}
	// calculate velocity
	velocity = vect2(
		0.12*(xTo-position[1]),
		0.12*(yTo-position[2]));
	// track onto goal position
	position[1] += velocity[1];
	position[2] += velocity[2];

	// collide with all entities within the same node
	for(var i=0;i<ds_list_size(_col_list);i++) EnforceMinDistance(_col_list[| i]);

	// update position
	x = position[1];
	y = position[2];
	
	ds_list_destroy(_col_list);
}
