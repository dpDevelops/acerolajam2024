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