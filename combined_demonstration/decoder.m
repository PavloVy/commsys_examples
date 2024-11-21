function decoded = decoder(data, G)
  [K,M] = size(G);
  bits_examples = de2bi(0:2.^K-1);
  transformed_examples = mod((G.')*bits_examples.',2).';


  % will add some zero bits at the end of the message if needed
  len_enough  = floor(length(data)./M)*M;
  data = data(1:len_enough);

  % number of codeword based on the input message size K
  num_codewords = size(data)(2)/M;

  % Creating an array for storage.
  out_vectors = zeros(num_codewords,K);

  % in cycle will take input vectors one by one, encode them and store
  % This function can be done much more effectvely as reshape(dot(reshape)), but
  % it would be much more difficult to read that code.
  for i = 1:num_codewords
    vector = data((i-1)*M+1:i*M);
    distances = sum (mod(vector-transformed_examples,2),2);

    [argvalue, argmin] = min(distances);

    out_vectors(i,:) = bits_examples(argmin,:);
  endfor

  decoded = reshape(out_vectors.',[1,prod(size(out_vectors))]);
