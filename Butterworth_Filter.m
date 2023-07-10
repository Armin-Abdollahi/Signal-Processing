%% Signal construction parameters
fs = 100;          % Sampling frequency (Hz)
t = 0:1/fs:1;      % Period (s)
f = 1;             % Signal frequency (Hz)
A = 1;             % The maximum value of the signal

%% Signal construction
x = A*sin(2*pi*f*t);

%% Apply noise
SNR = 10;          % Noise power to signal power (dB)
y = awgn(x, SNR, 'measured');

%% Apply the Butterworth filter
fc = 0.2;          % Filter cutoff frequency
[b,a] = butter(6, fc/(fs/2));
z = filter(b, a, y);

%% Display the signals
figure;
subplot(3,1,1);
plot(t,x);
title('Original Signal');
xlabel('Time (s)');
ylabel('Amount');

subplot(3,1,2);
plot(t,y);
title('Noisy Signal');
xlabel('Time (s)');
ylabel('Amount');

subplot(3,1,3);
plot(t,z);
title('The signal after applying the Butterworth filter');
xlabel('Time (s)');
ylabel('Amount');