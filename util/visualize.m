function r=visualize(X, mm, s1, s2)
%FROM RBMLIB http://code.google.com/p/matrbm/
%Visualize weights X. If the function is called as a void method,
%it does the plotting. But if the function is assigned to a variable 
%outside of this code, the formed image is returned instead.
if ~exist('mm','var')
    mm = [min(X(:)) max(X(:))];
end
if ~exist('s1','var')
    s1 = 0;
end
if ~exist('s2','var')
    s2 = 0;
end
    
[D,N]= size(X);
s=sqrt(D);
if s==floor(s) || (s1 ~=0 && s2 ~=0)
    if (s1 ==0 || s2 ==0)
        s1 = s; s2 = s;
    end
    %its a square, so data is probably an image
    num=ceil(sqrt(N));
    a=mm(2)*ones(num*s2+num-1,num*s1+num-1);
    x=0;
    y=0;
    for i=1:N
        im = reshape(X(:,i),s1,s2)';
        a(x*s2+1+x : x*s2+s2+x, y*s1+1+y : y*s1+s1+y)=im;
        x=x+1;
        if(x>=num)
            x=0;
            y=y+1;
        end
    end
    d=true;
else
    %there is not much we can do
    a=X;
end

%return the image, or plot the image
if nargout==1
    r=a;
else
    imshow(a, [mm(1) mm(2)]);
end
