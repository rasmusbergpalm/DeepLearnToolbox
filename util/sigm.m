function X = sigm(P)
    if(isInOctave())
        X = logistic_cdf(P);
    else
        X = 1./(1+exp(-P));
    end%if
end
