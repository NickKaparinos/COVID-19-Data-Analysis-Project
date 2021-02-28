% Nikos Kaparinos 9245
% Vasiliki Zarkadoula 9103

function [actualMax,dayofMax,estimatedMax,estimatedDayofMax] = Group21Exe3Fun1(data,distribution)
% This function returns the maximum value of data and the day that it
% occured. Also it estimates the maximum value and the day based on the 
% suitable parametric distribution

[actualMax,dayofMax] = max(data);
days = 1:length(data);

pd = fitdist(days',string(distribution),'Frequency',data);
fittedPdf = pdf(pd,days);
fittedPdf = fittedPdf.*sum(data);

[estimatedMax,estimatedDayofMax] = max(fittedPdf);
estimatedMax = round(estimatedMax);
end