function SoundCommand(_snd, _x=0, _y=0){
	with(global.i_sound)
	{
		var _comm = new global.i_engine.Command(-1, _snd, _x, _y);
		ds_queue_enqueue(sound_queue, _comm);
		//show_debug_message("sound command: {0}", _comm);
	}
}
function ChangeMusic(_snd, _x=0, _y=0){
	with(global.i_sound)
	{
		var _comm = new global.i_engine.Command(-1, _snd, _x, _y);
	}
}
