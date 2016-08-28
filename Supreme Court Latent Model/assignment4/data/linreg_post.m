function [ PosteriorMean, PosteriorCovar] = linreg_post(X,Y, priormean, priorvar_scalar, emissionvar_scalar)
% returns (PosteriorMean, PosteriorCovar)
% where PosteriorMean is a J-length vector
% where PosteriorCovar is a (J x J) shaped matrix

% emissionvar_scalar = 1
% priorvar_scalar = 1000

%pmean = ones(size(X,2),1);
%priormean = priormean_scalar * pmean;

priorvar = priorvar_scalar * eye(size(X,2));
PosteriorCovar = pinv(pinv(priorvar) + (X'*X));
a = (PosteriorCovar*pinv(priorvar)*priormean);
b = (PosteriorCovar*X'*Y);
PosteriorMean = (a + b);

end

