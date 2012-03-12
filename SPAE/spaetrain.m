function spae = spaetrain(spae, x, opts)
    %TODO: Transform x through spae{1} into new x. Only works for a single PAE. 
%     for i=1:numel(spae)
%         spae{i} = paetrain(spae{i}, x, opts);        
%     end
    spae{1} = paetrain(spae{1}, x, opts);        
  
end