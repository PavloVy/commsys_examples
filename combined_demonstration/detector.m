function [bits,codes] = detector(complex_amplitudes, x_coords,y_coords, grey_decoder)
  hard = true;
  distances =  zeros(length(complex_amplitudes),length(x_coords));
  codes = zeros(1, length(complex_amplitudes));
  for i = 1:length(complex_amplitudes)
    re = real(complex_amplitudes(i));
    im = imag(complex_amplitudes(i));
    distances(i,:) = sqrt((re-x_coords).^2+(im-y_coords).^2).';
    if (hard)
      [argvalue, argmin] = min(distances(i,:));
      codes(i) = argmin;
    else
      weights = exp(-distances.^2/0.1);
      codes(i) = 0; % not finished here
    endif

  endfor
decoded = grey_decoder(codes);
size(decoded);
bits = de2bi(decoded);
bits = reshape(bits.',[1,prod(size(bits))]);


