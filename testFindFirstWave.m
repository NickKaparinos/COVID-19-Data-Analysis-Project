% Data Analysis Project
% 2020
close all;
clc;
clear;

% This script is used to find the limit of cases for the first wave

% Dataset Cases
structCases = importdata("Covid19Confirmed.xlsx");
labels = structCases.textdata;
labels(1,:) = [];
population = structCases.data(:,1);
population(1) = [];

% Cases greece
dataCases = structCases.data;
dataCases(:,1) = [];
dataCases(1,:) = [];

casesGreece = dataCases(54,:);
casesGreece(1) = [];
casesGreece(isnan(casesGreece)) = 0;

% Find all european countries
% Save names,cases and populations in arrays
europeCountriesNames = {40};
europeCountriesCases = zeros(40,348);
europePopulation = zeros(40,1);
j = 1;
for i=1:size(dataCases,1)
    if (labels(i,2) == "Europe")
        europeCountriesNames(j) = labels(i,1);
        
        europeCountriesCases(j,:) = dataCases(i,:);
        nan = isnan(europeCountriesCases(j,:));
        europeCountriesCases(j,nan) = 0;
        
        europePopulation(j) = population(i);
        
        j = j+1;
    end
end

selectedCountriesID = [3,5,6,12,13,16,17,19,25,27,40];

% Plot selectec countries 7-day average rolling average of cases
% Also plot the limit of the first wave
for i = 1:size(europeCountriesNames,2)
    if( ismember(i,selectedCountriesID) )
        figure(i)
        plot(1:348,movmean(europeCountriesCases(i,1:end),15) );
        
        totalNumberOfcases = sum(europeCountriesCases(i,1:200));
        
%         limit = (2e-5)*europePopulation(i);
        limit = 0.0025*totalNumberOfcases;
        line([0,348],[limit,limit],'Color','r')
        line([200,200],[0,1500],'Color','r')
        title(europeCountriesNames(i));
    end
end

% PS: love you bitch <3
biggestMagoulaEver = "Vasouli";