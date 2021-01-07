function [actualMax,dayofMax,estimatedMax] = Group21Exe3Fun1(data,distribution)
% This function returns the maximum value of data and the day that it
% occured. Also it estimated the maximum value based on the suitable
% parametric distribution
[actualMax,dayofMax] = max(data);

if iscell(distribution) == iscell('Normal')
    probabiltyDistribution = fitdist(data,'Normal');
    mu = probabiltyDistribution.mu;
    sigma = probabiltyDistribution.sigma;
    M = 1000;
    maxR = zeros(M,1);
    % Estimation of max of length(data) samples from best distribution
    % Do M experiments and find median
    for i = 1:M
        r = normrnd(mu,sigma,length(data),1);
        maxR(i) = max(r);
    end
    estimatedMax = median(maxR);
    
elseif iscell(distribution) == iscell('Exponential')
    probabiltyDistribution = fitdist(data,'Exponential');
    mu = probabiltyDistribution.mu;
    M = 1000;
    maxR = zeros(M,1);
    for i = 1:M
        r = exprnd(mu,length(data),1);
        maxR(i) = max(r);
    end
    estimatedMax = median(maxR);
    
elseif iscell(distribution) == iscell('Rayleigh')
    probabiltyDistribution = fitdist(data,'Rayleigh');
    b = probabiltyDistribution.b;
    M = 1000;
    maxR = zeros(M,1);
    for i = 1:M
        r = raylrnd(b,length(data),1);
        maxR(i) = max(r);
    end
    estimatedMax = median(maxR);
    
elseif iscell(distribution) == iscell('Logistic')
    probabiltyDistribution = fitdist(data,'Logistic');
    mu = probabiltyDistribution.mu;
    sigma = probabiltyDistribution.sigma;
    M = 1000;
    maxR = zeros(M,1);
    for i = 1:M
        r = random('Logistic',mu,sigma,length(data),1);
        maxR(i) = max(r);
    end
    estimatedMax = median(maxR);
    
else 
    probabiltyDistribution = fitdist(data,'Poisson');
    lambda = probabiltyDistribution.lambda;
    M = 1000;
    maxR = zeros(M,1);
    for i = 1:M
        r = poissrnd(lambda,length(data),1);
        maxR(i) = max(r);
    end
    estimatedMax = median(maxR);
end
