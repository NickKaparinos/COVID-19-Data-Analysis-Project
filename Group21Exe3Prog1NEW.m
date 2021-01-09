% Data Analysis Project 2020-2021
% Nikos Kaparinos 9245
% Vasiliki Zarkadoula 9103
% Exercise 3: Time interval between peaks and confidence intervals
close all;
clc;
clear;

warning('off','all')

% Selected Countries
countryList = ["Greece","Austria","Belgium","Italy","France","Germany",...
"Hungary","Ireland","Finland","Netherlands","United_Kingdom"];

c = length(countryList);
bestFitCases = cell(c,1);
bestFitDeaths = cell(c,1);
actualMaxCases = zeros(c,1);
actualMaxDeaths = zeros(c,1);
dayofMaxCases = zeros(c,1);
dayofMaxDeaths = zeros(c,1);
estimatedMaxCases = zeros(c,1);
estimatedMaxDeaths = zeros(c,1);
estimatedDayofMaxCases = zeros(c,1);
estimatedDayofMaxDeaths = zeros(c,1);
for i = 1:c
    % Read cases and deaths from data files
    [cases,deaths,~] = Group21Exe1Fun3(countryList(i));
    countryList(i) = strrep(countryList(i),"_"," "); 
    
    % Find the start and end of the first wave using Group21Exe1Fun1
    [start1,end1] = Group21Exe1Fun1(cases);
    cases = cases(start1:end1)';
    deaths = deaths(start1:end1)';
    
    % Days of first wave
    daysCases = 1:length(cases);
    daysDeaths = 1:length(deaths);
    
    % Find the best distribution for each country's cases and deaths
    distributions = {'Normal';'Gamma';'HalfNormal';'InverseGaussian';
    'Nakagami';'Logistic';'Rician';'Exponential';'Poisson';'Rayleigh'};

    bestFitCases{i} = Group21Exe3Fun3(cases,distributions);
    bestFitDeaths{i} = Group21Exe3Fun3(deaths,distributions);
    
    % Find max values of cases and deaths, the day that they occured and an
    % estimation of this max value and day based on the most suitable 
	% probability distribution
    [actualMaxCases(i),dayofMaxCases(i),estimatedMaxCases(i),estimatedDayofMaxCases(i)] = Group21Exe3Fun1(cases,bestFitCases{i});
    [actualMaxDeaths(i),dayofMaxDeaths(i),estimatedMaxDeaths(i),estimatedDayofMaxDeaths(i)] = Group21Exe3Fun1(deaths,bestFitDeaths{i});
   
    % plot cases and peak
    figure(i);
    subplot(2,1,1);
    bar(daysCases,cases);
    hold on
    p1 = plot([dayofMaxCases(i) dayofMaxCases(i)],ylim,'m');
    hold on
    pp1 = plot([estimatedDayofMaxCases(i) estimatedDayofMaxCases(i)],ylim,'c');
    xlabel('Days of first wave');
    ylabel('Daily Cases')
    title(countryList(i));
    legend([p1 pp1],{'Day that max cases occur','Estimated day that max cases occur'})
    hold off
    % plot deaths and peak
    subplot(2,1,2); 
    bar(daysDeaths,deaths);
    hold on
    p2 = plot([dayofMaxDeaths(i) dayofMaxDeaths(i)],ylim,'m');
    hold on
    pp2 = plot([estimatedDayofMaxDeaths(i) estimatedDayofMaxDeaths(i)],ylim,'c');
    xlabel('Days of first wave');
    ylabel('Daily Deaths')
    title(countryList(i));
    legend([p2 pp2],{'Day that max deaths occur','Estimated day that max deaths occur'})
    hold off
end

% Display max cases and deaths of first wave
tablesofResults = table([actualMaxCases(1);estimatedMaxCases(1);],...
[actualMaxCases(2);estimatedMaxCases(2);],[actualMaxCases(3);estimatedMaxCases(3);],...
[actualMaxCases(4);estimatedMaxCases(4);],[actualMaxCases(5);estimatedMaxCases(5);],...
[actualMaxCases(6);estimatedMaxCases(6);],[actualMaxCases(7);estimatedMaxCases(7);],...
[actualMaxCases(8);estimatedMaxCases(8);],[actualMaxCases(9);estimatedMaxCases(9);],...
[actualMaxCases(10);estimatedMaxCases(10);],[actualMaxCases(11);estimatedMaxCases(11);],...
'VariableNames',{'Greece','Austria','Belgium','Italy','France','Germany',...
'Hungary','Ireland','Finland','Netherlands','United_Kingdom'},'RowName',...
{'Max value of cases','Estimated max value of cases'});
disp(tablesofResults);

