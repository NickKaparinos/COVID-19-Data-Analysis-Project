% Data Analysis Project
% 2020
close all;
clc;
clear;

% This script is used to find the limit of cases for the first wave

% Dataset Cases
casesTable = readtable('Covid19Confirmed.xlsx','basic',true);
labels = table2cell(casesTable(:,1:2));
population = table2array(casesTable(:,3));

casesTable(:,1:3) = [];
dataCases = table2array(casesTable);

% Dataset Deaths
deathsTable = readtable('Covid19Deaths.xlsx','basic',true);
deathsTable(:,1:3) = [];
dataDeaths = table2array(deathsTable);


% Cases greece
casesGreece = dataCases(54,:);
casesGreece(isnan(casesGreece)) = 0;

% Find all european countries
% Save names,cases and populations in arrays
europeCountriesNames = {40};
europeCountriesCases = zeros(40,348);
europeCountriesDeaths = zeros(40,348);
europePopulation = zeros(40,1);
j = 1;
for i=1:size(dataCases,1)
    if (labels(i,2) == "Europe")
        europeCountriesNames(j) = labels(i,1);
        
        europeCountriesCases(j,:) = dataCases(i,:);
        nan = isnan(europeCountriesCases(j,:));
        europeCountriesCases(j,nan) = 0;
        
        europeCountriesDeaths(j,:) = dataDeaths(i,:);
        nan = isnan(europeCountriesDeaths(j,:));
        europeCountriesDeaths(j,nan) = 0;
        
        europePopulation(j) = population(i);
        
        j = j+1;
    end
end

selectedCountriesID = [3,6,12,13,16,17,19,20,25,27,40];

% Fix negative values
for i = selectedCountriesID
    negativeCases = find(europeCountriesCases(i,:) < 0);
    negativeDeaths = find(europeCountriesDeaths(i,:) < 0);
    
    if(~isempty(negativeCases))
        for j = negativeCases
            avg = sum( europeCountriesCases(i,j-1:j+1) ) / 3;
            europeCountriesCases(i,j-1:j+1) = avg;
        end
    end
    
    if(~isempty(negativeDeaths))
        for j = negativeDeaths
            avg = sum( europeCountriesDeaths(i,j-1:j+1) ) / 3;
            europeCountriesDeaths(i,j-1:j+1) = avg;
        end
    end
end

