n = 5;
fc = 2e9;

[ze,pe,ke] = ellip(n,3,30,2*pi*fc,"s");
[be,ae] = zp2tf(ze,pe,ke);
[he,we] = freqs(be,ae,4096);

plot([we]/(2e9*pi), ...
    mag2db(abs([he])))
axis([0 5 -45 5])
grid
xlabel("Frequency (GHz)")
ylabel("Attenuation (dB)")
legend(["ellip"])