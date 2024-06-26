/*
	this script is intended to contain everything that is needed to instantiate a 
	hexagonal grid system for use in projects.  it assumes 'Axial' coordinates are used
	and can alternate hexagon types and sizes (this hsould be updated to use variables for 
	the grid properties instead of macros).  The 'vector_functions' will be reference in 
	conjuction with this one to supplement sone of the functions.
	
	All functions must be run by the hex_grid object in order to variable references to work
*/

#macro FLATTOP 0
#macro POINTYTOP 1
#macro ODD_R 0
#macro EVEN_R 1
#macro ODD_Q 2
#macro EVEN_Q 3

// node types
#macro NULLNODE 0
#macro SPAWNNODE 1
#macro GOALNODE 2

function InitHexagonalGrid(_tile_type, _offset_type, _size, _ox, _oy, _max_width, _max_height){
	// _type determines whether it uses pointy-top or flat-top hexagons
	// _offset determines how the tiles' position will be offset (Q refers to column offset & R refere to row offset)
	// _size represents the 'radius' of a circle which contains the hexagon
	var _struct = {
		hex_heap : undefined,
		hex_type : _tile_type,
		hex_size : _size,
		offset_type : _offset_type,
		origin :  vect2(_ox, _oy),
		h_spacing : _tile_type ? sqrt(3)*_size : 1.5*_size,
		v_spacing : _tile_type ? 1.5*_size : sqrt(3)*_size,
		axial_direction_vectors : [
			vect2(1,0),vect2(1,-1),vect2(0,-1),
			vect2(-1,0),vect2(-1,1),vect2(0,1)
		],
		hexgrid_width_max : _max_width,
		hexgrid_height_max : _max_height,
		hexgrid_height_pixels : 0,
		hexgrid_width_pixels : 0,
	}
	global.i_hex_grid = instance_create_layer(_ox, _oy, "Instances",o_hex_grid, _struct);
	global.hex_wgrid = _max_width;
	global.hex_hgrid = _max_height;
	
	// create all data structures
	with(global.i_hex_grid){
		depth = 0;
		var _cellcount = hexgrid_width_max*hexgrid_height_max;
		
		hexmap_loaded_filename = "";
		hexmap = ds_map_create(); // stores index values to be used
		// create unit vectors for each direction
		hex_unit_vectors = [vect2(1,0),vect2(1,-1),vect2(0,-1),vect2(-1,0),vect2(-1,1),vect2(0,1)];
		// calc the width and height of the grid
		hexgrid_width_pixels = hexgrid_width_max*h_spacing;
		hexgrid_height_pixels = hexgrid_height_max*v_spacing;
	
		// set data arrays
		hexgrid_enabled_list = ds_list_create();
		hexgrid_spawn_list = ds_list_create();
		hexgrid_goal_list = ds_list_create();
		hexarr_is_spawn = array_create(_cellcount,0);
		hexarr_is_goal = array_create(_cellcount,0);
		hexarr_enabled = array_create(_cellcount,1);
		hexarr_positions = array_create(_cellcount,1);
		hexarr_hexes = array_create(_cellcount,1);
		hexarr_neighbors = array_create(_cellcount,1);
		hexarr_containers = array_create(_cellcount,1);
		
		// create the hex nodes / determine the index values for each node
		var ind = 0;
		var qmin = (hexgrid_width_max div 2);
		var rmin = (hexgrid_height_max div 2);
		for(var i=0; i<hexgrid_height_max; i++){
		for(var j=0; j<hexgrid_width_max; j++){
			var r = i;
			var q = j - floor(r/2);
			// set grid origin to the top left corner
			if(i==0) && (j==0)
			{
				r -= rmin;
				q -= qmin;
				var _pos = hex_to_pixel([2,q,r], true);
				x = _pos[1];
				y = _pos[2];
				r+=rmin;
				q+=qmin;
			}
			// initialize the node index
			ds_map_add(hexmap, hex_get_key([2,q,r]), ind);
			hexarr_enabled[ind] = false;
			hexarr_positions[ind] = hex_to_pixel([2,q,r], true);
			hexarr_hexes[ind] = vect2(q,r);
			hexarr_containers[ind] = ds_list_create();
			ind++;
		}}

		// once the node indexes have been calculated, give each node an array to hold indexes if neighbor nodes
		for(var i=0; i<hexgrid_height_max; i++){
		for(var j=0; j<hexgrid_width_max; j++){
			var r = i;
			var q = j - floor(r/2);
			
			// get the hex node so we can give it neighbors
			var _hex = vect2(q,r);
			var _ind = hex_get_index(_hex);
			// instantiate the array
			hexarr_neighbors[_ind] = array_create(6,0);
			// get index numbers for each neighbor node
			for(var k=0;k<6;k++)
			{
				var _hex_neighbor = vect_add(_hex, axial_direction_vectors[k]);
				hexarr_neighbors[_ind][k] = hex_get_index(_hex_neighbor);
			}
		}}
		
		// update the game grid bounds & the bounds of the camera to be limited to the hex grid
		var _bbox = [0,0,0,0];
		_bbox[0] = x - (h_spacing div 2);
		_bbox[1] = y - (v_spacing div 2);
		_bbox[2] = x + hexgrid_width_pixels;
		_bbox[3] = y + hexgrid_height_pixels - (v_spacing div 2);
		global.playpace = _bbox;
		global.hex_wgrid = _bbox[2] - _bbox[0];
		global.hex_hgrid = _bbox[3] - _bbox[1];
		
		// instantiate the heap data structure, then create a new heap to handle hex nodes
		InitializeHeap();
		hex_heap = new Heap();
		hex_heap.Initialize(array_length(hexarr_hexes));
	
		//// create the line visualizer
		//var _struct = { line_arr : [], position : hexarr_positions[0], mouse_pos : vect2(mouse_x,mouse_y) }
		//instance_create_depth(_struct.position[1], _struct.position[2], depth, o_hex_grid_line_visualizer, _struct);
	}
	
	// load in the default map
	with(instance_create_layer(0,0,"Instances",o_hex_grid_save_load_menu))
	{
		hex_map_load("Default Layout");
		instance_destroy();
	}
}

