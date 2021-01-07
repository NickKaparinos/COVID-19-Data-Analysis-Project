function bestFit = Group21Exe3Fun3(data,distributions)
% This function finds the distrubition that fits best the data based on MSE
% and p-value metrics

% Find the empirical distribution of data
l = length(data);
m = max(data);
count = zeros(m+1,1);
for j=1:m+1
    count(j) = sum(data == j-1);
end
empiricalPdf = count/l;
range = 0:max(data);

% Find distrubition that fits best the data
pValues = zeros(length(distributions),1);
mse = zeros(length(distributions),1);
for i = 1:length(distributions)
     pd = fitdist(data,distributions{i});
     [~,pValues(i)] = chi2gof(data,'CDF',pd);
     fittedPdf = pdf(pd,range);
     mse(i) = 1/(length(empiricalPdf)-1)*sum((empiricalPdf-fittedPdf').^2);
end
[~,indexP] = max(pValues);
[~,indexMSE] = min(mse);

if indexP ~= indexMSE
    relativeDifP = abs(pValues(indexP)-pValues(indexMSE))/max(pValues(indexP),pValues(indexMSE));
    relativeDifMSE = abs(mse(indexP)-mse(indexMSE))/max(mse(indexP),mse(indexMSE));
    if relativeDifP > relativeDifMSE
        bestFit = distributions(indexP);
    else
        bestFit = distributions(indexMSE);
    end
else
    bestFit = distributions(indexP);
end


