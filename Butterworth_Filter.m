[A,B,C,D] = butter(10,[500 560]/750);
d = designfilt('bandpassiir','FilterOrder',20,'HalfPowerFrequency1',500,'HalfPowerFrequency2',560,'SampleRate',1500);

sos = ss2sos(A,B,C,D);
fvt = fvtool(sos,d,'Fs',1500);
legend(fvt,'butter','designfilt')