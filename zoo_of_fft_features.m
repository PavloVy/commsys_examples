close all;
% We want to construct a pulse shape which would satisfy the Nyquist theorem
% from the lectures.

% We start with time and frequency scales
duration = 0.001024; # I wanted 1024 samples, for more effective FFT.
sampling_rate = 1000000;
dt =  1/sampling_rate;
num_samples = sampling_rate*duration;
times = (0:num_samples-1)*dt;
df = 1/duration;
frequencies =  (0:num_samples-1)*df;

f = sampling_rate/256;

% Here you may switch between sine signal and a rectangular pulse. Both sine and
% pulse will show the nasty properties of the DFT (FFT).
sine_sig = false;
% Here you may modify sine signal frequency and see how it spoils the spectrum.
% If you put 1(one), for example, below, it will spoil the spectrum, and some
% form of 1/f will appear instead of -300dB beauty which used to be.
# "df/2" must be the worst case of this shift_the_freq.
shift_the_freq = df/2;

% Here we may switch between a long exp(-t) transfer function and a short rectangular one
long_transfer = true;

% making the signal
if (sine_sig)

  original_sig = sin(2*pi*times*(f+shift_the_freq));
else
  singal_start = 1;
  signal_len = 600;
  original_sig = zeros(1,length(times));
  original_sig(singal_start:singal_start+signal_len-1)= ones(1,signal_len);
endif

% Showing the signal
figure();
plot(times,original_sig);
title('Original signal');

% Showing the signal's spectrum
figure()
sp = fft(original_sig);
plot(frequencies,20*log10(abs(sp)));
title('Spectrum of the signal');

% Making a model of our transfer function (signal with which we'll convlolve).
if (long_transfer)
transfer_function = zeros(1,length(times));
transfer_function(1:600)= exp(-linspace(0,1.4,600));
else
transfer_function = zeros(1,length(times));
transfer_function(200:300)= ones(1,101);
endif

figure();
plot(transfer_function);

% Making our convolution (in fact, circular convolution).
presumably_convolved = ifft(sp.*fft(transfer_function));

% Showing the signal after the circular convolution.
figure()
plot(times,real(presumably_convolved))

