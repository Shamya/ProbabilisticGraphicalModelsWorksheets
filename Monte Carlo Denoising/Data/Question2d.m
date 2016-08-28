%Monte Carlo De-noising for Binary Images
%Read noisy image data
rng(0);
format long
X = textread('stripes-noise.txt');

%Read true pixel values
I = textread('stripes.txt');

%Initialize parameters - uncomment the setting you need
%initialization makes a big difference
WP = 1;
WL = 0.8;

%initialization doesnt make a big difference
%WP = 1;
%WL = 3;

%Warm start
%Initialize denoised value of pixels
Y = X;

Yestimateorig = zeros(50,50);
collectMAE = [];
collectPixelOn = [];

%Iterate over T full sweeps
T = 50;
for t = 1:T
    Ynew = single_gibbs_sweep(X, Y, WP, WL);
    Y = Ynew;
    Yestimateorig = Yestimateorig + Ynew;
    Yestimate = (1/t) * Yestimateorig;

    %collect #pixels turned on
    pxl = sum(Y);
    pxl = sum(pxl);
    collectPixelOn = [collectPixelOn pxl];
    
    %MAE
    MAE = abs(Yestimate-I);
    MAE = sum(MAE);
    MAE = sum(MAE);
    MAE = (1/(2500)) * MAE;
    collectMAE = [collectMAE MAE];
end

collectPixelOnWarm = collectPixelOn;

rng(0);
%Initialize denoised value of pixels
%Cold start
Y = zeros(50,50);

%Store the samples
collectMAE = [];
collectPixelOn = [];
Yestimateorig = zeros(50,50);

%Iterate over T full sweeps
T = 50;
for t = 1:T
    Ynew = single_gibbs_sweep(X, Y, WP, WL);
    Y = Ynew;
    Yestimateorig = Yestimateorig + Ynew;
    Yestimate = (1/t) * Yestimateorig;

    %collect #pixels turned on
    pxl = sum(Y);
    pxl = sum(pxl);
    collectPixelOn = [collectPixelOn pxl];
    
    %MAE
    MAE = abs(Yestimate-I);
    MAE = sum(MAE);
    MAE = sum(MAE);
    MAE = (1/(2500)) * MAE;
    collectMAE = [collectMAE MAE];
end

disp('Plotting...');
plot(1:T,collectPixelOnWarm, 'r', 1:T, collectPixelOn, 'g', 'LineWidth',1);
axis([1 T 0 2500]);
xlabel('iteration t');
ylabel('#pixels ON');
legend('Initialize to noisy image','Initialized to zero');
title('WP = 1, WL = 0.8');
%title('WP = 1, WL = 3'); 
