/// @description 


switch(trans_type)
{
	case IN:
		break;
	case OUT:
		// set timer to skip step event
		creator.image_alpha -= trans_rate;
		if(creator.image_alpha <= 0)
		{
			// start level and
			instance_destroy(creator);
			instance_destroy();
			StartCountdownToLevelStart(3);
		}
		break;
}

