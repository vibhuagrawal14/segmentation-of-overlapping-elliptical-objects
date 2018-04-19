function[]=MainCode(imageName,imagePath,rMin,rMax,resize)

try
L=1; %MSR variable
str=ones(3);
I=imread(imagePath);
%I=imread('input/curve8.jpg');%Input image
%I=imcomplement(I);%The image needs to be black objects on a white backgroud 
Id = rgb2gray(I);%Convert to grayscale
IdSmall = imresize(Id, resize);%Resize larger images for shorter run time
IdSmall_temp=im2bw(IdSmall,0.3);
[dimX,dimY]=size(IdSmall);
%-------------------------------------------------------------------------

%This part of the code finds the seedpoints in the image using fast radial
%symmetry (dark) algorithm and plots them

f = frst2d(IdSmall,rMin:rMax,2, 0.1);
figureName=[ imageName ' (' num2str(rMin) 'to' num2str(rMax) ')'];
figure('Name',figureName),
subplot(3,2,1),
imshow(IdSmall, []);%Plot result of FRS
title('Input Image');
subplot(3,2,2);
imshow(f,[]);
title('Fast Radial Symmetry Transform');
f=imerode(f,str);%Erode the result to remove erronous pixels
f=im2bw(f,0.04);%Threshold the pixels to binary image
subplot(3,2,3), imshow(f);%Plot threshold result
title('Thresholded FRS image');
s1=regionprops(IdSmall, 'centroid');
s = regionprops(f, 'centroid');%Detecting seed points from threshold of FRS
centroids = cat(1, s.Centroid);
subplot(3,2,4), imshow(IdSmall,[])

% figure,imshow(IdSmall,[])

title('Estimated Seed-points');
hold on
for k=1:length(s)
    plot(centroids(k,1),centroids(k,2), 'bx')
    desX=centroids(k,1);
    desY=centroids(k,2);
    desTxt=num2str(k);
%     text(desX,desY,desTxt,'Color','blue');
end
hold off
%-------------------------------------------------------------------------

%This part computes the edge map, then dilates it to 2-pixel wide edge

e = edge(IdSmall,'log');%Compute edge-map
%  figure, imshow(e);
str=ones(4);
e1=imdilate(e,str);%dilate edge-map to get 2-pixel wide edge
% figure,imshow(e1);
%-------------------------------------------------------------------------

%This part creates a matrix with all the edge points in a list format (E)
[rows,cols]=size(IdSmall);
v=1;
E=zeros(v,6);
for i=1:rows
    for j=1:cols
        if e(i,j)==1
            E(v,1)=j;
            E(v,2)=i;
            v=v+1;
        end
    end
end
%-------------------------------------------------------------------------

%Initializing some variables
arr=0;
g11=0; d11=0;
E(:,3)=0;
E(:,4)=0;
v=v-1;
rel=0;
MSR=0;
lambda=0;%Relevance metrix parameter 
[Gmag,Gdir] = imgradient(IdSmall);%Calculate the gradient map to be used in the relevance metric
%imshow(Gdir);
E(:,3)=0;
E(:,4)=0;
%-------------------------------------------------------------------------

%This part of the code links each pixel on the edge to a seedpoint using a
%relevance metric defined below
arr=zeros(1,v);
g11=zeros(1,v);
d11=zeros(1,v);


for i=1:v
    row=0;
    rel=0;
    MSR=0; 
    L=1;
    g=0;
    d=0;
    dont=0;
    MSR=zeros(10,2);
    for k=1:length(s)%Check each pixel's relevance for each seedpoint
        dont=0;
        distVar=round(dist2points(centroids(k,1),centroids(k,2),E(i,1),E(i,2)));
        if dist2points(centroids(k,1),centroids(k,2),E(i,1),E(i,2))<rMax*1.5 
            %Only check the seedpoints that are in the vicinity of the current pixel
            xi(1)=E(i,1);
            yi(1)=E(i,2);
            xi(2)=centroids(k,1);
            yi(2)=centroids(k,2);
            if xi(1)>0 && xi(2)>0 && yi(1)>0 && yi(2)>0 && distVar>0
%             [ix,iy,intensity] = improfile(e1,double(xi),double(yi),100);
            [ix,iy,intensity] = improfile(e1,double(xi),double(yi),3*distVar);
