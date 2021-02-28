% Nikos Kaparinos 9245
% Vasiliki Zarkadoula 9103

function [meanCI,bootMeanCI] = Group21Exe3Fun2(timeInterval,t0,B,alpha)
% This function calculates and returns the parametric and bootstrap 
% confidence intervals

% 95% parametric CI of time intervals and hypothesis testing
[h,~,meanCI,~] = ttest(timeInterval,t0);
if h==0
    fprintf('Time between peak of daily cases and deaths can be %i days (Parametric hypothesis test)\n',t0);
else
    fprintf('Time between peak of daily cases and deaths can not be %i days (Parametric hypothesis test)\n',t0);
end

% 95% bootstrap CI of time intervals
rng default;
bootstrMean = bootstrp(B,@mean,timeInterval);
limits = [alpha/2 100-alpha/2];
bootMeanCI = prctile(bootstrMean,limits); 
% hypothesis testing
if t0<bootMeanCI(2) && t0>bootMeanCI(1)
    fprintf('Time between peak of daily cases and deaths can be %i days (Bootstrap hypothesis test)\n',t0);
else
    fprintf('Time between peak of daily cases and deaths can not be %i days (Bootstrap hypothesis test)\n',t0);
end