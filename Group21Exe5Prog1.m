% Data Analysis Project 2020-2021
% Nikos Kaparinos 9245
% Vasiliki Zarkadoula 9103
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
    % Read cases amd deaths
    [cases,deaths,~] = Group21Exe1Fun3(countryList(i));
    countryList(i) = strrep(countryList(i),"_"," ");            % Replace "_" because it is used for subscripts in plot titles
    
    % Find the start and end of the first wave using Group21Exe1Fun1
    [start1,end1] = Group21Exe1Fun1(cases);
    cases = cases(start1:end1)';
    deaths = deaths(start1:end1)';
    n = length(cases);
    
    % Graphs are ploted only for these delays for simplicity
    graphsToPlot = [0,6,13,20];    
    
    % Make sure the optimal delay is plotted for every country
    if( countryList(i) == "Belgium" || countryList(i) == "Netherlands" )
        graphsToPlot(2) = 5;
    end
    
    minRMSE = 1e6;
    argMin = -1;

    figure(i)
    j = 1;                                  % j is the subplot number
    for t = 0:20
        % Linear Regression Model
        X = cases(1:n-t);
        Y = deaths(1+t:n);
        regressionModel = fitlm(X,Y);

        % Diagnostic plot of standardised error
        if(ismember(t,graphsToPlot))
            ei_standard = regressionModel.Residuals.Raw/regressionModel.RMSE;
            subplot(2,2,j)
            scatter(Y,ei_standard);
            text(0.8*max(Y),-1,"RMSE="+regressionModel.RMSE,'FontSize',12);
            text(0.8*(max(Y)),-1.5,"R^2="+regressionModel.Rsquared.Ordinary,'FontSize',12);
            hold on;
            plot(xlim,[1.96 1.96]);
            hold on;
            plot(xlim,[0 0]);
            hold on;
            plot(xlim,[-1.96 -1.96]);
            title(countryList(i) + " Diagnostic Plot: t = " + t);
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
    
    % Optimal Regression
    rmseArray(i) = minRMSE;
    R2Array(i) = maxR2;
    optimalDelay(i) = argMin;
    t = argMin;
    X = cases(1:n-t);
    Y = deaths(1+t:n);
    regressionModel = fitlm(X,Y);
    b = regressionModel.Coefficients.Estimate;
    Ypred = [ones(length(X),1) X]*b;

    % Plot predictions vs ground truth for the optimal linear model
    figure(i+10);
    subplot(2,1,1)
    plot(1:length(deaths),deaths);
    hold on;
    plot(1:length(deaths),movmean(deaths,7),"--");
    hold on;
    plot(1+t:n,Ypred,"LineWidth",2,"Color","m");
    title("Deaths in " + countryList(i) +" and optimal normal linear regression (t=" + t + ")"); 
    legend("Deaths","Deaths 7-Day moving average","Optimal Normal Linear regression");
    xlabel("Days")
    ylabel("Deaths")
    
    subplot(2,1,2)
    scatter(X,Y);
    lsline;
    title(countryList(i) +" scatterplot and normal linear regression (t=" + t + ")"); 
    xlabel("Cases")
    ylabel("Deaths")
end

% Previous exercises results
exercise4Results = [0,5,6,6,13,5,0];
exercise3Results = [-17,-2,6,3,19,-3,-2];

% Display results
table = [rmseArray'; R2Array'; optimalDelay'; exercise4Results; exercise3Results];
table = array2table(table,'RowNames',{'RMSE','R2','Optimal t based on Regression RMSE','Optimal t based on correlation (Ex. 4 results)','Peak time delay (Ex. 3 results)'},'VariableNames',{'Greece','Belgium','Italy','France','Germany','Netherlands','United_Kingdom'});
disp(table);

%%%%% Sumperasmata - Sxolia %%%%%%
%
%  Parathroume oti h aplh grammikh palindromhsh den prosparmozetai to idio
%  kala gia oles tis xwres. Gia paradeigma, sthn palindromhsh ths Elladas
%  o suntelesths prosdiorismou exei timh 0.24, dhladh h prosarmogh den 
%  einai katholou kalh, enw ths Italias exei timh 0.85, dhladh h
%  prosparmogh einai arketa kalh. Dhladh, uparxoun xwres oi opoies exoun
%  upshlo suntelesth prosdiorismou kai epomenws mporei na ginei problepsh
%  twn thanatwn apo ta krousmata, enw alles exoun mikro suntelesth
%  prosdiorismou kai den mporei na ginei akribhs problepsh twn thanatwn
%  apo ta krousmata. Auta fainontai kai apo ta antistoixa diagrammata
%  palindromhshs.
% 
%  Apo ta diagnwstika diagrammata,  se merikes xwres (Belgio, Italia,
%  Germania, Olandia) parathroume mono ena mikro pattern sto diagramma gia
%  th beltisth usterhsh. Se autes tis xwres gia tis upoloipes usterhseis
%  kai stis alles xwres gia oles tis usterhseis, parathroume ena ksekatharo
%  pattern, dhladh ta sfalmata den parousiazoun tuxaiothta. Epipleon,
%  parathroume oti to diagragnwstiko diagramma ths beltisths usterhshs
%  parousiazei megaluterh tuxaiothta gia oles tis xwres.
% 
%  Epishs, parathroume oti h beltisth xronikh usterhsh palindromhshs kathe
%  xwras sumfwnei apoluta me thn usterhsh pou megistopoiei ton suntelesth
%  susxetishs sto zhthma 4. Epishs, stis perissoteres ta apotelesmata einai
%  konta me to apotelesma ths usterhshs korufwsewn tou zhthmatos 3.
%