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
    % Read cases and deaths 
    [cases,deaths,~] = Group21Exe1Fun3(countryList(i));
    countryList(i) = strrep(countryList(i),"_"," ");
    
    % Find the start and end of the first wave using Group21Exe1Fun1
    [start1,end1] = Group21Exe1Fun1(cases);
    cases = cases(start1:end1)';
    deaths = deaths(start1:end1)';
    n = length(cases);
    
    % Calculate 3-day moving averages
    casesMovingAverage = movmean(cases,3);
    deathsMovingAverage = movmean(deaths,3);
    
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
    
    % plot 3-day moving average of cases and deaths and observe if there
    % is graphically a time lag between cases and deaths
    % check if these observations agree with the timeLag computed above
    % moving averages were used in order to make the time delay more
    % noticable (smoother curves)
    scalingCoef = max(casesMovingAverage)/max(deathsMovingAverage);
    figure(i)
    plot(1:length(casesMovingAverage),casesMovingAverage);
    hold on
    plot(1:length(deathsMovingAverage),deathsMovingAverage*scalingCoef,'r');
    xlabel('Days of first wave');
    ylabel('Daily Cases - Daily Deaths')
    legend('Cases','Deaths')
    title('3-day moving average of cases and deaths of ' + countryList(i));
    annotation('textbox',[.69 .73 .2 .08],'String',['time lag = ' num2str(timeLag(i))],'BackgroundColor','white')
    hold off
end

% Time interval results from exercise 3
timeIntervalResultsEx3 =  [-17,-2,6,3,19,-3,-2];

% Display results
tablesofResults = table([maxR(1);timeLag(1);timeIntervalResultsEx3(1)],...
[maxR(2);timeLag(2);timeIntervalResultsEx3(2)],...
[maxR(3);timeLag(3);timeIntervalResultsEx3(3)],...
[maxR(4);timeLag(4);timeIntervalResultsEx3(4)],...
[maxR(5);timeLag(5);timeIntervalResultsEx3(5)],...
[maxR(6);timeLag(6);timeIntervalResultsEx3(6)],...
[maxR(7);timeLag(7);timeIntervalResultsEx3(7)],...
'VariableNames',{'Greece','Belgium','Italy','France','Germany',...
'Netherlands','United_Kingdom'},'RowName',{'Max correlation coefficient',...
'Time lag','Ex3 time delays'});
disp(tablesofResults);

%%%%% Symperasmata - Sxolia %%%%%

% Parathrwdas ta parapanw diagrammata symperainoume oti yparxei mia xroniki
% ysterhsh metaxy thanatwn kai krousmatwn kai stis perissoteres periptwseis
% auth synadei me thn ysterhsh pou megistopoiei ton sydelesth sysxetishs.

% Epishs apo ton pinaka pou ektypwnoume eimaste se thesh na sygrinoume
% tis xronikes ysterhseis apo to zhthma 3 me tis xronikes ysterhseis pou
% megistopoioun ton syntelesth sysxethshs. Parathroume oti oi xronikes
% ysterhseis pou exoun th megisth sysxetish symvathizoun me th diafora twn
% koryfesewn pou vrhkame sto zhthma 3 (me exairesh thn Ellada). 
