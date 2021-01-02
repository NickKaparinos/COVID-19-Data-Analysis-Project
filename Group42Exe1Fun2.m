function [startSecondWave,endSecondWave] = Group42Exe1Fun2(cases)
    % This function is used to find the start and end of the second wave
    totalNumberOfCasesSecondWave = sum(cases(200:end));
    
    thresholdCasesSecond = 0.0012*totalNumberOfCasesSecondWave;
    
    casesMovingAverage = movmean(cases(200:end),7);
    startFound = false;
    endFound = false;
    j = 200;
    while( j<=size(cases,2))
        difference = casesMovingAverage(j-199) - thresholdCasesSecond;
        if(~startFound)
            if( difference>0 )
                startFound = true;
                startSecondWave = j;
                j = j + 30;
                continue;
            end
        else
            if( difference<0 )
                endFound = true;
                endSecondWave = j;
                break;
            end
        end
        j = j + 1;
    end
    if(~endFound)
        endSecondWave = size(cases,2);
    end
    
    
end