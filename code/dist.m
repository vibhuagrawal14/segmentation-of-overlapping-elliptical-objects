function [dM]= dist(centroids, corners)
    for i=1:length(centroids)
        for j=1:length(corners)
            x1=centroids(i,1);
            x2=corners.Location(j,1);
            y1=centroids(i,2);
            y2=corners.Location(j,2);
            dM(i,j)=sqrt((x1-x2)^2+(y1-y2)^2);
            %dM(i,j)=distance(centroids(i,:),(corners.Location(j,:)));
        end
    end      
end
