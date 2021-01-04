function [meanCI,bootMeanCI] = Group21Exe3Fun2(timeInterval,t0,B,alpha)

% 95% parametric CI of time intervals
[h,~,meanCI,~] = ttest(timeInterval,t0);
if h==0
    fprintf('Time between peak of daily cases and deaths can be %i days (Parametric check)\n',t0);
else
    fprintf('Time between peak of daily cases and deaths can not be %i days (Parametric check)\n',t0);
end

% 95% bootstrap CI of time intervals
bootstrMean = bootstrp(B,@mean,timeInterval);
lowerLim = (B+1)*alpha/2;
upperLim = B+1-lowerLim;
limits = [lowerLim upperLim]/B*100;
bootMeanCI = prctile(bootstrMean,limits); 
% hypothesis testing
if t0<bootMeanCI(2) && t0>bootMeanCI(1)
    fprintf('Time between peak of daily cases and deaths can be %i days (Bootstrap CI check)\n',t0);
else
    fprintf('Time between peak of daily cases and deaths can not be %i days (Bootstrap CI check)\n',t0);
end