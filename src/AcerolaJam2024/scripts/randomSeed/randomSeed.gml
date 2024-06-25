/*
ARGUMENTS:
range
*/
function randomSeed()
{
	var _range = argument[0];
	var _num = 0;
	switch(argument_count)
	{
	    case 2:
	        _num = argument[1];
	        break;
	    case 3:
	        _num = argument[1] + argument[2] * 65536;
	        break;
	}

	var _seed = global.seed + _num;

	random_set_seed(_seed);
	var _rand = irandom_range(0,_range);

	return round(_rand);
}
