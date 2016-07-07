%%% this function is called on from analyze_sets to densify the lines that
%%% were created using imfreehand

% function [output] = densify_lines(jset)

folder = 'D:\Field_data\2013\Summer\Images\JWC\GL1\Photogrammetry\July17\GL1PG1ST1\IMG_9030_analysis\'
load([folder 'sets.mat'])

for i = 2:length(s3)
    close all
    jset = s3{i};
    figure()
    plot(jset(:,1)',jset(:,2)','-o')
    xx = linspace(min(jset(:,1)),max(jset(:,1)),length(jset(:,1))*25);

    [jset] = findUnique(jset)
    [jset] = findUnique(jset)
    hold on
    plot(jset(:,1)',jset(:,2)','r-o')
    keyboard
    yy = pchip(jset(:,1)',jset(:,2)',xx);

    output = [xx',yy'];
    figure
    plot(xx,yy)
end


