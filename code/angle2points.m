function[angle]=angle2points(point1X,point1Y,point2X,point2Y)
%This function returns the angle between two points between -pi/2 to pi/2
angle=atan((point2Y-point1Y)/(point2X-point1X));
end
