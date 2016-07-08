clear all
close all

folder = 'D:\Field_data\2013\Summer\Images\JWC\GL1\Photogrammetry\July17\GL1PG1ST1\IMG_9030_analysis\'
load([folder 'sets.mat'])

% thetaA = [5:10:175];

setNum = 's1'
theta = '45'

load([folder 'sl_pts_' num2str(theta) '_' setNum '.mat'])


