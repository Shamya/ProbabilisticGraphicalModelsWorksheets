function [Y] = single_gibbs_sweep_gaussian_WP(X,Y, WP_base, WL)
% A single sweep of the gibb's sampler for gaussian values

%Gibb's sampling
for i = 1:50
    for j = 1:50
        %get neighbors
        [N, nb] = neighbors(i,j);
        %conditional probability
        sg = 0;
        m = 0;
        
        %general WP
        for nidx = 1: size(nb,1)
            WP = (WP_base) / (0.01 + ((X(i,j) - X(nb(nidx,1), nb(nidx,2)))^2));
            m = m + WP;
            sg = sg + (WP * Y(nb(nidx,1), nb(nidx,2)));
        end
        
        %mean and variance
        sigma = 1/(2*(m+WL));
        mu = (1/(m+WL)) * ((WL*X(i,j)) + (sg));
        
        %draw a normal random number z on [0,1]
        z = normrnd(0,1);
        
        %setting yij
        Y(i,j) = mu + (z * sqrt(sigma));
        
    end
end

end



