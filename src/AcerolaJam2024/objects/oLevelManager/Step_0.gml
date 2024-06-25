/// @description 

// handle functions when the countdown is running

if(level_running)
{
	// convert the level time remaining into a readable string
	var _time = int64(time_source_get_time_remaining(ts_level_timer)*1000);
	timer_minutes_string = string(_time div 60000);
	timer_seconds_string = string((_time div 1000) % 60);
	timer_milliseconds_string = string((_time % 1000) div 10);
	while(string_length(timer_minutes_string) < 2) timer_minutes_string = "0"+timer_minutes_string;
	while(string_length(timer_seconds_string) < 2) timer_seconds_string = "0"+timer_seconds_string;
	while(string_length(timer_milliseconds_string) < 2) timer_milliseconds_string = "0"+timer_milliseconds_string;
}

