% assignment 2
% select a set of raiding warrior
enum WARRIOR;
WARRIOR: dummy; 
enum CLAN; % the clan they belong too

int: l; % minimum raid party size
int: u; % maximum raid party size
int: m; % limit of hatreds

array[WARRIOR] of int: strength;
array[WARRIOR] of CLAN: clan;

array[CLAN,CLAN] of 0..1: hates;

set of int: BOUNDS =   1..u;
set of int: BOUNDS_1 = 1..u-1;
array[BOUNDS] of var WARRIOR: raid;

var int: raid_size =     sum(i in BOUNDS where raid[i] != dummy) (1);
var int: raid_strength = sum(i in BOUNDS) (strength[raid[i]]);
var int: raid_hates =    sum(i,j in BOUNDS where i < j) (hates[clan[raid[i]],clan[raid[j]]]);

% raid party warriors are sorted ascending; equality allows for multiple dummies, and the occurance constraint ensures that warriors only occur once
constraint forall(i in BOUNDS_1) (raid[i] <= raid[i+1]);
% no raid party warrior may occur more than once
constraint forall(w in WARRIOR where w != dummy)(sum(i in BOUNDS)(raid[i] = w) <= 1);
% size of raid party must be at least = l
constraint raid_size >= l;
% hates must be no more than limit m
constraint raid_hates <= m;

solve maximize raid_strength;

output ["raid = {"] ++ [if fix(raid[i]) != dummy then show(raid[i])
                        ++ if i < u /\ fix(raid[i+1]) != dummy then ", " else "" endif
                        else "" endif | i in BOUNDS ] ++ ["};\n"] ++ ["obj = \(raid_strength);\n"];
