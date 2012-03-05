function pae = spaerun(pae, folder, opts)
    close all
    ims = dir(['../nipsdata/resized/' folder '/*.png']);
    for i = 1 : numel(ims)
        im = imread(['../nipsdata/resized/' folder '/' ims(i).name]);
        x{1}{1}(i, :, :) = im(:, :, 1);
    end
    n = pae.inputkernel(1);

    i1 = randi(numel(x));
    l = randi(size(x{i1}{1}, 1) - opts.batchsize - n + 1);
    x1{1} = double(x{i1}{1}(l : l + opts.batchsize - 1, :, :)) / 255;

    if n == 1   %  Reconstructive Auto-Encoder
        x2{1} = x1{1};
    else        %  Predictive Auto-Encoder
        x2{1} = double(x{i1}{1}(l + n : l + n + opts.batchsize - 1, :, :)) / 255;
    end
    %  Denoising element
    x1{1} = x1{1} .* (rand(size(x1{1})) > pae.noise);

    pae = paeup(pae, x1);
    pae = paedown(pae);
    pae = paebp(pae, x2);
    
end
