function [Y] = single_gibbs_sweep_gaussian(X,Y, WP, WL)
% A single sweep of the gibb's sampler for gaussian values

%Gibb's sampling

for i = 1:50
    for j = 1:50
        
        %number of neighbors
        [N, nb] = neighbors(i,j);
        %conditional probability
        sigma = 1/(2*((WP*N)+WL));
        
        sg = 0;
        for nidx = 1: size(nb,1)
            sg = sg + WP * Y(nb(nidx,1), nb(nidx,2));
        end
        
        mu = (1/((WP*N)+WL)) * ((WL*X(i,j)) + (sg));
        
        %draw a normal random number alpha on [0,1]
        z = normrnd(0,1);
        
        %setting yij
        Y(i,j) = mu + (z * sqrt(sigma));
        
    end
end

end



