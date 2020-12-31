% Data Analysis Project
% 2020
close all;
clc;
clear;

% Dataset Cases
datasetCases = importdata("Covid19Confirmed.xlsx");
population = datasetCases.data(:,1);
population(1) = [];

% Cases greece
dataCases = datasetCases.data;
casesGreece = dataCases(55,:);
casesGreece(1) = [];
casesGreece(isnan(casesGreece)) = 0;

% figure(1)
% plot(1:length(casesGreece),casesGreece);
% hold on;

% ma = movmean(casesGreece,7);
% plot(1:length(casesGreece),ma);

europeCountriesNames = {};
europeCountriesCases = zeros(40,349);
j = 1;
% Choose countries
for i=1:size(dataCases,1)
    if (datasetCases.textdata(i,2) == "Europe")
        %disp(datasetCases.textdata(i,1))
        kasa = datasetCases.textdata(i,1);
        europeCountriesNames(j,:) = datasetCases.textdata(i,1);
        europeCountriesCases(j,:) = dataCases(i,:);
        nan = isnan(europeCountriesCases(j,:));
        europeCountriesCases(j,nan) = 0;
        j = j+1;
    end
end

europeCountriesCases(:,1) = [];

for i = 1:size(europeCountriesNames,1)
    figure(i)
    plot(1:size(europeCountriesCases,2),europeCountriesCases(i,:))
    title(europeCountriesNames(i))
end

sfet = find(europeCountriesCases(20,:) < 0);

