/// @description handle bg fade

if(ds_stack_size(menu_stack) > 0)
{
	// fade in
	if(global.bg_fade != 1) global.bg_fade = min(1, global.bg_fade+0.05);
} else {
	// fade out
	if(global.bg_fade != 0) global.bg_fade = max(0, global.bg_fade+0.1);
}
