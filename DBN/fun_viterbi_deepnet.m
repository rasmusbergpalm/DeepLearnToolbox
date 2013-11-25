function score=fun_viterbi_deepnet(c, STATE_NO, nn,m)

    N=STATE_NO;
    T=size(c,1);                
    P=cell(N,T);
    f=ones(N,T)*(-inf);
    for i=1:N
         P{i,1}=i;
    end
    t=1;i=1;

    f(i,t)=nn.a{end}(t,(m-1)*STATE_NO+i);
    % other f(i,t) terms have been set to -inf
    %%%%%%%%%%%%  t=2:T   %%%%%%%%%%%%%
    for t=2:T
        i=1;
            f(i,t)=f(i,t-1)+ nn.a{end}(t,(m-1)*STATE_NO+i);
        for i=2:N % pi=previous i
            [f(i,t), pi] = max(  [ f(i-1,t-1)  ,  f(i,t-1)  ] ); 
            f(i,t)=f(i,t)+nn.a{end}(t,(m-1)*STATE_NO+i);
            P{i,t}=[P{i+pi-2,t-1}  i ];  
       end
    end
    
    score =  f(N,T);

