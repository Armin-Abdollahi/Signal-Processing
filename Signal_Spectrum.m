%% 
N=100;fs=200;f1=35;
X=sin(2*pi*(1:N)*f1/fs)+rand(1,N);
plot(X);

%%
W=triang(N);
X=X'.*W;
figure;
plot(X);

%%
Y=fft(X,N);
Pyy = sqrt((Y.* conj(Y))) /(0.5*N);
figure;
plot(Pyy(1:N/2));