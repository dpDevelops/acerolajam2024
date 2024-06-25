function normalize_ds_grid(_grid){
	var _w = ds_grid_width(_grid);
	var _h = ds_grid_height(_grid);
	var _val = 0;
	var _min_val = ds_grid_get_min(_grid,0,0,_w-1,_h-1);
	var _max_val = ds_grid_get_max(_grid,0,0,_w-1,_h-1);
	
	// adjust values
	for(var i=0;i<_w;i++){
	for(var j=0;j<_h;j++){
		_grid[# i, j] = lerp(0,1,(_grid[# i, j]-_min_val)/(_max_val-_min_val));	
	}}
}