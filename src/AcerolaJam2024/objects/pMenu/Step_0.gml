/// @description Control the Button

if(global.game_state != GameStates.PAUSE)
{
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
}
