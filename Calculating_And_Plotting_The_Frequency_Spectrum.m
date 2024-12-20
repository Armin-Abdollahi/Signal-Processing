% Add the path to the required libraries
addpath('C:\Users\ASUS\Documents\MATLAB\eeglab2024.2.1'); 
eeglab; % EEGLAB execution

% Folder paths
folder1 = 'D:\Master\5_Semester\Master_Thesis\Dissertation_Dataset\BCI_Database\Signals\Changed_Signals\5\00\R';
folder2 = 'D:\Master\5_Semester\Master_Thesis\Dissertation_Dataset\BCI_Database\Signals\Changed_Signals\5\00\L';

% Reading .gdf files from folders
files1 = dir(fullfile(folder1, '*.gdf'));
files2 = dir(fullfile(folder2, '*.gdf'));

% Set sampling frequency
fs = 512; % Sampling frequency 512 Hz

% Calculate the frequency spectrum of signals
for i = 1:length(files1)
    EEG1 = pop_biosig(fullfile(folder1, files1(i).name));
    EEG2 = pop_biosig(fullfile(folder2, files2(i).name));
    
    signal1 = EEG1.data;
    signal2 = EEG2.data;
    
    % Remove NaN values ​​from signals
    signal1 = signal1(:, all(~isnan(signal1)));
    signal2 = signal2(:, all(~isnan(signal2)));
    
    % Number of samples
    N1 = length(signal1);
    N2 = length(signal2);
    
    % FFT calculation
    Y1 = fft(signal1, N1, 2);
    Y2 = fft(signal2, N2, 2);
    
    % Calculate the range
    amplitude1 = abs(Y1/N1);
    amplitude2 = abs(Y2/N2);
    
    % Calculate frequencies
    f1 = fs*(0:(N1/2))/N1;
    f2 = fs*(0:(N2/2))/N2;
    
    % Frequency spectrum plotting
    figure;
    subplot(2,1,1);
    plot(f1, amplitude1(:,1:N1/2+1));
    title('Frequency Spectrum - Right Hand');
    xlabel('Frequency (Hz)');
    ylabel('Amplitude');
    
    subplot(2,1,2);
    plot(f2, amplitude2(:,1:N2/2+1));
    title('Frequency Spectrum - Left Hand');
    xlabel('Frequency (Hz)');
    ylabel('Amplitude');
end