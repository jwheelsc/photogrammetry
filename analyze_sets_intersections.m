clear all
close all

[folder, subFolder, imgNum, setIn] = whatFolder()
folderStr = [folder subFolder setIn]

load(folderStr)

%% find some bounding boxesthe bounding box of the entire set

for i = 1:length(s1)
    lin = s1{i};
    mnx(i) = min(lin(:,1));
    mny(i) = min(lin(:,2));
    mxx(i) = max(lin(:,1));
    mxy(i) = max(lin(:,2));
end 
miny1 = min(mny)
maxy1 = max(mxy)
minx1 = min(mnx)
maxx1 = max(mxx)

for i = 1:length(s2)
    lin = s2{i};
    mnx(i) = min(lin(:,1));
    mny(i) = min(lin(:,2));
    mxx(i) = max(lin(:,1));
    mxy(i) = max(lin(:,2));
end 
miny2 = min(mny)
maxy2 = max(mxy)
minx2 = min(mnx)
maxx2 = max(mxx)

for i = 1:length(s3)
    lin = s3{i};
    mnx(i) = min(lin(:,1));
    mny(i) = min(lin(:,2));
    mxx(i) = max(lin(:,1));
    mxy(i) = max(lin(:,2));
end 
miny3 = min(mny)
maxy3 = max(mxy)
minx3 = min(mnx)
maxx3 = max(mxx)

miny = min([miny1,miny2,miny3])
maxy = max([maxy1,maxy2,maxy3])
minx = min([minx1,minx2,minx3])
maxx = max([maxx1,maxx2,maxx3])

%% plot all the lines
close all
f1 = figure('units','normalized','outerposition',[0 0 1 1])

for i = 1:length(s2)
    hold on
    p = s2{i};
    ph(i)=plot(p(:,1)',p(:,2)','k','linewidth',1);
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

xlim([minx maxx])
ylim([miny maxy])

%% densify the sets
densifyLines = 1
if densifyLines == 1
    for j = 1:3

        if j == 1
            SN = s1
        elseif j == 2
            SN = s2
        elseif j == 3
            SN = s3
        end


        for i = 1:length(SN)
            sz = size(SN{i})
            if sz(1)<2
                i
                keyboard
            end

            dense_jsets{i} = densify_lines(SN{i});

            if j == 1
                s1{i} = dense_jsets{i};
            elseif j == 2
                s2{i} = dense_jsets{i};
           elseif j == 3
                s3{i} = dense_jsets{i};
            end
        
        end

    end
end


%% plot all the lines
f2 = figure('units','normalized','outerposition',[0 0 1 1])

for i = 1:length(s2)
    hold on
    p = s2{i};
    ph(i)=plot(p(:,1)',p(:,2)','k','linewidth',1);
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

xlim([minx maxx])
ylim([miny maxy])
% 
% return
%% intersections of sets s1 and s2


count = 1
for i = 1:length(s2)
    
    j1 = s2{i};
    for j = 1:length(s3)
    
        j2 = s3{j};
        
       jp1x = repmat(j1(:,1),[1,length(j2(:,1))])';
       jp2x = repmat(j2(:,1),[1,length(j1(:,1))]);  
       jp1y = repmat(j1(:,2),[1,length(j2(:,2))])';
       jp2y = repmat(j2(:,2),[1,length(j1(:,2))]);  

       dM = sqrt((jp2x-jp1x).^2+(jp2y-jp1y).^2);
       
       mdM = min(min(dM));
       [row,col] = find(abs(dM-mdM)<1e-3);
       row = row(end);
       col = col(end);
       if mdM < 5
           intPts(count,:) = j1(col,:);
           count = count+1;
       end
       
    end
    
end

hold on 
plot(intPts(:,1),intPts(:,2),'o')
s2s3 = intPts;
save([folder subFolder 'setInt.mat'],'s1s3','-append')


























