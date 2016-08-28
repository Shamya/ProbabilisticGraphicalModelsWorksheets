function w = linreg_mle(X,Y)
% returns one vector of the inferred MLE weights.
% X: matrix shape (N x J)
% Y: vector length N

w = pinv(X' * X) *(X'* Y);

end

