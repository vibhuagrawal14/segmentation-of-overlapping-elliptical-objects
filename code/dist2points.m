function [distance]=dist2points(point1X,point1Y, point2X, point2Y)
%Calculates the distance between two points
distance=sqrt((point1X-point2X)^2 +(point1Y-point2Y)^2);
end