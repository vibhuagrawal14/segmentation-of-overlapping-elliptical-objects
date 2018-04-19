function [x,y]=drawarc(E,a,b)
%This function plots a circular arc between two points passed as
%parameters, taking into consideration their linked seedpoint

%The seedpoint is projected on the perpendicular bisector of the two points
%and a radius is obtained. The arc is finally drawn with angle as a
%parameter

x1=E(a,1);
x2=E(b,1);
y1=E(a,2);
y2=E(b,2);
% plot(x1,y1,'gx');
% plot(x2,y2,'bx');
[h,k]=fitting1(x1,x2,y1,y2,E(a,3),E(a,4));
% plot(h,k,'rx');
r=dist2points(h,k,E(a,1),E(a,2));
% if E(a,5)>E(b,5)
%     E(b,5)=E(b,5)+2*3.14159265;
% end
    angle1=angle2points1(h,k,E(a,1),E(a,2));
    angle2=angle2points1(h,k,E(b,1),E(b,2));
if angle1>angle2
    angle2=angle2+2*3.14159265;
end


% t=linspace(E(a,5),E(b,5));
t=linspace(angle1,angle2);
x = r*cos(t) + h;
y = r*sin(t) + k;
% drawspline(x,y,E,a,b);
%p=plot(x,y,'r');
end