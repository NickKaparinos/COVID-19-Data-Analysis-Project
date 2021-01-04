function [actualMax,dayofMax,estimatedMax] = Group21Exe3Fun1(data)

[actualMax,dayofMax] = max(data);
probabiltyDistribution = fitdist(data,'Exponential');
mu = probabiltyDistribution.mu;

M = 100;
maxR = zeros(M,1);
for i = 1:M
    r = exprnd(mu,length(data),1);
    maxR(i) = max(r);
end
estimatedMax = median(maxR);