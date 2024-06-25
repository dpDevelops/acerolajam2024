/// @description 

// create menu functions
UpgradeMenuFunctions();


// Inherit the parent event
event_inherited();

xTo = global.i_camera.x;
yTo = global.i_camera.y;
x = xTo;
y = yTo + global.i_camera.viewHeightHalf;

// set scaling
menu_9s = s_upgrade_menu_9s;
menu_size = vect2(480,336);
menu_half_w = menu_size[1] div 2;
menu_half_h = menu_size[2] div 2;
menu_xscale = menu_size[1] / sprite_get_width(s_upgrade_menu_9s);
menu_yscale = menu_size[2] / sprite_get_height(s_upgrade_menu_9s);

// Title
var _ind = -1

// next level button
ButtonAdd(126,114,id,++_ind,"next_level",s_commit_button,undefined,"",undefined,UpgradeMenuStartNextLevel,[]);

// nodes of the upgrade tree
var _pos = vect2(0,0);
var _name = "";
progression_index_start = _ind+1;
for(var i=0;i<19;i++)
{
	switch(i)
	{
		// tier 1 upgrades
		case 0: _pos = vect2(-96,114); _name = "t0_unlock"; break;
		case 1: _pos = vect2(-151,94); _name = "t1_1"; break;
		case 2: _pos = vect2(-41,94); _name = "t1_2"; break;
		// tier 2 upgrades
		case 3: _pos = vect2(-96,52); _name = "t1_unlock"; break;
		case 4: _pos = vect2(-191,32); _name = "t2_1"; break;
		case 5: _pos = vect2(-151,32); _name = "t2_2"; break;
		case 6: _pos = vect2(-41,32); _name = "t2_3"; break;
		case 7: _pos = vect2(-1,32); _name = "t2_4"; break;
		// tier 3 upgrades
		case 8: _pos = vect2(-96,-11); _name = "t2_unlock"; break;
		case 9: _pos = vect2(-231,-31); _name = "t3_1"; break;
		case 10: _pos = vect2(-191,-31); _name = "t3_2"; break;
		case 11: _pos = vect2(-151,-31); _name = "t3_3"; break;
		case 12: _pos = vect2(-41,-31); _name = "t3_4"; break;
		case 13: _pos = vect2(-1,-31); _name = "t3_5"; break;
		case 14: _pos = vect2(39,-31); _name = "t3_6"; break;
		// tier 4 upgrades
		case 15: _pos = vect2(-96,-72); _name = "t3_unlock"; break;
		case 16: _pos = vect2(-151,-92); _name = "t4_1"; break;
		case 17: _pos = vect2(-41,-92); _name = "t4_2"; break;
		// tier 5 upgrade
		case 18: _pos = vect2(-96,-133); _name = "t4_unlock"; break;
	}
	// create the button & set its sprite based on player progression
	with(ButtonAdd(_pos[1], _pos[2],id,++_ind,_name,s_upgrade_node_locked,undefined,"",undefined,NodeClickAction,[]))
	{
		var lvl = real(string_char_at(_name,2));
		if(lvl <= global.i_player.perception_level)
		{
			sprite = global.i_player.progression[$ _name][0] ? s_upgrade_node_bought : s_upgrade_node_available;
		}
	}
}
progression_index_end = _ind;
ts_progression_buy = time_source_create(time_source_global,1,time_source_units_seconds,GetUpgrade);
progression_clicked_index = progression_index_start;
progression_buy_progress = 0;
progression_focus_name = "";
progression_focus_title = "";
progression_focus_text = "This is sample text for the progression/upgrade eplanation window.  Please use this to format the textbox to make is as pretty as can be!!!"
required_flowers = [-1,-1,-1,-1,-1];
flower_draw_positions = [vect2(0,0),vect2(0,0),vect2(0,0),vect2(0,0),vect2(0,0)];
FocusProgressionNode();
GetUpgrade();
CheckAffordability();
// start music
SoundCommand(snd_upgrade_music, 0, 0);
