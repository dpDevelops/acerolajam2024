/// @description initialize game

/*
    add 8-directional cost values to the game grid for enemies
    add a 'path value' to the game grid.  enemy mobs will steer toward nodes with high path value
    add a method to cover areas of the game grid with fog_of_war (create oShroud object for the map editor)
    add steering behavior for enemy mobs
    create an instance layer on top of the fog_of_war layer, for a particle system object to display effects

    need tilemap 'PathInit' that can indicate spawn locations
*/

color0 = make_colour_rgb(13,43,69);
color1 = make_colour_rgb(32,60,86);
color2 = make_colour_rgb(84,78,104);
color3 = make_colour_rgb(141,105,122);
color4 = make_colour_rgb(208,129,89);
color5 = make_colour_rgb(255,170,94);
color6 = make_colour_rgb(255,212,163);
color7 = make_colour_rgb(255,236,214);


HexFunctions();	
MACROS();
STRUCTS();
COMPONENTS_GENERAL();
COMPONENTS_AI();
randomize();
game_set_speed(FRAME_RATE, gamespeed_fps);
InitializeDisplay(ASPECT_RATIO);

// other global variables
global.unitSelection = ds_list_create();
global.i_engine = id;
global.i_camera = instance_create_layer(0, 0, "Instances", oCamera);
global.i_player = instance_create_layer(0, 0, "Instances", oPlayer);
global.i_sound = instance_create_layer(0, 0, "Instances", oSoundManager);
global.i_hex_grid = noone;
global.hex_wgrid = 0;
global.hex_hgrid = 0;
global.game_state = GameStates.PLAY;
global.game_state_previous = global.game_state;
global.mouse_focus = noone;
global.playpace = [0,0,0,0];
global.bg_fade = 0.0;
global.seed = irandom(1000000);
global.player_dead = false;

action = {};
mouse_action = {};
menu_stack = ds_stack_create();
zoom_delay_time = 10;
recalc_enemies_in_range = false;
ParticleSystemsInit();

window_set_fullscreen(false);
room_goto(ROOM_START);


