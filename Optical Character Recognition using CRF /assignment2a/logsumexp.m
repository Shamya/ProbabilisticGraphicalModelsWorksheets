function s = logsumexp(x)
c = max(x);
s = c + log(sum(exp(x-c)));
end