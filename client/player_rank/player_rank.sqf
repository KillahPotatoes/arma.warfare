reset_kill_count = {
	player setVariable ["kills", 0];
};

increment_kill_count = {
	private kills = player getVariable "kills";
	player setVariable ["kills", kills + 1];
	
};

get_squadmates_skill = {

};