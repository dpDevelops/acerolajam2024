global.seed = irandom(10000000);

function generate_noise_grid(_width, _height, _range=100)
{
	// this function will create and return a new ds_grid containing random noise values
	var i=0,j=0,_grid = ds_grid_create(_width, _height);
	
	for(i=0; i<_width; i++){
	    for(j=0; j<_height; j++){
	        _grid[# i,j] = getPerlinNoise_2D(i,j,_range);
	    }
	}
	// normalize_ds_grid(_grid); // un-comment this to clamp values between 0 & 1
	return _grid;
}

function randomSeed()
{
	var _range = argument[0];
	var _num = 0;
	switch(argument_count)
	{
	    case 2:
	        _num = argument[1];
	        break;
	    case 3:
	        _num = argument[1] + argument[2] * 65536;
	        break;
	}

	var _seed = global.seed + _num;

	random_set_seed(_seed);
	var _rand = irandom_range(0,_range);

	return round(_rand);
}

function getPerlinNoise_2D(xx, yy, range)
{

	var chunkSize = 8;

	var noise = 0;

	range = range div 2;

	while(chunkSize > 0){
	    var index_x = xx div chunkSize;
	    var index_y = yy div chunkSize;
    
	    var t_x = (xx % chunkSize) / chunkSize;
	    var t_y = (yy % chunkSize) / chunkSize;
    
	    var r_00 = randomSeed(range,index_x,   index_y);
	    var r_01 = randomSeed(range,index_x,   index_y+1);
	    var r_10 = randomSeed(range,index_x+1, index_y);
	    var r_11 = randomSeed(range,index_x+1, index_y+1);
    
	    var r_0 = lerp(r_00,r_01,t_y);
	    var r_1 = lerp(r_10,r_11,t_y);
    
	    noise += lerp(r_0,r_1,t_x);
    
	    chunkSize = chunkSize div 2;
	    range = range div 2;
	    range = max(1,range);
	}

	return round(noise);
}

//--// OTHER HELFUL FUNCTIONS

function normalize_ds_grid(_grid){
	var _w = ds_grid_width(_grid);
	var _h = ds_grid_height(_grid);
	var _val = 0;
	var _min_val = ds_grid_get_min(_grid,0,0,_w-1,_h-1);
	var _max_val = ds_grid_get_max(_grid,0,0,_w-1,_h-1);
	
	for(var i=0;i<_w;i++){
	for(var j=0;j<_h;j++){
		_grid[# i, j] = lerp(0,1,(_grid[# i, j]-_min_val)/(_max_val-_min_val));	
	}}
}

function ds_grid_print(_grid, _title){
// print grid data in the terminal
	var _str = "";
	var _w = ds_grid_width(_grid);
	var _h = ds_grid_height(_grid);
	
	show_debug_message(_title);
	for(var j=0;j<_h;j++){
		_str = "[ ";
		// fill a string with contents of the current row
		for(var i=0;i<_w;i++){
			_str += string(_grid[# i,j])+" ";
		}
		_str += "]";
		// print row contents
		show_debug_message(_str);
	}
}