close all
seq = mseq(2,10);
seq = [seq; zeros(size(seq)); zeros(size(seq))];
size(seq)
sp = fft(seq);
acf = ifft(abs(sp).^2);
plot(seq)
figure
plot(abs(acf))
