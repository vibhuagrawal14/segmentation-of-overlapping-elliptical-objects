function[xSpline,ySpline]=curveFitting(IdSmall,h,k,r,a,b,x,y)
xSpline=0;ySpline=0;
c=a+0.6;
d=b-0.6;
t1=linspace(c,a,10);
r=1*r;
threshold=60;
countV=1;%count variable
countV1=1;%count variable for spline arrays
sp=0.92;%smoothing parameter
for countV=1:5
    m=tan(t1(countV*2));
    xi(1)=h;
    yi(1)=k;
    xi(2)=((4*r*r)/(1+m*m))^0.5+h;
    yi(2)=m*(xi(2)-h)+k;%is this the right point? or flipped around the origin?  
    xitemp=-((4*r*r)/(1+m*m))^0.5+h;
    yitemp=m*(xitemp-h)+k;
    if (((x(1)-xitemp)^2+(y(1)-yitemp)^2)^0.5)<(((x(1)-xi(2))^2+(y(1)-yi(2))^2)^0.5)
        xi(2)=xitemp;
        yi(2)=yitemp; 
        
    end    
    [ix,iy,intensity] = improfile(IdSmall,double(xi),double(yi),100); %ix,iy for each intensity 
    for j=1:length(intensity)
        if intensity(j)>threshold
            xSpline(countV1)=ix(j);
            ySpline(countV1)=iy(j);
           % plot(ix(j),iy(j),'o');
            countV1=countV1+1;
            break;
        end
    end
end
if countV1==6
% xSpline(6:12)=x(9:3:28);
% ySpline(6:12)=y(9:3:28);


xSpline(6:12)=x(9:1:15);
ySpline(6:12)=y(9:1:15);
%plotting Spline
xx = linspace(xSpline(1),xSpline(12),8);
% h,k
% xSpline,ySpline

yy = spline(xSpline,ySpline,xx);
% xx,yy
% plot(xx,yy,'r')


xSpline=xSpline(:);
ySpline=ySpline(:);
[f, goodness, output] = fit(xSpline,ySpline,'smoothingspline','SmoothingParam',sp);
plot(f,'w',xSpline,ySpline);

end



%second spline
t1=linspace(d,b,10);
countV=1;%count variable
countV1=1;%count variable for spline arrays
for countV=1:5
    m=tan(t1(countV*2));
    xi(1)=h;
    yi(1)=k;
    xi(2)=((4*r*r)/(1+m*m))^0.5+h;
    yi(2)=m*(xi(2)-h)+k;%is this the right point? or flipped around the origin?  
    xitemp=-((4*r*r)/(1+m*m))^0.5+h;
    yitemp=m*(xitemp-h)+k;
    if (((x(100)-xitemp)^2+(y(100)-yitemp)^2)^0.5)<(((x(100)-xi(2))^2+(y(100)-yi(2))^2)^0.5)
        xi(2)=xitemp;
        yi(2)=yitemp;   
    end    
    [ix,iy,intensity] = improfile(IdSmall,double(xi),double(yi),100); %ix,iy for each intensity 
    for j=1:length(intensity)
        if intensity(j)>threshold 
            xSpline(countV1)=ix(j);
            ySpline(countV1)=iy(j);
          %  plot(ix(j),iy(j),'o');
            countV1=countV1+1;
            break;
        end
    end
end
if countV1==6
% xSpline(6:12)=x(72:3:92); wrong
% ySpline(6:12)=y(72:3:92);

%  xSpline(6:12)=x(91:-3:72);   
%  ySpline(6:12)=y(91:-3:72);
 xSpline(6:12)=x(91:-1:85);
 ySpline(6:12)=y(91:-1:85);

%plotting Spline
xx = linspace(xSpline(1),xSpline(12),8);
% h,k
% xSpline,ySpline

yy = spline(xSpline,ySpline,xx);
% xx,yy
%plot(xx,yy,'r')


xSpline=xSpline(:);
ySpline=ySpline(:);
[f, goodness, output] = fit(xSpline,ySpline,'smoothingspline','SmoothingParam',sp);
    plot(f,'w',xSpline,ySpline);

end
end
