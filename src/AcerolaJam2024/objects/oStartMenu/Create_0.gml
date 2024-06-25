/// @description 
StartMenuFunctions();

alarm[0] = 0.5*FRAME_RATE;

// Inherit the parent event
event_inherited();

// general variables
xTo = global.i_camera.x;
yTo = global.i_camera.y;
x = xTo;
y = yTo + 2*global.i_camera.viewHeightHalf;

// tutorial setup
show_tutorial = false;
tut_9s = s_upgrade_menu_9s;
tut_size = vect2(230,300);
tut_half_w = tut_size[1] div 2;
tut_half_h = tut_size[2] div 2;
tut_xscale = tut_size[1] / sprite_get_width(s_upgrade_menu_9s);
tut_yscale = tut_size[2] / sprite_get_height(s_upgrade_menu_9s);
tut_true_pos = vect2(xTo+196,yTo);
tut_false_pos = vect2(xTo+196,yTo+340);
tut_pos = tut_false_pos;
tut = "     --------- CONTROLS ---------\nIN-GAME:\n[mouse_left] = target a bush or creature\n[mouse-right] = move player\nIN-MENU:\n[mouse-left] = interact\n";
tut += "     --------- SCENARIO ---------\n  The goal of this game is to collect magic flowers for your research to synthisize the Elixer of Life.  Be wary of the wildlife, some are friendlier than others.\n";
tut += "  Targeting a creature will force the player to chase/attack that target, while targeting a bush will force the player to move to it and collect flowers.  There will be buttons at the bottom of the screen to switch the player between \'peaceful\' & \'aggressive\' behaviors.  Play around with them to see what they do!"

// credits setup
show_credits = false;
cdt_9s = s_upgrade_menu_9s;
cdt_size = vect2(230,300);
cdt_half_w = cdt_size[1] div 2;
cdt_half_h = cdt_size[2] div 2;
cdt_xscale = cdt_size[1] / sprite_get_width(s_upgrade_menu_9s);
cdt_yscale = cdt_size[2] / sprite_get_height(s_upgrade_menu_9s);
cdt_true_pos = vect2(xTo-197,yTo);
cdt_false_pos = vect2(xTo-197,yTo+340);
cdt_pos = cdt_false_pos;
cdt = "---- Programming ----\n    Dorian Payton\n"+
      "---- Design ----\n    Dorian Payton\n"+
      "---- UI Elements  ----\n    \'Complete_GUI_Essential_Pack\'\n      by Crusenho Agus Hennihuno\n"+
      "---- Music ----\n    \'Pixel RPG Music\' by alkakrab\n"+
      "---- Font ----\n    \'m5x7\' & \'m3x6\' by Daniel Linssen\n"+
      "---- Player Sprite ----\n    \'The Dark Series - Character Pack 1\'\n      by Penusbmic\n"+
      "---- Enemy Sprites ----\n    \'Dungeon Crawl Tileset 32x32\'\n      [ open source ]\n"+
      "---- Environment/tileset ----\n    \'Mountain Landscape\'\n      [ source unknown ]\n";

// set scaling for main menu box
menu_9s = s_upgrade_menu_9s;
menu_size = vect2(160,300);
menu_half_w = menu_size[1] div 2;
menu_half_h = menu_size[2] div 2;
menu_xscale = menu_size[1] / sprite_get_width(s_upgrade_menu_9s);
menu_yscale = menu_size[2] / sprite_get_height(s_upgrade_menu_9s);

var _ind = -1;
var _title = "ALCHEMIC ABERRATIONS";
LabelAdd(-58,-90,id,++_ind,"title",undefined,_title);
// Start Game Button
ButtonAdd(-sprite_get_width(s_startmenu_start) div 2, -14, id, ++_ind, "start", s_startmenu_start,,"",,Start,[]);
// Controls/Tutorial Button
ButtonAdd(-sprite_get_width(s_startmenu_tutorial) div 2, 24, id, ++_ind, "start", s_startmenu_tutorial,,"",,Tutorial,[]);
// Credits Button
ButtonAdd(-sprite_get_width(s_startmenu_tutorial) div 2, 62, id, ++_ind, "start", s_startmenu_credits,,"",,Credits,[]);
// Quit Game Button
ButtonAdd(-sprite_get_width(s_startmenu_quit) div 2, 100, id, ++_ind, "start", s_startmenu_quit,,"",,Quit,[]);

SoundCommand(snd_title_music,0,0);
