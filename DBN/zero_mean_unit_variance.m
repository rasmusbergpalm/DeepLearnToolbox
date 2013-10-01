%soft version of ncc, data will still be invertible
function [Data,M,Std] = zero_mean_unit_variance( Data)

M=mean(Data,1);
Data = bsxfun(@minus, Data, M);

Std=std(Data,0,1);
Data=bsxfun(@times,Data,1./Std);



