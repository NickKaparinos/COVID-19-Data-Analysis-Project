% Data Analysis Project 2020-2021
% Vasiliki Zarkadoula 9103
% Nikos Kaparinos 9245
% This script is used as a demonstration of the start and end of the
% covid-19 first and second wave.
close all;
clc;
clear;

countryList = ["Greece","Italy","Belgium","Germany","Netherlands","United_Kingdom","France"];

for i = countryList
    % Read cases and deaths
    [cases,deaths,~] = Group21Exe1Fun3(i);
    
    % Find the start and end of the first wave using Group21Exe1Fun1
    [start1,end1] = Group21Exe1Fun1(cases);
    
    % Find the start and end of the second wave using Group21Exe1Fun2
    [start2,end2] = Group21Exe1Fun2(cases);

    % The first wave`s  boundaries are the red lines
    % The second wave`s boundaries are the blue lines
    
    % Plot Cases
    figure;
    plot(1:length(cases),cases);
    line([start1,start1],ylim,'Color','r');
    line([end1,end1],ylim,'Color','r');
    line([start2,start2],ylim,'Color','b');
    line([end2,end2],ylim,'Color','b');
    title(i+' cases')
    xlabel('Days')
    ylabel('Cases')
    
    % Plot Deaths
    figure;
    plot(1:length(cases),deaths);
    line([start1,start1],ylim,'Color','r');
    line([end1,end1],ylim,'Color','r');
    line([start2,start2],ylim,'Color','b');
    line([end2,end2],ylim,'Color','b');
    title(i + ' deaths');
    xlabel('Days')
    ylabel('Deaths')
end