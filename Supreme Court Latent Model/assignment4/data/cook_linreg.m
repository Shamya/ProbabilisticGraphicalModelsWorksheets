function [ w_cdf ] = cook_linreg(priormean, priorvar_scalar, emissionvar_scalar, Nsim)

%Runs Nsim simulations and returns list length Nsim of results for each one.
%Each result might contain the posterior mean/covar calculation, and/or the
%marginal posterior CDF of the "true" weight variable you're interested in, etc.
%(obviously there are lots of alternative ways to structure this.)

%priormean = [0;0];
%priorvar_scalar = 1;
%emissionvar_scalar = 1;
%Nsim = 10000;

rng(0);

X = [1,1;1,2; 1,3];
w_cdf = [];

%Fixed prior
w0 = priormean;
v0 = priorvar_scalar * ones(size(X,2),1);

for i = 1:Nsim
    %For a single simulation
    %sample w from the prior N (w0 , V0)
    w = normrnd(w0,sqrt(v0));
    %sample each yi from N (w?xi, ?2)
    Y = normrnd(X*w, sqrt(emissionvar_scalar));
    
    %infer the posterior P (w | X, Y, ?2)
    [ PosteriorMean, PosteriorCovar] = linreg_post(X,Y, priormean, priorvar_scalar, emissionvar_scalar);
    
    PosteriorVar = zeros(size(X,2),1);
    %derive variance
    for i = 1: size(X,2)
        PosteriorVar(i) = PosteriorCovar(i,i);
    end
    
    %CDF of the ?true? simulated w
    wc = normcdf(w,PosteriorMean,sqrt(PosteriorVar));
    w_cdf = [w_cdf, wc];
end
histogram(w_cdf(2,:),10);
end

