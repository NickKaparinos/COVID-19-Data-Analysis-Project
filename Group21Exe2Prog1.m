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
distribution = 'Exponential';

pValuesCases = zeros(length(countryList),1);
pValuesDeaths = zeros(length(countryList),1);
hCases = zeros(length(countryList),1);
hDeaths = zeros(length(countryList),1);
fitDeaths = string.empty;
fitCases = string.empty;
counterCases = 0;
counterDeaths = 0;
for i = 1:length(countryList)
    % Read cases and deaths from data files
    [cases,deaths,~] = Group21Exe1Fun3(countryList(i));
    countryList(i) = strrep(countryList(i),"_"," "); 
    
    % Find the start and end of the first wave using Group21Exe1Fun1
    [start1,end1] = Group21Exe1Fun1(cases);
    cases = cases(start1:end1)';
    deaths = deaths(start1:end1)';
    
    rangeCases = 0:max(cases);
    rangeDeaths = 0:max(deaths);
    
    % Fit exponential distribution to cases and check goodness-of-fit
    % Find the number of countries in which the distribution fits well to
    % their cases
    probDistribCases = fitdist(cases,distribution);
    casesFittedPdf = pdf(probDistribCases,rangeCases);
    [hCases(i),pValuesCases(i)] = chi2gof(cases,'CDF',probDistribCases);
    if hCases(i) == 1
        fitCases{i} = 'No';
    else
        counterCases = counterCases +1;
        fitCases{i} = 'Yes';
    end
    
    % Fit exponential distribution to deaths and check goodness-of-fit
    % Find the number of countries in which the distribution fits well to
    % their deaths
    probDistribDeaths = fitdist(deaths,distribution);
    predictedDeaths = pdf(probDistribDeaths,rangeDeaths);
    [hDeaths(i),pValuesDeaths(i)] = chi2gof(deaths,'CDF',probDistribDeaths);
    if hDeaths(i) == 1
        fitDeaths{i} = 'No';
    else
        counterDeaths = counterDeaths + 1;
        fitDeaths{i} = 'Yes';
    end
    
    % Graphic display
    % Plot a histogram with Normalization set to 'pdf' to produce an 
    % estimation of the probability density function and plot the fitted 
    % pdf
    figure(i);
    histogram(cases,length(cases),'Normalization','pdf')
    hold on
    plot(rangeCases,casesFittedPdf);
    title(countryList(i) + " - Exponential Distribution - Cases ");
    xlabel('Daily Cases')
    ylabel('Probability')
    
    figure(i+100);
    histogram(deaths,length(deaths),'Normalization','pdf')
    hold on
    plot(rangeDeaths,predictedDeaths);
    title(countryList(i) + " - Exponential Distribution - probability ");
    xlabel('Daily Deaths')
    ylabel('Probability')
    
end

% Sort countries based on the good fit of the parametric distribution to 
% each country data
[pValuesCases,sortedPcasesIndex] = sort(pValuesCases,'descend');
hCases = hCases(sortedPcasesIndex);
countryListCases = countryList(sortedPcasesIndex);
fitCases = fitCases(sortedPcasesIndex);

[pValuesDeaths,sortedPdeathsIndex] = sort(pValuesDeaths,'descend');
hCases = hCases(sortedPdeathsIndex);
countryListDeaths = countryList(sortedPdeathsIndex);
fitDeaths = fitDeaths(sortedPdeathsIndex);

% Display results to command window
% cases
fprintf('Results for cases:\n');
tablesofResults = table([pValuesCases(1);hCases(1);fitCases(1)],...
[pValuesCases(2);hCases(2);fitCases(2)],[pValuesCases(3);hCases(3);fitCases(3)],...
[pValuesCases(4);hCases(4);fitCases(4)],[pValuesCases(5);hCases(5);fitCases(5)],...
[pValuesCases(6);hCases(6);fitCases(6)],[pValuesCases(7);hCases(7);fitCases(7)],...
[pValuesCases(8);hCases(8);fitCases(8)],[pValuesCases(9);hCases(9);fitCases(9)],...
[pValuesCases(10);hCases(10);fitCases(10)],'VariableNames',...
{'Ireland','Austria','France','Belgium','Germany','Italy','Netherlands',...
'Finland','Hungary','United_Kingdom'},'RowName',{'p-value','h','distribution fits'});
disp(tablesofResults);

% deaths
fprintf('Results for deaths:\n');
tablesofResults = table(...
[pValuesDeaths(1);hDeaths(1);fitDeaths(1)],[pValuesDeaths(2);hDeaths(2);fitDeaths(2)],...
[pValuesDeaths(3);hDeaths(3);fitDeaths(3)],[pValuesDeaths(4);hDeaths(4);fitDeaths(4)],...
[pValuesDeaths(5);hDeaths(5);fitDeaths(5)],[pValuesDeaths(6);hDeaths(6);fitDeaths(6)],...
[pValuesDeaths(7);hDeaths(7);fitDeaths(7)],[pValuesDeaths(8);hDeaths(8);fitDeaths(8)],...
[pValuesDeaths(9);hDeaths(9);fitDeaths(10)],[pValuesDeaths(10);hDeaths(10);fitDeaths(10)],...
'VariableNames',{'Finland','France','Belgium','Germany','United_Kingdom','Austria','Netherlands',...
'Italy','Ireland','Hungary'},'RowName',{'p-value','h','distribution fits'});
disp(tablesofResults);

fprintf('\nExponential Distrubition for cases fits to %0.2f%% of the countries\n',(counterCases/length(countryList))*100);
fprintf('Exponential Distrubition for deaths fits to %0.2f%% of the countries\n',(counterDeaths/length(countryList))*100);

%%%%% Symperasmata - Sxolia %%%%%

% Se auto to zhthma prosarmosame thn veltisth katanomh poy vrethike sto
% zhthma 1 se alles 10 europaikes xwres. Oson afora ta krousmata, gia to
% 80% twn xwrwn den aporriptoume oti proerxontai apo ekthetikh katanomh.
% Parola auta mono stis 3 apo tis 10 xwres h katanomh fainetai na
% prosarmozetai poly kala (p>0.4). Oson afora tous thanatous, gia to
% 60% twn xwrwn den aporriptoume oti proerxontai apo ekthetikh katanomh,
% alla vlepoume oti 4 apo tis 10 xwres prosarmozontai poly kala (p>0.4).

