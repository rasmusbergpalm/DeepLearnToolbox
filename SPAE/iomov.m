function iomov(pae)
    for u=1:10
        for i=1:size(pae.i{1},1);
            subplot(1,2,1); 
            imshow(squeeze(pae.i{1}(i,:,:))); 
            
            subplot(1,2,2); 
            imshow(squeeze(pae.o{1}(i,:,:))); 
            
            drawnow; pause(0.1); 
        end;
    end
end