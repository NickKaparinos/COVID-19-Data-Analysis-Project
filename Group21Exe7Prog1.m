% Data Analysis Project 2020-2021
% Nikos Kaparinos 9245
% Vasiliki Zarkadoula 9103
% Exercise 7: Regression second wave
close all;
clc;
clear;

% Function handles
Rsq = @(ypred,y) 1-sum((ypred-y).^2)/sum((y-mean(y)).^2);
adjRsq = @(ypred,y,n,k) ( 1 - (n-1)/(n-1-k)*sum((ypred-y).^2)/sum((y-mean(y)).^2) );

% Selected Countries
countryList = ["Greece","Belgium","Italy","France","Germany","Netherlands","United_Kingdom"];

R2Training = zeros(length(countryList),4);
AdjR2Training = zeros(length(countryList),4);
R2Test = zeros(length(countryList),4);
AdjR2Test = zeros(length(countryList),4);
stepwiseNumberOfVariables = zeros(length(countryList));

for i = 1:length(countryList)
    %%% First Wave %%%
    % Read cases and deaths
    [cases,deaths,~] = Group21Exe1Fun3(countryList(i));
    
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
    
    % Normalised Full Linear Regression Model
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
    stepwiseNumberOfVariables(i) = length(bStep) - 1;
    
    % Training R2 and adjR2
    R2Training(i,3) = 1 - stats.SSresid/stats.SStotal;
    AdjR2Training(i,3) = adjRsq(YpredStep,Y,length(Y),stepwiseNumberOfVariables(i));
    
    % Normalised Stepwise regression
    [bStepNorm,~,~,modelStepNorm,stats] = stepwisefit(Xnorm,Y,'Display','off');
    bStepNorm = [stats.intercept; bStepNorm(modelStepNorm)];
    YpredStepNorm = [ones(length(Xnorm),1) Xnorm(:,modelStepNorm)]*bStepNorm;
    
    % Training R2 and adjR2
    R2Training(i,4) = 1 - stats.SSresid/stats.SStotal;
    AdjR2Training(i,4) = adjRsq(YpredStepNorm,Y,length(Y),stepwiseNumberOfVariables(i));
    
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
    
    % Save testinf R2 and AdjR2
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
    
    
    % Plot second wave deaths and full linear regression
    
    % Not normalised
    countryList(i) = strrep(countryList(i),"_"," ");
    figure;
    subplot(1,2,1);
    plot(1:length(deathsSecondWave),deathsSecondWave);
    hold on;
    plot(1:length(deathsSecondWave),movmean(deathsSecondWave,7),"--");
    hold on;
    plot(21:n2,YpredFull,"LineWidth",1.5,"Color","b");
    title("Second wave deaths in " + countryList(i) +" and full linear regression ");
    legend("Deaths","Deaths 7-Day moving average","Full Linear Regression");
    xlabel("Days")
    ylabel("Deaths")
    
    % Normalised
    subplot(1,2,2);
    plot(1:length(deathsSecondWave),deathsSecondWave);
    hold on;
    plot(1:length(deathsSecondWave),movmean(deathsSecondWave,7),"--");
    hold on;
    plot(21:n2,YpredFullNorm,"LineWidth",1.5,"Color","r");
    title("Second wave deaths in " + countryList(i) +" and normalised full linear regression ");
    legend("Deaths","Deaths 7-Day moving average","Normalised Full Linear Regression");
    xlabel("Days")
    ylabel("Deaths")
    
    % Plot second wave deaths and stepwise regression
    % Not normalised
    figure;
    subplot(1,2,1)
    plot(1:length(deathsSecondWave),deathsSecondWave);
    hold on;
    plot(1:length(deathsSecondWave),movmean(deathsSecondWave,7),"--");
    hold on;
    plot(21:n2,YpredStep,"LineWidth",1.5,"Color","b")
    title("Second wave deaths in " + countryList(i) +" and stepwise regression (" + stepwiseNumberOfVariables(i) + " variables)");
    legend("Deaths","Deaths 7-Day moving average","Stepwise Regression");
    xlabel("Days")
    ylabel("Deaths")
    
    % Normalised
    subplot(1,2,2)
    plot(1:length(deathsSecondWave),deathsSecondWave);
    hold on;
    plot(1:length(deathsSecondWave),movmean(deathsSecondWave,7),"--");
    hold on;
    plot(21:n2,YpredStepNorm,"LineWidth",1.5,"Color","r")
    title("Second wave deaths in " + countryList(i) +" and normalised stepwise regression (" + stepwiseNumberOfVariables(i) + " variables)");
    legend("Deaths","Deaths 7-Day moving average","Normalised Stepwise Regression");
    xlabel("Days")
    ylabel("Deaths")
    
end

% Create tables to display
tablesFullRegression = cell(length(countryList));
tablesStepwiseRegression = cell(length(countryList));
for i = 1:length(countryList)
    tablesFullRegression{i} = table([R2Training(i,1);R2Test(i,1)],[AdjR2Training(i,1);AdjR2Test(i,1)],[R2Training(i,2);R2Test(i,2)],[AdjR2Training(i,2);AdjR2Test(i,2)],'VariableNames',{'R2','AdjR2','Normalization_R2','Normalization_AdjR2'},'RowName',{'Training Set','Test Set'});
    tablesStepwiseRegression{i} = table([R2Training(i,3);R2Test(i,3)],[AdjR2Training(i,3);AdjR2Test(i,3)],[R2Training(i,4);R2Test(i,4)],[AdjR2Training(i,4);AdjR2Test(i,4)],'VariableNames',{'R2','AdjR2','Normalization_R2','Normalization_AdjR2'},'RowName',{'Training Set','Test Set'});
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
    disp(newline);
end

%%%%% Sumperasmata - Sxolia %%%%%%
%
% Exetazontas ta dedomena, sumperainoume oti ta dedomena twn duo kumatwn
% diaferoun polu. Sugkekrimena, sto deutero kuma gia ton idio arithmo
% krousmatwn, uparxoun polloi ligoteroi thanatoi. Epomenws, ena modelo
% ekpaideumeno me ta dedomena tou prwtou kumatos, de tha mporouse na kanei
% akribeis problepseis sto deutero kuma. Gia auto to logo, dokimasame na
% kanonikopoihsoume ta dedomena ekpaideushs kai elegxou.
%
% Parathroume apo ta diagrammata kai apo tis metrikes, oti xwris th xrhsh
% normalisation, ta montela palindromhshs de mporoun na kanoun katholou
% akribeis problepseis. Monh eksairesh apotelei h Ellada, sthn opoia ta
% ta montela ekanan pio akribeis problepseis xwris th xrhsh normalisation.
% Dokimasthkan diaforetikes methodoi kanonikopoihshs kai h kalyterh htan h
% methodos range, h opoia kanonikopoiei ta dedomena sto diasthma [0 1].
%
% Sugkrinontas ton prosarmosmeno suntelesth prosdiorismou gia ta  montela 
% plhrous kai stepwise palindromhshs, sumperainoume oti to stepwise modelo
% upertairei, me monh eksairesh th Germania.
%
% Sunolika, akoma kai to beltisto montelo se kathe periptwsh de mporei na
% kanei akribeis problepseis, me monh eksairesh th Germania.
%
% Enas problhmatismos mas einai h xrhsh normalization sta dedomena elegxou.
% Kanontas kanonikopoihsh prin apo thn problepsh, exoume eksagei
% plhroforia, kati to opoio genika den einai epithumhto.