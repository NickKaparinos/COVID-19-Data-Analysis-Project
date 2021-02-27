% Data Analysis Project 2020-2021
% Nikos Kaparinos 9245
% Vasiliki Zarkadoul 9103
% Exercise 8: Regression second wave and feature selection
close all;
clc;
clear;

% Function handles
Rsq = @(ypred,y) 1-sum((ypred-y).^2)/sum((y-mean(y)).^2);
adjRsq = @(ypred,y,n,k) ( 1 - (n-1)/(n-1-k)*sum((ypred-y).^2)/sum((y-mean(y)).^2) );

% Selected Countries
countryList = ["Greece","Belgium","Italy","France","Germany","Netherlands","United_Kingdom"];
PLSNormalisationType = ["range","range","range","range","range","zscore","range"];
R2Training = zeros(length(countryList),6);
AdjR2Training = zeros(length(countryList),6);
R2Test = zeros(length(countryList),6);
AdjR2Test = zeros(length(countryList),6);
stepwiseNumberOfVariables = zeros(length(countryList));


% LASSO
lambda = 1:100;
bLASSOArray = zeros(length(countryList),length(lambda),22);

R2LASSOTraining = zeros(length(countryList),length(lambda));
AdjR2LASSOTraining = zeros(length(countryList),length(lambda));

R2LASSOTest = zeros(length(countryList),length(lambda));
AdjR2LASSOTest = zeros(length(countryList),length(lambda));

% PLS
numberOfComponents = 1:21;
bPLSArray = zeros(length(countryList),length(numberOfComponents),22);

R2PLSTraining = zeros(length(countryList),length(numberOfComponents));
AdjR2PLSTraining = zeros(length(countryList),length(numberOfComponents));

R2PLSTest = zeros(length(countryList),length(numberOfComponents));
AdjR2PLSTest = zeros(length(countryList),length(numberOfComponents));

