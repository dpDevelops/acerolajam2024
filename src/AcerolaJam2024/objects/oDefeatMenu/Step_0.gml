/// @description 

xTo = global.i_camera.x;
yTo = global.i_camera.y;

// background fade
if(trans_type == NONE) // quit to menu
{
	bg_alpha = min(1,bg_alpha+trans_rate);
	image_alpha -= trans_rate;
	if(image_alpha <= 0)
	{
		instance_destroy();
		ReturnToStartMenu();
		exit;
	}
} else if(trans_type == IN){ // bring up pause menu
	bg_alpha = min(0.4,bg_alpha+trans_rate);
} else {
	bg_alpha = max(0,bg_alpha-trans_rate); // resume game
	image_alpha -= trans_rate
	if(image_alpha <= 0) 
	{
		unpause_game();
		exit;
	}
}

// pan to target
if(x != xTo) || (y != yTo)
{
	var _xdiff = xTo - x;
	var _ydiff = yTo - y;
	if(abs(_xdiff) <= 1) && (abs(_ydiff) <= 1){
		x = xTo; y = yTo;
		if(trans_type == OUT){
			unpause_game();
		}
	} else {
		x += 0.08*_xdiff; y += 0.08*_ydiff;
	}
}

// update controls
controlsCount = ds_list_size(controlsList)
if(controlsCount > 0)
{
	for(var i=0; i<controlsCount; i++)
	{
		var _ctrl = controlsList[| i];
		_ctrl.Update();
	}
}