%             for j=length(intensity):1
%             if intensity(j)>0 && ix(j)~=E(i,1)
            for j=13:length(intensity)
              
                if intensity(j)>0
                    dont=1;
                end
            end
            %----------------------
            end
            if dont~=1
            MSR (L,1)=centroids(k,1);
            MSR (L,2)=centroids(k,2);
            g=dist2points(centroids(k,1),centroids(k,2),E(i,1),E(i,2));%calculate distance from seedpoint 
            d=div(IdSmall,centroids,s,E(i,2),E(i,1));%calculate divergence from seedpoint
            g1(L)=((1-lambda)/(1+g));%Part 1 of relevance metric
            d1(L)=(lambda*(d+1)/2);%Part 2 of relevance metric
            rel(L)=g1(L)+d1(L);%Relevance metric
            L=L+1;
            end
        end
    end
    L=L-1;
    %Link the pixel with the seedpoint that has the maximum relevance and
    %store the seedpoint in the edge pixel list E
    if L~=0
    maxRel=max(rel);
    arr=[arr maxRel];
    [row] = find(rel==maxRel);
    g11=[g11 g1(row)];
    d11=[d11 d1(row)];
    E(i,3)=MSR(row,1);
    E(i,4)=MSR(row,2);
    E(i,5)=angle2points1(E(i,3),E(i,4),E(i,1),E(i,2));%Calculate angle of pixel from seedpoint and store in list
    end

end
sp=0;
L=1;
%-------------------------------------------------------------------------

%Sorting of array. The list E will now be sorted according to seedpoint and
%increasing angle
E=sortrows(E,5);
E=sortrows(E,3);
E=sortrows(E,4);
first=1;

%This part calculates the differences of angles of two consecutive pixels
for i=1:v-1
    if E(i+1,3)~=E(i,3) && E(i+1,4)~=E(i,4)
        E(i,6)=E(i,5)-E(first,5)-2*3.14159265;
        first=i+1;
    else
    E(i,6)=E(i,5)-E(i+1,5);
    end
    if i==v-1
        E(i+1,6)=E(i+1,5)-E(first,5)-2*3.14159265;
    end
end
avg=mean(abs(E));
avg=avg(6);
%-------------------------------------------------------------------------

%Reorganizing the data present in E
sp=zeros(length(s),500,3);
for k=1:length(s)
    L=1;
    for i=1:v
        if E(i,3)==centroids(k,1) && E(i,4)==centroids(k,2)
                sp(k,L,1)=E(i,1);
                sp(k,L,2)=E(i,2);
                sp(k,L,3)=angle2points(centroids(k,1),centroids(k,2),E(i,1),E(i,2));
                L=L+1;
        end
    end
end
%-------------------------------------------------------------------------

%This part gives a unique random color to each object detected, and stores
%the color values to be used later while plotting
[x,y,z]=size(sp);
newImg=zeros(rows,cols,3);   
for i=1:x
    i1=rand;
    i2=rand;
    i3=rand;
    col(i,1)=i1;
    col(i,2)=i2;
    col(i,3)=i3;
    for j=1:y
        if sp(i,j,1)~=0 && sp(i,j,2)~=0
            newImg(sp(i,j,2),sp(i,j,1),1)=i1;
            newImg(sp(i,j,2),sp(i,j,1),2)=i2;
            newImg(sp(i,j,2),sp(i,j,1),3)=i3;
        end
    end
end
% figure,imshow(newImg,[]);%To plot the edge map with different objects marked in different colors
subplot(3,2,5),
imshow(IdSmall,[]);
title('Output');
hold on

for k=1:length(s)
    plot(centroids(k,1),centroids(k,2), 'bx')
    desX=centroids(k,1);
    desY=centroids(k,2);
    desTxt=num2str(k);
%     text(desX,desY,desTxt,'Color','blue');
end  
%-------------------------------------------------------------------------

%This part draws circular arcs in between points where a gap is detected
% for i=1 :v-1
%     
%     if abs(E(i,6))>abs(7*avg)
%         if E(i+1,3)~=E(i,3) && E(i+1,4)~=E(i,4)
%             [x,y]=drawarc(E,i,first);
% %           [x,y]=drawarc(E,i-1,first+1);
%             [c,d] = find(centroids(:,1)==E(i,3));
%             plot(x,y,'color',[col(c,1),col(c,2),col(c,3)]);
%     
%         else
%             [x,y]=drawarc(E,i,i+1);
% %             [x,y]=drawarc(E,i-1,i+2);
%             [c,d] = find(centroids(:,1)==E(i,3));
%             plot(x,y,'color',[col(c,1),col(c,2),col(c,3)]);
%     
%         end
%     end
%     if E(i+1,3)~=E(i,3) && E(i+1,4)~=E(i,4)
%         first=i+1;
%     end
%     if i==v-1
%         i=i+1;
%         if abs(E(i,6))>abs(7*avg)
%             [x,y]=drawarc(E,i,first);
% %             [x,y]=drawarc(E,i-1,first+1);
%             [c,d] = find(centroids(:,1)==E(i,3));
%             plot(x,y,'color',[col(c,1),col(c,2),col(c,3)]);
%     
%         end
%         i=i-1;
%     end
%     
% end
%-------------------------------------------------------------------------

