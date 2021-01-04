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
movavgMaxCases = zeros(l,1);
movavgMaxDeaths = zeros(l,1);
movavgDayofMaxCases = zeros(l,1);
movavgDayofMaxDeaths = zeros(l,1);
movavgEstimatedMaxCases = zeros(l,1);
movavgEstimatedMaxDeaths = zeros(l,1);
for i = 1:l
    [cases,deaths,population] = Group21Exe1Fun3(countryList(i));
    countryList(i) = strrep(countryList(i),"_"," "); 
    
    [start1,end1] = Group21Exe1Fun1(cases);
    cases = cases(start1:end1)';
    deaths = deaths(start1:end1)';
    
    [actualMaxCases(i),dayofMaxCases(i),estimatedMaxCases(i)] = Group21Exe3Fun1(cases);
    [actualMaxDeaths(i),dayofMaxDeaths(i),estimatedMaxDeaths(i)] = Group21Exe3Fun1(deaths);
    
    casesMovingAverage = movmean(cases,7);
    deathsMovingAverage = movmean(deaths,7);
    
    [movavgMaxCases(i),movavgDayofMaxCases(i),movavgEstimatedMaxCases(i)] = Group21Exe3Fun1(casesMovingAverage);
    [movavgMaxDeaths(i),movavgDayofMaxDeaths(i),movavgEstimatedMaxDeaths(i)] = Group21Exe3Fun1(deathsMovingAverage);

end

% Calculate the time interval between peak of cases and peak of deaths
% Considering that peak of deaths follows peak of cases

t0 = 14;
B = 100;
alpha = 0.05;

% First approach
timeInterval = dayofMaxDeaths - dayofMaxCases;
fprintf('First approach:\n')
[meanCI1,bootMeanCI1] = Group21Exe3Fun2(timeInterval,t0,B,alpha);

% Second approach
% if there is an outlier in timeInterval remove it
for i=1:length(timeInterval)
    if timeInterval(i) < -5
        timeInterval(i) = NaN;
    end
end
timeInterval(isnan(timeInterval)) = [];
fprintf('Second approach:\n')
[meanCI2,bootMeanCI2] = Group21Exe3Fun2(timeInterval,t0,B,alpha);


% Third approach
movavgTimeInterval = movavgDayofMaxDeaths - movavgDayofMaxCases;
fprintf('Third approach:\n')
[meanCI3,bootMeanCI3] = Group21Exe3Fun2(movavgTimeInterval,t0,B,alpha);




