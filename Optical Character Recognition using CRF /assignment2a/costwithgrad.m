function [f,g] = costwithgrad(x)
% Calculate objective f
f = (1 - x(1))^2 + 100*(x(2)-x(1)^2)^2;

if nargout > 1 % gradient required
    g = [-2 + 2*x(1) - 400*x(1)*x(2) + 400*x(1)^3;
        200*(x(2)-x(1)^2)];
end