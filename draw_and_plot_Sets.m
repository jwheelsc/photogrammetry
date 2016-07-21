%%% here are some commands that you can use to trace out joint sets in
%%% images in matlab, then if you want to plot the traces you can run this
%%% scripts


[folder, subFolder, imgNum, setIn] = whatFolder()
folderStr = [folder subFolder setIn]

close all

f1 = figure('units','normalized','outerposition',[0 0 1 1])
imshow([folder imgNum])
xlim([1800 4650])
ylim([760 3000 ])
hold on
plot([1800 1800],[760 3000],'r-')
hold on
plot([4650 4650],[760 3000],'r-')
hold on
plot([1800 4650],[760 760],'r-')
hold on
plot([1800 4650],[3000 3000],'r-')
load(folderStr)

%% if you want to inititate a set, then do the following...BUT BE CAREFUL NOT TO DELETE
%%% these sets should be saved in source control
RUNTHIS = 'NO'

if strcmp(RUNTHIS,'YES')
    s3 = []
save(folderStr,'s3','-append')
end

%%

for i = 1:length(s1)
    hold on
    p = s1{i};
    ph(i)=plot(p(:,1)',p(:,2)','k','linewidth',1);
end

for i = 1:length(s2)
    hold on
    p = s2{i};
    ph(i)=plot(p(:,1)',p(:,2)','b','linewidth',1);
%     if i == 131
%         ph(i)=plot(p(:,1)',p(:,2)','b','linewidth',2);
%     end
end

for i = 1:length(s3)
    hold on
    p = s3{i};
    ph(i)=plot(p(:,1)',p(:,2)','r','linewidth',1);
end

popup = uicontrol('Style', 'popup',...
       'String', {'---set 1---','create line','append line, sort x','append line, sort y','redo line','draw set'},...
       'Position', [88 300 100 50],...
       'Callback', @draw_line_function_set1); 
   
popup = uicontrol('Style', 'popup',...
   'String', {'---set 2---','create line','append line, sort x','append line, sort y','redo line','draw set'},...
   'Position', [88 200 100 50],...
   'Callback', @draw_line_function_set2); 

popup = uicontrol('Style', 'popup',...
   'String', {'---set 3---','create line','append line, sort x','append line, sort y','redo line','draw set'},...
   'Position', [88 100 100 50],...
   'Callback', @draw_line_function_set3); 
   
return

%% to delete the last line and create a new one, run this section

h = imfreehand
% s1{131}=h.getPosition
s2{end}=h.getPosition

save(folderStr,'s2','-append')

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

%% if you need to get rid of a point, try this
[folder, subFolder, imgNum, setIn] = whatFolder()
folderStr = [folder subFolder setIn]
load(folderStr)
close all

pt = 166

SN = s1
% for i = 130:length(SN)
%     hold on
%     plot(SN{i}(:,1),SN{i}(:,2))
%     pause
% end
% 
% return

for i = 1:pt-1
    newSet{i} = SN{i}
end
for i = pt:length(SN)-1
    newSet{i} = SN{i+1}
end

figure
for i = 1:length(newSet)
    hold on
    p = newSet{i};
    ph(i)=plot(p(:,1)',p(:,2)','b','linewidth',1);

end

RESAVE = 1
if RESAVE == 1
    s1 = newSet
    save(folderStr,'s1','-append')
end

%% delete points outside the bounding box
clear all
xlim=[1800 4650]
ylim=[760 3000 ]
[folder, subFolder, imgNum, setIn] = whatFolder()
folderStr = [folder subFolder setIn]
load(folderStr)
close all

SN = s3

figure
for i = 1:length(SN)
    hold on
    plot(SN{i}(:,1),SN{i}(:,2))
end

for i = 1:length(SN)
    jnt = SN{i};
    jnt = jnt(jnt(:,1)>xlim(1),:);
    SN{i} = jnt;
end

for i = 1:length(SN)
    jnt = SN{i};
    jnt = jnt(jnt(:,1)<xlim(2),:);
    SN{i} = jnt;
end

for i = 1:length(SN)
    jnt = SN{i};
    jnt = jnt(jnt(:,2)>ylim(1),:);
    SN{i} = jnt;
end

for i = 1:length(SN)
    jnt = SN{i};
    jnt = jnt(jnt(:,2)<ylim(2),:);
    SN{i} = jnt;
end


figure
for i = 1:length(SN)
    hold on
    plot(SN{i}(:,1),SN{i}(:,2))
end
    
RESAVE = 0
if RESAVE == 1
    s3 = SN
    save(folderStr,'s3','-append')
end  
    
    
    







