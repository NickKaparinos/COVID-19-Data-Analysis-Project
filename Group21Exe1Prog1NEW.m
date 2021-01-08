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

% Read cases and deaths from data files
[cases,deaths,~] = Group21Exe1Fun3(country);
% Start and end of the first Covid-19 wave
[start1,end1] = Group21Exe1Fun1(cases);
cases = cases(start1:end1)';
deaths = deaths(start1:end1)';

% Days of first wave
daysCases = 1:length(cases);
daysDeaths = 1:length(deaths);

% Normalized cases and deaths
normCases = cases./sum(cases);
normDeaths = deaths./sum(deaths);

% Fit an existing parametric probability distribution to days of data
distributions1param = {'Exponential';'Poisson';'Rayleigh'};
distributions2param = {'Normal';'Gamma';'HalfNormal';...
'InverseGaussian';'Nakagami';'Logistic';'Rician'};

pValuesCases = zeros(length(distributions2param)+length(distributions1param),1);
pValuesDeaths = zeros(length(distributions2param)+length(distributions1param),1);
mseCases = zeros(length(distributions2param)+length(distributions1param),1);
mseDeaths = zeros(length(distributions2param)+length(distributions1param),1);
for i = 1:length(distributions2param)
        % Fit probability distributions to cases 
        % calculate the p-value metric
        probDistribCases = fitdist(daysCases',distributions2param{i},'Frequency',cases);
        casesFittedPdf = pdf(probDistribCases,daysCases);
        [~,pValuesCases(i)] = chi2gof(daysCases,'CDF',probDistribCases);

        % calculate MSE metric for cases
        mseCases(i) = 1/(length(normCases)-1)*sum((normCases-casesFittedPdf').^2);
        
        % Graphic display - cases
        figure;
        bar(daysCases,normCases);
        hold on;
        plot(daysCases,casesFittedPdf);
        title(distributions2param(i) + " Distribution - Cases");
        xlabel('Daily Cases')
        ylabel('Probability')
       
        % Fit probability distributions to deaths
        % calculate the p-value metric
        probDistribDeaths = fitdist(daysDeaths',distributions2param{i},'Frequency',deaths);
        deathsFittedPdf = pdf(probDistribDeaths,daysDeaths);
        [~,pValuesDeaths(i)] = chi2gof(daysDeaths,'CDF',probDistribDeaths);
        
        % calculate MSE metric for deaths
        mseDeaths(i) = 1/(length(normDeaths)-1)*sum((normDeaths-deathsFittedPdf').^2); 

        % Graphic display - cases
        figure;
        bar(daysDeaths,normDeaths);
        hold on;
        plot(daysDeaths,deathsFittedPdf);
        title(distributions2param(i) + " Distribution - Deaths");
        xlabel('Daily Deaths')
        ylabel('Probability')

end

for i = 1:length(distributions1param)
        % Fit probability distributions to cases 
        % calculate the p-value metric
        probDistribCases = fitdist(daysCases',distributions1param{i},'Frequency',cases);
        casesFittedPdf = pdf(probDistribCases,daysCases);
        [~,pValuesCases(i+length(distributions2param))] = chi2gof(daysCases,'CDF',probDistribCases);

        % calculate MSE metric for cases
        mseCases(i+length(distributions2param)) = 1/(length(normCases)-1)*sum((normCases-casesFittedPdf').^2);
        
        % Graphic display - cases
        figure;
        bar(daysCases,normCases);
        hold on;
        plot(daysCases,casesFittedPdf);
        title(distributions1param(i) + " Distribution - Cases");
        xlabel('Daily Cases')
        ylabel('Probability')
       
        % Fit probability distributions to deaths
        % calculate the p-value metric
        probDistribDeaths = fitdist(daysDeaths',distributions1param{i},'Frequency',deaths);
        deathsFittedPdf = pdf(probDistribDeaths,daysDeaths);
        [~,pValuesDeaths(i+length(distributions2param))] = chi2gof(daysDeaths,'CDF',probDistribDeaths);
        
        % calculate MSE metric for deaths
        mseDeaths(i+length(distributions2param)) = 1/(length(normDeaths)-1)*sum((normDeaths-deathsFittedPdf').^2); 

        % Graphic display - cases
        figure;
        bar(daysDeaths,normDeaths);
        hold on;
        plot(daysDeaths,deathsFittedPdf);
        title(distributions1param(i) + " Distribution - Deaths");
        xlabel('Daily Deaths')
        ylabel('Probability')

end

% Find best fit using  MSE for cases and deaths
% In order the distribution to fit well to data, MSE should be close to 0
[~,indexBestMSEcases] = min(mseCases);
[~,indexBestMSEdeaths] = min(mseDeaths);

if le(indexBestMSEcases,length(distributions2param))
    bestFitCases = distributions2param(indexBestMSEcases);
else
    bestFitCases = distributions1param(indexBestMSEcases-length(distributions2param));
end

if le(indexBestMSEdeaths,length(distributions2param))
    bestFitDeaths = distributions2param(indexBestMSEdeaths);
else
    bestFitDeaths = distributions1param(indexBestMSEdeaths-length(distributions2param));
end
% Display results
fprintf('Best fitted distribution to cases is %s\n',bestFitCases{1});
fprintf('Best fitted distribution to deaths is %s\n',bestFitDeaths{1});

%%%%% Symperasmata - Sxolia %%%%%

% Se auto to zhthma dokimasame 5 katanomes, sygekrimena thn Normal,
% Exponential,Rayleigh,Logistic kai Poisson wste na vroume poia katanomi
% prosarmozetai kalytera sta dedomena. Dokimasthkan kai alles katanomes apo
% to documentation ths fitdist, alla parousiasthkan sfalmata epeidh
% yparxoun mhdenikes times krousmatwn kai thanatwn sto deigma. Apofasisame 
% na xrhsimopoihsoume 2 metrikes gia thn axiologhsh ths prosarmoghs twn
% katanomwn, thn p-value kai to MSE. Otan diafwnoun ta apotelesmata twn 2
% metrikwn, dialegoume thn metrikh me thn megalyterh sxetikh diafora.
% Katalhxame oti h katanomh me thn kalyterh prosarmogh kai sta krousmata 
% kai stous thanatous htan h ekthetikh. 