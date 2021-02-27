function [startFirstWave,endFirstWave] = Group21Exe1Fun1(data)
    % This function is used to find the start and end of the first wave
    % We define a threshold. The first wave starts when the moving average 
    % of the data first surpasses the threshold and ends when the moving
    % average subceeds it.

    % Observing the data, we assume that the first wave ended before day number 200
    totalNumberOfDataFirstWave = sum(data(1:200));

    % The first wave threshold that resulted from experimentation
    threshold = 0.0019485*totalNumberOfDataFirstWave;

    % Find 1st wave
    movingAverage = movmean(data,7);
    startFound = false;
    j = 1;
    while(j<=200)
        difference = movingAverage(j) - threshold;
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