% Data Analysis Project 2020-2021
% Nikos Kaparinos 9245
% Vasiliki Zarkadoula 9103
% Exercise 4: Pearson correlation coefficient
close all;
clc;
clear;

% Selected Countries
countryList = ["Greece","Belgium","Italy","France","Germany",...
                "Netherlands","United_Kingdom"];
            
R = zeros(41,1);  
maxR = zeros(length(countryList),5);
timeLag = zeros(length(countryList),5);
for i = 1:length(countryList)
    % Read cases, deaths and population from data files
    [cases,deaths,population] = Group21Exe1Fun3(countryList(i));
    countryList(i) = strrep(countryList(i),"_"," "); % Replace "_" because it is used for subscripts in plot titles
    
    % Find the start and end of the first wave using Group21Exe1Fun1
    [start1,end1] = Group21Exe1Fun1(cases);
    cases = cases(start1:end1)';
    deaths = deaths(start1:end1)';
    n = length(cases);
    
    % Find max correlation coefficient for different time lags t
    for t = 0:20
        X = cases(1:n-t);
        Y = deaths(1+t:n);
        corrCoef = corrcoef(X,Y);
        R(t+1) = corrCoef(1,2);
    end
    for t = -20:-1
        X = cases(1-t:n);
        Y = deaths(1:n+t);
        corrCoef = corrcoef(X,Y);
        R(t+42) = corrCoef(1,2);
    end
    [sortedR, sortedInds] = sort(R,'descend');
    maxR(i,:) = sortedR(1:5);
    timeLag(i,:) = sortedInds(1:5);
    
    fprintf('In %s max correlation coefficient is found for time lag %i\n',countryList(i),timeLag(i,1));
    
end