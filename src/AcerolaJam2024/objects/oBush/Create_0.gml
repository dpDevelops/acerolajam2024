/// @description 

var _rad = 8;
var _squish = 0.8;
player_in_range = false;
foraging_progress = 0;
foraging_threshold = 60;
flower_angles = [irandom(360),irandom(360),irandom(360),irandom(360),irandom(360)];
flower_positions = [
	vect2(x+lengthdir_x(_rad,135),y+_squish*lengthdir_y(_rad,135)),
	vect2(x+lengthdir_x(_rad,45),y+_squish*lengthdir_y(_rad,45)),
	vect2(x+lengthdir_x(_rad,225),y+_squish*lengthdir_y(_rad,225)),
	vect2(x+lengthdir_x(_rad,315),y+_squish*lengthdir_y(_rad,315)),
	vect2(x,y),
]
// determine # of flowers based on player progression
var _lvl = global.i_player.perception_level;
var _dif = oLevelManager.level_difficulty;

// get base quantities for eeach flower
var _flower1 = irandom(2 + (_dif div 3));
var _flower2 = irandom(2 + (_dif div 3));
var _flower3 = irandom(1 + (_dif div 4))*(_lvl > 1);
var _flower4 = irandom(1 + (_dif div 4))*(_lvl > 2);
var _flower5 = irandom(0 + (_dif div 5))*(_lvl > 3);

// get random quantities, refer to perception level on whether to give higher tier flowers
foraging_charges = [_flower1,_flower2,_flower3,_flower4,_flower5];
// make sure bush has at least 1 flower
var _count = 0;
for(var i=4;i>=0;i--){ if(foraging_charges[i] == 0) _count++ }
if(_count == 5) 
{	foraging_charges[0] = max(1, irandom(3)); foraging_charges[1] = max(1, irandom(3)) }

// modify quantities ('Cultivation' Upgrade)
if(global.i_player.progression[$ "t4_2"][0])
{
	foraging_charges[0] = max(1, floor(foraging_charges[0]*0.8));
	foraging_charges[1] = max(1, floor(foraging_charges[1]*0.9));
	foraging_charges[2] = max(1, ceil(foraging_charges[2]*1.3));
	foraging_charges[3] = max(1, ceil(foraging_charges[3]*1.1));
	foraging_charges[4] = max(1, ceil(foraging_charges[4]*1.2));
}

// set foraging threshold
foraging_threshold = 360*max(1.0*(foraging_charges[0] > 0),
							1.15*(foraging_charges[1] > 0),
							1.3*(foraging_charges[2] > 0),
							1.45*(foraging_charges[3] > 0),
							1.6*(foraging_charges[4] > 0));
// set probabilities for each flower
switch(_lvl) {
	case 1: foraging_probs = [1.0,0.3,0,0,0]; break;
	case 2: foraging_probs = [1.0,0.4,0.2,0,0]; break;
	case 3: foraging_probs = [1.0,0.5,0.3,0.1,0]; break;
	case 4: foraging_probs = [1.0,0.7,0.5,0.2,0.05]; break;
}

function CheckForPlayer(){
	player_in_range = ds_list_find_index(fighter.enemies_in_range, global.i_player) > -1;
	if(player_in_range) global.i_player.ai.foraging_id = id;
}
function GetValidFlowerIndex(_start){
	// returns the index of the closest flower stack that still has charges
	var num = _start;
	for(var i=0;i<5;i++)
	{
		//show_debug_message("mod math:  start={0}, i={1}, num={2}",_start,i,(_start-i) % 5);
		num = _start-i;
		if(num < 0) num += 5;
		if(foraging_charges[num] > 0) return num;
	}
}
function ConsumeForagingCharge(){
	foraging_progress = 0;
	var _rand = random(1);
	for(var i=4;i>=0;i--)
	{
		if(_rand < foraging_probs[i]){
			var _ind = GetValidFlowerIndex(i);
			global.i_player.inventory.flower_counts[_ind] = global.i_player.inventory.flower_counts[_ind]+1;
			foraging_charges[_ind] = foraging_charges[_ind]-1;
			break;
		}
	}
	// see if all charges have been used
	_rand = 0;
	for(var i=0;i<5;i++)
	{
		if(foraging_charges[i] <= 0){ _rand++ }
	}
	if(_rand == 5) KillEntity(id);
}

// Inherit the parent event
event_inherited();

faction = FACTION_NEUTRAL;
//animation
spr_idle = s_bush_idle;
spr_move = s_bush_move;
spr_attack = s_bush_attack;
spr_death = s_bush_death;

//sound
sound_spawn = snd_bush_spawn;
sound_move = snd_bush_move;
sound_attack = snd_empty;
sound_death = snd_bush_death;

// overwrite parent values
movement_script = BushMovement;
col_ignored = true;

InstantiateBushComponents(10,1,1,0,0,10);