for i = 1:1:length(countryList)
    %%% First Wave %%%
    % Read cases and deaths
    [cases,deaths,~] = Group21Exe1Fun3(countryList(i));
    countryList(i) = strrep(countryList(i),"_"," ");
    
    % Find the start and end of the first wave using Group21Exe1Fun1
    [start1,end1] = Group21Exe1Fun1(cases);
    casesFirstWave = cases(start1:end1)';
    deathsFirstWave = deaths(start1:end1)';
    n1 = length(casesFirstWave);
    
    % Full Linear Regression Model
    X = zeros(n1-20,21);
    for t = 0:20                                            % Create X varibales based on all 21 delays
        X(:,t+1) = casesFirstWave(1+t:n1-20+t);
    end
    Xinput = [ones(n1-20,1) X];
    k = 21;
    
    Y = deathsFirstWave(21:n1);
    bFull = regress(Y,Xinput);
    YpredFull = Xinput*bFull;
    
    % Training R2 and AdjR2
    R2Training(i,1) = Rsq(YpredFull,Y);
    AdjR2Training(i,1) = adjRsq(YpredFull,Y,length(Y),k);
    
    % Normalised Full Linear Regression Model %
    Xnorm = normalize(X,'range');
    Xinput = [ones(n1-20,1) Xnorm];
    Y = deathsFirstWave(21:n1);
    
    bFullNorm = regress(Y,Xinput);
    YpredFull = Xinput*bFullNorm;
    
    % Training R2 and AdjR2
    R2Training(i,2) = Rsq(YpredFull,Y);
    AdjR2Training(i,2) = adjRsq(YpredFull,Y,length(Y),k);
    
    % Step wise regression
    [bStep,~,~,modelStep,stats] = stepwisefit(X,Y,'Display','off');
    bStep = [stats.intercept; bStep(modelStep)];
    YpredStep = [ones(length(X),1) X(:,modelStep)]*bStep;
    
    % Training R2 and adjR2
    R2Training(i,3) = 1 - stats.SSresid/stats.SStotal;
    AdjR2Training(i,3) = adjRsq(YpredStep,Y,length(Y),length(bStep)-1);
    stepwiseNumberOfVariables(i) = length(bStep) - 1;
    
    % Normalised Stepwise regression
    [bStepNorm,~,~,modelStepNorm,stats] = stepwisefit(Xnorm,Y,'Display','off');
    bStepNorm = [stats.intercept; bStepNorm(modelStepNorm)];
    YpredStepNorm = [ones(length(Xnorm),1) Xnorm(:,modelStepNorm)]*bStepNorm;
    
    % Training R2 and adjR2
    R2Training(i,4) = 1 - stats.SSresid/stats.SStotal;
    AdjR2Training(i,4) = adjRsq(YpredStepNorm,Y,length(Y),length(bStepNorm)-1);
    
    % LASSO
    [bLASSO,info] = lasso(Xnorm,Y);
       
    for l = 1:100
        bLASSOTemp = bLASSO(:,i);
        %b0 = mean(Y) - mean(X)*bLASSOTemp;
        %b0 = mean(Y);
        %b0 = 0;
        b0 = info.Intercept(i);
        bLASSOTemp = [b0; bLASSOTemp];
        YpredLASSO = [ones(length(X),1) Xnorm]*bLASSOTemp;
        
        bLASSOArray(i,l,:) = bLASSOTemp;

        % Training R2 and AdjR2
        R2LASSOTraining(i,l) = Rsq(YpredLASSO,Y);
        AdjR2LASSOTraining(i,l) = adjRsq(YpredLASSO,Y,length(Y),length(bLASSOTemp));
    end
    
    % PLS
    for l = 1:length(numberOfComponents)
        [~,~,~,~,bPLS,~] = plsregress(normalize(X,PLSNormalisationType(i)),Y,numberOfComponents(l));
        YpredPLS = [ones(length(X),1) normalize(X,PLSNormalisationType(i))]*bPLS;
        
        bPLSArray(i,l,:) = bPLS;
        
        % Training R2 and AdjR2
        R2PLSTraining(i,l) = Rsq(YpredPLS,Y);
        AdjR2PLSTraining(i,l) = adjRsq(YpredPLS,Y,length(Y),numberOfComponents(i));
    end
    
    %%% Second wave %%%
    % Find the start and end of the second wave using Group21Exe1Fun2
    [start2,end2] = Group21Exe1Fun2(cases);
    casesSecondWave = cases(start2:end2)';
    deathsSecondWave = deaths(start2:end2)';
    n2 = length(casesSecondWave);
    
    % Full Linear Regression Model
    X = zeros(n2-20,21);
    k = 21;
    for t = 0:20                                            % Create X variables based on all 21 delays
        X(:,t+1) = casesSecondWave(1+t:n2-20+t);
    end
    Xinput = [ones(length(X),1) X];
    Y = deathsSecondWave(21:n2);
    YpredFull = Xinput*bFull;
    
    % Save training R2 and AdjR2
    R2Test(i,1) = Rsq(YpredFull,Y);
    AdjR2Test(i,1) = adjRsq(YpredFull,Y,length(Y),k);
    
    % Normalised Full Linear Regression Model
    Xnorm = normalize(X,'range');
    Xinput = [ones(length(Xnorm),1) Xnorm];
    Y = deathsSecondWave(21:n2);
    YpredFullNorm = Xinput*bFullNorm;
    
    % Save testing R2 and AdjR2
    R2Test(i,2) = Rsq(YpredFullNorm,Y);
    AdjR2Test(i,2) = adjRsq(YpredFullNorm,Y,length(Y),k);
    
    % Step wise regression
    YpredStep = [ones(length(X),1) X(:,modelStep)]*bStep;
    
    % Save testing R2 and adjR2
    R2Test(i,3) = Rsq(YpredStep,Y);
    AdjR2Test(i,3) = adjRsq(YpredStep,Y,length(Y),stepwiseNumberOfVariables(i));
    
    % Normalised Step wise regression
    YpredStepNorm = [ones(length(Xnorm),1) Xnorm(:,modelStepNorm)]*bStepNorm;
    
    % Save R2 and adjR2
    R2Test(i,4) = Rsq(YpredStepNorm,Y);
    AdjR2Test(i,4) = adjRsq(YpredStepNorm,Y,length(Y),stepwiseNumberOfVariables(i));
    
    % LASSO
    for l = 1:100
        %bTemp = zeros(size(X,2),1);
        bTemp = bLASSOArray(i,l,:);
        bTemp = reshape(bTemp,[size(bTemp,3),1,1]);
        YpredLASSO =  [ones(length(X),1) Xnorm]*bTemp;
        
        R2LASSOTest(i,l) = Rsq(YpredLASSO,Y);
        AdjR2LASSOTest(i,l) = adjRsq(YpredLASSO,Y,length(Y),length(bTemp));
    end
    
    % Find optimal LASSO model and save metrics
    [maximum,argMax] = max( AdjR2LASSOTest(i,:) );
    optimalLambda = info.Lambda(argMax);
    AdjR2Test(i,5) = maximum;
    R2Test(i,5) = R2LASSOTest(i,argMax);
    
    AdjR2Training(i,5) = AdjR2LASSOTraining(i,argMax);
    R2Training(i,5) = R2LASSOTraining(i,argMax);
    
    bTemp = bLASSOArray(i,argMax,:);
    bTemp = reshape(bTemp,[size(bTemp,3),1,1]);
    YpredLASSO =  [ones(length(X),1) Xnorm]*bTemp;
    
    % PLS
    for l = 1:length(numberOfComponents)
        bTemp = bPLSArray(i,l,:);
        bTemp = reshape(bTemp,[size(bTemp,3),1,1]);
        YpredPLS =  [ones(length(X),1) normalize(X,PLSNormalisationType(i))]*bTemp;
        
        R2PLSTest(i,l) = Rsq(YpredPLS,Y);
        AdjR2PLSTest(i,l) = adjRsq(YpredPLS,Y,length(Y),numberOfComponents(i));
    end
    
    % Find optimal PLS model and save metrics
    [maximum,argMax] = max( AdjR2PLSTest(i,:) );
    optimalNumComponets = argMax;
    AdjR2Test(i,6) = maximum;
    R2Test(i,6) = R2PLSTest(i,argMax);
    
    AdjR2Training(i,6) = AdjR2PLSTraining(i,argMax);
    R2Training(i,6) = R2PLSTraining(i,argMax);
    
    % Optimal PLS model prediction
    bTemp = bPLSArray(i,argMax,:);
    bTemp = reshape(bTemp,[size(bTemp,3),1,1]);
    YpredPLS =  [ones(length(X),1) normalize(X,PLSNormalisationType(i))]*bTemp;
    
    % Comparison Plot of PLS models
    figure;
