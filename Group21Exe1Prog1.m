% Data Analysis Project 2020-2021
% Nikos Kaparinos 9245
% Vasiliki Zarkadoula 9103
% Exercise 1: Fit parametric probability distribution
close all;
clc;
clear;

% Chosen country -> remainder(9103/156) + 1 = 56
% Closest European country -> 55, Greece
country = "Greece";
[cases,deaths,population] = Group42Exe1Fun3(country);

% Start and end of the first Covid-19 wave
[start1,end1] = Group42Exe1Fun1(cases);
cases = cases(start1:end1)';
deaths = deaths(start1:end1)';

% Find empirical distribution of cases
lengthC = length(cases);
maxC = max(cases);
countC = zeros(maxC+1,1);
for j=1:maxC+1
    countC(j) = sum(cases == j-1);
end
yActualCases = countC/lengthC;
xActualCases = 0:length(yActualCases)-1;

figure;
histogram(cases);
xlabel('Daily Cases')
ylabel('Number of days that cases occur')

figure;
bar(yActualCases)
title('Empirical Distribution')
xlabel('Daily Cases')

% Find empirical distribution of deaths

lengthD = length(deaths);
maxD = max(deaths);
countD = zeros(maxD+1,1);
for j=1:maxD+1
    countD(j) = sum(deaths == j-1);
end
yActualDeaths = countD/lengthD;
xActualDeaths = 0:length(yActualDeaths)-1;

figure;
histogram(deaths);
xlabel('Daily Deaths')
ylabel('Number of days that deaths occur')

figure;
bar(yActualDeaths)
xlabel('Daily Deaths')
title('Empirical Distribution')

% Fit an existing parametric probability distribution to data

distributions = {'Normal'; 'Exponential'; 'Rayleigh'; 'Logistic'; 'Poisson'};

pValuesCases = zeros(length(distributions),1);
pValuesDeaths = zeros(length(distributions),1);
mseCases = zeros(length(distributions),1);
mseDeaths = zeros(length(distributions),1);
for i = 1:numel(distributions)
   
        % Apply probability distributions to cases

        probdistribCases = fitdist(cases,distributions{i});
        [~,pValuesCases(i)] = chi2gof(cases,'CDF',probdistribCases);
        PredictedCases = pdf(probdistribCases,xActualCases);
        
        figure;
        histogram(cases,lengthC,'Normalization','probability')
        hold on
        plot(xActualCases,PredictedCases);
        title(distributions(i) + " Distribution - Cases");
        xlabel('Daily Cases')
        ylabel('Probability')
       
        mseCases(i) = 1/((maxC+1)-1)*sum((yActualCases-PredictedCases').^2);
        
        % Apply probability distributions to deaths
        
        probDistribDeaths = fitdist(deaths,distributions{i});
        [~,pValuesDeaths(i)] = chi2gof(deaths,'CDF',probDistribDeaths);
        PredictedDeaths = pdf(probDistribDeaths,xActualDeaths);
        
        figure;
        histogram(deaths,lengthD,'Normalization','probability')
        hold on
        plot(xActualDeaths,PredictedDeaths);
        title(distributions(i) + " Distribution - Deaths");
        xlabel('Daily Deaths')
        ylabel('Probability')

        mseDeaths(i) = 1/((maxD+1)-1)*sum((yActualDeaths-PredictedDeaths').^2); 
        
end

% Find best fit using pValue and MSE for cases

[~,indexBestPcases] = max(pValuesCases);
bestFitCasesP = distributions{indexBestPcases};

[~,indexBestMSEcases] = min(mseCases);
bestFitCasesMSE = distributions{indexBestMSEcases};

% Check for different results from pValue method and MSE method 

if indexBestPcases ~= indexBestMSEcases
    difP = abs(pValuesCases(indexBestPcases)-pValuesCases(indexBestMSEcases))/max(pValuesCases(indexBestPcases),pValuesCases(indexBestMSEcases));
    difMSE = abs(mseCases(indexBestPcases)-mseCases(indexBestMSEcases))/max(mseCases(indexBestPcases),mseCases(indexBestMSEcases));
    if difP>difMSE
        bestFitCases = distributions(indexBestPcases);
    else
        bestFitCases = distributions(indexBestMSEcases);
    end
end

% Find best fit using pValue and MSE for deaths

[~,indexBestPdeaths] = max(pValuesDeaths);
bestFitDeathsP = distributions{indexBestPdeaths};

[~,indexBestMSEdeaths] = min(mseDeaths);
bestFitDeathsMSE = distributions{indexBestMSEdeaths};

% Check for different results from pValue method and MSE method 

if indexBestPdeaths ~= indexBestMSEdeaths
    difP = abs(pValuesCases(indexBestPdeaths)-pValuesCases(indexBestMSEdeaths))/max(pValuesCases(indexBestPdeaths),pValuesCases(indexBestMSEdeaths));
    difMSE = abs(mseCases(indexBestPdeaths)-mseCases(indexBestMSEdeaths))/max(mseCases(indexBestPdeaths),mseCases(indexBestMSEdeaths));
    if difP>difMSE
        bestFitDeaths = distributions(indexBestPdeaths);
    else
        bestFitDeaths = distributions(indexBestMSEdeaths);
    end
end
