I=imread('E:\IIRS 1 - Curve\Input\images vibhu\5.jpg');
subplot(1,2,1),imshow(I);
% I=imcomplement(I);
f = rgb2gray(I);
f=im2bw(f,0.5);
str=ones(2);
f=imcomplement(f);
% f=imerode(f,str);
f=imcomplement(f);

subplot(1,2,2), imshow(f);

iptsetpref('ImshowBorder','tight');

figure,imshow(f);
