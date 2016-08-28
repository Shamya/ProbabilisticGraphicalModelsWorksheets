%  Set options for fminunc
options = optimoptions('fminunc','Algorithm','trust-region','GradObj','on');

%intial values
x0 = [-1,2];
fun = @costwithgrad;
%  Run fminunc
x = fminunc(fun,x0,options);
x = int8(x);
disp('maximum at (x,y) -');
disp(x);

f = -(1 - x(1))^2 - 100*(x(2)-x(1)^2)^2;
disp('max value of the function');
disp(f);
