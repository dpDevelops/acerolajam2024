/// @description 

if(alarm[0] > -1) exit

xTo = global.i_camera.x;
yTo = global.i_camera.y;

// pan into the center of camera
if(x != xTo) || (y != yTo)
{
	var _xdiff = xTo - x;
	var _ydiff = yTo - y;
	if(abs(_xdiff) <= 1) && (abs(_ydiff) <= 1){
		x = xTo; y = yTo;
	} else {
		x += 0.08*_xdiff; y += 0.08*_ydiff;
	}
}
// move the tutorial in and out of view
var _pos = show_tutorial ? tut_true_pos : tut_false_pos;
tut_pos = vect_add(tut_pos, vect_multr((vect_subtract(_pos, tut_pos)),0.1));

// move the credits in and out of view
_pos = show_credits ? cdt_true_pos : cdt_false_pos;
cdt_pos = vect_add(cdt_pos, vect_multr((vect_subtract(_pos, cdt_pos)),0.1));

// Inherit the parent event
event_inherited();





