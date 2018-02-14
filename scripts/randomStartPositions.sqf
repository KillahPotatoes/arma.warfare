_prefixes = ["alpha", "bravo", "charlie"];

guer_prefix = selectRandom _prefixes;
_prefixes deleteAt (_prefixes find guer_prefix);

east_prefix = selectRandom _prefixes;
_prefixes deleteAt (_prefixes find east_prefix);

west_prefix = selectRandom _prefixes;

publicVariable "west_prefix";
publicVariable "east_prefix";
publicVariable "guer_prefix";
