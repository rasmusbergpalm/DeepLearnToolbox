function X=wbox(n,N)
    middle = padarray(ones(n-2),[1 1]);
    edges = ones(n)-middle;
    c = zeros(n);
    c(1)=1;c(end)=1;
    corners = c+flipdim(c,1);
    sumN = (0.5*N*(N+1));
    X = (edges-corners)*sumN/N + corners*(sumN^2)/(N^2) + middle;
end