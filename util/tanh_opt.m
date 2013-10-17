function  f=tanh_opt(A)
%Use tanh with optimal parameters reported in literature. See LeCun's "Neural Networks - Tricks of the trade" Chapter 1.4.4.
    f=1.7159*tanh(2/3.*A);
end