%This part of the code takes each seedpoint and its linked edge pixels, and
%fits an ellipse using the Direct Fit method. The ellipse parameters are
%then passed to the drawellipse1 function and the relevant part of the
%ellipse is then plotted between two points
sp2=zeros(length(s),7);

for k=1:length(s)
    x=0;y=0;
    c=1;
    zer=0;
    zer=find(sp(k,:,1)==0);
    if ~isnan(zer)
    XY=squeeze(sp(k,1:zer(1)-1,1:2));
    else
    XY=squeeze(sp(k,:,1:2));  
    end
    XY=squeeze(XY);
    if any(XY)
    A = EllipseDirectFit(XY);%Ellipse parameters are stored in the array A
    sp2(k,1)=A(1);
    sp2(k,2)=A(2);
    sp2(k,3)=A(3);
    sp2(k,4)=A(4);
    sp2(k,5)=A(5);
    sp2(k,6)=A(6);
    if sp2(k,1)<0
        for loopvar1=1:6 %loop variable 1
            sp2(k,loopvar1)=sp2(k,loopvar1)*(-1);
        end
    end
    %Convert the A to str 
    a = num2str(A(1)); 
    b = num2str(A(2)); 
    c = num2str(A(3)); 
    d = num2str(A(4)); 
    f = num2str(A(5)); 
    g = num2str(A(6));
    %Equation 
    eqt= ['(',a,')*x^2 + (',b,')*x*y + (',c,')*y^2 + (',d,')*x+ (',f,')*y + (',g,')']; 
    %Entire ellipse may be plotted using ezplot function passing eqt 
    a=A(1);
    b=A(2);
    c=A(3);
    d=A(4);
    f=A(5);
    g=A(6);
%     xmin=0.1*min(XY(:,1)); 
%     xmax=2*max(XY(:,2)); 
%     ezplot(eqt,[xmin,xmax]) 
    %----------------------
    for i=1:v
        if E(i,3)==centroids(k,1) && E(i,4)==centroids(k,2)
            first=i;
            break;
        end
    end
    %----------------------

    
    %This part of the code finds the gaps in the edges and plots a part of the ellipse
    for i=first:v-1   
        x=0;y=0;
    if E(i,3)==centroids(k,1) && E(i,4)==centroids(k,2)
        if abs(E(i,6))>abs(4*avg)
            if E(i+1,3)~=E(i,3) && E(i+1,4)~=E(i,4)
                [x,y]=drawellipse1(E,i,first,a,b,c,d,f,g);
%                 [x,y]=drawarc(E,i-1,first+1);
                [c1,d1] = find(centroids(:,1)==E(i,3));
%                 plot(x,y,'r');
                plot(x,y,'color',[col(c1,1),col(c1,2),col(c1,3)]);

            else
                [x,y]=drawellipse1(E,i,i+1,a,b,c,d,f,g);
%                 [x,y]=drawarc(E,i,i+1);
%                 [x,y]=drawarc(E,i-1,i+2);
                [c1,d1] = find(centroids(:,1)==E(i,3));
%                 plot(x,y,'r');
                plot(x,y,'color',[col(c1,1),col(c1,2),col(c1,3)]);

            end
        end
        if E(i+1,3)~=E(i,3) && E(i+1,4)~=E(i,4)
            first=i+1;
        end
        if i==v-1
            i=i+1;
            if abs(E(i,6))>abs(4*avg)
                [x,y]=drawellipse1(E,i,first,a,b,c,d,f,g);
%                 [x,y]=drawarc(E,i,first);
%                 [x,y]=drawarc(E,i-1,first+1);
                [c1,d1] = find(centroids(:,1)==E(i,3));
%                 plot(x,y,'r');
                plot(x,y,'color',[col(c1,1),col(c1,2),col(c1,3)]);

            end
            i=i-1;
        end
    else
        break;
    end
    end
    end
end

%-------------------------------------------------------------------------

