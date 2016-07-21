clear all
close all

% here you can get the point cloud from ptCloud, but for some reason,
% ptCloud won't read in the colors from the .ply file, so you actually have
% to read in the .ply file from textscan and convert the colors to uint8,
% then plot it. 

% load the pointcloud cloud from the vSFM model
ptCloud = pcread('D:\Code\photogrammetry\imageSequences\Glaciers\GL1\PG3\model3.nvm.cmvs\00\models\option-0000.ply');
% read in just the xyz coordinates and color from the same point clod
f1 = fopen('D:\Code\photogrammetry\imageSequences\Glaciers\GL1\PG3\model3.nvm.cmvs\00\models\option-0000_4ml.ply');
a1 = textscan(f1,'%f %f %f %f %f %f %d %d %d');
xyz = [a1{1} a1{2} a1{3}];
color = [a1{7} a1{8} a1{9}];
close all
% convert the color format and append it to ptCloud
fig1 = figure
ptCloud.Color = uint8(color);
pcshow(ptCloud)

%% make some bars here to compute a scale factor

% figure 
% imshow('D:\Code\photogrammetry\imageSequences\Glaciers\GL1\PG3\IMG_9233.JPG')

%%% get the length length of 3 lines on 2D image
% xl = ginput(2)
% dif=xl(2,:)-xl(1,:)
% lx = sqrt(sum(dif.*dif,2))

line1 = 509.1
line2 = 197.5292
line3 = 595.887
line4 = 494.8535
line5 = 381.8481
line6 = 393.9746
line7 = 828.3091
line8 = 65.3952
%%% get the scales from the left and right balls
% xlim([736,777])
% ylim([1876,1901])
% xl = ginput(2)
% dif=xl(2,:)-xl(1,:)
% lxl = sqrt(sum(dif.*dif,2))
ball = 0.25
% 
% xlim([3171,3210])
% ylim([2131,2160])
% xr = ginput(2)
% dif=xr(2,:)-xr(1,:)
% lxr = sqrt(sum(dif.*dif,2))
% ball = 0.25

px = 28
sc_ball = ball/px

lines_2d = [line1;line2;line3;line4;line5;line6;...
    line7;line8]*sc_ball


% s3 scale bars

l1p1 = [0.02704,0.02206,1.116]
l1p2 = [-0.00212,0.1312,1.064]
l2p1 = [0.3108,0.05256,1.099]
l2p2 = [0.323,0.01597,1.124]
l3p1 = [0.5745,0.03147,1.175]
l3p2 = [0.4964,-0.0939,1.232]

bars = [l1p1;l1p2;l2p1;l2p2;l3p1;l3p2;0.3118,0.05399,1.1;0.3488,-0.05447,1.195;...
    0.9603,-0.1808,1.263;1.044,-0.1388,1.243;0.002871,-0.02619,1.139;0.05889,0.06992,1.092;...
    0.5755,0.02838,1.176;0.6784,-0.1899,1.297;0.02735,0.02049,1.116;0.003041,0.00559,1.121]

barL3d = bars(2:2:length(bars(:,1)),:)-bars(1:2:length(bars(:,1))-1,:)
lin3d = sqrt(sum(barL3d .*barL3d ,2))


%% here we are doing short range, and we know the absolute distance between
%%% camera stations to be X meters, and there is 1 camera per station. We
%%% don't care about orienting the model at this point, and we know the
%%% scale on the wall.

% read in the camera coordinates from the vSFM model
f2 = fopen('D:\Code\photogrammetry\imageSequences\Glaciers\GL1\PG3\model3.nvm.cmvs\00\centers-0000_4ml.ply');
a = textscan(f2,'%f %f %f');
p = [a{1} a{2} a{3}];

[ps,pi] = sort(p(:,1))
ps = p(pi,:)

hold on
plot3(ps(:,1),ps(:,2),ps(:,3),'ro','markerfacecolor','r')
hold on
% txt = [1:5]
% for i = 1:5
%     text(ps(i,1),ps(i,2),ps(i,3),num2str(txt(i))) 
% end
for i = 1:(length(bars(:,1)))/2
    plot3(bars((2*i)-1:2*i,1),bars((2*i)-1:2*i,2),bars((2*i)-1:2*i,3),'y-','linewidth',10)
end
view([0 280])
% savePDFfunction(fig1,'D:\Documents\Writing\Thesis\photogram\figures\fracture_mapping_methods_v1\scales3d')


len_m = ps(2:end,:)-ps(1:end-1,:)
d_m = sqrt(sum(len_m.*len_m,2))

d = 6

sf = d/mean(d_m)
sfp = d/(mean(d_m)+std(d_m))
sfm = d/(mean(d_m)-std(d_m))

lines_3d = lin3d*sf
return
fs = figure
h = plot(lines_2d,lines_3d,'o')
h.MarkerFaceColor = h.Color
xlim([0 10])
ylim([0 10])
refline(1,0)
grid on

xlabel('Trace length in 2D (from scale ball)','fontsize',16)
ylabel('Trace length in 3D (from camera spacing)','fontsize',16)
set(gca,'fontsize',16)
savePDFfunction(fs,'D:\Documents\Writing\Thesis\photogram\figures\fracture_mapping_methods_v1\scales2Dvs3D')
% 

































