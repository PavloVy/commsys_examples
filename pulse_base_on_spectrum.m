close all;
% We want to construct a pulse shape which would satisfy the Nyquist theorem
% from the lectures.

% We start with time and frequency scales
duration = 0.01;
sampling_rate = 1000000;
dt =  1/sampling_rate;
num_samples = sampling_rate*duration;
times = (0:num_samples-1)*dt;
df = 1/duration;

% We will draw on a spectrum model
spectrum_model = zeros(1,num_samples);

% number of samples corresponding to half of the top by the half level
half_level_width = 250;

% here we'll find a theoretical sampling period which is matched to the
% spectrum we want to construct. Some magic numbers here come from the way
% how the spectrum is designed.
time_period = 1/(2*half_level_width-2)/df;

% we construct our signal similar to the raised cosine.
transition_fraction = 0.9;
half_transition_samples = round(half_level_width*transition_fraction/2);

% making our shape. We want it symmetrical.
f = 1:half_transition_samples;
transition_shape = cos(f*pi/half_transition_samples);
%transition_shape = 2.^(f.^2/half_transition_samples.^2/4);
st = transition_shape(1); %starting value
en = transition_shape(half_transition_samples); %ending value

%will scale the shape so that it goes from 1 to 0.5 and, then, from 0.5 to 0.
scaled_decay = 1-0.5*(transition_shape-st)/(en-st);
flipped = fliplr(transition_shape(1:half_transition_samples-1));
second_half = 0.5*(flipped-st)/(en-st);

full_shape = [ones(1,half_level_width-half_transition_samples) scaled_decay second_half];

spectrum_model(1:length(full_shape))=full_shape;
spectrum_model(num_samples-length(full_shape)+2:num_samples) = fliplr(full_shape(2:length(full_shape)));
plot(df*(0:num_samples-1),spectrum_model)
xlabel('Frequency, Hz')
ylabel('Spectrum, magnitude')


sp = fft(spectrum_model);
figure;
plot(times,20*log10(abs(sp)+1e-5))
hold on;

for i = 0:100
  plot([time_period*i time_period*i],[-40 40])
endfor
xlabel('Time, s')
ylabel('Pulse shape, dB')


