function bestDistribution = Group21Exe3Fun3(data,distributions)
% This function finds the distrubition that fits best the data based on MSE

normData = data./sum(data);
days = 1:length(data);
mse = zeros(length(distributions),1);
for i = 1:length(distributions)
    pd = fitdist(days',distributions{i},'Frequency',data);
    fittedPdf = pdf(pd,days);
    
    mse(i) = 1/(length(normData)-1)*sum((normData-fittedPdf').^2);
end
[~,indexMSE] = min(mse);
bestDistribution = distributions(indexMSE);
end


