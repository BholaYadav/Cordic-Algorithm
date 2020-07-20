function [x,y,z]=cordic(x,y,z,inLUT,niter)
temp_x=x;
temp_y=y;
for i=1:niter
    if z<0
        z(:)=accumpos(z,inLUT(i));
        x(:)=accumpos(x,temp_y);
        y(:)=accumneg(y,temp_x);
    else
        z(:)=accumneg(z,inLUT(i));
        x(:)=accumneg(x,temp_y);
        y(:)=accumpos(y,temp_x);
    end
    temp_x=bitsra(x,i);
    temp_y=bitsra(y,i);
end
end
