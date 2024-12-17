function [modulated,matched_filter,step] = modulator(complex_amplitudes,compression_ratio,method)
  #method = 'mlseq' #'ones' 'lfm'

  fs = 1e+6;
  pulse_duration = compression_ratio*1e-6;

  if strcmp(method, 'ones')
    pulse_shape = ones(1,floor(pulse_duration*fs));
  elseif  strcmp(method, 'lfm')
    pulse_samples = floor(pulse_duration*fs)
    pulse_times = linspace(0,pulse_samples/fs,pulse_samples);
    df = fs/10;
    frequencies = linspace(-df,df,pulse_samples);
    phase_accumulator = 0;
    for i = 1:pulse_samples

      pulse_times(i) = phase_accumulator;
      phase_accumulator = phase_accumulator+2*pi*frequencies(i)/fs;
    endfor
    pulse_shape = exp(j*pulse_times);
    plot(real(pulse_shape))
    figure
  else
    pulse_shape = mseq(2,round(log2(compression_ratio))).';
  endif

  pulse_step = pulse_duration;
  int_step = floor(pulse_step*fs);
  int_start = 0;

  num_out_samples = length(complex_amplitudes)*(int_step+1);

  binary_sequence = complex_amplitudes;

  % Initialize the output signal
  output_signal = zeros(1, num_out_samples);

  % Loop over the binary sequence
  for i = 1:length(binary_sequence)

        % Time vector for the pulse position
        pulse_start = int_start + (i-1)*int_step+1;  % Start time for the pulse
        pulse_end = pulse_start + length(pulse_shape); % End time for the pulse

        % Add the pulse shape to the output signal
        output_signal(pulse_start:pulse_end-1)=output_signal(pulse_start:pulse_end-1)+binary_sequence(i)*pulse_shape;

  end

  modulated = output_signal;
  matched_filter = pulse_shape;
  step = int_step;


