% Beauty Trap
% Create the most magnificient feast 

include "alldifferent.mzn";
include "regular.mzn";

enum DISH;
enum TASTE = {spicy, sour, salty, sweet, umame, bland};
enum TEMP = {hot, cold, warm};
%int: ndish;
%set of int: DISH = 1..ndish;
%set of int: TASTE = 1..6;
%int: spicy = 1; int: sour = 2; int: salty = 3; int: sweet = 4; int: umame = 5; int: bland = 6;
%set of int: TEMP = 1..3;
%int: hot = 1; int: cold = 2; int: warm = 3;


array[DISH] of TASTE: taste;
array[DISH] of TEMP: temp;
array[DISH] of bool: heavy;
array[DISH] of int: value;

int: len; % length of banquet
set of int: COURSE = 1..len;
set of int: COURSE_1 = 1..len-1;
set of int: COURSE_2 = 1..len-2;

array[COURSE] of var DISH: dish;

constraint alldifferent(dish);
constraint forall(i in COURSE_1)(taste[dish[i]] != taste[dish[i+1]]);
constraint taste[dish[1]] = salty;
constraint taste[dish[len]] = sweet;
constraint forall(i in COURSE_1)(taste[dish[i]] = spicy -> taste[dish[i+1]] in { bland, sweet });
constraint forall(i in COURSE_1)(taste[dish[i]] = sour  -> taste[dish[i+1]] in { bland, umame });
constraint forall(i in COURSE_1)(taste[dish[i]] = sweet -> taste[dish[i+1]] in { sour, salty, bland });
constraint forall(i in COURSE_1, j in i+1..len)
                 (temp[dish[i]] = hot /\ temp[dish[j]] = cold -> 
                   exists(k in i+1 .. j-1)(temp[dish[k]] = warm));
constraint forall(i in COURSE_2)((heavy[dish[i]] /\ heavy[dish[i+1]]) -> not(heavy[dish[i+2]]));

var int: obj = sum(i in COURSE)(value[dish[i]])
              + sum(i in COURSE_1)(taste[dish[i]] != taste[dish[i+1]])
              + sum(i in COURSE_1)(temp[dish[i]] != temp[dish[i+1]])
              + sum(i in COURSE_1)(heavy[dish[i]] != heavy[dish[i+1]]);

solve maximize obj;
