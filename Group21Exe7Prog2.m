% Data Analysis Project 2020
% Nikos Kaparinos 9245
% Vasiliki Zarkadoul 9103
% Exercise 7: Regression second wave
close all;
clc;
clear;

% Function handles
Rsq = @(ypred,y) 1-sum((ypred-y).^2)/sum((y-mean(y)).^2);
adjRsq = @(ypred,y,n,k) ( 1 - (n-1)/(n-1-k)*sum((ypred-y).^2)/sum((y-mean(y)).^2) );

% Selected Countries
countryList = ["Greece","Belgium","Italy","France","Germany","Netherlands","United_Kingdom"];
%countryList = ["Italy"];

R2Training = zeros(length(countryList),2);
AdjR2Training = zeros(length(countryList),2);
R2Test = zeros(length(countryList),2);
AdjR2Test = zeros(length(countryList),2);
stepwiseNumberOfVariables = zeros(length(countryList),1);



for i = 1:1:length(countryList)
    % First Wave
    
    % Read cases, deaths and population from data files
    [cases,deaths,population] = Group21Exe1Fun3(countryList(i));
    
    % Find the start and end of the first wave using Group21Exe1Fun1
    [start1,end1] = Group21Exe1Fun1(cases);
    casesFirstWave = cases(start1:end1)';
    deathsFirstWave = deaths(start1:end1)';
    n1 = length(casesFirstWave);
    
    % Full Linear Regression Model
    X = zeros(n1-20,21);
    k = 21;
    for t = 0:20                                            % Create X varibales based on all 21 delays
        X(:,t+1) = casesFirstWave(1+t:n1-20+t);
    end
    X = normalize(X,'range');
    Xinput = [ones(n1-20,1) X];
    Y = deathsFirstWave(21:n1);
    
    b = regress(Y,Xinput);
    YpredFull = Xinput*b;
    
    bFull = b;                                              % Save model for testing
    
    % Training R2 and AdjR2
    R2Training(i,1) = Rsq(YpredFull,Y);
    AdjR2Training(i,1) = adjRsq(YpredFull,Y,length(Y),k);
    
    % Step wise regression
    [b,~,~,model,stats] = stepwisefit(X,Y);
    b0 = stats.intercept;
    b = [b0; b(model)];
    k = length(b);
    
    bStep = b;                                              % Save model for testing
    modelStep = model;
    

    YpredStep = [ones(length(X),1) X(:,model)]*b;
    
    % Training R2 and adjR2
    R2Training(i,2) = Rsq(YpredStep,Y);
    AdjR2Training(i,2) = adjRsq(YpredStep,Y,length(Y),k);
    stepwiseNumberOfVariables(i) = length(b) - 1;
    
    % Second wave
    
    % Find the start and end of the second wave using Group21Exe1Fun2
    [start2,end2] = Group21Exe1Fun2(cases);
    casesSecondWave = cases(start2:end2)';
    deathsSecondWave = deaths(start2:end2)';
    n2 = length(casesSecondWave);
    
    % Full Linear Regression Model
    X = zeros(n2-20,21);
    k = 21;
    for t = 0:20                                            % Create X varibales based on all 21 delays
        X(:,t+1) = casesSecondWave(1+t:n2-20+t);
    end
    X = normalize(X,'range');
    Xinput = [ones(n2-20,1) X];
    Y = deathsSecondWave(21:n2);

    YpredFull = Xinput*bFull;
    
    % Save training R2 and AdjR2
    R2Test(i,1) = Rsq(YpredFull,Y);
    AdjR2Test(i,1) = adjRsq(YpredFull,Y,length(Y),k);
    
    % Step wise regression
    YpredStep = [ones(length(X),1) X(:,modelStep)]*bStep;
    
    % Save R2 and adjR2
    R2Test(i,2) = Rsq(YpredStep,Y);
    AdjR2Test(i,2) = adjRsq(YpredStep,Y,length(Y),stepwiseNumberOfVariables(i) + 1);
    
    
    % Plot second wave deaths and regressions
    countryList(i) = strrep(countryList(i),"_"," ");            % Replace "_" because it is used for subscripts in plot titles
    figure;
    plot(1:length(deathsSecondWave),deathsSecondWave);
    hold on;
    plot(1:length(deathsSecondWave),movmean(deathsSecondWave,7),"--");
    hold on;
    plot(21:n2,YpredFull,"LineWidth",1.5,"Color","m");
    title("Second wave deaths in " + countryList(i) +" and full linear regression ");
    legend("Deaths","Deaths 7-Day moving average","Full Linear Regression");
    
    figure;
    plot(1:length(deathsSecondWave),deathsSecondWave);
    hold on;
    plot(1:length(deathsSecondWave),movmean(deathsSecondWave,7),"--");
    hold on;
    plot(21:n2,YpredStep,"LineWidth",1.5,"Color","m")
    title("Second wave deaths in " + countryList(i) +" and stepwise regression (" + stepwiseNumberOfVariables(i) + " varaibles)");
    legend("Deaths","Deaths 7-Day moving average","Stepwise Regression");
    
end

% Results
disp("Displaying Results:")
for i = 1:length(countryList)
    disp(countryList(i) + " results:")
    disp("Full linear regression training set results: R2 = " + R2Training(i,1) + ", Adjusted R2 = " + AdjR2Training(i,1) + ".")
    disp("Full linear regression testing  set results: R2 = " + R2Test(i,1) + ", Adjusted R2 = " + AdjR2Test(i,1) + ".")
    disp("Stepwise regression training set results: R2 = " + R2Training(i,2) + ", Adjusted R2 = " + AdjR2Training(i,2) + ".")
    disp("Stepwise regression testing  set results: R2 = " + R2Test(i,2) + ", Adjusted R2 = " + AdjR2Test(i,2) + ".")
    disp("Stepwise regression number of variables kept = " + stepwiseNumberOfVariables(i) + newline)
    
    
end

