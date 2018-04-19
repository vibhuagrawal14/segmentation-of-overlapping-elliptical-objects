clear all
rMin=20;%minimum estimated radius of objects
rMax=40;%maximum estimated radius of objects 
xExt=0;yExt=0;

I=imread('curve5.jpg');
%I=imcomplement(I);%The image needs to be black objects on a white backgroud 
Id = rgb2gray(I);
IdSmall = imresize(Id, 0.5);
IdSmall_temp=im2bw(IdSmall,0.3);
[dimX,dimY]=size(IdSmall);
corners = detectHarrisFeatures(IdSmall_temp, 'MinQuality', 0.4);%Detecting intersection points of the objects
f = frst2d(IdSmall,rMin:rMax,2, 0.1);%Fast radial symmetry (Dark)
subplot(2,2,1),
imshow(IdSmall, []);%Plot result of FRS
subplot(2,2,2);
imshow(f,[]);
f=im2bw(f,0.12);%Threshold the pixels to binary image
subplot(2,2,3), imshow(f);%Plot threshold result

s1=regionprops(IdSmall, 'centroid');%Detecting seed points from threshold of FRS
s = regionprops(f, 'centroid');
centroids = cat(1, s.Centroid);

B = bwperim(IdSmall,8);%outline of entire image

subplot(2,2,4), imshow(IdSmall,[])
hold on

for k=1:length(s)
    plot(centroids(:,1),centroids(:,2), 'bx')
end
plot(corners);

d=dist(centroids,corners)%Matrix holding distance from each centroid to each corner

% for i=1:length(centroids)
%     M=min(d(i,:));
%     for j=1:length(corners)
%         if d(i,j)<=(M*1.1)
%             if d(i,j)>=(M*0.9)%connectivity
%             con(i,j,:)=corners.Location(j,:);         
%             end
%         end
%     end
% end
% hold off
% %why is con so big? 

figure, imshow(IdSmall,[])
hold on
length(centroids)
for i=1:length(centroids)
    M=min(d(i,:));%finding the closest corner point
    
    if M<1.4*rMax %To not run for non-overlapping objects
        c1=1;
        xc=0;yc=0;
        
        for j=1:length(corners)
            if d(i,j)<=(M*1.4)%finding other possible corner points in the range radius of 0.6r-1.4r
                 if d(i,j)>=(M*0.6)%connectivity
                    xc(c1)= corners.Location(j,1);
                    yc(c1)= corners.Location(j,2);
                    c1=c1+1;
                 end
            end
        end
        xc;
        c1=c1-1;

        %     c=1;
        %     for j=1:length(corners)
        %         if con(i,j,1)~=0
        %             p(c)=j;
        %             c=c+1;
        %         end    
        %     end

        %     x1=con(i,p(1),1);
        %     x2=con(i,p(2),1);
        %     y1=con(i,p(1),2);
        %     y2=con(i,p(2),2);
        for z=1:c1-1 
            dontPlot=0;% middleObject=0;    

            x1=xc(z)
            x2=xc(z+1)%taking two corner points at a time
            y1=yc(z)
            y2=yc(z+1)
            [h,k]=fitting1(x1,x2,y1,y2,centroids(i,1),centroids(i,2)); %find center by projecting the seedpoint

            plot(h,k,'gx');
            a=atan2((y2-k),(x2-h));
            b=atan2((y1-k),(x1-h));

            if a<b
                t=a;a=b;b=t;
            end


            d1=sqrt((x1-h)^2+(y1-k)^2);
            t = linspace(b,a);
            r=d1*0.9;%error tolerance?
            x = r*cos(t) + h;
            y = r*sin(t) + k;  
            xExt=round(r*1.2*cos(t(50))+h); %check if the arc is being drawn in the right direction
            yExt=round(r*1.2*sin(t(50))+k);


           % if ~isnan(xExt)

                if ((xExt<dimX) && (yExt<dimY))
           % plot(xExt,yExt,'rx');
                if IdSmall(xExt,yExt)>100
                        c=2*pi-abs(a)-abs(b);
                        b=a+c;
                        t = linspace(b,a);%check if arc is being drawn in the right direction after changing direction
                        r=d1*0.9;%error tolerance?
                        x = r*cos(t) + h;
                        y = r*sin(t) + k;  
                        xExt=round(r*1.2*cos(t(50))+h);
                        yExt=round(r*1.2*sin(t(50))+k);
                       %plot(xExt,yExt,'gx');

                        if IdSmall(xExt,yExt)>100 %if the arc still fails to satisfy the criteria, then the arc is not viable
                             dontPlot=1; %dont draw the arc
                        end   
                end
                else %if the external point to be checked is outside the image, assume that its white
                c=2*pi-abs(a)-abs(b);
                        b=a+c;
                        t = linspace(b,a);%check if arc is being drawn in the right direction after changing direction
                        r=d1*0.9;%error tolerance?
                        x = r*cos(t) + h;
                        y = r*sin(t) + k;  
                        xExt=round(r*1.2*cos(t(50))+h);
                        yExt=round(r*1.2*sin(t(50))+k);
                       %plot(xExt,yExt,'gx');

                        if IdSmall(xExt,yExt)>100 %if the arc still fails to satisfy the criteria, then the arc is not viable
                             dontPlot=1; %dont draw the arc
                        end     
                end

            if a<b
                t=a;a=b;b=t;
            end
            t = linspace(a,b);
            r=d1;%error tolerance?
            x = r*cos(t) + h;
            y = r*sin(t) + k;  
            if dontPlot~=1
            %curvefitting2(IdSmall,h,k,r,a,b,t,x,y);
            curveFitting(IdSmall,h,k,r,a,b,x,y);
            %curvefitting3(IdSmall,h,k,r,a,b,x,y);
            P = plot(x(15:85),y(15:85),'w');
        %     P = plot(x,y,'r');
             end
             %end
            c1=c1+1;

            end
        %       r=d1;
        %       d = sqrt((x2-x1)^2+(y2-y1)^2); % Distance between points
        %       %a = atan2(-(x2-x1),y2-y1); % Perpendicular bisector angle
        %       a = atan2(x2-x1,-(y2-y1));
        %       b = asin(d/2/r); % Half arc angle
        %       c = linspace(a-b,a+b); % Arc angle range
        %       e = sqrt(r^2-d^2/4); % Distance, center to midpoint
        %       x = (x1+x2)/2-e*cos(a)+r*cos(c); % Cartesian coords. of arc
        %       y = (y1+y2)/2-e*sin(a)+r*sin(c);
        %       
        %       slopex=(x(10)-h)/r;
        %       slopey=(y(10)-k)/r;
        %       xExt=round(h+slopex*r*1.1); %extrapolate
        %       yExt=round(k+slopey*r*1.1);
        %       plot(xExt,yExt,'rx');
        %       if IdSmall(xExt,yExt)==0
        %           a = atan2(x2-x1,-(y2-y1));
        %       else
        %           a = atan2(-(x2-x1),y2-y1);
        %       end
        %       b = asin(d/2/r);
        %       c = linspace(a-b,a+b);
        %       e = sqrt(r^2-d^2/4);
        %       x = (x1+x2)/2-e*cos(a)+r*cos(c);
        %       y = (y1+y2)/2-e*sin(a)+r*sin(c);
        %       plot(x,y,'r');
    end         
end

hold off
%if centers are not accurate, try recursive process
