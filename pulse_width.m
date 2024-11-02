close all;
% Parameters
fs = 10000;               % Sampling frequency (Hz)
total_duration = 1;
t = 0:1/fs:total_duration;           % Time vector (1 second duration)
pulse_duration = 0.001;   % Duration of each pulse (seconds)
pulse_step = 0.001;
bit_rate = 1/pulse_step
pulse_amplitude = 1;    % Amplitude of the pulse
start_of_everything = 0.05;
sequence_len = 400;
sigma = pulse_duration / 4;
% Rectangular pulse shape
pulse_shape = ones(1,floor(pulse_duration*fs));
int_step = floor(pulse_step*fs);
int_start = floor(start_of_everything*fs);
pulse_duration*fs
num_out_samples = 1000;
matrix_of_result = zeros(num_out_samples,num_out_samples);

for rep = 1:1000
binary_sequence = randi([0, 1], 1, sequence_len);
modulation_signal = binary_sequence*2-1;

% Initialize the output signal
output_signal = zeros(1, length(t));

% Loop over the binary sequence
for i = 1:length(binary_sequence)

      % Time vector for the pulse position
      pulse_start = int_start + (i-1)*int_step;  % Start time for the pulse
      pulse_end = pulse_start + length(pulse_shape); % End time for the pulse

      % Add the pulse shape to the output signal
      output_signal(pulse_start:pulse_end-1)=output_signal(pulse_start:pulse_end-1)+binary_sequence(i)*pulse_shape;

end

matrix_of_result =matrix_of_result+ (output_signal(int_start:int_start+num_out_samples-1).')*output_signal(int_start:int_start+num_out_samples-1);
end
imagesc(matrix_of_result)

% Plot the results
figure;
subplot(2, 1, 1);
stem(binary_sequence, 'filled');
title('Binary Sequence');
xlabel('Bit Index');
ylabel('Value');
axis tight;

subplot(2, 1, 2);
plot(t, output_signal);
title('Output Signal');
xlabel('Time (s)');
ylabel('Amplitude');
axis tight;

grid on;

f_cut = 1/pulse_step/2;

if (false)
% Compute and plot the spectrum
N = length(output_signal);
f = (0:N-1) * (fs/N);         % Frequency vector
sp = fft(output_signal);
Y = 20*log10(abs(sp+1e-2));
sp(f>f_cut & f<fs-f_cut)=0;
figure;
subplot(2, 1, 1);
plot(f, Y);
hold on;
plot(f,20*log10(abs(sp+1e-2)));
title('Spectrum of Output Signal');
xlabel('Frequency (Hz)');
ylabel('Magnitude,dB');
axis tight;
grid on;



filtered_signal = ifft(sp);

% Plot the distorted output signal
subplot(2, 1, 2);
plot(t, filtered_signal);
hold on;
plot(t,output_signal);
title('Distorted Output Signal after Bandlimiting');
xlabel('Time (s)');
ylabel('Amplitude');
axis tight;
grid on;
figure;
plot(output_signal,filtered_signal,'+')
endif


