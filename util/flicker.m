function flicker(X,fps)
    figure;
    colormap gray;
    axis image;
    while 1
        for i=1:size(X,1);
            imagesc(squeeze(X(i,:,:))); drawnow;
            pause(1/fps);
        end
    end
end