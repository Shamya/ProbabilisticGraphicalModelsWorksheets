%Monte Carlo De-noising for Gaussian Images
%Read noisy image data
rng(0);
format long
X = textread('swirl-noise.txt');

%Read true pixel values
I = textread('swirl.txt');
WP = 11; %Initialized to best value found
WL = 415; %Initialized to best value found
%Initialize denoised value of pixels
Y = X;

%Store the samples
samples = [];
%collectMAE = [];
Yestimateorig = zeros(50,50);

%Iterate over T full sweeps
T = 50;
for t = 1:T
    Ynew = single_gibbs_sweep_gaussian_WP(X, Y, WP, WL);
    %samples = [samples Ynew];
    Y = Ynew;
    Yestimateorig = Yestimateorig + Ynew;
    Yestimate = (1/t) * Yestimateorig;
    
    %MAE
    MAE = abs(Yestimate-I);
    MAE = sum(MAE);
    MAE = sum(MAE);
    MAE = (1/(2500)) * MAE;
end
disp('WP');
disp(WP);
disp('WL');
disp(WL);
disp(MAE);
imshow(Yestimate);