% Data Analysis Project 2020-2021
% Nikos Kaparinos 9245
% Vasiliki Zarkadoula 9103
% Exercise 4: Pearson correlation coefficient
close all;
clc;
clear;

% Selected Countries
countryList = ["Greece","Belgium","Italy","France","Germany",...
    "Netherlands","United_Kingdom"];
            
R = zeros(41,1);  
maxR = zeros(length(countryList),1);
timeLag = zeros(length(countryList),1);
for i = 1:length(countryList)
    % Read cases and deaths from data files
    [cases,deaths,~] = Group21Exe1Fun3(countryList(i));
    countryList(i) = strrep(countryList(i),"_"," ");
    
    % Find the start and end of the first wave using Group21Exe1Fun1
    [start1,end1] = Group21Exe1Fun1(cases);
    cases = cases(start1:end1)';
    deaths = deaths(start1:end1)';
    n = length(cases);
    
    % Calculate 7-day moving averages
    casesMovingAverage = movmean(cases,7);
    deathsMovingAverage = movmean(deaths,7);
    
    % Find max correlation coefficient of cases and deaths for different 
    % time lags t
    for t = -20:-1
        X = cases(1-t:n);
        Y = deaths(1:n+t);
        corrCoef = corrcoef(X,Y);
        R(t+21) = corrCoef(1,2);
    end
    for t = 0:20
        X = cases(1:n-t);
        Y = deaths(1+t:n);
        corrCoef = corrcoef(X,Y);
        R(t+21) = corrCoef(1,2);
    end
    
    % Sort correlations coefficients and indices
    [sortedR, sortedIndex] = sort(R,'descend');
    maxR(i) = sortedR(1);
    timeLag(i) = sortedIndex(1) - 21;
    
    % plot 7-day moving average of cases and deaths and observe if there
    % is graphically a time lag between cases and deaths
    % check if these observations agree with the timeLag computed above
    figure(i)
    plot(1:length(casesMovingAverage),casesMovingAverage);
    hold on
    plot(1:length(deathsMovingAverage),deathsMovingAverage*8,'r');
    xlabel('Days of first wave');
    ylabel('Daily Cases (blue) - Daily Deaths (red)')
    title('7-day moving average of cases and deaths of ' + countryList(i));
    annotation('textbox',[.63 .8 .2 .08],'String',['time lag = ' num2str(timeLag(i))],'BackgroundColor','white')
    hold off
end

% Time interval results from exercise 3
timeIntervalResultsEx3 =  [-17,-2,6,3,19,-3,-2];
mvavgTimeIntervalResultsEx3 = [3,0,7,4,13,-2,1];
 
% Display results
tablesofResults = table([maxR(1);timeLag(1);timeIntervalResultsEx3(1);mvavgTimeIntervalResultsEx3(1)],...
[maxR(2);timeLag(2);timeIntervalResultsEx3(2);mvavgTimeIntervalResultsEx3(2)],...
[maxR(3);timeLag(3);timeIntervalResultsEx3(3);mvavgTimeIntervalResultsEx3(3)],...
[maxR(4);timeLag(4);timeIntervalResultsEx3(4);mvavgTimeIntervalResultsEx3(4)],...
[maxR(5);timeLag(5);timeIntervalResultsEx3(5);mvavgTimeIntervalResultsEx3(5)],...
[maxR(6);timeLag(6);timeIntervalResultsEx3(6);mvavgTimeIntervalResultsEx3(6)],...
[maxR(7);timeLag(7);timeIntervalResultsEx3(7);mvavgTimeIntervalResultsEx3(7)],...
'VariableNames',{'Greece','Belgium','Italy','France','Germany',...
'Netherlands','United_Kingdom'},'RowName',{'Max correlation coefficient',...
'Time lag','Ex3 time delays','Ex3 moving avg time delays'});
disp(tablesofResults);

%%%%% Symperasmata - Sxolia %%%%%

% Apo to pinakaki pou ektypwnoume parapanw eimaste se thesh na sygrinoume
% tis xronikes ysterhseis twn thanatwn se sxesh me ta krousmatwn pou 
% proekypsan parapanw me auta apo to zhthma 3. Parathroume oti oi xronikes
% ysterhseis pou exoun th megisth sysxetish symvathisoum me th diafora twn
% koryfesewn pou vrhkame sto zhthma 3 (me exairesh thn Ellada). Epishs
% fainetai ta apotelesmata na symvadizoun perissotero me auta tou moving
% average time delays.
