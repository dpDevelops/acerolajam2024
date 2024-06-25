/// @description 

if(room == rGame)
{
	room_start_init_playspace();
	room_start_init_player_entity();
	room_start_init_camera();
	room_start_init_hud();
	
	// room starts with the start menu
	instance_create_depth(0,0,UPPERDEPTH,oStartMenu);
}
