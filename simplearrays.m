close all;

function p = timeAndFreqPlots(a,s,fc)
  % this function will plot a couple of plots for you
  a=a+0*j;
  N = size(a)(2);
  idxes = 0:(N-1);
  figure(fc)

  subplot(2,1,1)
  p = plot(idxes,[real(a);imag(a);abs(a);-abs(a)])
  title('Real amd imaginary parts of timedomain')

  subplot(2,1,2)
  plot(20*log10(abs(s).'))
  title('Spectrum of timedomain')

endfunction

function time_and_histo(a,fc)
  % Thif function will plot original signal and its histogram
  N = size(a)(2);
  idxes = 0:(N-1);
  figure(fc)

  subplot(2,1,1)
  p = plot(idxes,real(a))
  title('Original signal')

  subplot(2,1,2)
  hist(abs(a),100)
  title('Histogram of real part')


endfunction

% first test. Array of 32 samples to check how the signal are generated
N = 32;
idxes = 0:(N-1);
phase = idxes/N*2*pi;

a = sin(phase);
size(a)
plot([a,a]);
title('Checking continuos sin')

% Large array just because we can (will work well with 512 samples)
N = 1024;
idxes = 0:(N-1);
phase = idxes/N*2*pi;

a = sin(phase*100);
a(30:N)=0;

s = zeros(1,N);
min_sp = 5;
mx_spectrum = 10;
s(min_sp:min_sp+mx_spectrum-1) = randn(1,mx_spectrum)+i*randn(1,mx_spectrum);
a = ifft(s);

%time_and_histo(a,10);

s = fft(a);
timeAndFreqPlots(a,s,1);


s(N/2:N)=0;
s = s*2;
a_compl = ifft(s);

for k=0:35
  %Rotating linear phase shift (because depends on sample number (see indexes))
  %additional_phase =  idxes/N*2*pi*k*3;
  %Rotating contstant phase multiplier
  additional_phase = k/25*2*pi;
  frequency_response = exp(-i*additional_phase);
  s_inner = s.*frequency_response;
  a_inner = ifft(s_inner);
  p = timeAndFreqPlots(a_inner,s_inner,2);
  %fname= strcat('img',num2str(k),'.png')
  %print("-dpng","-S1000,500",fname)
  drawnow;

endfor



