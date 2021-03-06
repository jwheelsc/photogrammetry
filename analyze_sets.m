clear all
close all

[folder, subFolder, imgNum, setIn] = whatFolder()
folderStr = [folder subFolder setIn]

load(folderStr)
setNum = 's1'
SN = s1
jsets = {}


%% densify the sets

for i = 1:length(SN)
    sz = size(SN{i})
    if sz(1)<2
        i
        keyboard
    end
    
    dense_jsets{i} = densify_lines(SN{i});
    
end

%% get length of line in pixels

d1 = getLineLength(SN)

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

%% create a scaline line, and find the intersections
yr = maxy-miny;

h = 250;
thetaA = [5:5:175];
% thetaA = 30

for t = 1:length(thetaA)

    theta = thetaA(t);
    m_sl = tan(theta*pi/180); %slope in radians
    B = abs(h/sin((90-theta)*pi/180)); %this is the offset in y for lines a distance of h apart
    if theta < 90
        bf = (m_sl*minx)/B %the scale factor for the first intercept that will keep the upper line in the box
        b_sl = maxy-(B*bf) %the first intercept
        max_l = floor((miny-(m_sl*maxx)-maxy)/-B)-ceil(bf) % the number of lines that will be in the box
    else 
        bf = (miny-(m_sl*minx))/B;
        b_sl = B*bf
        max_l = floor((maxy-(m_sl*maxx))/B)-ceil(bf)
    end

    count = 1;
    min_x_line = 0;

    set_int = {};
    line_length = [];

    if theta < 90
        for l = 1:max_l

            b_sl = b_sl-B;

            min_x_line = (miny-b_sl)/m_sl;
            
            pa = [(maxy-b_sl)/m_sl,maxy];
            pb = [maxx,m_sl*maxx+b_sl];
            pc = [minx, m_sl*minx+b_sl];
            pd = [(miny-b_sl)/m_sl,miny];
            pA = [pa;pb;pc;pd];
            [ps,pind] = sort(pA(:,1));
            p1 = pA(pind(2),:);
            p2 = pA(pind(3),:);
            
            line_length(l) = sqrt(sum((p2-p1).^2));

            hold on
            plot([p1(1) p2(1)],[p1(2) p2(2)],'m-')
            count_i = 1;
            int_point = [];

            for i = [1:length(dense_jsets)]

                frac = dense_jsets{i};

                x_sl = frac(:,1);
                y_sl = (m_sl*x_sl)+b_sl;

                dy = y_sl-frac(:,2);

                el = find(abs(dy)<5);
                if isempty(el)==0
                    hold on
                    el = el(end);
                    plot(frac(el,1),frac(el,2),'ko')
                    int_point(count_i,:) = [frac(el,1),frac(el,2)];
                    count_i = count_i+1;
                end

            end
            set_int{end+1}= int_point;

        end
    end

    min_y_line = 0;
    if theta > 90
        for l = 1:max_l

            b_sl = b_sl+B;

            min_y_line = m_sl*maxx+b_sl;
           
            pa = [(maxy-b_sl)/m_sl,maxy];
            pb = [maxx,m_sl*maxx+b_sl];
            pc = [minx, m_sl*minx+b_sl];
            pd = [(miny-b_sl)/m_sl,miny];
            pA = [pa;pb;pc;pd];
            [ps,pind] = sort(pA(:,1));
            p1 = pA(pind(2),:);
            p2 = pA(pind(3),:);
            
            line_length(l) = sqrt(sum((p2-p1).^2));

            hold on
            plot([p1(1) p2(1)],[p1(2) p2(2)],'m-')
            count_i = 1;
            int_point = [];
            for i = [1:length(dense_jsets)]

                frac = dense_jsets{i};

                x_sl = frac(:,1);
                y_sl = (m_sl*x_sl)+b_sl;

                dy = y_sl-frac(:,2);

                el = find(abs(dy)<5);
                if isempty(el)==0
                    hold on
                    el = el(end);
                    plot(frac(el,1),frac(el,2),'ko')
                    int_point(count_i,:) = [frac(el,1),frac(el,2)];
                    count_i = count_i+1;
                end

            end

            set_int{end+1}= int_point;

        end
    end

    axis equal
%     save([folder subFolder 'sl_pts_' num2str(theta) '_' setNum '_sets.mat'], 'set_int', 'line_length')

end































