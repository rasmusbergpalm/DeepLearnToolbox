function sae = saesetup(size)
%% SAESETUP create stacked auto-encoders network
% size ..TODO

sae = nnsetup(); % always call constructor first 
sae.type = 'sae';
sae.size=size;
    for u = 2 : numel(size)
        sae.ae{u-1} = ffnnsetup([size(u-1) size(u) size(u-1)]);
    end
end
