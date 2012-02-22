function w = symconv(u,v)
   % CONV Nonnumeric convolution.
   % W = CONV(U,V) is the convolution of symbolic vectors U and V.
   % length(w) = length(u)+length(v)-1
   % w(k) = sum(u(j)*v(k+1-j)), j = max(1,k+1-length(v):min(k,length(u))
   
   % Form Toeplitz matrix from v.
   m = length(u);
   n = length(v);
   p = m+n-1;
   T = [v(:); zeros(m,1)]*ones(1,m);
   T = reshape(T(1:m*p),p,m);
   
   % Convolve
   w = T*u(:);
   
   % Return row vector if appropriate
   if size(u,2) > size(u,1)
      w = w.';
   end