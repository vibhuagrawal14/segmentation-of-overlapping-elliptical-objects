# Completing Overlapping Objects
Image processing code for completing overlapping convex objects through ellipse fitting.

Description of all major functions:

| Function|	Description|	Parameters|	Page on Thesis |
| ------------- | ------------- | ------------- | ------------- |
|Main|	Used to execute the code|	Image name and path|	N/A|
|MainCode	|Called by Main during each iteration	|Image name, path, range of radii, resize factor	|N/A|
|frst2d	|Fast Radial Symmetry algorithm	|Image, radii range, alpha (constant = 2), stdFactor (constant = 0.1)	|15|
|dist2points|	Calculates Euclidean distance between 2 points	|Coordinates of the 2 points|	N/A|
|div	|Calculates divergence factor for edge-to-seed-point association|	Image, list of seed-points, list of edge-points| 	19|
|angle2points1|	Calculates angle between 2 points (between 0 and 2*pi)	|Coordinates of the 2 points|	N/A|
|angle2points|	Calculates angle between 2 points (between -pi and pi)	|Coordinates of the 2 points|	N/A|
|preprocessing|	Binarizes an image	|Threshold factor|	26|
|EllipseDirectFit	|Fits an ellipse into the given data points|	List of data points	|22|
|drawarc|	Draws a circular arc between 2 points using their linked seed-point	Association matrix| E, the 2 points for drawing arc| 	21|
|drawellipse|	Calculates standard ellipse parameters from equation, and draws ellipse between 2 points|	Association matrix E, the 2 points for drawing arc, ellipse equation coefficients	|27|


Refer to Thesis.docx for full information on the algorithm and the results.
