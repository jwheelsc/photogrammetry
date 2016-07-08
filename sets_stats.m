clear all
close all

folder = 'D:\Field_data\2013\Summer\Images\JWC\GL1\Photogrammetry\July17\GL1PG1ST1\IMG_9030_analysis\'
load([folder 'sets.mat'])

% thetaA = [5:10:175];

setNum = 's1'
theta = '45'

load([folder 'sl_pts_' num2str(theta) '_' setNum '.mat'])

t_dist_bwp = []

for i = 1:length(set_int)
    
    jset = set_int{i};
    dif1 = jset(2:end,:)-jset(1:end-1,:);
    dist_bwp = sqrt(sum(dif1.*dif1,2));
    t_dist_bwp = [t_dist_bwp;dist_bwp];

end

hist(t_dist_bwp)