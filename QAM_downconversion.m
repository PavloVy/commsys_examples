close all;
fs = 1e6;       % Sampling frequency
N = 10000;      % Number of samples
t = (0:N-1)/fs; % Time vector
fc = 50e3;      % Carrier frequency (10 kHz)

s1 = sin(2*pi*1000*t);
s2 = sign(sin(2*pi*2000*t));



baseband_signal = s1 + 1j * s2;


carrier = exp(1j * 2 * pi * fc * t);


upconverted_signal = baseband_signal .* carrier;


qam_signal = real(upconverted_signal);


nfft = 2^nextpow2(N);
frequencies = (-nfft/2:nfft/2-1)*(fs/nfft);


baseband_spectrum = fftshift(fft(baseband_signal, nfft));  % Baseband spectrum
qam_spectrum = fftshift(fft(qam_signal, nfft));  % Spectrum of the QAM signal


figure;

% Time Domain Plot: I and Q components
subplot(2, 2, 1);
plot(t, real(baseband_signal), 'b', t, imag(baseband_signal), 'r');
legend('In-phase (I)', 'Quadrature (Q)');
title('I and Q Components (Baseband) in Time Domain');
xlabel('Time (s)');
ylabel('Amplitude');

% Frequency Domain Plot: Spectrum before upconversion
subplot(2, 2, 2);
plot(frequencies, abs(baseband_spectrum)/N);
title('Spectrum of Baseband Signal (I + Q)');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
xlim([-50e3 50e3]);  % Limit the frequency axis to baseband range

% Plot I and Q components after upconversion
subplot(2, 2, 3);
plot(t, qam_signal);
title('Upconverted QAM Signal in Time Domain');
xlabel('Time (s)');
ylabel('Amplitude');

% Frequency Domain Plot: Spectrum after upconversion
subplot(2, 2, 4);
plot(frequencies, abs(qam_spectrum)/N);
title('Spectrum of Upconverted QAM Signal');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
xlim([-100e3 100e3]);  % Limit the frequency axis around the carrier frequency

% phase shift to model signal propagation of LO phase mismatch
qam_signal = qam_signal*exp(1j*pi/8);

%LO signal for downconversion
back_carrier = exp(-1j * 2 * pi * fc * t);
figure;
subplot(1, 2, 2);
% down conversion
downconverted_signal = qam_signal.*back_carrier;

dw_spectrum = fftshift(fft(downconverted_signal, nfft));
plot(frequencies,abs(dw_spectrum));

hold on;
%
windowWidth = 25;
kernel = blackman(windowWidth);
kernel = kernel/sum(kernel);
out = filter(kernel, 1, downconverted_signal);
dw_spectrum = fftshift(fft(out, nfft));
plot(frequencies,abs(dw_spectrum));
legend('Original','Filtered');
title('Spectrum of downconverted Signal (I + Q)');
xlabel('Frequency (Hz)');
ylabel('Magnitude');


subplot(1, 2, 1);
plot(t,real(out));
hold on;
plot(t,imag(out));
legend('I','Q');
title('Restored I and Q signals');
xlabel('Time (s)');
ylabel('Amplitude');
