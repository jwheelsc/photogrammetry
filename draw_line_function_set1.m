function draw_line_function_set1(source, callbackdata)
%DRAW_LINE_FUNCTION Summary of this function goes here
%   Detailed explanation goes here

[folder, subFolder, imgNum, setIn] = whatFolder()
folderStr = [folder subFolder setIn]
load(folderStr)

val = source.Value
source.String(val)
if strcmp(source.String(val),'create line')
    h = imfreehand
    lin = h.getPosition
    s1{end+1}= lin(1:end-5,:)
    save(folderStr,'s1','-append')
end   

if strcmp(source.String(val),'append line, sort x')
    h = imfreehand
    h0 = s1{end}
    lin = h.getPosition
    hArr = [h0;lin(1:end-5,:)]
    [dv,ia] = sort(hArr(:,1))
    s1{end} = hArr(ia,:)
    save(folderStr,'s1','-append')
end

if strcmp(source.String(val),'append line, sort y')
    h = imfreehand
    h0 = s1{end}
    lin = h.getPosition
    hArr = [h0;lin(1:end-5,:)]
    [dv,ia] = sort(hArr(:,2))
    s1{end} = hArr(ia,:)
    save(folderStr,'s1','-append')
end

if strcmp(source.String(val),'redo line')
    h = imfreehand
    lin = h.getPosition
    s1{end+1}= lin(1:end-5,:)
    save(folderStr,'s1','-append')
end 

if strcmp(source.String(val),'draw set')
    run D:\Code\photogrammetry\draw_and_plot_Sets.m
end

end

