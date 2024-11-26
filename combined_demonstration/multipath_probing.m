close all
channel_probing_signal = zeros(1,256);
channel_probing_signal(1) = 1;
channel_probing_signal(128) = 1;
channel_probing_signal(131) = 2;
channel_probing_signal(133) = 1;
channel_probing_signal(138) = -1;
out_signal = baseband_channel_model(channel_probing_signal,100,true);
plot(channel_probing_signal)
hold on
plot(real(out_signal))

M = zeros(32,32);
for i =1:32
  s = shift(out_signal(1:32),i-1);
  s(1:i-1)=0;
  M(i,:) = s;
 endfor
 figure
 imagesc(real(M))

 inversed_M = pinv(M);
 figure
 imagesc(imag(inversed_M))

 useful_signal = out_signal(128:128+31);
 figure
 plot(real(channel_probing_signal(128:128+31)),'-o')
 hold on
 plot(real(useful_signal))
 plot(real(useful_signal*inversed_M))


 [ U , S , V ] = svd(inversed_M);
 plot(real(channel_probing_signal(128:128+31)*M*(U*S*(V'))),'+')
 figure
 imagesc(real(S))



