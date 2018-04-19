imageName='curve24'; %ImageName
imagePath='E:\IIRS 1 - Curve\Input\curve24.png';%Image Path
image=imread(imagePath);
[dimX1,dimY1]=size(image);
resize=1;
for rMin=round(dimX1*0.02-1):round(dimX1*0.05)
    for rMax=(rMin+7):round(dimX1*0.1)
        MainCode(imageName, imagePath, rMin, rMax, resize);
    end
end
