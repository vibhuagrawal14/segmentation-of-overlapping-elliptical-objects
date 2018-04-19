function[angle]=angle2points1(point1X,point1Y,point2X,point2Y)
%This function returns the angle between two points between 0 and 2pi
point2X=point2X-point1X;
point2Y=point2Y-point1Y;
point1X=0; point1Y=0;
angle=angle2points(point1X,point1Y,point2X,point2Y);
if point2X<0 && point2Y>0
    angle=angle+3.14159265;
elseif point2X<0 && point2Y<0
    angle=angle+3.14159265;
elseif point2X>0 && point2Y<0
    angle=angle+3.14159265*2;
end

end
