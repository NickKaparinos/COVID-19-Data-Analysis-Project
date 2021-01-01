% Data Analysis Project
% 2020
close all;
clc;
clear;

% This script is used to find the limit of cases for the first wave

% Dataset Cases
casesTable = readtable('Covid19Confirmed.xlsx','basic',true);
labels = table2cell(casesTable(:,1:2));
population = table2array(casesTable(:,3));

casesTable(:,1:3) = [];
dataCases = table2array(casesTable);

deathsTable = readtable('Covid19Deaths.xlsx','basic',true);
deathsTable(:,1:3) = [];
dataDeaths = table2array(deathsTable);


% Cases greece
casesGreece = dataCases(54,:);
casesGreece(isnan(casesGreece)) = 0;

% Find all european countries
% Save names,cases and populations in arrays
europeCountriesNames = {40};
europeCountriesCases = zeros(40,348);
europeCountriesDeaths = zeros(40,348);
europePopulation = zeros(40,1);
j = 1;
for i=1:size(dataCases,1)
    if (labels(i,2) == "Europe")
        europeCountriesNames(j) = labels(i,1);
        
        europeCountriesCases(j,:) = dataCases(i,:);
        nan = isnan(europeCountriesCases(j,:));
        europeCountriesCases(j,nan) = 0;
        
        europeCountriesDeaths(j,:) = dataDeaths(i,:);
        nan = isnan(europeCountriesDeaths(j,:));
        europeCountriesDeaths(j,nan) = 0;
        
        europePopulation(j) = population(i);
        
        j = j+1;
    end
end

selectedCountriesID = [3,6,12,13,16,17,19,20,25,27,40];

% Fix negative values
for i = selectedCountriesID
    negativeCases = find(europeCountriesCases(i,:) < 0);
    negativeDeaths = find(europeCountriesDeaths(i,:) < 0);
    
    if(~isempty(negativeCases))
        for j = negativeCases
            avg = sum( europeCountriesCases(i,j-1:j+1) ) / 3;
            europeCountriesCases(i,j-1:j+1) = avg;
        end
    end
    
    if(~isempty(negativeDeaths))
        for j = negativeDeaths
            avg = sum( europeCountriesDeaths(i,j-1:j+1) ) / 3;
            europeCountriesDeaths(i,j-1:j+1) = avg;
        end
    end
end

% Plot selectec countries 7-day average rolling average of cases
% Also plot the limit of the first wave
for i = 1:size(europeCountriesNames,2)
    if( ismember(i,selectedCountriesID) )
        figure(i)
        plot(1:348,movmean(europeCountriesCases(i,1:end),7));
        
        totalNumberOfCases = sum(europeCountriesCases(i,1:200));
        totalNumberOfDeaths = sum(europeCountriesDeaths(i,1:200));
        
        limit = 0.0025*totalNumberOfCases;
        line(xlim,[limit,limit],'Color','r')
        line([200,200],ylim,'Color','r')
        title(europeCountriesNames(i) + " Cases");
        
        
        
        figure(100+i)
        plot(1:348,movmean(europeCountriesDeaths(i,1:end),7));
        limit = 0.0015*totalNumberOfDeaths;
        line(xlim,[limit,limit],'Color','r')
        line([200,200],ylim,'Color','r')
        title(europeCountriesNames(i) + " Deaths");

    end
end

italyCases = find(europeCountriesCases(20,:) < 0);
italyDeaths = find(europeCountriesDeaths(20,:) < 0);
irelandDeaths = find(europeCountriesDeaths(19,:) < 0);