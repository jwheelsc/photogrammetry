%%% here are some commands that you can use to trace out joint sets in
%%% images in matlab, then if you want to plot the traces you can run this
%%% scripts


[folder, subFolder, imgNum, set] = whatFolder()
folderStr = [folder subFolder set]

close all

f1 = figure('units','normalized','outerposition',[0 0 1 1])
ih = imshow([folder imgNum])
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
    ph(i)=plot(p(:,1)',p(:,2)','r','linewidth',1);
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
    ph(i)=plot(p(:,1)',p(:,2)','y','linewidth',1);
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
[folder, subFolder, imgNum, set] = whatFolder()
folderStr = [folder subFolder set]
load(folderStr)
close all
figure

pt = 51

SN = s1
for i = 1:length(SN)
    hold on
    plot(SN{i}(:,1),SN{i}(:,2))
    pause
    SNnew{i} = SN{i}(1:end-5,:)
end
figure
for i = 1:length(SN)
    hold on
    plot(SNnew{i}(:,1),SNnew{i}(:,2))
    pause
end

return

for i = 1:pt-1
    newSet{i} = SN{i}
end
for i = pt:length(SN)-1
    newSet{i} = SN{i+1}
end

figure
for i = 1:length(SN)
    hold on
    p = SN{i};
    ph(i)=plot(p(:,1)',p(:,2)','b','linewidth',1);

end

RESAVE = 1
if RESAVE == 1
    s2 = newSet
    save(folderStr,'s4','-append')
end









