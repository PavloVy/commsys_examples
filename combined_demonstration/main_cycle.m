close all
clear all
showplots = false;
pkg load communications
data_len = 5000;
pulse_shape_method = 'mlseq' #'ones' 'lfm' 'mlseq'
data = randi([0,1],[1,data_len]);

multipath_switch = true;

%[C0, G0] = encoder(data,4);
[codes,G] = encoder(data,3);
ratio = size(data)/size(codes)


[complex_amplitudes, vocabulary,code_x,code_y,decimal_codes] = canstellator(codes);
% just drawing the complex


[modulated,matched_filter,step]= modulator(complex_amplitudes,128,pulse_shape_method);

SNR_db =-6;
transferred = baseband_channel_model(modulated,SNR_db, multipath_switch);
plot(real(transferred))
hold on
plot(imag(transferred))
figure

matched_filter = matched_filter/sum(abs(matched_filter));
matched_filtered = ifft(fft(transferred).*conj(fft([matched_filter zeros(1,length(transferred)-length(matched_filter))])));
%plot(real(matched_filtered),imag(matched_filtered))

plot(real(matched_filtered))
hold on
plot(imag(matched_filtered))

indexes_to_take = (1:step:length(matched_filtered));
plot(indexes_to_take,zeros(size(indexes_to_take)),'+')


samples = matched_filtered(indexes_to_take);
samples =samples(1:length(complex_amplitudes));
samples = samples/sqrt(mean(abs(samples).^2));
figure

plot(real(samples),imag(samples),'o')

[detected,decimal_detected] = detector(samples,code_x,code_y,vocabulary);
detected = detected(1:length(codes));
num_bit_errors_before_hamming = sum(mod(detected-codes,2))

BER = num_bit_errors_before_hamming/length(detected)
H = (BER*log2(BER) + (1-BER)*log2(1-BER))
shannon_ratio= 1+H

decoded = decoder(detected,G);
%decoded = decoder(decoded0,G0);
decoded = decoded(1:length(data));
num_bit_errors_after_hamming = sum(mod(decoded-data,2))

if (num_bit_errors_after_hamming>0)
  figure
  plot(1:length(detected),detected-codes)
  hold on
  [K,M] = size(G);
  plot((1:length(data))/K*M,decoded-data)
 endif;
