% Nikos Kaparinos 9245
% Vasiliki Zarkadoula 9103

function [cases,deaths,population] = Group21Exe1Fun3(countryName)
    % This function reads the data for a specific country

    % Dataset Cases
    warning('OFF', 'MATLAB:table:ModifiedAndSavedVarnames')
    casesTable = readtable('Covid19Confirmed.xlsx','basic',true);
    labels = table2cell(casesTable(:,1:2));
    populations = table2array(casesTable(:,3));

    casesTable(:,1:3) = [];
    dataCases = table2array(casesTable);

    % Dataset Deaths
    deathsTable = readtable('Covid19Deaths.xlsx','basic',true);
    deathsTable(:,1:3) = [];
    dataDeaths = table2array(deathsTable);
    
    indexOfCountry = find(labels(:,1) == countryName);
    population = populations(indexOfCountry);
    cases = dataCases(indexOfCountry,:);
    deaths = dataDeaths(indexOfCountry,:);
    
    % Preprocessing
    
    % Replace NaNs
    cases(isnan(cases)) = 0;
    deaths(isnan(deaths)) = 0;
    
    % Average out negative values
    negativeCases = find(cases < 0);
    negativeDeaths = find(deaths < 0);
    
    if(~isempty(negativeCases))
        for i = negativeCases
            avg = sum( cases(i-2:i+2) ) / 5;
            cases(i-1:i+1) = avg;
        end
    end
    
    if(~isempty(negativeDeaths))
        for i = negativeDeaths
            avg = sum( cases(i-2:i+2) ) / 5;
            deaths(i-1:i+1) = avg;
        end
    end
end