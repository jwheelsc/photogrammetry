clear all
close all

% here you can get the point cloud from ptCloud, but for some reason,
% ptCloud won't read in the colors from the .ply file, so you actually have
% to read in the .ply file from textscan and convert the colors to uint8,
% then plot it. 

% load the pointcloud cloud from the vSFM model
ptCloud = pcread('D:\Code\photogrammetry\imageSequences\Glaciers\GL1\PG1\test1.nvm.cmvs\00\models\option-0000.ply');
% read in just the xyz coordinates and color from the same point clod
f1 = fopen('D:\Code\photogrammetry\imageSequences\Glaciers\GL1\PG1\test1.nvm.cmvs\00\models\option-0000_4ml.ply');
a1 = textscan(f1,'%f %f %f %f %f %f %d %d %d');
xyz = [a1{1} a1{2} a1{3}];
color = [a1{7} a1{8} a1{9}];
close all
% convert the color format and append it to ptCloud
ptCloud.Color = uint8(color);
fig1 = pcshow(ptCloud)

%%


l1p1 = [0.2615,-0.106,3.841]
l1p2 = [0.2554,-0.1242,3.859]
l2p1 = [0.3776,-0.1518,3.822]
l2p2 = [0.4049,-0.1591,3.821]
l3p1 = [0.2082,-0.04165,3.815]
l3p2 = [0.2088,-0.05959,3.825]

bars = [0.2615,-0.106,3.841;0.2554,-0.1242,3.859;0.3776,-0.1518,3.822;...
    0.4049,-0.1591,3.821;0.2082,-0.04165,3.815;0.2088,-0.05959,3.825]


% %%
% [gx,gy] = ginput(6)
% 
% %% find the elements that belong to these points
% 
% for i = 1:length(gx)
%       
%     i = 2
%     elx = find(abs(double(xyz(:,1))-gx(i))<1e-4)
%     ely = find(abs(double(xyz(:,2))-gy(i))<1e-4)
%     intersect(elx,ely)
%     
% end


%%

% read in the camera coordinates from the vSFM model
f2 = fopen('D:\Code\photogrammetry\imageSequences\Glaciers\GL1\PG1\test1.nvm.cmvs\00\centers-0000_4ml.ply');
a = textscan(f2,'%f %f %f');
p = [a{1} a{2} a{3}];

% figure out which stations the cameras belong to in the model
clust = kmeans(p,2)
p1 = p(clust==1,:)
p2 = p(clust==2,:)
hold on
plot3(p1(:,1),p1(:,2),p1(:,3),'r.')
hold on
plot3(p2(:,2),p2(:,2),p2(:,3),'b.')

% here are the "real" camera coordinates from the GPS location
rC = [[221,859,2107]',[214,948,2115]']
len = rC(:,1)-rC(:,2)
d = sqrt(len(1)^2+len(2)^2+len(3)^2)
uVec = len/d

hold on
% here is a vector that assumes that the first camera is at the origin,
% while the second camera is at the end of the unit vector
plot3([0 uVec(1)],[0 uVec(2)],[0 uVec(3)],'go-')

% %%% compute distance between all camera pairs
% for i = 1:length(p(:,1))-1
%     for j = i+1:length(p(:,1))
%         
%         d(i,j-1)=sqrt((p(i,1)-p(j,1))^2+(p(i,2)-p(j,2))^2+(p(i,3)-p(j,3))^2)
%         
%     end
% end
% aved = mean(mean(d~=0))

%%% try the following two camera points
mC = [p1(1,:)',p2(1,:)']
rC = [[221,859,2107]',[214,948,2115]'] 

[xyzp,newC] = rotateFunction(ptCloud.Location',mC,rC);

M = xyzp';
hold on
fig1 = plot3(M(:,1),M(:,2),M(:,3),'k.')

%%% or, with or wihtout rotating the vectors, we can scale 
% first find the ration of the lengths of cameras
count_ij = 1
for i = 1:length(p1(:,1))
    for j = 1:length(p2(:,1))
        len_m = p1(i,:)'-p2(j,:)';
        d_m(count_ij) = sqrt(len_m(1)^2+len_m(2)^2+len_m(3)^2);
        count_ij = count_ij + 1;
    end
end

f = d/mean(d_m)
fp = d/(mean(d_m)+std(d_m))
fm = d/(mean(d_m)-std(d_m))

scaled_bars(:,:,1) = bars*fm
scaled_bars(:,:,2) = bars*f
scaled_bars(:,:,3) = bars*fp

scaled_b_d = scaled_bars(2:2:6,:,:)-scaled_bars(1:2:5,:,:)
scales = sqrt(sum(scaled_b_d.*scaled_b_d,2))

scales = permute(scales,[1,3,2]) 
%%% this is now matrix, with the rows corresponding to the line number, and
%%% the columns are the +-SD with the mean in the middle. 



% filename = 'D:\Documents\Writing\Thesis\photogram\figures\fracture_mapping_methods_v1\model3d'
% print(fig1,filename,'-dpdf','-r0')
% savePDFfunction(fig1,'D:\Documents\Writing\Thesis\photogram\figures\fracture_mapping_methods_v1\model3d')
% save('D:\Field_data\2013\Summer\Images\JWC\GL1\Photogrammetry\July17\GL1PG1ST1\IMG_9030_analysis\scales_3d.mat','scales')
%% this was my attempt at writing a ply file
% M_out = [xyz_s, a1{4}, a1{5}, a1{6}, color];
% 
% fileID = fopen('D:\Code\photogrammetry\imageSequences\Glaciers\GL1\PG1\test1.nvm.cmvs\00\models\test1_scaled.ply','w')
% nbytes =fprintf(fileID,M_out)
% fclose(fileID)













































