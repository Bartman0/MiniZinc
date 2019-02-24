% Use this editor as a MiniZinc scratch book
var 0..10: x;
constraint x mod 4 = 0;
output[show(x)];
solve minimize (x-7)^2;
