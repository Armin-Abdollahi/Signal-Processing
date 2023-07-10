%% Definition of signal and parameters
fs = 1000;                            % sampling rate (Hz)
t = 0:1/fs:1-1/fs;                    % time axis
f1 = 10;                              % frequency of the first sine
f2 = 50;                              % frequency of the second sine
x = sin(2*pi*f1*t) + sin(2*pi*f2*t);  % input signal
plot(x);

%% Using the steganogram function
[S,F,T,P] = spectrogram(x,hamming(256),128,256,fs,'yaxis');

%% Steganogram drawing
figure
surf(T,F,10*log10(P),'edgecolor','none');
axis tight;
view(0,90);
xlabel('Time (seconds)');
ylabel('Frequency (Hz)');
title('signal steganography');
colorbar;