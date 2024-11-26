function transferred = baseband_channel_model(signal, SNR_db, multipath_switch)
  % normalizing the power, so that when we set SNR, it is meaningful.
  signal_power = mean(abs(signal).^2);
  out_sig = signal;
  if (multipath_switch)
    num_multipaths = 6;
    max_multipath_amplitude = 0.7;
    max_multipath_samples = 12;
    for i=1:num_multipaths
      out_sig = out_sig+circshift(signal,randint(1,1,[1,max_multipath_samples]))*max_multipath_amplitude*exp(j*rand(1)*2*pi);
    endfor
  signal = out_sig;
  endif

  %signal = signal/sqrt(signal_power);



  SNR = 10.^(SNR_db/10);
  noise = 1/ sqrt(2*SNR) * (randn(size(signal)) + j*randn(size(signal)));
  meansq(noise)
  meansq(signal)
  signal = signal+noise;
  transferred = signal;

