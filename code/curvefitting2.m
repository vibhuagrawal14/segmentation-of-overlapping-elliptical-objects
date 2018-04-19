function[xSpline,ySpline]=curvefitting2(IdSmall,h,k,r,a,b,t,x,y)
xSpline=0;ySpline=0;
t1(11:110)=t;
diff=t1(11)-t1(20);
for j=1:10
    t1(11-j)=t(12-j)+diff;
    t1(110+j)=t1(109+j)-diff;
end
r=1.2*r;
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
    if (((x(1)-xitemp)^2+(y(1)-yitemp)^2)^0.5)<(((x(1)-xi(2))^2+(y(1)-yi(2))^2)^0.5)
        xi(2)=xitemp;
        yi(2)=yitemp;   
    end    
    [ix,iy,intensity] = improfile(IdSmall,double(xi),double(yi),100); %ix,iy for each intensity 
    for j=1:length(intensity)
        if intensity(j)>150 
            xSpline(countV1)=ix(j);
            ySpline(countV1)=iy(j);
            countV1=countV1+1;
            break;
        end
    end
end
if countV1==6
xSpline(6:12)=x(15:2:28);
ySpline(6:12)=y(15:2:28);
%plotting Spline
xx = linspace(xSpline(1),xSpline(12),12);
h;k;
xSpline;ySpline;

yy = spline(xSpline,ySpline,xx);
xx;yy;
plot(xx,yy,'')  




%second spline
countV=1;%count variable
countV1=1;%count variable for spline arrays
for countV=1:5
    m=tan(t1(110+countV*2));
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
        if intensity(j)>150 
            xSpline(countV1)=ix(j);
            ySpline(countV1)=iy(j);
            countV1=countV1+1;
            break;
        end
    end
end
if countV1==6
    xSpline(6:12)=x(85:-2:72);
    ySpline(6:12)=y(85:-2:72);
    %plotting Spline
    xx = linspace(xSpline(1),xSpline(12),12);
    h;k;
    xSpline;ySpline;

    yy = spline(xSpline,ySpline,xx);
    xx;yy;
    plot(xx,yy,'')


end
end