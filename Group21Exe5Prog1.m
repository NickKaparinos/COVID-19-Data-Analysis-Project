% Data Analysis Project 2020
% Nikos Kaparinos 9245
% Vasiliki Zarkadoul 9103
% Exercise 5: Normal Linear Regression
close all;
clc;
clear;

% Selected Countries
countryList = ["Greece","Belgium","Italy","France","Germany","Netherlands","United_Kingdom"];
rmseArray = zeros(length(countryList),1);
R2Array = zeros(length(countryList),1);
optimalDelay = zeros(length(countryList),1);

for i = 1:length(countryList)
    % Read cases, deaths and population from data files
    [cases,deaths,population] = Group21Exe1Fun3(countryList(i));
    countryList(i) = strrep(countryList(i),"_"," ");            % Replace "_" because it is used for subscripts in plot titles
    
    % Find the start and end of the first wave using Group21Exe1Fun1
    [start1,end1] = Group21Exe1Fun1(cases);
    cases = cases(start1:end1)';
    deaths = deaths(start1:end1)';
    n = length(cases);
    
    graphsToPlot = [0,6,13,20];                                 % Graphs are ploted only for these delays for simplicity

    minRMSE = 1e6;
    argMin = -1;

    figure(i)
    j = 1;                                                      % j is the number of subplot
    for t = 0:20
        % Linear Regression Model
        X = cases(1:n-t);
        Y = deaths(1+t:n);
        regressionModel = fitlm(X,Y);
        b = table2array(regressionModel.Coefficients);
        b = b(:,1);

        % Diagnostic plot of standardised error
        ei_standard = regressionModel.Residuals.Raw/regressionModel.RMSE;
        if(ismember(t,graphsToPlot))
            subplot(2,2,j)
            scatter(Y,ei_standard);
            hold on;
            plot(Y,repmat(2,1,length(Y)));
            hold on;
            plot(Y,zeros(1,length(Y)));
            hold on;
            plot(Y,repmat(-2,1,length(Y)));
            title(countryList(i) + " Diagnostic Plot: t = " + t);
            text(6,-1,"RMSE="+regressionModel.RMSE,'FontSize',12);
            text(6,-1.5,"R^2="+regressionModel.Rsquared.Ordinary,'FontSize',12);
            xlabel("Y")
            ylabel("Standard Error");
            j = j+1;
        end
        
        % Find optimal model
        if(regressionModel.RMSE < minRMSE)
            minRMSE = regressionModel.RMSE;
            argMin = t;
            maxR2 = regressionModel.Rsquared.Ordinary;
        end
    end

    % Plot predictions vs ground truth for the optimal linear model
    rmseArray(i) = minRMSE;
    R2Array(i) = maxR2;
    optimalDelay(i) = argMin;
    t = argMin;
    X = cases(1:n-t);
    Y = deaths(1+t:n);
    regressionModel = fitlm(X,Y);
    b = table2array(regressionModel.Coefficients);
    b = b(:,1);
    Ypred = [ones(length(X),1) X]*b;

    figure(i+10);
    plot(1:length(deaths),deaths);
    hold on;
    plot(1:length(deaths),movmean(deaths,7),"--");
    hold on;
    plot(1+t:n,Ypred,"LineWidth",2,"Color","m");
    title("Deaths in " + countryList(i) +" and optimal normal linear regression (t=" + t + ")"); 
    legend("Deaths","Deaths 7-Day moving average","Optimal Normal Linear regression");
    
end

table = zeros(3,length(countryList));
table(1,:) = rmseArray';
table(2,:) = R2Array';
table(3,:) = optimalDelay';

table = array2table(table,'RowNames',{'RMSE','R2','Optimal t based on RMSE'},'VariableNames',{'Greece','Belgium','Italy','France','Germany','Netherlands','United_Kingdom'});
disp(table);