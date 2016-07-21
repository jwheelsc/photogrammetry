function draw_line_function_set2(source, callbackdata)
%DRAW_LINE_FUNCTION Summary of this function goes here
%   Detailed explanation goes here

[folder, subFolder, imgNum, setIn] = whatFolder()
folderStr = [folder subFolder setIn]
load(folderStr)

val = source.Value
source.String(val)
if strcmp(source.String(val),'create line')
    h = imfreehand
    s2{end+1}= h.getPosition
    save(folderStr,'s2','-append')
end   

if strcmp(source.String(val),'append line, sort x')
    h = imfreehand
    h0 = s2{end}
    hArr = [h0;h.getPosition]
    [dv,ia] = sort(hArr(:,1))
    s2{end} = hArr(ia,:)
    save(folderStr,'s2','-append')
end

if strcmp(source.String(val),'append line, sort y')
    h = imfreehand
    h0 = s2{end}
    hArr = [h0;h.getPosition]
    [dv,ia] = sort(hArr(:,2))
    s2{end} = hArr(ia,:)
    save(folderStr,'s2','-append')
end

if strcmp(source.String(val),'redo line')
    h = imfreehand
    s2{end}= h.getPosition
    save(folderStr,'s2','-append')
end 

if strcmp(source.String(val),'draw set')
    run D:\Code\photogrammetry\draw_and_plot_Sets.m
end

end

