close all
clear all
showplots = false;
pkg load communications
data_len = 8192*3;
data = randi([0,1],[1,data_len]);

%[C0, G0] = encoder(data,4);
[codes,G] = encoder(data,4);
ratio = size(codes)/size(data)


[complex_amplitudes, vocabulary,code_x,code_y,decimal_codes] = canstellator(codes);
% just drawing the complex


[modulated,matched_filter,step]= modulator(complex_amplitudes,5);

SNR_db =5;
transferred = baseband_channel_model(modulated,SNR_db);
%plot(real(transferred))
%hold on
%plot(imag(transferred))

matched_filter = matched_filter/sum(matched_filter);
matched_filtered = conv(transferred,flip(matched_filter));
plot(real(matched_filtered),imag(matched_filtered))
hold on

indexes_to_take = step:step:length(matched_filtered);
samples = matched_filtered(indexes_to_take);
samples =samples(1:length(complex_amplitudes));
plot(real(samples),imag(samples),'o')

[detected,decimal_detected] = detector(samples,code_x,code_y,vocabulary);
detected = detected(1:length(codes));
num_bit_before_hamming = sum(mod(detected-codes,2))

BER = num_bit_before_hamming/length(detected)
H = (BER*log2(BER) + (1-BER)*log2(1-BER))/2
shannon_ratio= 1/(1+H)

decoded = decoder(detected,G);
%decoded = decoder(decoded0,G0);
decoded = decoded(1:length(data));
num_bit_after_hamming = sum(mod(decoded-data,2))

if (num_bit_after_hamming>0)
  figure
  plot(1:length(detected),detected-codes)
  hold on
  [K,M] = size(G);
  plot((1:length(data))/K*M,decoded-data)
 endif;
