array[int] of int: readings;
int: start;
int: n = length(readings);
set of int: HOUR = 1..n;
set of int: HOUR0 = 0..n;

enum ACTION = {heat, strongly_heat, cool, strongly_cool, do_nothing};

% ieder uur moet de temperatuur een bepaalde waarde krijgen; index 0 is voor de start
array[HOUR0] of var 25..30: temp;   % kan ook als var int worden gedefinieerd met een extra constraint

% ieder uur kan er een actie worden uitgevoerd om de temperatuur bij te stellen
array[HOUR] of var ACTION: actions;

% parameters voor de acties, deze brengen nl kosten met zich mee, en hebben een zeker effect
array[ACTION] of var int: costs = [1,5,3,9,0];   % kosten respectievelijk in euro's, dus heat kost 1 euro
array[ACTION] of var int: adjustment = [1,4,-2,-5,0];   % effect van de actie; strongy_cool resulteert in -5 graden

constraint temp[0] = start;

constraint forall(h in HOUR) (temp[h] = (temp[h-1] + readings[h]) div 2 + adjustment[actions[h]]);
% constraint forall(h in HOUR) (temp[h] >= 25 /\ temp[h] <= 30);   % indien temp van type int is ipv 25..30

var int: cost = sum(h in HOUR) (costs[actions[h]]);

solve minimize cost;   % minimaliseer de kosten om het doel van temperatuur tussen 25 en 30 graden te bereiken

% ouderwetse printjes van de uitkomsten
output ["temp = \(temp);\n"];
output ["choice = \(actions);\n"];
output ["costs = \(sum(h in HOUR) (costs[actions[h]]));\n"];
