N = 1024;
idxes = 0:(N-1);
phase = idxes/N*2*pi;
dp = 0.01;
np = 500;
results_arr = zeros(0,np);
f_arr = zeros(0,np);
window = hamming(N)';
for f= 0:np-1
  a = exp(j*phase*dp*f).*window;
  results_arr(f+1) = max(abs(fft(a)));
  f_arr(f+1)=dp*f;
 endfor
 plot(f_arr,20*log10(results_arr/max(results_arr)))
 xlabel('Frequency, sample');
ylabel('Magnitude (dB)');
