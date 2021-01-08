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

xCases = 1:length(cases);
xDeaths = 1:length(deaths);

dist = fitdist(xCases','Nakagami','Frequency',cases);

% Plot cases and deaths
figure(100);
bar(xCases,cases./sum(cases));
title('Cases');
hold on;
%plot(xCases,pdf('Nakagami',xCases,dist.ParameterValues(:)) )

args = dist.ParameterValues;
args2 = num2cell(args);
plot(xCases,pdf('Nakagami',xCases,args2{:}) );
plot(xCases,pdf(dist,xCases) );
legend("fet","sfet","kasa")
