% Initalizing with basic simulation parameters
sampling_frequency = 10e+9;
max_time = 0.000001;
num_samples = round(max_time * sampling_frequency);
samples = 0:num_samples-1;
%Making arrays which represent time and frequency axes
times = samples / sampling_frequency;
frequencies = (samples - num_samples/2) * sampling_frequency / num_samples;

LO_frq = 5E+8;
signals = [1, LO_frq];

time_realization = zeros(size(times));
% Adding each signal from the pack
for i = 1:size(signals, 1)
  time_realization = time_realization + ...
      signals(i, 1) * sin(2 * pi * signals(i, 2) * times);
end

time_realization= exp(time_realization);

sp = fft(time_realization);
sp = abs(sp).^2/max(abs(sp).^2);

plot(10*log10(sp))

20*log10(1/3)
