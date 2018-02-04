// [format ["Curator Points:\n%1/10000", (curatorPoints _x) * 10000]] remoteExec ["hintSilent", _x];

while {true} do {
    {
        [format ["%1%2", ceil((curatorPoints _x) * 100), "%"]] remoteExec ["hintSilent", _x];

    } forEach allCurators;
    sleep 60;
};