%     subplot(1,2,1);
    plot(numberOfComponents,AdjR2PLSTest(i,:));
    title("PLS models Adjusted R^2 in test set")
    xlabel("Number of components")
    ylabel("Adjusted R2")
    
%     % Comparison Plot of LASSO models
%     subplot(1,2,2);
%     plot(info.Lambda',AdjR2LASSOTest(i,:)');
%     title("LASSO models Adjusted R^2 in the test set")
%     xlabel("Lambda")
%     ylabel("Adjusted R2")
%     

    % Find the best regression and compare it to LASSO and PLS
    [~,bestRegression] = max(AdjR2Test(i,1:4));

    % Plot the best regression
    figure;
    subplot(1,3,1);
    plot(1:length(deathsSecondWave),deathsSecondWave);
    hold on;
    plot(1:length(deathsSecondWave),movmean(deathsSecondWave,7),"--");
    hold on;
    
    switch bestRegression
        case 1
            plot(21:n2,YpredFull,"LineWidth",1.5,"Color","m");
            title("Second wave deaths in " + countryList(i) +" and full linear regression ");
            legend("Deaths","Deaths 7-Day moving average","Full Linear Regression");
    
        case 2
            plot(21:n2,YpredFullNorm,"LineWidth",1.5,"Color","c");
            title("Second wave deaths in " + countryList(i) +" and normalised full linear regression ");
            legend("Deaths","Deaths 7-Day moving average","Normalised Full Linear Regression");
            
        case 3
            plot(21:n2,YpredStep,"LineWidth",1.5,"Color","m")
            title("Second wave deaths in " + countryList(i) +" and stepwise regression (" + stepwiseNumberOfVariables(i) + " variables)");
            legend("Deaths","Deaths 7-Day moving average","Stepwise Regression");
    
        case 4
            plot(21:n2,YpredStepNorm,"LineWidth",1.5,"Color","c")
            title("Second wave deaths in " + countryList(i) +" and normalised stepwise regression (" + stepwiseNumberOfVariables(i) + " variables)");
            legend("Deaths","Deaths 7-Day moving average","Normalised Stepwise Regression");
    end

    % PLOT LASSO
    subplot(1,3,2);
    plot(1:length(deathsSecondWave),deathsSecondWave);
    hold on;
    plot(1:length(deathsSecondWave),movmean(deathsSecondWave,7),"--");
    hold on;
    plot(21:n2,YpredLASSO,"LineWidth",1.5,"Color","b");
    title("Second wave deaths in " + countryList(i))
    legend("Deaths","Deaths 7-Day moving average","LASSO (lambda = " + num2str(optimalLambda) + ")");

    % PLOT PLS
    subplot(1,3,3);
    plot(1:length(deathsSecondWave),deathsSecondWave);
    hold on;
    plot(1:length(deathsSecondWave),movmean(deathsSecondWave,7),"--");
    hold on;
    plot(21:n2,YpredPLS,"LineWidth",1.5,"Color","r");
    title("Second wave deaths in " + countryList(i))
    legend("Deaths","Deaths 7-Day moving average","PLS (components = " + num2str(optimalNumComponets) +")");
    
