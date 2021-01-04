% Data Analysis Project 2020-2021
% Nikos Kaparinos 9245
% Vasiliki Zarkadoula 9103
% Exercise 3: Estimation of the time interval from the peak of
% daily cases until the peak of daily deaths
% 95% parametric and bootstrap confidence intevals, hypothesis testing
close all;
clc;
clear;

% Selected Country
country = "Greece";

% Read cases, deaths and population from data files
[cases,deaths,population] = Group21Exe1Fun3(country);

% Find the start and end of the first wave using Group21Exe1Fun1
[start1,end1] = Group21Exe1Fun1(cases);
cases = cases(start1:end1)';
deaths = deaths(start1:end1)';

% Calculation of peaks of the first wave for cases-deaths and an estimation
% of them based on the maximum value of the exponential distribution
[actualMaxCasesGreece,dayofMaxCasesGreece,estimatedMaxCasesGreece] = Group21Exe3Fun1(cases);
[actualMaxDeathsGreece,dayofMaxDeathsGreece,estimatedMaxDeathsGreece] = Group21Exe3Fun1(deaths);


% Selected Countries
countryList = ["Greece","Austria","Belgium","Italy","France","Germany",...
    "Hungary","Ireland","Finland","Netherlands","United_Kingdom"];

% Same procedure as above but for the 11 selected countries
l = length(countryList);
actualMaxCases = zeros(l,1);
actualMaxDeaths = zeros(l,1);
dayofMaxCases = zeros(l,1);
dayofMaxDeaths = zeros(l,1);
estimatedMaxCases = zeros(l,1);
estimatedMaxDeaths = zeros(l,1);
for i = 1:l
    [cases,deaths,population] = Group21Exe1Fun3(countryList(i));
    countryList(i) = strrep(countryList(i),"_"," "); 
    
    [start1,end1] = Group21Exe1Fun1(cases);
    cases = cases(start1:end1)';
    deaths = deaths(start1:end1)';
    
    [actualMaxCases(i),dayofMaxCases(i),estimatedMaxCases(i)] = Group21Exe3Fun1(cases);
    [actualMaxDeaths(i),dayofMaxDeaths(i),estimatedMaxDeaths(i)] = Group21Exe3Fun1(deaths);

end

% Calculate the time interval between peak of cases and peak of deaths
% Considering that peak of deaths follows peak of cases
timeInterval = dayofMaxDeaths - dayofMaxCases;
% if timeInterval negative replace it with zero
for i=1:length(timeInterval)
    if timeInterval(i) < 0
        timeInterval(i) = 0;
    end
end

% 95% parametric CI of time intervals
[~,~,meanCI,~] = ttest(timeInterval);
% hypothesis testing
t0 = 14;
if t0<meanCI(2) && t0>meanCI(1)
    fprintf('Time between peak of daily cases and deaths can be %i days (Parametric CI check)\n',t0);
else
    fprintf('Time between peak of daily cases and deaths can not be %i days (Parametric CI check)\n',t0);
end
%or
[h,~,~,~] = ttest(timeInterval,14);
if h==0
    fprintf('Time between peak of daily cases and deaths can be %i days (ttest check)\n',t0);
else
    fprintf('Time between peak of daily cases and deaths can not be %i days (ttest check)\n',t0);
end


% 95% bootstrap CI of time intervals
B = 100;
alpha = 0.05;
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