%This part of the code finds and stores the eccentricities and areas of the
%objects
value(1:dimX,1:dimY)=0;
area(1:length(s))=0;
for k=1:length(s)
    A=sp2(k,1);
    B=sp2(k,2);
    C=sp2(k,3);
    D=sp2(k,4);
    F=sp2(k,5);
    G=sp2(k,6);
    e = 4*A*C-B^2;  
    x0 = (B*F-2*C*D)/e; %center points
    y0 = (B*D-2*A*F)/e;

    F0 = -2*(A*x0^2+B*x0*y0+C*y0^2+D*x0+F*y0+G);
    g1 = sqrt((A-C)^2+B^2); 
    a1 = F0/(A+C+g1); 
    b1 = F0/(A+C-g1);
    % Major & minor axes
    a1 = sqrt(a1);  
    b1 = sqrt(b1);
    if a1<b1
        temp=b1;
        b1=a1;
        a1=temp;
    end
    sp2(k,7)=sqrt(1-(b1^2)/(a1^2));
    area(k)=pi*a1*b1;
end
area=round(area);

%-------------------------------------------------------------------------
om=zeros(k);%Individual overlap matrix

%This part of the code assigns to each pixel its degree of overlap.

for i=1:dimY
    for j=1:dimX
        for k=1:length(s)
            point1=sp2(k,1)*i*i+sp2(k,2)*i*j+sp2(k,3)*j*j+sp2(k,4)*i+sp2(k,5)*j+sp2(k,6);
%             if sp2(k,1)<0 
%                 if point1>0
%                     value(j,i)=value(j,i)+1;
%                 end
%             else
                if point1<0
                    value(j,i)=value(j,i)+1;
                    for m=(k+1):length(s)
                        point2=sp2(m,1)*i*i+sp2(m,2)*i*j+sp2(m,3)*j*j+sp2(m,4)*i+sp2(m,5)*j+sp2(m,6);
                        if point2<0
                            om(k,m)=om(k,m)+1;
                        end
                    end
                end
%             end
        end
    end
end

%-------------------------------------------------------------------------


%This part of the code traverses over all the pixels and finds the ratio of
%overlapping pixels to non overlapping area, for all objects


ocount(1:length(s))=0;
for i=1:dimY
    for j=1:dimX
        for k=1:length(s)
            point1=sp2(k,1)*i*i+sp2(k,2)*i*j+sp2(k,3)*j*j+sp2(k,4)*i+sp2(k,5)*j+sp2(k,6);
%             if sp2(k,1)<0 
%                 if point1>0
%                     if value(j,i)>1
%                         ocount(k)=ocount(k)+1;
%                     end
%                 end
%             else
                if point1<0
                    if value(j,i)>1
                        ocount(k)=ocount(k)+1;
                    end
%               end
            end
        end
    end
end
overlapRatio(1:length(s))=0;
for k=1:length(s)
    overlapRatio(k)=ocount(k)/area(k);
    nonoverlap(k)=area(k)-ocount(k);
    nonoverlapRatio(k)=nonoverlap(k)/area(k);
end
count1=0;
ocount1=0;
for i=1:dimY
    for j=1:dimX
        if value(j,i)>0
            count1=count1+1;
            if value(j,i)>1
                ocount1=ocount1+1;
            end
        end
    end
end
totalOverlap=ocount1/count1;

%-------------------------------------------------------------------------

%This part of the code creates a spreadsheet (xlsx) and stores
%eccentricities, overlap area, overlap ratios, total overlap, average
%overlap, average eccentricities



filename=[figureName 'overlap.xlsx'];
delete(filename);
sheet=1; 



A={'Object Number',};
numbers=1:length(s);
numbers=numbers';
toExcel( filename, numbers, sheet, 'A1','A2',A);

A={'Eccentricity',};
numbers=sp2(1:length(s),7);
toExcel( filename, numbers, sheet, 'B1','B2',A);

A={'Overlap Area',};
numbers=ocount;
numbers=numbers';
toExcel( filename, numbers, sheet, 'C1','C2',A);

A={'Overlap Percentage',};
overlapRatio=overlapRatio*100;
numbers=overlapRatio;
numbers=numbers';
toExcel( filename, numbers, sheet, 'D1','D2',A);

A={'Non-Overlap Area',};
numbers=nonoverlap;
numbers=numbers';
toExcel( filename, numbers, sheet, 'E1','E2',A);

A={'Non-Overlap Percentage',};
nonoverlapRatio=nonoverlapRatio*100;
numbers=nonoverlapRatio;
numbers=numbers';
toExcel( filename, numbers, sheet, 'F1','F2',A);

