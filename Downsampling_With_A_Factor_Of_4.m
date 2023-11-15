% Create a signal (a square wave)
Fs = 1000;
t = 0:1/Fs:1;
x = square(2*pi*5*t); % Square wave with frequency 5 Hz

% Downsample by 1/4
x_downsampled = downsample(x, 4);

% Plot the original and downsampled signals
subplot(2,1,1);
plot(t, x);
title('Original Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2,1,2);
t_downsampled = 0:1/(Fs/4):1;
plot(t_downsampled, x_downsampled);
title('Downsampled Signal (1/4)');
xlabel('Time (s)');
ylabel('Amplitude');