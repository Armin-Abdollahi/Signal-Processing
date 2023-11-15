% Create a signal (a sine wave)
Fs = 1000;             % Sampling frequency (in Hz)
t = 0:1/Fs:1;          % Time vector
x = sin(2*pi*10*t);    % A sine wave with frequency 10 Hz

% Downsample by 1/2
x_downsampled = downsample(x, 2);

% Plot the original and downsampled signals
subplot(2,1,1);
plot(t, x);
title('Original Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2,1,2);
t_downsampled = 0:1/(Fs/2):1;
plot(t_downsampled, x_downsampled);
title('Downsampled Signal (1/2)');
xlabel('Time (s)');
ylabel('Amplitude');