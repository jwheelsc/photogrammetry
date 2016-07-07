%%% this function is called on from analyze_sets to densify the lines that
%%% were created using imfreehand

function [output] = densify_lines(jset)
% clear all 
% close all
% folder = 'D:\Field_data\2013\Summer\Images\JWC\GL1\Photogrammetry\July17\GL1PG1ST1\IMG_9030_analysis\'
% load([folder 'sets.mat'])

% for kk = 1:length(s2)
% jset = s2{250};

[jset] = findUnique(jset);
if length(jset(:,1))<2
    output = jset;
    return
end
[isu_x] = unique(jset(:,1)) ;

if isempty(isu_x) == 0

    xx = linspace(min(jset(:,2)),max(jset(:,2)),length(jset(:,2))*25);
   
    for i = 1:length(jset(:,1))
        njset = jset(i,:)+(0.1*rand-(0.1/2));
        jset(i,:) = njset;
    end

    yy = pchip(jset(:,2),jset(:,1),xx);

    output = [yy',xx'];
    
else
    
    xx = linspace(min(jset(:,1)),max(jset(:,1)),length(jset(:,1))*25);

    for i = 1:length(jset(:,1))
        njset = jset(i,:)+(0.25*rand-0.125);
        jset(i,:) = njset;
    end
    yy = pchip(jset(:,1),jset(:,2),xx);

    output = [xx',yy'];

end


