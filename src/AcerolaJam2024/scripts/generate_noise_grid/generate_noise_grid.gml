function generate_noise_grid(_width, _height)
{
	// noise values range from 0 to 1
	var i=0,j=0,_grid = ds_grid_create(_width, _height);
	
	for(i=0; i<_width; i++){
	    for(j=0; j<_height; j++){
	        _grid[# i,j] = getPerlinNoise_2D(i,j,100);
	    }
	}
	normalize_ds_grid(_grid);
	return _grid;
}
