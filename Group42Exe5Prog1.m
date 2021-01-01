% Data Analysis Project 2020
% Nikos Kaparinos 9245
% Vasiliki Zarkadoul 9103
% Exercise 5: Linear Regression
close all;
clc;
clear;

%rng(666);
countryList = ["Greece","Italy"];
rmseArray = zeros(length(countryList),21);

for i = 1:length(countryList)
    [cases,deaths,population] = Group42Exe1Fun3(countryList(i));

    % Plot
    % figure(200)
    % plot(1:length(deaths),movmean(deaths,7));

    % Start and end of the first Covid-19 wave
    [start1,end1] = Group42Exe1Fun1(cases);
    cases = cases(start1:end1)';
    deaths = deaths(start1:end1)';
    n = length(cases);

    graphsToPlot = [0,6,13,20];

    minRMSE = 1e6;
    argMin = -1;
    bestR2 = -100;

    % maxR2 = - 100;
    % argR2 = -1;
    figure(i)
    j = 1;
    for t = 0:20
        % Linear Regression Model
        X = cases(1:n-t);
        Y = deaths(1+t:n);
        regressionModel = fitlm(X,Y);
        b = table2array(regressionModel.Coefficients);
        b = b(:,1);
        ypred = [ones(length(X),1) X]*b;

        % Diagnostic plot of standardised error
        ei_standard = (Y - ypred)/regressionModel.RMSE;
        %figure(t+1)
        if(ismember(t,graphsToPlot))
            subplot(2,2,j)
            scatter(Y,ei_standard);
            hold on;
            plot(Y,repmat(2,1,length(Y)));
            hold on;
            plot(Y,repmat(0,1,length(Y)));
            hold on;
            plot(Y,repmat(-2,1,length(Y)));
            title(countryList(i) + " Diagnostic Plot: t = " + t);
            text(6,-1,"RMSE="+regressionModel.RMSE,'FontSize',12);
            text(6,-1.5,"R^2="+regressionModel.Rsquared.Ordinary,'FontSize',12);
            j = j+1;
        end

        % Save rmse
        rmseArray(i,t+1) = regressionModel.Rsquared.Ordinary;
        
        % Find optimal model
        if(regressionModel.RMSE < minRMSE)
            minRMSE = regressionModel.RMSE;
            argMin = t;
            bestR2 = regressionModel.Rsquared.Ordinary;
        end

    %     if(regressionModel.Rsquared.Ordinary > maxR2)
    %         maxR2 = regressionModel.Rsquared.Ordinary;
    %         argR2 = t;
    %     end
    end

    % Plot predictions vs ground truth for the optimal linear model
    t = argMin;
    X = cases(1:n-t);
    Y = deaths(1+t:n);
    regressionModel = fitlm(X,Y);
    b = table2array(regressionModel.Coefficients);
    b = b(:,1);
    ypred = [ones(length(X),1) X]*b;

    figure(i+10);
    plot(1:length(deaths),deaths);
    hold on;
    plot(1:length(deaths),movmean(deaths,7),"--");
    hold on;
    plot(1+t:n,ypred,"LineWidth",2,"Color","m");
    title("Deaths in " + countryList(i) +" and optimal linear regression (t=" + t + ")"); 
    legend("Deaths","Deaths 7-Day moving average","Linear regression");
    
    % Compare different values of t
    [~,rmseArray(i,:)] = sort(rmseArray(i,:),'descend');
end

rmseArray = rmseArray - 1;

places = zeros(21,1);

for t =0:20
    for i =1:length(countryList)
        places(t+1) = places(t+1) + find(rmseArray(i,:) == t);
    end
end

[~,bestT] = sort(places);
bestT = bestT - 1;




