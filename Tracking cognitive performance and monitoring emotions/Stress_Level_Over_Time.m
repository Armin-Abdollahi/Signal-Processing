% Add EEGLAB path
addpath('C:\Users\ASUS\Documents\MATLAB\eeglab2024.2');

% EEGLAB launch
eeglab;

% Read GDF file
EEG = pop_biosig('C:\Users\ASUS\Documents\A1_R1_acquisition.gdf');

% Signal extraction and sampling frequency
rawSignal = double(EEG.data(1, :)); % Using the first channel
fs = EEG.srate;

% Time window settings
windowSize = 2 * fs; % 2 second window
overlap = windowSize / 2; % 50% overlap

% Calculate and display stress over time
calculateAndPlotStress(rawSignal, fs, windowSize, overlap);

function calculateAndPlotStress(signal, fs, windowSize, overlap)
    % Calculate the number of windows
    numWindows = floor((length(signal) - overlap) / (windowSize - overlap));
    
    % Prepare arrays to store results
    stressIndex = zeros(1, numWindows);
    timePoints = zeros(1, numWindows);
    
    % Calculate stress index for each window
    for i = 1:numWindows
        startIdx = (i-1)*(windowSize-overlap) + 1;
        endIdx = startIdx + windowSize - 1;
        
        % Signal window extraction
        windowSignal = signal(startIdx:endIdx);
        
        % FFT calculation
        Y = fft(windowSignal);
        P2 = abs(Y/windowSize);
        P1 = P2(1:windowSize/2+1);
        P1(2:end-1) = 2*P1(2:end-1);
        f = fs * (0:(windowSize/2))/windowSize;
        
        % Calculation of power of frequency bands
        thetaPower = mean(P1(f >= 4 & f <= 8));
        betaPower = mean(P1(f >= 13 & f <= 30));
        
        % Stress Index Calculation
        stressIndex(i) = betaPower / thetaPower;
        
        % Calculate the window's central time
        timePoints(i) = (startIdx + endIdx) / (2 * fs);
    end
    
    % Show results
    figure;
    plot(timePoints, stressIndex, 'LineWidth', 2);
    title('Stress Index Over Time');
    xlabel('Time (s)');
    ylabel('Stress Index (Beta/Theta Power Ratio)');
    
    % Add reference lines
    hold on;
    yline(mean(stressIndex), 'r--', 'Average Stress', 'LineWidth', 1.5);
    yline(mean(stressIndex) + std(stressIndex), 'g--', 'High Stress', 'LineWidth', 1.5);
    yline(mean(stressIndex) - std(stressIndex), 'b--', 'Low Stress', 'LineWidth', 1.5);
    hold off;
    
    % Set chart range
    ylim([0, max(stressIndex) * 1.1]);
    
    % Add description
    legend('Stress Index', 'Average', 'High Stress', 'Low Stress');
    grid on;
end