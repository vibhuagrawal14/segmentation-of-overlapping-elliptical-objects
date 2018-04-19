%To call the function defined in frst2d.m
I = imread('curve5.jpg');
% I=imcomplement(I); 
Id = rgb2gray(I);
IdSmall = imresize(Id, 0.5);
IdSmall_temp=im2bw(IdSmall,0.3);
corners = detectHarrisFeatures(IdSmall_temp, 'MinQuality', 0.45);
f = frst2d(IdSmall,30:40,2, 0.1);

subplot(3,2,1),
imshow(IdSmall, []);
subplot(3,2,2);
imshow(f,[]);
f=im2bw(f,0.12);  %threshold the pixels to binary image
subplot(3,2,3), imshow(f);

%now, find seedpoints
s1=regionprops(IdSmall, 'centroid');
s = regionprops(f, 'centroid');
centroids = cat(1, s.Centroid);

subplot(3,2,4), imshow(IdSmall,[])
hold on

for k=1:length(s)
    plot(centroids(:,1),centroids(:,2), 'bx')
end
plot(corners);%.selectStrongest(2));






%fitting a circle
x1=corners.Location(1,1);
x2=corners.Location(2,1);
y1=corners.Location(1,2);
y2=corners.Location(2,2);
%first centroid
cx=centroids(1,1);
cy=centroids(1,2);
x3=(x1+x2)/2;
y3=(y1+y2)/2;
m=(x1-x2)/(y2-y1);
h=cx-m*((m*cx-cy+y3-m*x3)/(m*m+1));
k=cy-(-1)*((m*cx-cy+y3-m*x3)/(m*m+1));
plot(h,k,'gx');
%second centroid
dx=centroids(2,1);
dy=centroids(2,2);
x3=(x1+x2)/2;
y3=(y1+y2)/2;
m=(x1-x2)/(y2-y1);
h1=dx-m*((m*dx-dy+y3-m*x3)/(m*m+1));
k1=dy-(-1)*((m*dx-dy+y3-m*x3)/(m*m+1));
plot(h1,k1,'gx');
hold off;
subplot(3,2,5), imshow(IdSmall, []);
hold on

d1=sqrt((x1-h)^2+(y1-k)^2);
d2=sqrt((x1-h1)^2+(y1-k1)^2);
a=atan((y2-k)/(x2-h));
b=atan((y1-k)/(x1-h));

r=d1;
%plotting final circle1
%function [P] = plot_arc(a,b,h,k,r)
% Plot a circular arc as a pie wedge.
% a is start of arc in radians, 
% b is end of arc in radians, 
% (h,k) is the center of the circle.
% r is the radius.
t = linspace(a,b);
x = r*cos(t) + h;
y = r*sin(t) + k;
x = [x h x(1)];
y = [y k y(1)];
P = plot(x,y,'r');
axis([h-r-1 h+r+1 k-r-1 k+r+1]) 
axis square;
if ~nargout
    clear P
end

hold off;

%plotting final circle2
subplot(3,2,6), imshow(IdSmall, []);
hold on
b=pi+atan((y2-k1)/(x2-h1));
a=pi+atan((y1-k1)/(x1-h1));
h=h1;
k=k1;
r=d2;
t = linspace(a,b);
x = r*cos(t) + h;
y = r*sin(t) + k;
x = [x h x(1)];
y = [y k y(1)];
P = plot(x,y,'r');
axis([h-r-1 h+r+1 k-r-1 k+r+1]) 
axis square;
if ~nargout
    clear P
end
hold off
