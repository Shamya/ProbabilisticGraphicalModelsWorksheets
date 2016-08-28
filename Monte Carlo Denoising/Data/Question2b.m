%Monte Carlo De-noising for Binary Images
%Read noisy image data
rng(0);
format long
X = textread('stripes-noise.txt');

%Read true pixel values
I = textread('stripes.txt');

%Initialize parameters - uncomment the setting you need
%best
WP = 11;
WL = 14;

%undersmooting
%WP = 1;
%WL = 120; 

%oversmoothing
%WP = 130;
%WL = 1;
Yestimateorig = zeros(50,50);

%baseline
disp('Baseline MAE');
MAE = abs(X-I);
MAE = sum(MAE);
MAE = sum(MAE);
MAE = (1/(2500)) * MAE;
disp(MAE);

%Initialize denoised value of pixels
Y = X;


%Iterate over T full sweeps
T = 50;
for t = 1:T
    Ynew = single_gibbs_sweep(X, Y, WP, WL);
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

disp('MAE');
disp(MAE);
imshow(Yestimate);

