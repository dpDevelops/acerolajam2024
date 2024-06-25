/// @description 

// check to see if the start menu exists
// if it exists, transition out of the start menu
// else, transition into the start menu

creator = noone;
with(oUpgradeMenu) other.creator = id;

trans_type = creator == noone ? IN : OUT;
trans_rate = 0.05;

switch(trans_type)
{
	case IN:
		break;
	case OUT:
		// set timer to skip step event
		with(creator){ alarm[0] = 400}
		break;
}
