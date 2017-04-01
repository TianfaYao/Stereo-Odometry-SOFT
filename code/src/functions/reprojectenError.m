function error = reprojectenError(t, R, K1, K2, points3D, pts_l, pts_r)
%%Reprojection error function to be minimized for translation t
%   K1, K2: 3 x 3 Intrinsic parameters matrix for the left and right cameras
%   R: Estimated rotation matrix from the previous step
%   points3D: 3D Point cloud generated from stereo pair
%   pts_l: matched feature points locations in left camera frame
%   pts_r: matched feature points locations in right camera frame

% Writing 3D coordinates in homogenous form
points3D = [points3D; ones(1,length(points3D(1,:)))];

% Retrieving image coordinates from datatype cornerPoints
pts_l = pts_l.Location';  
pts_r = pts_r.Location';
    
% Homogenous coordinates projection on camera's image plane
proj_l = K1*[R, t]*points3D;
proj_r = K2*[R, t]*points3D;

% Normalize z row of projection to use x and y coordinates.
proj_nl = hom2cart(proj_l')';
proj_nr = hom2cart(proj_r')';

e_l = sum((proj_nl - pts_l).^2, 1);
e_r = sum((proj_nr - pts_r).^2, 1);

% Calculate total error
error = sum(e_l+e_r,2);
end