tablesofResults = table([actualMaxDeaths(1);estimatedMaxDeaths(1);],...
[actualMaxDeaths(2);estimatedMaxDeaths(2);],[actualMaxDeaths(3);estimatedMaxDeaths(3);],...
[actualMaxDeaths(4);estimatedMaxDeaths(4);],[actualMaxDeaths(5);estimatedMaxDeaths(5);],...
[actualMaxDeaths(6);estimatedMaxDeaths(6);],[actualMaxDeaths(7);estimatedMaxDeaths(7);],...
[actualMaxDeaths(8);estimatedMaxDeaths(8);],[actualMaxDeaths(9);estimatedMaxDeaths(9);],...
[actualMaxDeaths(10);estimatedMaxDeaths(10);],[actualMaxDeaths(11);estimatedMaxDeaths(11);],...
'VariableNames',{'Greece','Austria','Belgium','Italy','France','Germany',...
'Hungary','Ireland','Finland','Netherlands','United_Kingdom'},'RowName',...
{'Max value of deaths','Estimated max value of deaths'});
disp(tablesofResults);

% Calculate the time interval between peak of cases and peak of deaths
% Considering that peak of deaths follows peak of cases
t0 = 14;
B = 1000;
alpha = 0.05;

% First approach
timeInterval = dayofMaxDeaths - dayofMaxCases;
timeIntervalEst = estimatedDayofMaxDeaths - estimatedDayofMaxCases;
% Display time intervals 
fprintf('\n\nTime intervals between days of peak of deaths and peak of cases\n\n');
tablesofResults = table([timeInterval(1);timeIntervalEst(1)],...
[timeInterval(2);timeIntervalEst(2)],[timeInterval(3);timeIntervalEst(3)],...
[timeInterval(4);timeIntervalEst(4)],[timeInterval(5);timeIntervalEst(5)],...
[timeInterval(6);timeIntervalEst(6)],[timeInterval(7);timeIntervalEst(7)],...
[timeInterval(8);timeIntervalEst(8)],[timeInterval(9);timeIntervalEst(9)],...
[timeInterval(10);timeIntervalEst(10)],[timeInterval(11);timeIntervalEst(11)],...
'VariableNames',{'Greece','Austria','Belgium','Italy','France','Germany',...
'Hungary','Ireland','Finland','Netherlands','United_Kingdom'},'RowName',...
{'Time Interval','Time Interval Estimation'});
disp(tablesofResults);

fprintf('\n\nHypothesis testing results:\n')
fprintf('First approach:\n')
[meanCI1,bootMeanCI1] = Group21Exe3Fun2(timeInterval,t0,B,alpha);

% Second approach
% if there is an outlier in timeInterval remove it
for i=1:length(timeInterval)
    if timeInterval(i) < -10
        timeInterval(i) = NaN;
    end
end
timeInterval(isnan(timeInterval)) = [];
fprintf('Second approach:\n')
[meanCI2,bootMeanCI2] = Group21Exe3Fun2(timeInterval,t0,B,alpha);

%Same as above but for the estimated days of max cases and deaths

fprintf('\n\nHypothesis testing results:\n')
fprintf('First approach - estimation:\n')
[meanCI11,bootMeanCI11] = Group21Exe3Fun2(timeIntervalEst,t0,B,alpha);

for i=1:length(timeIntervalEst)
    if timeIntervalEst(i) < -10
        timeIntervalEst(i) = NaN;
    end
end
timeIntervalEst(isnan(timeIntervalEst)) = [];
fprintf('Second approach - estimation:\n')
[meanCI22,bootMeanCI22] = Group21Exe3Fun2(timeInterval,t0,B,alpha);


%%%%% Symperasmata - Sxolia %%%%% na allaxthoun!!!!!!!

% Arxika vriskoume apo tis 10 katanomes auth pou prosarmozetai kalytera sta
% dedomena ths kathe xwras. Parathroume oti stis perissoteres periptwseis
% prosarmozetai veltista h gamma katanomh, opws kai sto prwto erwthma.
% Sth synexeia me bash th kalyterh katanomh gia kathe xwra ektimhsame 
% th koryfwsh twn krousmatwn kai twn thanatwn apo th ktanomh kai ta sygriname
% me tis pragmatikes koryfwseis. Parathroume oti exoun arketa megalh
% apoklish oi ektimhseis apo tis pragmatikes.

% Epishs vrhkame kai kaname mia ektimhsh twn hmerwn stis opoies exoume 
% koryfwsh sta krousmata kai tous thanatous gia kathe xwra, kathws kai to
% xroniko diasthma metaxy twn koryfwsewn. Edw oi ektimhseis poy phrame apo
% thn katanomh einai se polles periptwseis konta sta pragmatika.

% Epeita, ypologisame ta 95% parametrika kai
% bootstrap diasthmata empistosynhs ths xronikhs diaforas twn koryfwsewn
% metaxy thanatwn kai krousmatwn. Akolouthisame 2 proseggiseis. Sthn prwth
% symperilavame ola ta dedomena,enw sth deuterh diwxame tis xwres, stis opoies
% h koryfwsh twn krousmatwn epetai arketa ths koryfwshs twn thanatwn 
% (10 meres). Emfanisthke mia xwra outlier kai ayth htan h Ellada.
% Thewroume oti auto ofeiletai ston mikro arithmo twn covid tests. 


 


