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

% Read cases and deaths
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
distributions = {'Normal';'Gamma';'HalfNormal';'InverseGaussian';
'Nakagami';'Logistic';'Rician';'Exponential';'Poisson';'Rayleigh'};

mseCases = zeros(length(distributions),1);
mseDeaths = zeros(length(distributions),1);
for i = 1:length(distributions)
        % Fit probability distributions to cases 
        probDistribCases = fitdist(daysCases',distributions{i},'Frequency',cases);
        casesFittedPdf = pdf(probDistribCases,daysCases);

        % Calculate MSE metric for cases
        mseCases(i) = 1/(length(normCases)-1)*sum((normCases-casesFittedPdf').^2);
        
        % Graphic display - cases
        figure;
        bar(daysCases,normCases);
        hold on;
        plot(daysCases,casesFittedPdf);
        title(distributions(i) + " Distribution - Cases");
        xlabel('Days')
        ylabel('Cases')
       
        % Fit probability distributions to deaths
        probDistribDeaths = fitdist(daysDeaths',distributions{i},'Frequency',deaths);
        deathsFittedPdf = pdf(probDistribDeaths,daysDeaths);

        % Calculate MSE metric for deaths
        mseDeaths(i) = 1/(length(normDeaths)-1)*sum((normDeaths-deathsFittedPdf').^2); 

        % Graphic display - deaths
        figure;
        bar(daysDeaths,normDeaths);
        hold on;
        plot(daysDeaths,deathsFittedPdf);
        title(distributions(i) + " Distribution - Deaths");
        xlabel('Days')
        ylabel('Deaths')
       
end

% Find best fit using  MSE for cases and deaths
% In order the distribution to fit well to data, MSE should be close to 0
[~,indexBestMSEcases] = min(mseCases);
[~,indexBestMSEdeaths] = min(mseDeaths);

bestFitCases = distributions(indexBestMSEcases);
bestFitDeaths = distributions(indexBestMSEdeaths);

% Display results
fprintf('Best fitted distribution to daily cases of first wave is: %s Distribution\n',bestFitCases{1});
fprintf('Best fitted distribution to daily deaths of first wave is: %s Distribution\n',bestFitDeaths{1});

%%%%% Symperasmata - Sxolia %%%%%

% Se auto to zhthma dokimasame 10 katanomes wste na vroume poia katanomi
% prosarmozetai kalytera sta dedomena. Dokimasthkan kai alles katanomes apo
% to documentation ths fitdist, alla parousiasthkan kapoia sfalmata (epeidh
% yparxoun mhdenikes times krousmatwn kai thanatwn sto deigma). Arxika 
% eixame apofasisei na xrhsimopoihsoume 2 metrikes gia thn axiologhsh ths 
% prosarmoghs twn katanomwn, thn p-value kai to MSE. Omws eidame oti to 
% p-value epairne para poly mikres times, enw emeis kata protimhsh tha 
% thelame na htan konta sth monada. Opote telika krinoume gia th prosarmogh
% me vash mono to MSE. 
% Katalhxame oti h katanomh me thn kalyterh prosarmogh kai sta krousmata 
% kai stous thanatous htan h Gamma. Auto epivevaiwnetai ki apo ta
% graphimata kathws fainetai na perigrafei arketa kala th poreia tou prwtou
% kymatos.