function [x1,y1]=drawellipse(E,p,q,a,b,c,d,f,g)
a1=sqrt(2*(a*f*f+c*d*d+g*b*b-2*b*d*f-a*c*g)/((b*b-a*c)*(sqrt((a-c)^2+4*b*b)-(a+c))));
b1=sqrt(2*(a*f*f+c*d*d+g*b*b-2*b*d*f-a*c*g)/((b*b-a*c)*(-sqrt((a-c)^2+4*b*b)-(a+c))));
h=(c*d-b*f)/(b*b-a*c);
k=(a*f-b*d)/(b*b-a*c);
if b==0 & a<c
        phi=0;
    elseif b==0 & a>c
        phi=0.5*pi;
    elseif b~=0 & a<c
        phi=0.5*acot((a-c)/(2*b));
    elseif b~=0 & a>c
        phi=pi/2+1/2*acot((a-c)/2*b);
end
% if E(a,5)>E(b,5)
%     E(b,5)=E(b,5)+2*3.14159265;
% end
angle1=angle2points1(h,k,E(p,1),E(p,2));
angle2=angle2points1(h,k,E(q,1),E(q,2));
if angle1>angle2
    angle2=angle2+2*3.14159265;
end


% t=linspace(E(a,5),E(b,5));
t=linspace(angle1,angle2);
x=h+a1*cos(atan((a1/b1)*tan(t-phi)));
y=k+b1*sin(atan((a1/b1)*tan(t-phi)));
for z=1:100
    x1(z)=x(z)*cos(phi)-y(z)*sin(phi);
    y1(z)=x(z)*sin(phi)+y(z)*cos(phi);
end
% drawspline(x,y,E,a,b);
%p=plot(x,y,'r');
end