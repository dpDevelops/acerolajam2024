/// @description 

if(global.mouse_focus == id) global.mouse_focus = noone;

// clear id from occupy cells
with(global.i_hex_grid)
{
	var _hex_index =  hex_get_index(other.hex);
	var _hex_container = hexarr_containers[_hex_index];
	var _container_index = ds_list_find_index(_hex_container, other.id);
}
if( _container_index != -1) ds_list_delete(_hex_container, _container_index);

// remove components
if(!is_undefined(fighter)) { fighter.Destroy(); delete fighter } 
if(!is_undefined(ai)) { ai.Destroy(); delete ai }