function hex_xy_to_qr(_v2)
{
	return vect2(
			_v2[2],
			_v2[1] - floor(_v2[2]/2)
	);
}
function hex_find_nearest_goal(hex)
{
	// this will return either, undefined, or the hex of the nearest goal node
	with(global.i_hex_grid)
	{
		var _size = ds_list_size(hexgrid_goal_list);
		if(_size == 0)
		{
			// there are no goals to persue
			return undefined;
		} else {
			// compare distance to each available spawn node
			var _lowest_index = hexgrid_goal_list[| 0];
			if(_lowest_index == hex_get_index(hex)) return undefined; // cancel search if hex is already a goal
			var _lowest_dist = axial_distance(hex, hexarr_hexes[_lowest_index]);
			//show_debug_message("current target goal/distance: {0} / {1}", _lowest_index,_lowest_dist);
			var _new_index = 0;
			var _new_dist = infinity;
			for(var i=1;i<_size;i++)
			{
				_new_index = hexgrid_goal_list[| i];
				if(_new_index == hex_get_index(hex)) return undefined; // cancel search if hex is already a goal
				_new_dist = axial_distance(hex, hexarr_hexes[_new_index]);
				if(_new_dist<_lowest_dist)
				{
					_lowest_index = _new_index;
					_lowest_dist = _new_dist;
				}
			}
			// return the hex of the nearest node
			return hexarr_hexes[_lowest_index];
		}
	}
}

function hex_find_path_for_unit(_entity, _goal_hex_index){

}

function hex_grid_mouse_position(){
	with(o_hex_grid){
		return mouse_hex_last_valid_pos;
	} return undefined;
}
function hex_grid_mouse_coord(){
	with(o_hex_grid){
		return mouse_hex_last_valid_coord;
	} return undefined;
}
function hex_get_neighbor(_hex, _direction){
	var rtn = -1;
	with(global.i_hex_grid)
	{	// combine hex and the unit vector for the given direction, then check if the new hex is valid
		rtn = vect_add(_hex,global.i_hex_grid.hex_unit_vectors[_direction]);
		if(hex_get_index(rtn) == -1) rtn = -1;
	}
	return rtn;
}
//--// distances
function axial_distance(v0, v1){
	return (
		abs(v0[1]-v1[1])
		+ abs(v0[1]+v0[2] - v1[1]-v1[2])
		+ abs(v0[2]-v1[2])
	) / 2;
}
//--// misc conversion functions
function hex_to_pixel(hex, _absolute=false){
	with(o_hex_grid)
	{
		if(hex_type == POINTYTOP)
		{
			return vect2(x*_absolute + (hex_size*(sqrt(3)*hex[1] + sqrt(3)*hex[2]/2)),
						 y*_absolute + (hex_size*(3*hex[2]/2)));
		} else {
			return vect2(x*_absolute + (hex_size*(3*hex[1]/2)),
						 y*_absolute + (hex_size*(sqrt(3)*hex[1]/2 + sqrt(3)*hex[2])));
		}
	}
}
function pixel_to_hex(point){
	with(o_hex_grid)
	{
		var dx = point[1] - x;
		var dy = point[2] - y;
		if(hex_type == POINTYTOP)
		{
			var v = vect2((sqrt(3)/3*dx - dy/3)/hex_size,
						 (2*dy)/(3*hex_size));
		} else {
			var v = vect2((2*dx) / (hex_size*3),
						 (-dx/3 + sqrt(3)*dy/3) / hex_size);
		}
		return axial_round(v);
	}
}
function get_hexes_in_line(p0, p1){
	// p0 & p1 are vect2 that contain pixel positions of the start and end points 
	// return an array of axial coordinates of all hex nodes in the line
	var hex0 = pixel_to_hex(p0);
	var hex1 = pixel_to_hex(p1)
	var n = axial_distance(hex0, hex1);
	var arr = array_create(n+1, 0);
	with(o_hex_grid)
	{
		var cube0 = axial_to_cube(hex0);
		var cube1 = axial_to_cube(hex1);
		for(var i=0;i<=n;i++)
		{
			arr[i] = cube_to_axial(cube_round(cube_lerp(cube0, cube1, i/n)));
		}
	}
	show_debug_message("");
	return arr;
}