end

% Create tables to display
tablesFullRegression = cell(length(countryList));
tablesStepwiseRegression = cell(length(countryList));
tablesLASSO = cell(length(countryList));
tablesPLS = cell(length(countryList));
for i = 1:length(countryList)
    tablesFullRegression{i} = table([R2Training(i,1);R2Test(i,1)],[AdjR2Training(i,1);AdjR2Test(i,1)],[R2Training(i,2);R2Test(i,2)],[AdjR2Training(i,2);AdjR2Test(i,2)],'VariableNames',{'R2','AdjR2','Normalization_R2','Normalization_AdjR2'},'RowName',{'Training Set','Test Set'});
    tablesStepwiseRegression{i} = table([R2Training(i,3);R2Test(i,3)],[AdjR2Training(i,3);AdjR2Test(i,3)],[R2Training(i,4);AdjR2Test(i,4)],[R2Training(i,4);AdjR2Test(i,4)],'VariableNames',{'R2','AdjR2','Normalization_R2','Normalization_AdjR2'},'RowName',{'Training Set','Test Set'});
    tablesLASSO{i} = table([R2Training(i,5); R2Test(i,5)],[AdjR2Training(i,5); AdjR2Test(i,5)],'VariableNames',{'R2','AdjR2'},'RowName',{'Training Set','Test Set'});
    tablesPLS{i} = table([R2Training(i,6); R2Test(i,6)],[AdjR2Training(i,6); AdjR2Test(i,6)],'VariableNames',{'R2','AdjR2'},'RowName',{'Training Set','Test Set'});
end


% Display Results
disp("Displaying Results:")
disp(newline);
for i = 1:length(countryList)
    disp(countryList(i) + " results:");
    disp("Full Linear Regression:");
    disp(tablesFullRegression{i});
    disp("Stepwise Regression:");
    disp(tablesStepwiseRegression{i});
    disp("LASSO Regression:");
    disp(tablesLASSO{i})
    disp("PLS Regression:");
    disp(tablesPLS{i})
    disp(newline);
end

%%%%% Sumperasmata - Sxolia %%%%%%
%
% Se auto to zhthma xrhsimopoieisame tis methodous palindromhshs LASSO kai
% PLS. Epeita, tis sugkriname me tis methodous Stepwise kathws kai me to
% plhres montelo palindromhshs.
%
% Parathrhthke to idio problhma me to zhthma 7 sto deutero kuma. Logw ths
% diaforas ths sumperiforas twn krousmatwn-thanatwn, h apodosh twn montelwn
% palindromhshs htan kakh. Gia na luthei auto to problhma, pali efarmosame
% normalisation sta dedomena epkpaideushs kai elegxou.
%
