% Data Analysis Project
% 2020
close all;
clc;
clear;

% This script plots the cases for all the europian countries

% Dataset Cases
casesTable = readtable('Covid19Confirmed.xlsx','basic',true);
labels = table2cell(casesTable(:,1:2));
population = table2array(casesTable(:,3));

casesTable(:,1:3) = [];
dataCases = table2array(casesTable);

% Cases greece
casesGreece = dataCases(54,:);
casesGreece(isnan(casesGreece)) = 0;

% Plot Greece cases and 7-day moving average
figure(100)
plot(1:length(casesGreece),casesGreece);
hold on;
plot(1:length(casesGreece),movmean(casesGreece,7));

% Find all european countries
% Save names and cases in arrays
europeCountriesNames = {40};
europeCountriesCases = zeros(40,348);
j = 1;
for i=1:size(dataCases,1)
    if (labels(i,2) == "Europe")
        europeCountriesNames(j) = labels(i,1);
        
        europeCountriesCases(j,:) = dataCases(i,:);
        nan = isnan(europeCountriesCases(j,:));
        europeCountriesCases(j,nan) = 0;
        
        j = j+1;
    end
end

% Plot europian countries cases
for i = 1:size(europeCountriesNames,2)
    figure(i)
    plot(1:size(europeCountriesCases,2),europeCountriesCases(i,:));
    title(europeCountriesNames(i));
end