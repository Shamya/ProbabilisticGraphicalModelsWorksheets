function [ alpha, beta ] = resample_alphabeta(Y, Z, theta)

K = size(Y,1);
J = size(Y,2);
%eta for alpha and beta
eta = zeros(K,2);
b0 = zeros(2,1);
B0 = eye(2);

theta_star = ones(J, 2);
theta_star(:,1) = theta;

E = pinv(theta_star'*theta_star + pinv(B0));
e = ((Z*theta_star) + repmat((pinv(B0)*b0)',[K 1]))*E;

for i = 1: 2
    var(i) = sqrt(E(i,i));
end

%sample new alphas and betas from  posteriors
for k = 1:K
    eta(k,:) = normrnd(e(k,:), var);
end

alpha = eta(:,1);
beta = eta(:,2);
end