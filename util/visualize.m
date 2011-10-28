function r=visualize(X)
%FROM RBMLIB http://code.google.com/p/matrbm/
%Visualize weights X. If the function is called as a void method,
%it does the plotting. But if the function is assigned to a variable 
%outside of this code, the formed image is returned instead.

[D,N]= size(X);
s=sqrt(D);
if s==floor(s)
    %its a square, so data is probably an image
    num=ceil(sqrt(N));
    a=zeros(num*s+num+1,num*s+num+1)-1;
    x=0;
    y=0;
    for i=1:N
        a(x*s+1+x:x*s+s+x,y*s+1+y:y*s+s+y)=reshape(X(:,i),s,s)';
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
    imshow(a, [-1 1]);
end
