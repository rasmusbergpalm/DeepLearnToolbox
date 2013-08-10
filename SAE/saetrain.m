function sae = saetrain(sae, x, opts)
%% SAETRAIN train stacked auto-encoders
% 
    for i = 1 : numel(sae.ae);
        disp(['Training AE ' num2str(i) '/' num2str(numel(sae.ae))]);
        % set info for each new layer
        sae.ae{i}.batchsize=sae.batchsize; 
        sae.ae{i}.numepochs=sae.numepochs;
        sae.ae{i}.type='sae';
        
        sae.ae{i} = nntrain(sae.ae{i}, x, x, opts);
        t = nnff(sae.ae{i}, x, x);
        x = t.a{2};
        %remove bias term
        x = x(:,2:end);
    end
end
