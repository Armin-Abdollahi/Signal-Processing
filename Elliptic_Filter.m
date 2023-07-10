%% Making a signal
fs = 1000;                   % sampling frequency (Hz)
t = 0:1/fs:1-1/fs;           % time axis
f = 10;                      % signal frequency (Hz)
x = sin(2*pi*f*t);           % Making signal with frequency f

%% applying noise to the signal
SNR = 10;                                                % signal to noise ratio (dB)
noise = randn(size(x));                                  % noise generation with Gaussian distribution
noise = noise / norm(noise) * norm(x) / (10^(SNR/20));   % Comparison of noise and signal energy based on SNR
x_noisy = x + noise;                                     % Adding noise to the signal

%% Apply elliptic filter
[n, Wn] = ellipord(40/100, 50/100, 3, 30); % Calculation of degree and filter coefficients
[b, a] = ellip(n, 3, 30, 40/100);      % Elliptic filter design
freqz(b,a)
x_filtered = filter(b, a, x_noisy); % Apply filter on noisy signal

%% Show the main signal, noisy signal and signal after filter application
figure
subplot(3,1,1);
plot(t,x);
title('main signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(3,1,2);
plot(t,x_noisy);
title('Noisy signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(3,1,3);
plot(x_filtered);
title('signal after applying the filter');
xlabel('Time (s)');
ylabel('Amplitude');