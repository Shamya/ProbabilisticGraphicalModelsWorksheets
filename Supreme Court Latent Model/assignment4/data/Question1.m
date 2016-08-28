%Toy Data set for Q1a and Q1b
X =[1,2;2,4;3,6];
Y = [1;2;3];

disp('Dataset..');
disp('X =');
disp(X);
disp('Y = ');
disp(Y);

disp('Q1a. linear regression MLE');
w = linreg_mle(X,Y)

disp('Q1b. linear regression posterior correctness');
disp('N (0, big)');
priormean = [0;0];
[PosteriorMean,PosteriorCovar] = linreg_post(X,Y,priormean,1e100,1)

disp('With a prior mean proportional to MLE, the value of posterior mean was nearly same as the MLE even with a small prior variance.');
priormean = [1;2]
[PosteriorMean,PosteriorCovar] = linreg_post(X,Y,priormean,1,1)

disp('Q1c. Cook test');
priormean = [0;0]
priorvar_scalar = 1
emissionvar_scalar = 1
Nsim = 10000

disp('Plotting decile histogram...');
w_cdf = cook_linreg(priormean, priorvar_scalar, emissionvar_scalar, Nsim);