function calc_hex_corner(center, i){
	// center is a vector2 of the center of the hexagon

    var angle_deg = 60 * i - (30*hex_type); // will offset angle when pointy-top is used
    var angle_rad = pi / 180 * angle_deg;
    return vect2(center[1] + hex_size * cos(angle_rad), center[2] + hex_size * sin(angle_rad))
}

//--// direction & neighbors
function axial_direction(_ind){
	with(global.i_hex_grid) return axial_direction_vectors[_ind];
}

function axial_neighbor(hex_vect, dir_index){
	with(global.i_hex_grid) return vect_add(hex_vect, axial_direction_vectors[dir_index]);
}


function cube_to_axial(cube_vect){
	var q = cube_vect[1];
	var r = cube_vect[2];
	return vect2(q, r);
}
function axial_to_cube(hex_vect){
	var q = hex_vect[1];
	var r = hex_vect[2];
	var s = -q-r;
	return vect3(q, r, s);
}

//--// rounding to nearest hex
function cube_round(vect){
	var q = round(vect[1]);
	var r = round(vect[2]);
	var s = round(vect[3]);
	
	var q_diff = abs(q-vect[1]);
	var r_diff = abs(r-vect[2]);
	var s_diff = abs(s-vect[3]);

    if(q_diff > r_diff) && (q_diff > s_diff){
        q = -r-s;
	} else if(r_diff > s_diff){
        r = -q-s;
	} else {
        s = -q-r;
	}
	return vect3(q, r, s);
}
function axial_round(hex){
	return cube_to_axial(cube_round(axial_to_cube(hex)));
}
function cube_lerp(v0, v1, t){
	return vect3(lerp(v0[1], v1[1], t),
				 lerp(v0[2], v1[2], t),
				 lerp(v0[3], v1[3], t));
}


//--// movement range
function hex_in_radius(vect, rad){
	// vect is the axial coordinates to use as the center point
	// rad is the radius from the center to check for
	var arr = [], q=0, r=0;
	for(q=-rad;q<=rad;q++)
	{
		for(r=max(-rad, -q-rad); r<=min(rad, -q+rad); r++)
		{
			var _new_hex = vect_add(vect, [2, q, r]);
			if(!is_undefined(hex_get_index(_new_hex))) { array_push(arr, _new_hex) }
		}
	}
	return arr;
}
function hex_in_intersection(vec0, rad0, vec1, rad1){
	// vect is the axial coordinates to use as the center point
	// rad is the radius from the center to check for
	var arr = [], q=0, r=0;
	var qmin = max(vec0[1]-rad0, vec1[1]-rad1);
	var qmax = min(vec0[1]+rad0, vec1[1]+rad1);
	var rmin = max(vec0[1]-rad0, vec1[2]-rad1);
	var rmax = min(vec0[1]+rad0, vec1[2]+rad1);
	var smin = -qmin-rmin;
	var smax = -qmax-qmax;
	for(q=qmin;q<=qmax;q++)
	{
		for(r=max(rmin, -q-smax); r<=min(rmax, -q+smin); r++)
		{
			array_push(arr, [2, q, r]);
		}
	}
	return array_length(arr) == 0 ? -1 : arr;
}

