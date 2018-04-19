function [ filtered ] = frst2d( image, radii, alpha, stdFactor )
%This function performs Fast Radial Symmetry transform on the image, and
%returns a transformed image according to the passed parameters
    original = double(image);

    [gy, gx] = gradient(original);
    
    maxR = ceil(max(radii(:)));
    offset = [maxR maxR];
    
    filtered = zeros(size(original) + 2*offset);

    
    S = zeros([numel(radii), size(filtered, 1), size(filtered, 2)]);
    
    radiusIndex = 1;
    for n = radii
        
        O_n = zeros(size(filtered));
        M_n = zeros(size(filtered));
        
        for i = 1:size(original, 1)
            for j=1:size(original, 2)
                p = [i j];
                g = [gx(i,j) gy(i,j)];
                gnorm = sqrt( g * g' ) ;
                if (gnorm > 0)
                    gp = round((g./gnorm) * n);
                    pnve = p - gp;
                    pnve = pnve + offset;
                    O_n(pnve(1), pnve(2)) = O_n(pnve(1), pnve(2)) - 1;
                    M_n(pnve(1), pnve(2)) = M_n(pnve(1), pnve(2)) - gnorm;
                    
                end
                
            end
        end

        O_n = abs(O_n);
        O_n = O_n ./ max(O_n(:));
        
        M_n = abs(M_n);
        M_n = M_n ./ max(M_n(:));
        
        
        S_n = (O_n.^alpha) .* M_n;
        
        gaussian = fspecial('gaussian', [ceil(n/2) ceil(n/2)], n*stdFactor);
        S(radiusIndex, :, :) = imfilter(S_n, gaussian);
        
        radiusIndex = radiusIndex + 1;
    end
    
    filtered = squeeze(sum(S, 1));
    filtered = filtered(offset(1)+1:end-offset(2), offset(1)+1:end-offset(2));

end
