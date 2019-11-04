// KEYS

ARWA_KEY_owned_by = "owned_by";
ARWA_KEY_active = "active";
ARWA_KEY_target = "target";
ARWA_KEY_occupied = "occupied";
ARWA_KEY_sector = "sector";
ARWA_KEY_transport = "transport";
ARWA_KEY_manpower = "manpower";

ARWA_KEY_menu = "menu";
ARWA_KEY_fired_barrage = "fired_barrage";
ARWA_KEY_player_driver = "player_driver";
ARWA_KEY_pos = "position";
ARWA_KEY_marker = "marker";
ARWA_KEY_static_artillery = "static_artillery";
ARWA_KEY_static = "static";
ARWA_KEY_respawn_pos = "respawn_pos";
ARWA_KEY_respawn_ground = "respawn_ground";
ARWA_KEY_respawn_air = "respawn_air";
ARWA_KEY_target_name = "target_name";
ARWA_KEY_box = "box";
ARWA_KEY_HQ = "HQ";
ARWA_KEY_manpower_box = "manpower-box";
ARWA_KEY_soldier_count = "s_count";
ARWA_KEY_defense = "defense";
ARWA_KEY_penalty = "penalty";
ARWA_KEY_kill_bonus = "kill_bonus";
ARWA_KEY_vehicle = "vehicle";
ARWA_KEY_helicopter = "helicopter";
ARWA_KEY_infantry = "infantry";
ARWA_KEY_interceptor = "interceptor";
ARWA_KEY_priority_target = "priority_target";
ARWA_KEY_sector_capture_progress = "ARWA_KEY_sector_capture_progress";
ARWA_KEY_hacked = "hacked";
ARWA_KEY_sector_markers = "sector_markers";
ARWA_KEY_static_defense = "static_defense";
ARWA_KEY_sector_defense = "sector_defense";
ARWA_KEY_can_rearm = "can_rearm";
ARWA_KEY_sympathizers = "sympathizers";
ARWA_KEY_reinforements_available = "reinforements_available";

ARWA_KEY_rank1 = "PRIVATE";
ARWA_KEY_rank2 = "CORPORAL";
ARWA_KEY_rank3 = "SERGEANT";
ARWA_KEY_rank4 = "LIEUTENANT";
ARWA_KEY_rank5 = "CAPTAIN";
ARWA_KEY_rank6 = "MAJOR";
ARWA_KEY_rank7 = "COLONEL";

ARWA_ranks = [
	ARWA_KEY_rank1,
	ARWA_KEY_rank2,
	ARWA_KEY_rank3,
	ARWA_KEY_rank4,
	ARWA_KEY_rank5,
	ARWA_KEY_rank6,
	ARWA_KEY_rank7
];

ARWA_ARRAY_KEY_prefixes = [
	"alpha",
	"bravo",
	"charlie"
];

ARWA_penalty = "penalty";
ARWA_kill_bonus = "kill_bonus";

// CONSTANT VARS
ARWA_rating_per_rank = 1500;
ARWA_respawn_cooldown = 900;
ARWA_sector_size = 200;
ARWA_unit_cap = 90;
ARWA_defender_cap = 10;
ARWA_squad_cap = 12;
ARWA_transport_helicopter_spawn_height = 100;
ARWA_gunship_spawn_height = 500;
ARWA_manpower_generation_time = 60;
ARWA_show_all = false;
ARWA_capture_time = 60;
ARWA_interceptor_safe_distance = 16000;
ARWA_uav_flight_height = 1000;
ARWA_squad_kill_rating = 200;
ARWA_spawn_forces_interval = 120;
ARWA_spawn_forces_interval_variation = 60;
ARWA_tier_base_gunship_respawn_time = 900;
ARWA_tier_0_gunship_respawn_time = 900;
ARWA_tier_1_gunship_respawn_time = 600;
ARWA_tier_2_gunship_respawn_time = 300;
ARWA_cease_fire = false;
ARWA_infantry_reinforcement_distance = 2000;
ARWA_static_defense_reinforcement_interval = 900;
ARWA_sector_defense_reinforcement_interval = 300;
ARWA_min_distance_presence = 400;
ARWA_max_distance_presence = 600;
ARWA_max_random_enemies = 10;
ARWA_required_sympathizers_for_commander_spawn = 3;
ARWA_min_commander_manpower = 10;
ARWA_max_commander_manpower = 30;
ARWA_chance_of_enemy_presence_in_controlled_area = 5;

// Action priority

ARWA_air_vehicle_menu = 150;
ARWA_ground_vehicle_menu = 140;
ARWA_infantry_menu = 130;
ARWA_interceptor_menu = 120;
ARWA_return_vehicle = 90;
ARWA_intel_menu = 85;
ARWA_ground_transport_actions = 70;
ARWA_air_transport_actions = 80;
ARWA_active_transport_actions = 80;
ARWA_active_uav_actions = 75;
ARWA_manpower_actions = 60;
ARWA_squad_actions = 50;
ARWA_interceptor_actions = 45;
ARWA_rearm_arsenal = 40;
