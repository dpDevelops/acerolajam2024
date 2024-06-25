/// @description 

function UpdateFloatPos(){
	float_pos = vect2(global.i_camera.xTo,global.i_camera.yTo);
}
function CountdownFloat(){
	with(oLevelCountdown)
	{
		var time_str = string(min(ceil(time_source_get_time_remaining(ts_countdown)), time_source_get_period(ts_countdown)));
		CreateFloatNumber(float_pos[1],float_pos[2],time_str,FLOATTYPE.LINEAR,f_float_text,90);
	}
}
function CountdownFinish(){
	with(oLevelCountdown){
		var _l = level_time;
		var _b = bush_time;
		var _e = enemy_time;
		CreateFloatNumber(float_pos[1],float_pos[2],"BEGIN",FLOATTYPE.LINEAR,f_float_text,90);
		with(oLevelManager){LevelBegin(_l,_b,_e)}
		instance_destroy();
	}
}


title = "Outing #";
with(oLevelManager) other.title += string(level_index+1);

ts_floatnumbers = time_source_create(time_source_global,1,time_source_units_seconds,CountdownFloat,[],seconds);
ts_countdown = time_source_create(time_source_global,seconds,time_source_units_seconds,CountdownFinish,);

ds_stack_push(global.i_engine.menu_stack,id);
UpdateFloatPos();

time_source_start(ts_floatnumbers);
time_source_start(ts_countdown);
CountdownFloat();

	// start music
	var _song = choose(snd_11,snd_12,snd_13,snd_21,snd_22,snd_23,snd_31,snd_32);
	SoundCommand(_song, 0, 0);