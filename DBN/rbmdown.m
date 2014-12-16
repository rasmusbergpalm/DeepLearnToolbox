function x = rbmdown(rbm, x)
    expected = repmat(rbm.b', size(x, 1), 1) + x * rbm.W;
    if strcmp(rbm.type,'gb')
        %Then is Gaussian-Bernboilli so is mean of normal
        x = expected;
    else
        %assume it is bernoilli-bernoili so exected is a sigmoid of inputs
        x = sigm(expected);
    end
end
