function draw_line_function_set3(source, callbackdata)
%DRAW_LINE_FUNCTION Summary of this function goes here
%   Detailed explanation goes here

[folder, subFolder, imgNum, set] = whatFolder()
folderStr = [folder subFolder set]
load(folderStr)

val = source.Value
source.String(val)
if strcmp(source.String(val),'create line')
    h = imfreehand
    s3{end+1}= h.getPosition
    save(folderStr,'s3','-append')
end   

if strcmp(source.String(val),'append line, sort x')
    h = imfreehand
    h0 = s3{end}
    hArr = [h0;h.getPosition]
    [dv,ia] = sort(hArr(:,1))
    s3{end} = hArr(ia,:)
    save(folderStr,'s3','-append')
end

if strcmp(source.String(val),'append line, sort y')
    h = imfreehand
    h0 = s3{end}
    hArr = [h0;h.getPosition]
    [dv,ia] = sort(hArr(:,2))
    s3{end} = hArr(ia,:)
    save(folderStr,'s3','-append')
end

if strcmp(source.String(val),'redo line')
    h = imfreehand
    s3{end}= h.getPosition
    save(folderStr,'s1','-append')
end 

if strcmp(source.String(val),'draw set')
    run D:\Code\photogrammetry\draw_and_plot_Sets.m
end

end

