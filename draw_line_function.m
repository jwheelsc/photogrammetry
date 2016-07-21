function draw_line_function(source, callbackdata)
%DRAW_LINE_FUNCTION Summary of this function goes here
%   Detailed explanation goes here

folder = 'D:\Field_data\2013\Summer\Images\JWC\GL1\Photogrammetry\July17\GL1PG1ST1\'
load([folder 'IMG_9030_analysis\sets_2.mat'])

val = source.Value
source.String(val)
if strcmp(source.String(val),'create line')
    h = imfreehand
    s1{end+1}= h.getPosition
    save([folder 'IMG_9030_analysis\sets_2.mat'],'s1','-append')
end   

if strcmp(source.String(val),'append line, sort x')
    h = imfreehand
    h0 = s1{end}
    hArr = [h0;h.getPosition]
    [dv,ia] = sort(hArr(:,1))
    s1{end} = hArr(ia,:)
    save([folder 'IMG_9030_analysis\sets_2.mat'],'s1','-append')
end

if strcmp(source.String(val),'append line, sort y')
    h = imfreehand
    h0 = s1{end}
    hArr = [h0;h.getPosition]
    [dv,ia] = sort(hArr(:,2))
    s1{end} = hArr(ia,:)
    save([folder 'IMG_9030_analysis\sets_2.mat'],'s1','-append')
end

if strcmp(source.String(val),'redo line')
    h = imfreehand
    s1{end}= h.getPosition
    save([folder 'IMG_9030_analysis\sets_2.mat'],'s1','-append')
end 

if strcmp(source.String(val),'draw set')
    run D:\Code\photogrammetry\draw_and_plot_Sets.m
end

end

