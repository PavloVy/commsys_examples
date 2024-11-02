% Initalizing with basic simulation parameters
sampling_frequency = 10e+9;
max_time = 0.0001;
num_samples = round(max_time * sampling_frequency);
samples = 0:num_samples-1;
%Making arrays which represent time and frequency axes
times = samples / sampling_frequency;
frequencies = (samples - num_samples/2) * sampling_frequency / num_samples;

% Specification of the signals for simulation.
% We'll make a LO signal and an additional signal representing our passband
% The passband signal will be shifted with respect to the LO
LO_frq = 1200.123987e+6;
signal_shift = 50e+6;
% will pack signals into an array for simple adding of more
signals = [0.1, LO_frq, -1.5;
          0.05, LO_frq + signal_shift, 0.16];
          %0.05, LO_frq + signal_shift/2, 0.16 ];
time_realization = zeros(size(times));
% Adding each signal from the pack
for i = 1:size(signals, 1)
  time_realization = time_realization + ...
      signals(i, 1) * sin(2 * pi * signals(i, 2) * times + signals(i, 3));
end

% application of nonlinearity
nonlinear = (time_realization + 1).^2;
%nonlinear = nonlinear + 0.1 * exp(time_realization + 0.3);
nonlinear = nonlinear - mean(nonlinear);

% windowing of time realization for a smooth spectrum
window = hamming(length(nonlinear))';

% spectra of the original and nonlinear signals
sp = fftshift(fft(nonlinear .* window));
sp0 = fftshift(fft(time_realization .* window));

figure;
plot(frequencies / 1e6, 20*log10(abs(sp)), 'DisplayName', 'Nonlinear Signal');
hold on;
plot(frequencies / 1e6, 20*log10(abs(sp0)), 'DisplayName', 'Original Signal');
hold off;

xlabel('Frequency (MHz)');
ylabel('Magnitude (dB)');
legend('show');
title('Frequency Spectrum of Original and Nonlinear Signals');
grid on;


% Apply Butterworth filter to the nonlinear signal
filter_cutoff_fraction = 0.02;
cutoff_reference= filter_cutoff_fraction*sampling_frequency/2
[b, a] = butter(5, filter_cutoff_fraction);  % 5th order, cutoff frequency filter_cutoff_fraction * Nyquist frequency
filtered_signal = filter(b, a, nonlinear);
decimated_filtered_signal = filtered_signal;

% Compute spectrum of the filtered signal
sp_filtered = fftshift(fft(filtered_signal .* window));
  % Plot the filtered signal spectrum
    figure;
    plot(frequencies / 1e6, 20 * log10(abs(sp_filtered)), 'DisplayName', 'Filtered Nonlinear Signal');
    xlabel('Frequency (MHz)');
    ylabel('Magnitude (dB)');
    legend('show');
    title('Frequency Spectrum of Filtered Nonlinear Signal');
    grid on;


 % Decimate the filtered signal by a factor of 25
    decimation_factor = 25;
    decimated_signal = decimate(filtered_signal, decimation_factor);

    % Adjust the sampling frequency and frequency axis after decimation
    new_sampling_frequency = sampling_frequency / decimation_factor;
    new_num_samples = length(decimated_signal);
    new_frequencies = (-new_num_samples/2:new_num_samples/2-1) * ...
        (new_sampling_frequency / new_num_samples);

    % Compute spectrum of the decimated signal
    sp_decimated = fftshift(fft(decimated_signal .* hamming(new_num_samples)'));

    figure;
    plot(new_frequencies / 1e6, 20 * log10(abs(sp_decimated)), 'DisplayName', 'Decimated Signal');
    xlabel('Frequency (MHz)');
    ylabel('Magnitude (dB)');
    legend('show');
    title('Frequency Spectrum of Decimated Signal');
    grid on;
