% workshop 2
% select a set of trade negotiation party
enum NEGOTIATOR;
NEGOTIATOR: dummy; 

int: l; % minimum party size
int: u; % maximum party size
int: m; % minimum joint ability

array[NEGOTIATOR] of int: honor;
array[NEGOTIATOR,NEGOTIATOR] of int: joint;

set of int: BOUNDS = l..u;
set of int: BOUNDS_1 = l..u-1;
array[BOUNDS] of var NEGOTIATOR: party;

% total strength
var int: strength = sum(i,j in BOUNDS where i < j) (joint[party[i],party[j]]);
var int: minhonor = min(i in BOUNDS)(honor[party[i]]);

% party negotiators are sorted ascending
constraint forall(i in BOUNDS_1) (party[i] < party[i+1] + (party[i] != dummy));
% no party negotiator may occur more than once
constraint forall(n in NEGOTIATOR where n != dummy)(sum(i in BOUNDS)(party[i] = n) <= 1);
constraint strength >= m;

%solve maximize strength;
solve maximize minhonor;

%output ["party = {"] ++ [show(party[i]) ++ if party[i] != dummy then if i == u then "};\n" else ", " endif else "" endif | i in BOUNDS ]
output ["party = {"] ++ [ show(party[i]) ++ if i < u then ", " else "" endif | i in BOUNDS ] ++ ["}\n"];
output ["strength = \(strength)\n"];
output ["obj = \(minhonor)\n"];
