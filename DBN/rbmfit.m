function rbm = rbmfit(rbm, x, y)

    lr = rbm.lr;
    m = size(x,1);
    
    for i=1:m
        v1 = x(i,:)';                                   %clamp data
        l1 = y(i,:)';                                   %clamp label
        h1 = sigmrnd(rbm.c + rbm.Wl*l1 + rbm.W*v1);     %up
        v2 = sigmrnd(rbm.b + rbm.W'*h1);                %down
        l2 = (softmax((rbm.bl + rbm.Wl'*h1)') > rand(size(l1))')'; %down (labels)
        h2 = sigmrnd(rbm.c + rbm.Wl*l2 + rbm.W*v2);     %up

        c1 = v1*h1';
        c2 = v2*h2';

        rbm.W = rbm.W + lr*(c1-c2)';
        rbm.b = rbm.b + lr*(v1-v2);
        rbm.c = rbm.c + lr*(h1-h2);
        
        rbm.Wl = rbm.Wl + lr*(l1*h1' - l2*h2')';
        rbm.bl = rbm.bl + lr*(l1-l2);
    end

end