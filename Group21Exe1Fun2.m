function [startSecondWave,endSecondWave] = Group21Exe1Fun2(data)
    % This function is used to find the start and end of the second wave
    % We define a threshold. The second wave starts when the moving average 
    % of the data first surpasses the threshold and ends when the moving
    % average subceeds it.
    
    % Observing the data, we assume that the second wave started after day number 200
    totalNumberOfDataSecondWave = sum(data(200:end));
    
    % The second wave threshold that resulted from experimentation
    threshold = 0.0012*totalNumberOfDataSecondWave;
    
    % Find 2nd wave
    movingAverage = movmean(data(200:end),7);
    startFound = false;
    endFound = false;
    j = 200;
    while( j<=size(data,2))
        difference = movingAverage(j-199) - threshold;
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
        endSecondWave = size(data,2);
    end
end