function scae = scaetrain(scae, x, opts)
    %TODO: Transform x through scae{1} into new x. Only works for a single PAE. 
%     for i=1:numel(scae)
%         scae{i} = paetrain(scae{i}, x, opts);        
%     end
    scae{1} = caetrain(scae{1}, x, opts);        
  
end