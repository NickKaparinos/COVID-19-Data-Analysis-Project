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

% Read cases and deaths data files
[cases,deaths,~] = Group21Exe1Fun3(country);

% Start and end of the first Covid-19 wave
[start1,end1] = Group21Exe1Fun1(cases);
cases = cases(start1:end1)';
deaths = deaths(start1:end1)';

% Find the empirical distribution of cases
lengthCases = length(cases);
maxCases = max(cases);
countCases = zeros(maxCases+1,1);
for j=1:maxCases+1
    countCases(j) = sum(cases == j-1);
end
casesEmpiricalPdf = countCases/lengthCases;
rangeCases = 0:max(cases);


% Find the empirical distribution of deaths
lengthDeaths = length(deaths);
maxDeaths = max(deaths);
countDeaths = zeros(maxDeaths+1,1);
for j=1:maxDeaths+1
    countDeaths(j) = sum(deaths == j-1);
end
deathsEmpiricalPdf = countDeaths/lengthDeaths;
rangeDeaths = 0:max(deaths);

% Fit an existing parametric probability distribution to data
distributions = {'Normal'; 'Exponential'; 'Rayleigh'; 'Logistic'; 'Poisson'};

pValuesCases = zeros(length(distributions),1);
pValuesDeaths = zeros(length(distributions),1);
mseCases = zeros(length(distributions),1);
mseDeaths = zeros(length(distributions),1);
for i = 1:length(distributions)
        % Fit probability distributions to cases
        probDistribCases = fitdist(cases,distributions{i});
        [~,pValuesCases(i)] = chi2gof(cases,'CDF',probDistribCases);
        casesFittedPdf = pdf(probDistribCases,rangeCases);
        
        % Histogram of cases and fitted distribution
        figure;
        histogram(cases,lengthCases,'Normalization','pdf')
        hold on
        plot(rangeCases,casesFittedPdf);
        title(distributions(i) + " Distribution - Cases");
        xlabel('Daily Cases')
        ylabel('Probability')
       
        mseCases(i) = 1/(length(casesEmpiricalPdf)-1)*sum((casesEmpiricalPdf-casesFittedPdf').^2);
        
        % Fit probability distributions to deaths
        probDistribDeaths = fitdist(deaths,distributions{i});
        [~,pValuesDeaths(i)] = chi2gof(deaths,'CDF',probDistribDeaths);
        deathsFittedPdf = pdf(probDistribDeaths,rangeDeaths);
        
        % Histogram of deaths and fitted distribution
        figure;
        histogram(deaths,lengthDeaths,'Normalization','probability')
        hold on
        plot(rangeDeaths,deathsFittedPdf);
        title(distributions(i) + " Distribution - Deaths");
        xlabel('Daily Deaths')
        ylabel('Probability')

        mseDeaths(i) = 1/(length(deathsEmpiricalPdf)-1)*sum((deathsEmpiricalPdf-deathsFittedPdf').^2); 
end

% Find best fit using pValue and MSE for cases
[~,indexBestPcases] = max(pValuesCases);
bestPdistributionCases = distributions{indexBestPcases};

[~,indexBestMSEcases] = min(mseCases);
bestMSEdistributionCases = distributions{indexBestMSEcases};

% Check for different results from pValue metric and MSE metric 
% If the two metrics disagree, the overall result will be determined by the
% metric with the biggest relative difference
if indexBestPcases ~= indexBestMSEcases
    relativeDifP = abs(pValuesCases(indexBestPcases)-pValuesCases(indexBestMSEcases))/max(pValuesCases(indexBestPcases),pValuesCases(indexBestMSEcases));
    relativeDifMSE = abs(mseCases(indexBestPcases)-mseCases(indexBestMSEcases))/max(mseCases(indexBestPcases),mseCases(indexBestMSEcases));
    if relativeDifP > relativeDifMSE
        bestFitCases = distributions(indexBestPcases);
    else
        bestFitCases = distributions(indexBestMSEcases);
    end
else
    bestFitCases = distributions(indexBestPcases);
end

% Find best fit using pValue and MSE for deaths
[~,indexBestPdeaths] = max(pValuesDeaths);
bestPdistributionDeaths = distributions{indexBestPdeaths};

[~,indexBestMSEdeaths] = min(mseDeaths);
bestMSEdistributionDeaths = distributions{indexBestMSEdeaths};

% Check for different results from pValue method and MSE method 
if indexBestPdeaths ~= indexBestMSEdeaths
    relativeDifP = abs(pValuesCases(indexBestPdeaths)-pValuesCases(indexBestMSEdeaths))/max(pValuesCases(indexBestPdeaths),pValuesCases(indexBestMSEdeaths));
    relativeDifMSE = abs(mseCases(indexBestPdeaths)-mseCases(indexBestMSEdeaths))/max(mseCases(indexBestPdeaths),mseCases(indexBestMSEdeaths));
    if relativeDifP>relativeDifMSE
        bestFitDeaths = distributions(indexBestPdeaths);
    else
        bestFitDeaths = distributions(indexBestMSEdeaths);
    end
else
    bestFitDeaths = distributions(indexBestPdeaths);
end

% Display results
fprintf('Best fitted distribution to cases is %s\n',bestFitCases{1});
fprintf('Best fitted distribution to deaths is %s\n',bestFitDeaths{1});

%%%%% Symperasmata - Sxolia %%%%%

% Se auto to zhthma dokimasame 5 katanomes, sygekrimena thn Normal,
% Exponential,Rayleigh,Logistic,Poisson wste na vroume poia katanomi
% prosarmozetai kalytera sta dedomena. Dokimasthkan kai alles katanomes apo
% to documentation ths fitdist, alla parousiasthkan sfalmata epeidh
% yparxoun mhdenikes times krousmatwn kai thanatwn sto deigma. Apofasisame 
% na xrhsimopoihsoume 2 metrikes gia thn axiologhsh ths prosarmoghs twn
% katanomwn, thn p-value kai to MSE. Otan diafwnoun ta apotelesmata twn 2
% metrikwn, dialegoume thn metrikh me thn megalyterh sxetikh diafora.
% Katalhxame oti h katanomh me thn kalyterh prosarmogh kai sta krousmata 
% kai stous thanatous htan h ekthetikh. 
