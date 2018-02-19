setup_faction_relations = {
	EAST setFriend [WEST, 0];
	WEST setFriend [EAST, 0];

	independent setFriend [west, 0];
	west setFriend [independent, 0];

	east setFriend [independent, 0];
	independent setFriend [east, 0];
};
