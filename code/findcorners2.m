I1 = imread('curve4.jpg')
I=im2bw(I1,0.5);
I=imcomplement(I);
canny=edge(I,'canny');
figure, imshow(canny);
corners = detectHarrisFeatures(canny, 'MinQuality', 0.4);
imshow(canny); hold on;
plot(corners);