% Plot selected countries 7-day average rolling average of cases and deaths
% Also plot the waves and the thresholds
for i = 1:size(europeCountriesNames,2)
    if( ismember(i,selectedCountriesID) )
        % Briskw to first wave me bash cases kai me bash deaths
        % Briskw to second wave me bash cases kai me bash deaths
        % Sum
        totalNumberOfCasesFirstWave = sum(europeCountriesCases(i,1:200));
        totalNumberOfDeathsFirstWave = sum(europeCountriesDeaths(i,1:200));
        totalNumberOfCasesSecondWave = sum(europeCountriesCases(i,200:end));
        totalNumberOfDeathsSecondWave = sum(europeCountriesDeaths(i,200:end));
        
        % Thresholds
        % Auto pou elega limit
        thresholdCasesFirst = 0.00225*totalNumberOfCasesFirstWave;
        thresholdDeathsFirst = 0.0015*totalNumberOfDeathsFirstWave;
        
        thresholdCasesSecond = 0.0017*totalNumberOfCasesSecondWave;
        thresholdDeathsSecond = 0.0015*totalNumberOfDeathsSecondWave;
        
        % Find 1st wave for cases
        casesMovingAverage = movmean(europeCountriesCases(i,1:end),7);
        startFound = false;
        endFound = false;
        j = 1;
        % Ksekinaw na blepw to moving averages twn cases apo thn arxh kai
        % to sigkrhnw me to threshold
        % Otan perasei prwth fora to threshold, lew brhka to start
        % Meta apo auto, otan pesei lew brhka to end
        while(j<=200)
            difference = casesMovingAverage(j) - thresholdCasesFirst;
            if(~startFound)
                if( difference>0 )
                    startFound = true;
                    startCases = j;
                    j = j + 30;
                    continue;
                end
            else
                if( difference<0 )
                    endFound = true;
                    endCases = j;
                    break;
                end
            end
            j = j+1;
        end
        
        % Find 2nd wave for cases
        casesMovingAverage = movmean(europeCountriesCases(i,200:end),7);
        startFound = false;
        endFound = false;
        j = 200;
        while( j<=size(europeCountriesCases,2))
            difference = casesMovingAverage(j-199) - thresholdCasesSecond;
            if(~startFound)
                if( difference>0 )
                    startFound = true;
                    startCasesSecond = j;
                    j = j + 30;
                    continue;
                end
            else
                if( difference<0 )
                    endFound = true;
                    endCasesSecond = j;
                    break;
                end
            end
            j = j + 1;
        end
        if(~endFound)
            endCasesSecond = size(europeCountriesCases,2);
        end
        
        % [Start of first wave, end of first wave]
        % [Start of second wave, end of second wave]
        % Ta ekane se function opw ta thelei kai to upologizv kai me to
        % function gia epalitheush
        [s1,e1] = Group42Exe1Fun1(europeCountriesCases(i,1:end));
        [s2,e2] = Group42Exe1Fun2(europeCountriesCases(i,1:end));
        
        % Plot cases
        figure(i)
        plot(1:size(europeCountriesCases,2),movmean(europeCountriesCases(i,1:end),7));
        
        % Plot thresholds
        xlimit = xlim;
        line([xlimit(1) 200],[thresholdCasesFirst,thresholdCasesFirst],'Color','r')
        line([200 xlimit(2)],[thresholdCasesSecond,thresholdCasesSecond],'Color','r')
        line([200,200],ylim,'Color','g')
        
        % Plot start and end for the first wave
        % An de blepw tis mple grammes, shmainei oti einai katw apo tis
        % grames xrwmatos magenta, dhladh h epalhtheysh peftei panw sta
        % kanonika ara komple
        line([startCases,startCases],ylim,'Color','b')
        line([endCases,endCases],ylim,'Color','b')
        line([s1,s1],ylim,'Color','m')
        line([e1,e1],ylim,'Color','m')
        
        % Plot start and end for the second wave
        line([startCasesSecond,startCasesSecond],ylim,'Color','b')
        line([endCasesSecond,endCasesSecond],ylim,'Color','b')
        line([s2,s2],ylim,'Color','m')
        line([e2,e2],ylim,'Color','m')
        
        title(europeCountriesNames(i) + " Cases");
        
        % Kanw ola ta idia alla me bash ta deaths
        
        % Find 1st wave for deaths
        deathsMovingAverage = movmean(europeCountriesDeaths(i,1:end),7);
        startFound = false;
        endFound = false;
        j = 1;
        while( j<=200)
            difference = deathsMovingAverage(j) - thresholdDeathsFirst;
            if(~startFound)
                if( difference>0 )
                    startFound = true;
                    startDeaths = j;
                    j = j + 30;
                    continue;
                end
            else
                if( difference<0 )
                    endFound = true;
                    endDeaths = j;
                    break;
                end
            end
            j = j + 1;
        end
        
         % Find 2nd wave for deaths
        deathsMovingAverage = movmean(europeCountriesDeaths(i,200:end),7);
        startFound = false;
        endFound = false;
        j = 200;
        while( j<=size(europeCountriesDeaths,2))
            difference = deathsMovingAverage(j-199) - thresholdDeathsSecond;
            if(~startFound)
                if( difference>0 )
                    startFound = true;
                    startDeathsSecond = j;
%                     j = j + 30;
                    continue;
                end
            else
                if( difference<0 )
                    endFound = true;
                    endDeathsSecond = j;
                    break;
                end
            end
            j = j + 1;
        end
        if(~endFound)
            endDeathsSecond = size(europeCountriesDeaths,2);
        end
        
        % Plot deaths
        figure(100+i)
        plot(1:size(europeCountriesCases,2),movmean(europeCountriesDeaths(i,1:end),7));
        xlimit = xlim;
        line([xlimit(1) 200],[thresholdDeathsFirst,thresholdDeathsFirst],'Color','r')
        line([200 xlimit(2)],[thresholdDeathsSecond,thresholdDeathsSecond],'Color','r')
        line([200,200],ylim,'Color','g')
        line([startDeaths,startDeaths],ylim,'Color','b')
        line([endDeaths,endDeaths],ylim,'Color','b')
        line([startDeathsSecond,startDeathsSecond],ylim,'Color','b')
        line([endDeathsSecond,endDeathsSecond],ylim,'Color','b')
        title(europeCountriesNames(i) + " Deaths");

    end
end