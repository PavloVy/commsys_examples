a = randn(1,1024);
b = fft(a);
c = ifft(abs(b).^2);
c = c/max(c);
plot(fftshift(20*log10(abs(c))))
