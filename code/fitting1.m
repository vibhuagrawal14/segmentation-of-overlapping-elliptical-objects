function [h,k]  = fitting1 (x1,x2,y1,y2,cx,cy)
    x3=(x1+x2)/2;
    y3=(y1+y2)/2;
    m=(x1-x2)/(y2-y1);
    if m==-Inf
    h=x3;
    k=cy;
    elseif m==Inf
    h=x3;
    k=cy;
    else
    h=cx-m*((m*cx-cy+y3-m*x3)/(m*m+1));
    k=cy-(-1)*((m*cx-cy+y3-m*x3)/(m*m+1));
    end
end