I1 = imread('curve8.jpg')
I=im2bw(I1,0.4);
I=imcomplement(I);
%figure, imshow(I);
corners = detectHarrisFeatures(I, 'MinQuality', 0.4);
imshow(I); hold on;
plot(corners.selectStrongest(3));

%Distance Transform
D=bwdist(~I, 'euclidean');
figure
imshow(D,[],'InitialMagnification','fit')
D=-D;
D(~I)=Inf;

%Watershed
L=watershed(D);
L(~I) = 0;
% rgb = label2rgb(L,'jet',[.5 .5 .5]);
% figure
% imshow(rgb,'InitialMagnification','fit')
%title('Watershed transform of D')



%Ultimate Erosion algorithm to find seed points
% I4=bwulterode(L)
% figure, imshow(I4);



% %Find and plots centroids
s = regionprops(L, 'centroid','Orientation', 'MajorAxisLength', ...
    'MinorAxisLength', 'Eccentricity');
centroids = cat(1, s.Centroid);
hold on
imshow(I,'InitialMagnification','fit')
for k=1:length(s)
    plot(centroids(:,1),centroids(:,2), 'wx')
end
hold off



%Plot fitted ellipses (Does not work well for irregular images)
t = linspace(0,2*pi,50);

hold on
for k = 1:length(s)
    a = s(k).MajorAxisLength/2;
    b = s(k).MinorAxisLength/2;
    Xc = s(k).Centroid(1);
    Yc = s(k).Centroid(2);
    phi = deg2rad(-s(k).Orientation);
    x = Xc + a*cos(t)*cos(phi) - b*sin(t)*sin(phi);
    y = Yc + a*cos(t)*sin(phi) + b*sin(t)*cos(phi);
    plot(x,y,'r','Linewidth',2)
end
hold off
