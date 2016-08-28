function [Y] = single_gibbs_sweep(X,Y, WP, WL)
% A single sweep of the gibb's sampler

%Gibb's sampling

for i = 1:50
    for j = 1:50
        %draw a uniform random number alpha on [0,1]
        alpha = rand;
        
        %conditional probability
        P = conditional_probability(X, Y, i, j, WP, WL);
        
        %setting yij = 1 if ? < P(Yij = 1|yAij,xij) and setting yij = 0 otherwise
        if (alpha < P)
            Y(i,j) = 1;
        else
            Y(i,j) = 0;
        end
    end
end
end

