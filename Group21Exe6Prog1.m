% Data Analysis Project 2020
% Nikos Kaparinos 9245
% Vasiliki Zarkadoul 9103
% Exercise 6: Multiple Linear Regression
close all;
clc;
clear;

% Function handles
Rsq = @(ypred,y) 1-sum((ypred-y).^2)/sum((y-mean(y)).^2);
adjRsq = @(ypred,y,n,k) ( 1 - (n-1)/(n-1-k)*sum((ypred-y).^2)/sum((y-mean(y)).^2) );

% Selected Countries
countryList = ["Greece","Belgium","Italy","France","Germany","Netherlands","United_Kingdom"];

% Optimal day for for each country on Exercise 5
optimalT = [0,5,6,6,13,5,0];

% Metrics
R2Array = zeros(length(countryList),3);
AdjR2Array = zeros(length(countryList),3);
RegressionType = ["Normal Linear Regression","Multiple Linear Regression","Stepwise Regression"];
stepwiseNumberOfVariables = zeros(length(countryList),1);

for i = 1:length(countryList)
    % Read cases, deaths and population from data files
    [cases,deaths,population] = Group21Exe1Fun3(countryList(i));
    countryList(i) = strrep(countryList(i),"_"," ");            % Replace "_" because it is used for subscripts in plot titles
    
    % Find the start and end of the first wave using Group21Exe1Fun1
    [start1,end1] = Group21Exe1Fun1(cases);
    cases = cases(start1:end1)';
    deaths = deaths(start1:end1)';
    n = length(cases);
    
    % Optimal Normal Linear Regression Model
    t = optimalT(i);
    X = cases(1:n-t);
    Y = deaths(1+t:n);
    regressionModel = fitlm(X,Y);
    b = table2array(regressionModel.Coefficients);
    b = b(:,1);
    Ypred = [ones(length(X),1) X]*b;
    YpredNormal = Ypred;
    
    % Save R2 and adjR2
    R2Array(i,1) = regressionModel.Rsquared.Ordinary;
    AdjR2Array(i,1) = regressionModel.Rsquared.Adjusted;
    
    f = figure(i);
    f.Position = [660 10 600 1000];                         % figure position is optimised for 1920x1080 monitors
    j = 1;                                                  % Otherwise comment line 51 to return to defaults
    % Diagnostic plot of standardised error
    ei_standard = (Y - Ypred)/regressionModel.RMSE;
    subplot(3,1,j)
    scatter(Y,ei_standard);
    hold on;
    plot(Y,repmat(2,1,length(Y)));
    hold on;
    plot(Y,zeros(1,length(Y)));
    hold on;
    plot(Y,repmat(-2,1,length(Y)));
    title(countryList(i) + " Diagnostic Plot: t = " + t);
    text(6,-1,"R^2="+R2Array(i,1),'FontSize',12);
    text(6,-1.5,"Adj R^2="+AdjR2Array(i,1),'FontSize',12);
    xlabel("Y")
    ylabel("Standard Error");
    j = j+1;
    
    % Full Linear Regression Model
    X = zeros(n-20,21);
    k = 21;
    for t = 0:20                                            % Create X varibales based on all 21 delays
        X(:,t+1) = cases(1+t:n-20+t);
    end
    Xinput = [ones(n-20,1) X];
    Y = deaths(21:n);
    
    b = regress(Y,Xinput);
    Ypred = Xinput*b;
    YpredFull = Ypred;
    
    % Save R2 and adjR2
    R2Array(i,2) = Rsq(Ypred,Y);
    AdjR2Array(i,2) = adjRsq(Ypred,Y,length(Y),k);
    
    % Diagnostic plot of standardised error
    error = Y - Ypred;
    se = sqrt( 1/(length(X)-k-1) * (sum(error.^2)));
    ei_standard = error./se;
    % ei_standard = (Y - ypred)/regressionModel.RMSE;
    subplot(3,1,j)
    scatter(Y,ei_standard);
    hold on;
    plot(Y,repmat(2,1,length(Y)));
    hold on;
    plot(Y,zeros(1,length(Y)));
    hold on;
    plot(Y,repmat(-2,1,length(Y)));
    title(countryList(i) + " Diagnostic Plot: Full Linear Model");
    text(6,-1.25,"R^2="+R2Array(i,2),'FontSize',12);
    text(6,-1.75,"Adj R^2="+AdjR2Array(i,2),'FontSize',12);
    xlabel("Y")
    ylabel("Standard Error");
    j = j+1;
    
    % Step wise regression
    [b,~,~,model,stats] = stepwisefit(X,Y);
    b0 = stats.intercept;
    b = [b0; b(model)];
    k = length(b);

    Ypred = [ones(length(X),1) X(:,model)]*b;
    YpredStep = Ypred;
    
    % Save R2 and adjR2
    R2Array(i,3) = (1-stats.SSresid/stats.SStotal);
    AdjR2Array(i,3) = adjRsq(Ypred,Y,length(Y),k);
    stepwiseNumberOfVariables(i) = length(b) - 1;
    
    % Diagnostic plot of standardised error
    error = Y - Ypred;
    se = sqrt( 1/(length(X)-k-1) * (sum(error.^2)));
    ei_standard = error./se;
    subplot(3,1,j)
    scatter(Y,ei_standard);
    hold on;
    plot(Y,repmat(2,1,length(Y)));
    hold on;
    plot(Y,zeros(1,length(Y)));
    hold on;
    plot(Y,repmat(-2,1,length(Y)));
    title(countryList(i) + " Diagnostic Plot: Full Linear Model");
    text(6,-1,"R^2="+R2Array(i,3),'FontSize',12);
    text(6,-1.5,"Adj R^2="+AdjR2Array(i,3),'FontSize',12);
    xlabel("Y")
    ylabel("Standard Error");
    
    f = figure(100+i);
    f.Position = [660 10 600 1000];                         % figure position is optimised for 1920x1080 monitors
    subplot(3,1,1)                                          % Otherwise comment line 156 to return to defaults
    t = optimalT(i);
    Y = deaths(1+t:n);
    plot(1:length(deaths),deaths);
    hold on;
    plot(1:length(deaths),movmean(deaths,7),"--");
    hold on;
    plot(1+t:n,YpredNormal,"LineWidth",1.5,"Color","m");
    title("Deaths in " + countryList(i) +" and optimal normal linear regression (t=" + t + ")");
    legend("Deaths","Deaths 7-Day moving average","Optimal Normal Linear regression");
    
    subplot(3,1,2)
    plot(1:length(deaths),deaths);
    hold on;
    plot(1:length(deaths),movmean(deaths,7),"--");
    hold on;
    plot(21:n,YpredFull,"LineWidth",1.5,"Color","c");
    title("Deaths in " + countryList(i) +" and full linear regression ");
    legend("Deaths","Deaths 7-Day moving average","Full Linear Regression");
    
    subplot(3,1,3)
    plot(1:length(deaths),deaths);
    hold on;
    plot(1:length(deaths),movmean(deaths,7),"--");
    hold on;
    plot(21:n,YpredStep,"LineWidth",1.5,"Color","k");
    title("Deaths in " + countryList(i) +" and stepwise regression (" + stepwiseNumberOfVariables(i) + " variables)");
    legend("Deaths","Deaths 7-Day moving average","Stepwise Regression");
end

% Clear command window
clc

% Create tables to display
tablesStepwiseRegression = cell(length(countryList));
regressionTables = cell(length(countryList));
for i = 1:length(countryList)
    regressionTables{i} = table(R2Array(i,:)',AdjR2Array(i,:)','VariableNames',{'R2','Adjusted_R2'},'RowName',{'Normal Linear Regression','Full Linear Regression','Stepwise Regression'});
end

% Results
disp("Displaying Results:")
for i = 1:length(countryList)
    disp(countryList(i) + " results:")
    disp(regressionTables{1})
    disp("Stepwise regression number of Variables kept = " + stepwiseNumberOfVariables(i))
    [~,R2SortedIdx] = sort(R2Array(i,:),'descend');
    [~,AdjR2SortedIdx] = sort(AdjR2Array(i,:),'descend');
    disp("Best regression type based on R2: " + RegressionType(R2SortedIdx(1)) );
    disp("Best regression type based on Adjusted R2: " + RegressionType(AdjR2SortedIdx(1)) + newline + newline );
end


