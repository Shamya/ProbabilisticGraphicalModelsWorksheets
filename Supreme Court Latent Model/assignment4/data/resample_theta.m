function theta = resample_theta(Z, alpha, beta)
J = size(Z,2);
%beta = repmat(beta, [1, J]);
alpha = repmat(alpha, [1, J]);

[means, covar] = linreg_post(beta, Z-alpha, 0, 1, 1);
%covar =  covar(1,1)* eye(J);
theta = normrnd(means,covar);

end

