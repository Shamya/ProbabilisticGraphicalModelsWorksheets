%Supreme Court latent space model
rng(0);

J = 29; % justices
K = 3450; %cases
D = 1;    % dimensionality of the issue space

%MCMC parameters
burnin = 2000;
gibbs  = 8000;
tot_iter = burnin + gibbs;

b0 = zeros(D+1,1);
B0 = eye(D+1);
B0b0 = B0*b0;

t0 = zeros(D,1);
T0 = eye(D);
T0t0 = T0*t0;

% read data
Y = textread('allvotes.txt');
Y = Y(:,3:end);

%sampler intialization
theta_store = [];%zeros(gibbs/thin,J*D);
median_store = zeros(J,1);
avg_correct = zeros(J,K);
Zpred = zeros(J,K);

%priors
Z     = zeros(J,K);
theta = normrnd(0,1,[J 1]);
eta   = normrnd(0,1,[K D+1]);
alpha = normrnd(0,1,[K 1]);
beta = normrnd(0,1, [K 1]);

disp('Starting Gibbs sampler');
%Gibbs Sampler
count = 0;
for iter=1:tot_iter
    disp(iter);
    Z = resample_Z(Y, alpha, beta, theta);
    theta = resample_theta(Z, alpha, beta);
    [alpha, beta] = resample_alphabeta(Y, Z, theta);
    if(iter > burnin)
        theta_store = [theta_store ;theta];
    end
end

%plot
jusnames = textread('data/justicenames.txt');
figure()
for j = 1:J:
    plot(theta_store(:,j), 1:gibbs);
end
xlabel('gibbs sampling iteration after burnin');
ylabel('policy prefernce(theta j)');
title('Ploicy prefernce updates for each justice');

%mean and std
mean = sum(theta_score);
mean = mean / 8000;
std = std(theta_store);