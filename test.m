% Test Project
close all;
clc;
clear;

countries = ["Estonia","Greece","Italy","Ireland"];
%countries = "Italy";
j = 1;
for i = countries
    [cases,deaths,population] = Group42Exe1Fun3(i);

    % Plot Greece cases and 7-day moving average
    figure(j)
    plot(1:length(cases),movmean(cases,7));

    [s1,e1] = Group42Exe1Fun1(cases);
    [s2,e2] = Group42Exe1Fun2(cases);
    line([s1,s1],ylim,'Color','m');
    line([e1,e1],ylim,'Color','m');
    line([s2,s2],ylim,'Color','c');
    line([e2,e2],ylim,'Color','c');
    title(i);
    j = j + 1;
end