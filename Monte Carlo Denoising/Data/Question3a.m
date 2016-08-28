%Monte Carlo De-noising for GAUSSIAN Images
%Read noisy image data
rng(0);
format long
X = textread('swirl-noise.txt');

%Read true pixel values
I = textread('swirl.txt');

%Initialize parameters
bestWP = -1;
bestWL = -1;
bestMAE = 1;
bestYestimate = zeros(50,50);

%explore combinations of the parameters to get better at the MAE
for WP = 193 %have plugged the final values to reduce the execution time
    for WL =1100 %have plugged the final values to reduce the execution time
        
        %Initialize denoised value of pixels
        Y = X;
        
        %Store the samples
        samples = [];
        collectMAE = [];
        Yestimateorig = zeros(50,50);
        
        %Iterate over T full sweeps
        T = 50;
        for t = 1:T
            Ynew = single_gibbs_sweep_gaussian(X, Y, WP, WL);
            %samples = [samples Ynew];
            Y = Ynew;
            Yestimateorig = Yestimateorig + Ynew;
            Yestimate = (1/t) * Yestimateorig;
            
            %MAE
            MAE = abs(Yestimate-I);
            MAE = sum(MAE);
            MAE = sum(MAE);
            MAE = (1/(2500)) * MAE;
            collectMAE = [collectMAE MAE];%used to plot for evaluation
            
            if (MAE < bestMAE)
                bestWP = WP;
                bestWL = WL;
                bestMAE = MAE;
                bestYestimate = zeros(50,50);
            end 
        end
    end
end
disp('Best WP');
disp(bestWP);
disp('Best WL');
disp(bestWL);
disp('MAE from the model');
imshow(Yestimate);
disp(MAE);

%baseline MAE
baseMAE = abs(X-I);
baseMAE = sum(baseMAE);
baseMAE = sum(baseMAE);
baseMAE = (1/(2500)) * baseMAE;
disp('Baeline MAE');
disp(baseMAE);