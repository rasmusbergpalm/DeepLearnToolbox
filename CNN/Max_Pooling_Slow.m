function [max_cube] = Max_Pooling_Slow(IM,scale)
% This is not the idea version, because two for loops,
% I have implemented a C++ version which is 10 times faster
[sz1 sz2 sz3] = size(IM);

ngridx = floor(sz1/scale);
ngridy = floor(sz2/scale);
max_cube = zeros(ngridx,ngridy,sz3);
for x = 1 : ngridx
    for y= 1 : ngridy
       max_cube(x,y,:) = max(max(IM((x-1)*scale+1:x*scale,(y-1)*scale+1:y*scale,:),[],1),[],2);
    end
end




