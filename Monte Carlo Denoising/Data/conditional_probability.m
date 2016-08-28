function P = conditional_probability(X,Y,i,j, WP, WL)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
%calculate conditional probability
weight1 = 0;
weight0 = 0;
if i-1>0
    if Y(i-1, j) == 1
        weight1 = weight1+WP;
    else
        weight0 = weight0+WP;
    end
end
if i+1<51
    if Y(i+1, j) == 1
        weight1 = weight1+WP;
    else
        weight0 = weight0+WP;
    end
end
if j-1>0
    if Y(i, j-1) == 1
        weight1 = weight1+WP;
    else
        weight0 = weight0+WP;
    end
end
if j+1<51
    if Y(i, j+1) == 1
        weight1 = weight1+WP;
    else
        weight0 = weight0+WP;
    end
end
if X(i,j) == 1
    weight1 = weight1+WL;
else
    weight0 = weight0+WL;
end

P = exp(weight1) / (exp(weight0) + exp(weight1));

end

