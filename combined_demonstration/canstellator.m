function [canstellated, vocabulary,code_x,code_y,decimal_codes] = canstellator(data)
  num_bits = 4;
  qam_coords = [-1.5,-0.5,0.5,1.5];
  [code_x, code_y] =meshgrid(qam_coords.',qam_coords);
  code_x = reshape(code_x,16,1);
  code_y = reshape(code_y,16,1);
  normalizer = sqrt(mean(code_x.^2+code_y.^2));
  code_x = code_x/normalizer;
  code_y = code_y/normalizer;

  % gray encoding and playing with the results
   gray = bin2gray([0:15],'qam',16);
 %gray = 0:15;
  [_,inv_gray] = sort(gray);
  inv_gray = inv_gray-1;
  bts = dec2bin(gray);
  vector_bits = de2bi(gray);

  % now will transform each word into IQ voltages with Grey encoding
   % will add some zero bits at the end of the message if needed
  remainder  = mod(size(data)(2),num_bits)
  if remainder>0
    num_zeros_to_add = num_bits-remainder;
    data = [data, zeros(1,num_zeros_to_add)];
  endif

  % number of codeword based on the input message size K
  num_IQs = size(data)(2)/num_bits;

  % Creating an array for storage.
  out_IQs = zeros(1,num_IQs);

  % in cycle will take input bits and choose canstellation point according to grey
  % inverse index (which works as a LUT).
  decimal_codes = zeros(1,num_IQs);
  for i = 1:num_IQs
    bits_array = data((i-1)*num_bits+1:i*num_bits);
    decimal = bi2de(bits_array)+1;
    coded_decimal = inv_gray(decimal)+1;
    decimal_codes(i) = coded_decimal;
    out_IQs(i) =code_x(coded_decimal)+j*code_y(coded_decimal);

  endfor

canstellated = out_IQs;
vocabulary = gray;


%  figure()
%  plot(code_x,code_y,'o')
%  hold on
%  for i = 1:length(code_x)
%    vec =vector_bits(i,:);
%    out=strrep(num2str(vec), ' ', '');
%    text(code_x(i),code_y(i),out);
%  endfor

