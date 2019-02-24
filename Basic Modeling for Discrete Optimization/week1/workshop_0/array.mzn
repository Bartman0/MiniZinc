% Use this editor as a MiniZinc scratch book
int: n = 8;
array[0..n] of var 0..9: x;
constraint sum(x) = product(x);
constraint forall (i in 0..n-1)(x[i] <= x[i+1]);
output[show(x)];
solve satisfy;
