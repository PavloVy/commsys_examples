close all;
% Filter specifications
order = 51;           % Filter order (higher order gives better performance)
cutoff = 0.3;         % Normalized cutoff frequency (0 to 1, where 1 corresponds to Nyquist frequency)

% Design the FIR filter using a Hamming window
b = fir1(order, cutoff, 'low', hamming(order+1));

% OR design FIR filter with kaiser:
beta = 11.5;  % Adjust beta for different trade-offs
b = fir1(order, cutoff, 'low', kaiser(order+1, beta));
figure;
subplot(2,1,1);
plot(b)
title('Filter coeficients');
xlabel('Time (sample)');
ylabel('Amplitude');
subplot(2,1,2);
filter_with_zeros = zeros(1,2048);
filter_with_zeros(1:numel(b))=b;
s = fft(filter_with_zeros);
s = s(1:numel(s)/2);
plot(linspace(0,1,numel(s)),20*log10(abs(s)))
title('Frequency response');
xlabel('Relative band');
ylabel('Amplitude, dB');

% Create a sample signal (sum of two sinusoids with different frequencies)
Fs = 1000;            % Sampling frequency
t = 0:1/Fs:1-1/Fs;    % Time vector
x = cos(2*pi*50*t) + cos(2*pi*200*t);  % Signal with two frequencies: 50 Hz and 200 Hz

% Parameters for the LFM signal
Fs = 1000;           % Sampling frequency (Hz)
T = 1;               % Duration of the signal (seconds)
f0 = 50;             % Start frequency (Hz)
f1 = 250;            % End frequency (Hz)
t = 0:1/Fs:T-1/Fs;   % Time vector

% Generate the LFM signal (chirp)
lfm_signal = chirp(t, f0, T, f1);
x = lfm_signal;

% Apply the FIR filter to the signal
y = filter(b, 1, x);

% Plot the original and filtered signals
figure;
subplot(2,1,1);
plot(t, x);
title('Original Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2,1,2);
plot(t, y);
title('Filtered Signal');
xlabel('Time (s)');
ylabel('Amplitude');

zeropadded_signal = zeros(1,2048);
zeropadded_signal(1:numel(y))=y;
noise = randn(1,2048);
signal_with_noize = circshift( zeropadded_signal+noise, 50);
figure;
subplot(2,1,1);
plot(zeropadded_signal)
hold on
plot(signal_with_noize)
title('Signal with noise')
cross_spectrum = fft(signal_with_noize).*conj(fft(zeropadded_signal));
cross_spectrum(1024:2048) = 0;
ccf = ifft(cross_spectrum);
subplot(2,1,2);
plot(abs(ccf))
title('Cross correlation')
