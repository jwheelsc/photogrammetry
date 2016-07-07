%%% so there are two sets of points, the reference (camera) line is blue
%%% and the model line is red, every time a line is rotated, the line gets
%%% thinner

%%% line 1 is a column vector [x,y,z]' where C is for camera, p is for
%%% point, and l is for l. M is for Model

function [newXYZ,MCp] = rotateFunction(M,mC,rC)

l12C = rC;

%%% here you set up an arbitraty camera line between the model
l12M = mC;

% here you can take a set of points, whether arbitrary or not

%%%okay now you rotate all the points so that the camera line is rotated
%%%about z over the positve x axis. the angle is made positive becasue we
%%%are in a right hand system, but I want to rotate clockwise, whereas the
%%%convention is ccw
rise = (l12C(2,2)-l12C(2,1));
run  = (l12C(1,2)-l12C(1,1));
psiz = -atan(rise/run);
%%%the rotation matrix about z is
Mrz = [cos(psiz) -sin(psiz) 0; sin(psiz) cos(psiz) 0; 0 0 1];
%%% and all new coordinates are now
l12Cp = Mrz*l12C;
l12Mp = Mrz*l12M;
M1p = Mrz*M;

M1p(:,1:10)

%%% now i want to get my line positioned flat on x, so I compute it's angle
%%% with the x axis as using the rotation about y with Mry
rise = (l12Cp(3,2)-l12Cp(3,1));
run  = (l12Cp(1,2)-l12Cp(1,1));
psiy = -atan(rise/run);
Mry = [cos(psiy) 0 -sin(psiy); 0 1 0; sin(psiy) 0 cos(psiy)];
l12Cpp = Mry*l12Cp;
l12Mpp = Mry*l12Mp;
M2p = Mry*M1p;
M2p(:,1:10)

%%%now i want to apply the same transformation, but only to the model line,
%%% to get it to lay flat on the x axis. 

%%% so again, first rotate about z
rise = (l12Mpp(2,2)-l12Mpp(2,1));
run  = (l12Mpp(1,2)-l12Mpp(1,1));
psiz2 = -atan(rise/run);
%%%the rotation matrix about z is, with Mrz2 indicatingd the second roation
%%%about z
Mrz2 = [cos(psiz2) -sin(psiz2) 0; sin(psiz2) cos(psiz2) 0; 0 0 1];
%%% and all new coordinates are now, with the 3p indicating tripple prime
l12M3p = Mrz2*l12Mpp;
M3p = Mrz2*M2p;
M3p(:,1:10)

%%% and now, rotate about y
rise = (l12M3p(3,2)-l12M3p(3,1));
run  = (l12M3p(1,2)-l12M3p(1,1));
psiy2 = -atan(rise/run);
Mry2 = [cos(psiy2) 0 -sin(psiy2); 0 1 0; sin(psiy2) 0 cos(psiy2)];
l12M4p = Mry2*l12M3p;
M4p = Mry2*M3p;
M4p(:,1:10)

%%% okay, what a battle, now rotate both lines back up to the position of
%%% the original C line
psiy = -psiy;
Mry3 = [cos(psiy) 0 -sin(psiy); 0 1 0; sin(psiy) 0 cos(psiy)];
l12M5p = Mry3*l12M4p;
l12C3p = Mry3*l12Cpp;
M5p = Mry3*M4p;
M5p(:,1:10)

%%% and lastly rotate back about z
psiz = -psiz;
Mrz = [cos(psiz) -sin(psiz) 0; sin(psiz) cos(psiz) 0; 0 0 1];
l12M6p = Mrz*l12M5p;
l12C4p = Mrz*l12C3p;
newXYZ = Mrz*M5p;
newXYZ(:,1:10)
MCp = l12C4p;





