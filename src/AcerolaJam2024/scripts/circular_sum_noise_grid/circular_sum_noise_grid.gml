function circular_sum_noise_grid(_grid, rad_min=0.1, rad_max=0.3, spacing=1){
	//CHANGE THESE VARIABLES FOR DIFFERENT LOOKS!
	// var rad_min = 7; //radius
	// var rad_max = 15;
	// var spacing = global.num;

	// NOTE: this algorithm ignores the cells at the edges of the grid, 
	//       so a larger temp grid must be used to generate the values.  
	//       Then those values can be inserted into the target grid at the end. 

	var width = ds_grid_width(_grid);
	var height = ds_grid_height(_grid);
	var _tempw = width+2;
	var _temph = height+2;
	var _temp_grid = ds_grid_create(_tempw, _temph);
	
	// the radius min/max must be proportional to the size of the grid
	rad_max = min(width,height,ceil(width*rad_max),ceil(height*rad_max));
	rad_max = min(width,height,floor(width*rad_min),floor(height*rad_min));
	
	var val = 0;
	var xx=rad_max;
	var yy=rad_max;

	for(yy=rad_max; yy<_temph-rad_max; yy+=spacing){
	for(xx=rad_max; xx<_tempw-rad_max; xx+=spacing){
		val = irandom(255);
		ds_grid_add_disk(_temp_grid,xx,yy,random_range(rad_min,rad_max),val);
	}}

	//GENERATION DONE! But max value is unknown. Normalize values
	var grid_max = ds_grid_get_max(_temp_grid,0,0,_tempw - 1,_temph - 1);
	var grid_min = ds_grid_get_min(_temp_grid,0,0,_tempw - 1,_temph - 1);
	var _diff = grid_max-grid_min;
	for(yy=0; yy<_temph; yy++){
	for(xx=0; xx<_tempw; xx++){ 
		_temp_grid[# xx, yy] = (_temp_grid[# xx, yy]-grid_min)/(_diff);
	}}
	
	// move data from temp grid over to the target grid, since this algorithm ignores the edge cells
	for(yy=0; yy<height; yy++){
	for(xx=0; xx<width; xx++){
		_grid[# xx, yy] = _temp_grid[# xx+1, yy+1];
	}}
	// remove temp grid
	ds_grid_destroy(_temp_grid);
	// ds_grid_print(_grid, "Circular-Sum NOISE GRID " + string(grid_max) + " | " + string(grid_min));
}