% A={'Average Eccentricity',};
% numbers=mean(sp2(:,7));
% numbers=numbers'; 
% toExcel( filename, numbers, sheet, 'G1','G2',A);
% 
% A={'Average Overlap',};
% numbers=mean(overlapRatio);
% numbers=numbers';
% toExcel( filename, numbers, sheet, 'H1','H2',A);

numbers=mean(sp2(:,7));%Mean eccentricity
numbers=numbers'; 
xlRange1=['B' num2str(length(s)+3)];
xlswrite(filename,numbers,sheet,xlRange1);

numbers=median(sp2(:,7));%Median eccentricity
numbers=numbers'; 
xlRange1=['B' num2str(length(s)+4)];
xlswrite(filename,numbers,sheet,xlRange1);

numbers=std(sp2(:,7));%Standard Deviation eccentricity
numbers=numbers'; 
xlRange1=['B' num2str(length(s)+5)];
xlswrite(filename,numbers,sheet,xlRange1);


numbers=mean(ocount);%Mean overlap area
numbers=numbers'; 
xlRange1=['C' num2str(length(s)+3)];
xlswrite(filename,numbers,sheet,xlRange1);

numbers=median(ocount);%Median overlap area
numbers=numbers'; 
xlRange1=['C' num2str(length(s)+4)];
xlswrite(filename,numbers,sheet,xlRange1);

numbers=std(ocount);%Standard Deviation overlap area
numbers=numbers'; 
xlRange1=['C' num2str(length(s)+5)];
xlswrite(filename,numbers,sheet,xlRange1);


numbers=mean(overlapRatio);%Mean overlap percentage
numbers=numbers'; 
xlRange1=['D' num2str(length(s)+3)];
xlswrite(filename,numbers,sheet,xlRange1);

numbers=median(overlapRatio);%Median overlap percentage
numbers=numbers'; 
xlRange1=['D' num2str(length(s)+4)];
xlswrite(filename,numbers,sheet,xlRange1);

numbers=std(overlapRatio);%Standard Deviation overlap percentage
numbers=numbers'; 
xlRange1=['D' num2str(length(s)+5)];
xlswrite(filename,numbers,sheet,xlRange1);




numbers=mean(nonoverlap);%Mean non overlap area
numbers=numbers'; 
xlRange1=['E' num2str(length(s)+3)];
xlswrite(filename,numbers,sheet,xlRange1);

numbers=median(nonoverlap);%Median non overlap area
numbers=numbers'; 
xlRange1=['E' num2str(length(s)+4)];
xlswrite(filename,numbers,sheet,xlRange1);

numbers=std(nonoverlap);%Standard Deviation non overlap area
numbers=numbers'; 
xlRange1=['E' num2str(length(s)+5)];
xlswrite(filename,numbers,sheet,xlRange1);


numbers=mean(nonoverlapRatio);%Mean overlap percentage
numbers=numbers'; 
xlRange1=['F' num2str(length(s)+3)];
xlswrite(filename,numbers,sheet,xlRange1);

numbers=median(nonoverlapRatio);%Median overlap percentage
numbers=numbers'; 
xlRange1=['F' num2str(length(s)+4)];
xlswrite(filename,numbers,sheet,xlRange1);

numbers=std(nonoverlapRatio);%Standard Deviation overlap percentage
numbers=numbers'; 
xlRange1=['F' num2str(length(s)+5)];
xlswrite(filename,numbers,sheet,xlRange1);




A={'Mean',};
xlRange1=['A' num2str(length(s)+3)];
xlswrite(filename,A,sheet,xlRange1);

A={'Median',};
xlRange1=['A' num2str(length(s)+4)];
xlswrite(filename,A,sheet,xlRange1);

A={'Standard Deviation',};
xlRange1=['A' num2str(length(s)+5)];
xlswrite(filename,A,sheet,xlRange1);

%-------------------------------------------------------------------------

%This part of the code stores the overlaps for each object in sheet 2

sheet=2;
A=om;
xlRange1='A1';
xlswrite(filename,A,sheet,xlRange1);

%-------------------------------------------------------------------------

print(figureName,'-dtiffn'	);

%-------------------------------------------------------------------------

catch
disp(['Cannot complete image for radii rMin ' num2str(rMin) ' and rMax ' num2str(rMax)]);   
disp('due to bad estimation of seed-point for this pair of rMin and rMax');
    
end


end            

%-------------------------------------------------------------------------
         
         
         
         