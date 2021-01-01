function [startFirstWave,endFirstWave] = Group42Exe1Fun1(cases)
    % This function is used to find the start and end of the first wave
    totalNumberOfCasesFirstWave = sum(cases(1:200));

    thresholdCasesFirst = 0.0025*totalNumberOfCasesFirstWave;

    % Find 1st wave
    casesMovingAverage = movmean(cases,7);
    startFound = false;
    j = 1;
    while(j<=200)
        difference = casesMovingAverage(j) - thresholdCasesFirst;
        if(~startFound)
            if( difference>0 )
                startFound = true;
                startFirstWave = j;
                j = j + 30;
                continue;
            end
        else
            if( difference<0 )
                endFirstWave = j;
                break;
            end
        end
        j = j+1;
    end


end