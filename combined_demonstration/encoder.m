function [encoded,G]= encoder(data,sz)

  % creating Hamming encoder using buildin function
  [H, G, N, K] = hammgen(sz);

  %imagesc(H)
  %figure()
  %imagesc(G)

  % will add some zero bits at the end of the message if needed
  remainder  = mod(size(data)(2),K)
  if remainder>0
    num_zeros_to_add = K-remainder;
    data = [data, zeros(1,num_zeros_to_add)];
  endif

  % number of codeword based on the input message size K
  num_codewords = size(data)(2)/K;

  % Creating an array for storage.
  out_vectors = zeros(num_codewords,N);

  % in cycle will take input vectors one by one, encode them and store
  % This function can be done much more effectvely as reshape(dot(reshape)), but
  % it would be much more difficult to read that code.
  for i = 1:num_codewords
    vector = data((i-1)*K+1:i*K);
    newvector = mod((G.')*vector.',2);
    out_vectors(i,:) = newvector;
  endfor

  % We enjoyed seeing codewords one by one, but now the time is to pack them into a linear array
  encoded = reshape(out_vectors.',[1,prod(size(out_vectors))]);



