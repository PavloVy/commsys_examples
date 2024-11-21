function transferred = baseband_channel_model(signal, SNR_db)
  % normalizing the power, so that when we set SNR, it is meaningful.
  signal_power = mean(abs(signal).^2);
  signal = signal/sqrt(signal_power);
  SNR = 10.^(SNR_db/10);
  noise = 1/ sqrt(2*SNR) * (randn(size(signal)) + j*randn(size(signal)));
  meansq(noise)
  meansq(signal)
  signal = signal+noise;
  transferred = signal;

