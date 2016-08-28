%Monte Carlo De-noising for Binary Images
%Read noisy image data
rng(0);
format long
X = textread('stripes-noise.txt');

%Read true pixel values
I = textread('stripes.txt');

%Initialize parameters - *** UNCOMMENT the one you need ***
%WP = 0;
%WL = 0;
WP = 1;
WL = 1;
%WP = 1;
%WL = -1;
%WP = -1;
%WL = 1;
%WP = -1;
%WL = -1;
Yestimateorig = zeros(50,50);

%Initialize denoised value of pixels
Y = X;

%Iterate over T full sweeps
T = 10;
for t = 1:T
    Ynew = single_gibbs_sweep(X, Y, WP, WL);
    
    Y = Ynew;
    Yestimateorig = Yestimateorig + Ynew;
    Yestimate = (1/t) * Yestimateorig;
    
end

imshow(Yestimate);
