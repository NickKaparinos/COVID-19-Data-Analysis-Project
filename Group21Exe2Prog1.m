% Data Analysis Project 2020-2021
% Nikos Kaparinos 9245
% Vasiliki Zarkadoula 9103
% Exercise 2: Apply distribitions found in excersise 1 to 11 counries and
% check if they fit well
close all;
clc;
clear;

% Selected Countries
countryList = ["Greece","Austria","Belgium","Italy","France","Germany",...
    "Hungary","Ireland","Finland","Netherlands","United_Kingdom"];

% distribution chosen from excercise 1
distribution = 'Exponential';

pValuesCases = zeros(length(countryList),1);
pValuesDeaths = zeros(length(countryList),1);
hCases = zeros(length(countryList),1);
hDeaths = zeros(length(countryList),1);
counterCases = 0;
counterDeaths = 0;
for i = 1:length(countryList)
    % Read cases, deaths and population from data files
    [cases,deaths,population] = Group21Exe1Fun3(countryList(i));
    countryList(i) = strrep(countryList(i),"_"," "); % Replace "_" because it is used for subscripts in plot titles
    
    % Find the start and end of the first wave using Group21Exe1Fun1
    [start1,end1] = Group21Exe1Fun1(cases);
    cases = cases(start1:end1)';
    deaths = deaths(start1:end1)';
    
    %cases
    lengthC = length(cases);
    maxC = max(cases);
    countC = zeros(maxC+1,1);
    for j=1:maxC+1
        countC(j) = sum(cases == j-1);
    end
    yActualCases = countC/lengthC;
    xActualCases = 0:length(yActualCases)-1;
    
    %deaths
    lengthD = length(deaths);
    maxD = max(deaths);
    countD = zeros(maxD+1,1);
    for j=1:maxD+1
        countD(j) = sum(deaths == j-1);
    end
    yActualDeaths = countD/lengthD;
    xActualDeaths = 0:length(yActualDeaths)-1;
    
    % Fit exponential distribution to cases and deaths
    probDistribCases = fitdist(cases,distribution);
    predictedCases = pdf(probDistribCases,xActualCases);
    [hCases(i),pValuesCases(i)] = chi2gof(cases,'CDF',probDistribCases);
    
    if hCases(i) == 1
        fprintf('Exponential distribution does not fit to cases of %s (p = %0.4f)\n',countryList(i),pValuesCases(i))
    else
        counterCases = counterCases +1;
        fprintf('Exponential distribution fits to cases of %s (p = %0.4f)\n',countryList(i),pValuesCases(i))    
    end
    
    probDistribDeaths = fitdist(deaths,distribution);
    predictedDeaths = pdf(probDistribDeaths,xActualDeaths);
    [hDeaths(i),pValuesDeaths(i)] = chi2gof(deaths,'CDF',probDistribDeaths);
    
    if hDeaths(i) == 1
        fprintf('Exponential distribution does not fit to deaths of %s (p = %0.4f)\n',countryList(i),pValuesDeaths(i))
    else
        counterDeaths = counterDeaths + 1;
        fprintf('Exponential distribution fits to deaths of %s (p = %0.4f)\n',countryList(i),pValuesDeaths(i))
    end
    
    % Graphic display
    figure(i);
    bar(yActualCases);
    xlabel('Daily Cases')
    
    figure(i+100);
    histogram(cases,lengthC,'Normalization','probability')
    hold on
    plot(xActualCases,predictedCases);
    title(countryList(i) + " - Exponential Distribution - Cases ");
    xlabel('Daily Cases')
    ylabel('Probability')
    
    figure(i+200);
    bar(yActualDeaths)
    xlabel('Daily Deaths')
    
    figure(i+300);
    histogram(deaths,lengthD,'Normalization','pdf')
    hold on
    plot(xActualDeaths,predictedDeaths);
    title(countryList(i) + " - Exponential Distribution - probability ");
    xlabel('Daily Deaths')
    ylabel('Probability')
    
end

fprintf('\nExponential Distrubition for cases fits to %0.2f%% of the countries\n',(counterCases/length(countryList))*100);
fprintf('Exponential Distrubition for deaths fits to %0.2f%% of the countries\n',(counterDeaths/length(countryList))*100);

