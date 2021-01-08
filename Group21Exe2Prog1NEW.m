% Data Analysis Project 2020-2021
% Nikos Kaparinos 9245
% Vasiliki Zarkadoula 9103
% Exercise 2: Fit distribitions found in excersise 1 to 10 countries and
% check goodness-of-fit.
close all;
clc;
clear;

% Selected Countries
countryList = ["Austria","Belgium","Italy","France","Germany","Hungary",...
"Ireland","Finland","Netherlands","United_Kingdom"];

% Distribution chosen from excercise 1
distribution = 'Gamma';

mseCases = zeros(length(countryList),1);
mseDeaths = zeros(length(countryList),1);
for i = 1:length(countryList)
    % Read cases and deaths from data files
    [cases,deaths,~] = Group21Exe1Fun3(countryList(i));
    countryList(i) = strrep(countryList(i),"_"," "); 
    
    % Find the start and end of the first wave using Group21Exe1Fun1
    [start1,end1] = Group21Exe1Fun1(cases);
    cases = cases(start1:end1)';
    deaths = deaths(start1:end1)';
    
    % Days of first wave
    daysCases = 1:length(cases);
    daysDeaths = 1:length(deaths);
    
    % Normalized cases and deaths
    normCases = cases./sum(cases);
    normDeaths = deaths./sum(deaths);
    
    % Fit exponential distribution to cases and check goodness-of-fit
    probDistribCases = fitdist(daysCases',distribution,'Frequency',cases);
    casesFittedPdf = pdf(probDistribCases,daysCases);
    
    % Calculate MSE metric for cases
    mseCases(i) = 1/(length(normCases)-1)*sum((normCases-casesFittedPdf').^2);
    
    % Fit exponential distribution to deaths and check goodness-of-fit
    probDistribDeaths = fitdist(daysDeaths',distribution,'Frequency',deaths);
    deathsFittedPdf = pdf(probDistribDeaths,daysDeaths);
    
    % Calculate MSE metric for deaths
    mseDeaths(i) = 1/(length(normDeaths)-1)*sum((normDeaths-deathsFittedPdf').^2);
    
    % Graphic display
    figure(i);
    bar(daysCases,normCases);
    hold on;
    plot(daysCases,casesFittedPdf);
    title(countryList(i) + " - Gamma Distribution - Cases");
    xlabel('Days')
    ylabel('Normalized Cases')
    
    figure(i+100);
    bar(daysDeaths,normDeaths);
    hold on;
    plot(daysDeaths,deathsFittedPdf);
    title(countryList(i) + " - Gamma Distribution - Deaths");
    xlabel('Days')
    ylabel('Normalized Deaths')
    
end
% Sort countries based on the good fit (min MSE) of the parametric 
% distribution to each country data
[sortedMSEcases, sortedMSEcasesIndex] = sort(mseCases);
countryListCases = countryList(sortedMSEcasesIndex);

[sortedMSEdeaths, sortedMSEdeahsIndex] = sort(mseDeaths);
countryListDeaths = countryList(sortedMSEdeahsIndex);

% Display results to command window
fprintf('Sorted countries according to best MSEs and their MSE value for cases: \n\n');
tablesofResults = table(sortedMSEcases(1)',sortedMSEcases(2),...
sortedMSEcases(3)',sortedMSEcases(4)',sortedMSEcases(5)',sortedMSEcases(6)',...
sortedMSEcases(7)',sortedMSEcases(8)',sortedMSEcases(9)',sortedMSEcases(10)',...
'VariableNames',{'United_Kingdom','Italy','Netherlands','Germany','Hungary',...
'Belgium','Finland','France','Ireland','Austria'},'RowName',{'MSE'});
disp(tablesofResults);

fprintf('\nSorted countries according to best MSEs and their MSE value for deaths: \n\n');
tablesofResults = table(sortedMSEdeaths(1)',sortedMSEdeaths(2),...
sortedMSEdeaths(3)',sortedMSEdeaths(4)',sortedMSEdeaths(5)',sortedMSEdeaths(6)',...
sortedMSEdeaths(7)',sortedMSEdeaths(8)',sortedMSEdeaths(9)',sortedMSEdeaths(10)',...
'VariableNames',{'Belgium','Italy','United_Kingdom','Netherlands','Germany',...
'Hungary','France','Austria','Finland','Ireland'},'RowName',{'MSE'});
disp(tablesofResults);

%%%%% Symperasmata - Sxolia %%%%%

% Se auto to zhthma prosarmosame thn veltisth katanomh poy vrethike sto
% zhthma 1 se alles 10 europaikes xwres. Genika kai stis alles xwres
% fainetai toso apo ta diagrammata, oso ki apo tis times tou MSE, oti h
% katanamomh Gamma prosarmozetai poly kala sta dedomena, kai eidikotera sta
% kroumsata (mikrotera MSE).

