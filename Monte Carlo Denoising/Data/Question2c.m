%Monte Carlo De-noising for Binary Images
%Read noisy image data
rng(0);
format long
X = textread('stripes-noise.txt');

%Read true pixel values
I = textread('stripes.txt');

%Initialize best parameters
WP = 11;
WL = 14;

%Initialize denoised value of pixels
Y = X;

%Store the samples
collectMAE = [];
Yestimateorig = zeros(50,50);

%Iterate over T full sweeps
T = 200;
for t = 1:T
    Ynew = single_gibbs_sweep(X, Y, WP, WL);
    Y = Ynew;
    Yestimateorig = Yestimateorig + Ynew;
    Yestimate = (1/t) * Yestimateorig;
    
    %MAE
    MAE = abs(Yestimate-I);
    MAE = sum(MAE);
    MAE = sum(MAE);
    MAE = (1/(2500)) * MAE;
    collectMAE = [collectMAE MAE];
end

disp('MAE converged to');
disp(min(collectMAE));
disp('Plotting...'); 
plot(1:T,collectMAE);
axis([1 T 0 0.005]);
xlabel('step t');
ylabel('MAE of the t-step posterior mean images');
title('MAE of the t-step posterior mean images versus t');