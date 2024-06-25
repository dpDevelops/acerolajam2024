function room_start_init_playspace(){
	var _w=0, _h=0, i=0, j=0,_node=undefined;
    var x1=room_width, x2=0, y1=room_height, y2=0;
	with(oPlaySpace)
	{// determine the available play space given the bounding box of this object
		x1 = x; x2 = x+(bbox_right-bbox_left);
		y1 = y; y2 = y+(bbox_bottom-bbox_top);
		show_debug_message("playspace found \nx = {0}, {1}\ny = {2}, {3}\n", x1, x2, y1, y2);
		instance_destroy();
	}
	_w = x2-x1+1;
	_h = y2-y1+1;
	
	// check for valid width & height
	show_debug_message("width = {0}, height = {1}", _w, _h)
	if(_w <= 0) || (_h <= 0)
	{
		show_message("playspace not set correctly.  please check the playspace object in the following room: [" + room_get_name(room) + "]"); 
		game_end();
	}
		
	// set up the hexagonal grid
	if(!instance_exists(o_hex_grid))
	{
		InitHexagonalGrid(POINTYTOP, ODD_R, 32, room_width div 2, room_height div 2, 14, 14);
	}
}
function room_start_init_player_entity(){
	var _x = 0;
	var _y = 0;
	with(global.i_hex_grid)
	{
		_x = x + (hexgrid_width_max div 2)*h_spacing + (h_spacing div 2);
		_y = y + (hexgrid_height_max div 2)*v_spacing;
	}
	with(global.i_player)
	{
		position = vect2(_x, _y);
		x = position[1]; xTo = x;
		y = position[2]; yTo = y;
		velocity = vect2(0, 0);
		sprite_index = spr_idle;
		image_index = 0;
		image_speed = 1;
		// update with respect to the hex grid
		ds_list_clear(hex_path_list);
		hex = pixel_to_hex(position);
		if(!variable_instance_exists(id, "hex_prev")) hex_prev = hex;
		InstantiatePlayerComponents(10,1,0,1,1,0);
	}
}
function room_start_init_camera(){
	// NOTE: the playspace must initialize prior to updating the camera

	with(global.i_camera)
	{
		// set the camera to use
		cam = view_camera[0];
		// set size of camera using zoom parameters of the engine
		with(global.i_engine) camera_set_view_size(other.cam,idealWidth*view_zoom, idealHeight*view_zoom);
		// set the bounds for camera movement
		array_copy(cam_bounds, 0, global.playpace, 0, 4);
		// adjust internal variables
		follow = instance_exists(global.i_player) ? global.i_player : noone;
		viewWidthHalf = round(0.5*camera_get_view_width(cam));
		viewHeightHalf = round(0.5*camera_get_view_height(cam));

		// set initial position of camera
		xTo = follow == noone ? (cam_bounds[0]+cam_bounds[2]) div 2 : follow.xTo; 
		yTo = follow == noone ? (cam_bounds[1]+cam_bounds[3]) div 2 : follow.yTo; 
		x = xTo;
		y = yTo;
	}
}
function room_start_init_hud(){
	var _wHalf = global.i_camera.viewWidthHalf;
	var _hHalf = global.i_camera.viewHeightHalf;
	instance_create_depth(0.165*_wHalf,1.8*_hHalf, UPPERDEPTH+10,o_hud_player_healthbar);
	instance_create_depth(0.165*_wHalf,1.9*_hHalf, UPPERDEPTH+10,o_hud_player_staminabar);
	instance_create_depth(0.16*_wHalf,1.6*_hHalf, UPPERDEPTH+10,o_hud_player_inventory);
	instance_create_depth(0.4*_wHalf,1.8*_hHalf, UPPERDEPTH+10,o_hud_interactables);
	instance_create_depth(0.375*_wHalf,1.4*_hHalf,UPPERDEPTH+10,o_hud_clock);
}