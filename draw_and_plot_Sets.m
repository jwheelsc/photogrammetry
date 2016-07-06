%%% here are some commands that you can use to trace out joint sets in
%%% images in matlab, then if you want to plot the traces you can run this
%%% scripts


folder = 'D:\Field_data\2013\Summer\Images\JWC\GL1\Photogrammetry\July17\GL1PG1ST1\'

close all

f1 = figure('units','normalized','outerposition',[0 0 1 1])
imshow([folder 'IMG_9030.JPG'])
load([folder 'IMG_9030_analysis\sets.mat'])

for i = 1:length(s2)
    hold on
    p = s2{i};
    ph(i)=plot(p(:,1)',p(:,2)','y','linewidth',1);
%     if i == 131
%         ph(i)=plot(p(:,1)',p(:,2)','b','linewidth',2);
%     end
end

for i = 1:length(s1)
    hold on
    p = s1{i};
    ph(i)=plot(p(:,1)',p(:,2)','r','linewidth',1);
end

for i = 1:length(s3)
    hold on
    p = s3{i};
    ph(i)=plot(p(:,1)',p(:,2)','b','linewidth',1);
end

for i = 1:length(s4)
    hold on
    p = s4{i};
    ph(i)=plot(p(:,1)',p(:,2)','g','linewidth',1);
end


return

h = imfreehand
s2{end+1}=h.getPosition

save([folder 'IMG_9030_analysis\sets.mat'],'s2','-append')

%% to delete the last line and create a new one, run this section

h = imfreehand
% s1{131}=h.getPosition
s2{end}=h.getPosition

save([folder 'IMG_9030_analysis\sets.mat'],'s3','-append')

%% if you want to find a given line
pl = [2523,1935]

for i = 1:length(s1)
    p = s1{i};
    for j = 1:length(p)
        pr = p-pl;
        elx = find(abs(pr(:,1))<1);
        ely = find(abs(pr(:,2))<1);
        if isempty(elx) == 0 && isempty(ely) == 0
            ['this is the ' num2str(i) 'th line']
        end
    end
end