//--// extra functionality, for specific game purpose
function hex_is_enabled(_hex){
	with(global.i_hex_grid)
	{
		var _ind = hex_get_index(_hex);
		if(is_undefined(_ind)) return -1;
		return hexarr_enabled[_ind];
	}
}
function hex_enable_index(index){
	if(hexarr_enabled[index] == false)
	{
		hexarr_enabled[index] = true;
		ds_list_add(hexgrid_enabled_list, index);
	}
}
function hex_enable_coord(hex){
	var index = hex_get_index(hex);
	if(hexarr_enabled[index] == false)
	{
		hexarr_enabled[index] = true;
		ds_list_add(hexgrid_enabled_list, index);
	}
}
function hex_disable_index(index){
	if(hexarr_enabled[index] == true)
	{
		hexarr_enabled[index] = false;
		ds_list_delete(hexgrid_enabled_list, ds_list_find_index(hexgrid_enabled_list, index));
	}
}
function hex_disable_coord(hex){
	var index = hex_get_index(hex);
	if(hexarr_enabled[index] == true)
	{
		hexarr_enabled[index] = false;
		ds_list_delete(hexgrid_enabled_list, ds_list_find_index(hexgrid_enabled_list, index));
	}
}
function hex_get_key(hex){
	var q = hex[1];
	var r = hex[2];
	return string(q) + "." + string(r);
}
function hex_get_index(hex){
	with(global.i_hex_grid) return hexmap[? hex_get_key(hex)];
}

function hex_set_goal(hex){
	var ind = hex_get_index(hex);
	if(!is_undefined(ind)) && (hexarr_is_goal[ind] == false)
	{
		// set as goal
		ds_list_add(hexgrid_goal_list, ind);
		hexarr_is_goal[ind] = true;
		// disable as spawn if previously enabled
		if(hexarr_is_spawn[ind])
		{
			hexarr_is_spawn[ind] = false;
			ds_list_delete(hexgrid_spawn_list, ds_list_find_index(hexgrid_spawn_list, ind));
		}
		// make sure node is enabled
		if(hexarr_enabled[ind] == false)
		{
			hex_enable_index(ind);
		}
		show_debug_message("Node {0} set as goal", mouse_hex_coord);
	} else {
		show_debug_message("Cannot set node {0} as goal, node is already a goal", mouse_hex_coord);
	}
}
function hex_remove_goal(hex){
	var ind = hex_get_index(hex);
	if(!is_undefined(ind)) && (hexarr_is_goal[ind] == true)
	{
		ds_list_delete(hexgrid_goal_list, ds_list_find_index(hexgrid_goal_list, ind));
		hexarr_is_goal[ind] = false;
		if(hexarr_is_spawn[ind])
		{
			hexarr_is_spawn[ind] = false;
			ds_list_delete(hexgrid_spawn_list, ds_list_find_index(hexgrid_spawn_list, ind));
		}
		show_debug_message("Node {0} removed as goal", mouse_hex_coord);
	} else {
		show_debug_message("Cannot set remove {0} as goal, node is already a goal", mouse_hex_coord);
	}
}
function hex_set_spawn(hex){
	var ind = hex_get_index(hex);
	if(!is_undefined(ind)) && (hexarr_is_spawn[ind] == false)
	{
		// set as spawn
		ds_list_add(hexgrid_spawn_list, ind);
		hexarr_is_spawn[ind] = true;
		// disable as goal if previously enabled
		if(hexarr_is_goal[ind])
		{
			hexarr_is_goal[ind] = false;
			ds_list_delete(hexgrid_goal_list, ds_list_find_index(hexgrid_goal_list, ind));
		}
		// make sure node is enabled
		if(hexarr_enabled[ind] == false)
		{
			hex_enable_index(ind);
		}
		show_debug_message("Node {0} set as spawn", mouse_hex_coord);
	} else {
		show_debug_message("Cannot set node {0} as goal, node is already a goal", mouse_hex_coord);
	}
}
function hex_remove_spawn(hex){
	var ind = hex_get_index(hex);
	if(!is_undefined(ind)) && (hexarr_is_spawn[ind] == true)
	{
		ds_list_delete(hexgrid_spawn_list, ds_list_find_index(hexgrid_spawn_list, ind));
		hexarr_is_spawn[ind] = false;
		if(hexarr_is_goal[ind])
		{
			hexarr_is_goal[ind] = false;
			ds_list_delete(hexgrid_goal_list, ds_list_find_index(hexgrid_goal_list, ind));
		}
		show_debug_message("Node {0} removed as spawn", mouse_hex_coord);
	} else {
		show_debug_message("Cannot set node {0} as goal, node is already a goal", mouse_hex_coord);
	}
}
