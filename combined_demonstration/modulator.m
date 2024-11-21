function [modulated,matched_filter,step] = modulator(complex_amplitudes,compression_ratio)
  fs = 1e+6;
  pulse_duration = compression_ratio*1e-6;
  pulse_shape = ones(1,floor(pulse_duration*fs));
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


