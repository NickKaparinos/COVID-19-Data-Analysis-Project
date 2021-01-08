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

% Plot cases and deaths
figure;
bar(xCases,cases);
title('Cases')
figure;
bar(xDeaths,deaths);
title('Deaths')

%Exponent
fExp = fit(xCases',cases,'exp1');
casesFit = feval(fExp,xCases);
mseCasesExp = 1/(length(cases)-1)*sum((cases-casesFit).^2);

figure;
bar(xCases,cases);
hold on
plot(fExp,xCases,cases)
hold off

%Gaussian
gaussEqn = 'a*exp(-((x-b)/c)^2)+d';
fGauss = fit(xCases',cases,gaussEqn,'Start', [1 10 25 50] );
casesFit = feval(fGauss,xCases);
mseCasesGauss = 1/(length(cases)-1)*sum((cases-casesFit).^2);

figure;
bar(xCases,cases);
hold on
plot(fGauss,xCases,cases)
title('Gaussian')
hold off

%Logistic
LogisticEqn = '1/(A+B*exp(-C*x))';
fLogis = fit(xCases',cases,LogisticEqn,'Start', [1 10 30] );
casesFit = feval(fLogis,xCases);
mseCasesLogis = 1/(length(cases)-1)*sum((cases-casesFit).^2);

figure;
bar(xCases,cases);
hold on
plot(fLogis,xCases,cases)
title('Logistic');
hold off

%Poisson
PoissEqn = '((a^x)/factorial(round(x)))*e^(-a)*b + c';
fPoiss = fit(xCases',cases,PoissEqn,'Start', [1 5 15 30] );
casesFit = feval(fPoiss,xCases);
mseCasesPois = 1/(length(cases)-1)*sum((cases-casesFit).^2);

figure;
bar(xCases,cases);
hold on
plot(fPoiss,xCases,cases)
title('Poisson')
hold off

% Nakeqn = '((2*m^m)/(gamma(m)*w^m))*x^(2*m-1)*exp(-((m/w)*x^2))';
% fPoiss = fit(xCases',cases,Nakeqn,'Start', [1 40] );
% 

