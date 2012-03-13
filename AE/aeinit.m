function ae = aeinit(layers)
    if length(layers) == 1
        error('You need to specify a visible and a hidden layer (specifying the output layer is optional).')
    end

    if length(layers) == 2
        layers(3) = layers(1);
    end

    if length(layers) > 3
        error('Autoencoders can only have one hidden layer.')
    end

    if layers(1) ~= layers(3)
        error('The input and output layers of an autoencoders must have the same number of nodes.')
    end

    ae = nninit(layers);
end
