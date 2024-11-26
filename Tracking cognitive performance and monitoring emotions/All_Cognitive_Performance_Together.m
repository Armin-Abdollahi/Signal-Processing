% Add EEGLAB path
addpath('C:\Users\ASUS\Documents\MATLAB\eeglab2024.2');

% Start EEGLAB
eeglab;

% Read GDF file
EEG = pop_biosig('C:\Users\ASUS\Documents\A1_R1_acquisition.gdf');

% Extract signal and sampling frequency
rawSignal = double(EEG.data(1, :)); % Use the first channel
fs = EEG.srate;

% Set up the time window
windowSize = 2 * fs; % 2-second window
overlap = windowSize / 2; % 50% overlap

% Prepare for graphical display
figure;

% Loop to process data and update the graph
while true
    % Calculate the number of windows
    numWindows = floor((length(rawSignal) - overlap) / (windowSize - overlap));
    
    % Prepare arrays to store results
    attentionIndex = zeros(1, numWindows);
    engagementIndex = zeros(1, numWindows);
    excitementIndex = zeros(1, numWindows);
    interestIndex = zeros(1, numWindows);
    relaxationIndex = zeros(1, numWindows);
    stressIndex = zeros(1, numWindows);
    timePoints = zeros(1, numWindows);
    
    % Calculate indices for each window
    for i = 1:numWindows
        startIdx = (i-1)*(windowSize-overlap) + 1;
        endIdx = startIdx + windowSize - 1;
        
        % Extract signal window
        windowSignal = rawSignal(startIdx:endIdx);
        
        % Perform FFT
        Y = fft(windowSignal);
        P2 = abs(Y/windowSize);
        P1 = P2(1:windowSize/2+1);
        P1(2:end-1) = 2*P1(2:end-1);
        f = fs * (0:(windowSize/2))/windowSize;
        
        % Calculate band powers
        alphaPower = mean(P1(f >= 8 & f <= 12));
        betaPower = mean(P1(f >= 13 & f <= 30));
        thetaPower = mean(P1(f >= 4 & f <= 8));
        gammaPower = mean(P1(f >= 30 & f <= 50));
        
        % Calculate indices
        attentionIndex(i) = betaPower / alphaPower;     % Attention: Beta/Alpha
        engagementIndex(i) = betaPower / gammaPower;    % Engagement: Beta/Gamma
        excitementIndex(i) = gammaPower / betaPower;    % Excitement: Gamma/Beta
        interestIndex(i) = betaPower / alphaPower;      % Interest: Beta/Alpha (repeated)
        relaxationIndex(i) = alphaPower / thetaPower;   % Relaxation: Alpha/Theta
        stressIndex(i) = betaPower / thetaPower;        % Stress: Beta/Theta
        
        % Calculate the center time of the window relative to the total signal length
        timePoints(i) = (startIdx + endIdx) / (2 * fs); 
    end
    
    % Plot indices in separate subplots
    subplot(6, 1, 1); % Attention
    plot(timePoints, attentionIndex, 'Color', [0.0, 0.5, 0.0], 'LineWidth', 2); 
    title('Attention Index');
    ylabel('Attention');
    grid on;

    subplot(6, 1, 2); % Engagement
    plot(timePoints, engagementIndex, 'Color', [0.5, 0.5, 0.0], 'LineWidth', 2); 
    title('Engagement Index');
    ylabel('Engagement');
    grid on;

    subplot(6, 1, 3); % Excitement
    plot(timePoints, excitementIndex, 'Color', [0.85, 0.33, 0.10], 'LineWidth', 2); 
    title('Excitement Index');
    ylabel('Excitement');
    grid on;

    subplot(6, 1, 4); % Interest
    plot(timePoints, interestIndex, 'Color', [0.0, 0.7, 0.7], 'LineWidth', 2); 
    title('Interest Index');
    ylabel('Interest');
    grid on;

    subplot(6, 1, 5); % Relaxation
    plot(timePoints, relaxationIndex, 'Color', [0.0, 0.0, 0.5], 'LineWidth', 2); 
    title('Relaxation Index');
    ylabel('Relaxation');
    grid on;

    subplot(6, 1, 6); % Stress
    plot(timePoints, stressIndex, 'Color', [1.0, 0.0, 0.0], 'LineWidth', 2); 
    title('Stress Index');
    ylabel('Stress');
    xlabel('Time (s)');
    grid on;

    
    % Update the graphics
    drawnow;
    
    % End the loop after one execution and display the plots only once.
    break; 
end

% Calculate the average for each index for the pie chart
meanAttention = mean(attentionIndex);
meanEngagement = mean(engagementIndex);
meanExcitement = mean(excitementIndex);
meanInterest = mean(interestIndex);
meanRelaxation = mean(relaxationIndex);
meanStress = mean(stressIndex);

% Data for pie chart
dataForPieChart = [meanAttention, meanEngagement, meanExcitement,...
                   meanInterest, meanRelaxation, meanStress];

% Section names for labeling
labelsForPieChart = {'Attention', 'Engagement', 'Excitement', ...
                     'Interest', 'Relaxation', 'Stress'};

% Draw the pie chart with percentages inside and section names alongside
figure;
hPieChart = pie(dataForPieChart); 

% Add percentage to each section of the pie chart and index names inside the sections
percentValues = dataForPieChart / sum(dataForPieChart) * 100; % Calculate percentages

for k = 1:length(hPieChart)
   if mod(k,2) == 0 % Only label the sections corresponding to percentages.
       percentageText = sprintf('%.1f%%', percentValues(k/2)); % Format the percentage.
       labelText = sprintf('%s\n%s', labelsForPieChart{k/2}, percentageText); % Combine name and percentage.
       hPieChart(k).String = labelText; % Add label to the section.
   end
end

title('Average EEG Indices Pie Chart');

hold off;