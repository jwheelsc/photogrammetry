clear all
close all

folder = 'D:\Field_data\2013\Summer\Images\JWC\GL1\Photogrammetry\July17\GL1PG1ST1\IMG_9030_analysis\'
load([folder 'sets.mat'])

setNum = 's3'
SN = s3
jsets = {}
%% densify the sets

for i = 1:length(SN)

    dense_jsets{i} = densify_lines(SN{i});
    
end

%% get length of line in pixels

d1 = getLineLength(SN)

%% find some bounding boxesthe bounding box of the entire set
for i = 1:length(SN)
    lin = SN{i};
    mnx(i) = min(lin(:,1));
    mny(i) = min(lin(:,2));
    mxx(i) = max(lin(:,1));
    mxy(i) = max(lin(:,2));
end 
miny = min(mny)
maxy = max(mxy)
minx = min(mnx)
maxx = max(mxx)

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
thetaA = [5:10:175];
% thetaA = [75]

for t = 1:length(thetaA)

    theta = thetaA(t);
    m_sl = tan(theta*pi/180);
    B = h/sin((90-theta)*pi/180);
    if theta < 90
        b_sl = maxy-B;
    else 
        b_sl = B;
    end

    count = 1;
    min_x_line = 0;

    set_int = {};
    line_length = [];

    if theta < 90
        while min_x_line < maxx

            b_sl = maxy-(B*count);

            min_x_line = (miny-b_sl)/m_sl;
            
            pa = [(maxy-b_sl)/m_sl,maxy];
            pb = [maxx,m_sl*maxx+b_sl];
            pc = [minx, m_sl*minx+b_sl];
            pd = [(miny-b_sl)/m_sl,miny];
            pA = [pa;pb;pc;pd];
            [ps,pind] = sort(pA(:,1));
            p1 = pA(pind(2),:);
            p2 = pA(pind(3),:);
            
            line_length(count) = sqrt(sum((p2-p1).^2));

            hold on
            plot([p1(1) p2(1)],[p1(2) p2(2)],'m-')
            count_i = 1;
            int_point = [];
            for i = [1:length(dense_jsets)]

                frac = dense_jsets{i};

                x_sl = frac(:,1);
                y_sl = (m_sl*x_sl)+b_sl;

                dy = y_sl-frac(:,2);

                el = find(abs(dy)<10);
                if isempty(el)==0
                    hold on
                    el = el(end);
                    plot(frac(el,1),frac(el,2),'ko')
                    int_point(count_i,:) = [frac(el,1),frac(el,2)];
                    count_i = count_i+1;
                end

            end

            count = count + 1;
            set_int{end+1}= int_point;

        end
    end

    min_y_line = 0;
    if theta > 90
        while min_y_line < maxy

            b_sl = abs(B*count);

            min_y_line = m_sl*maxx+b_sl;
           
            pa = [(maxy-b_sl)/m_sl,maxy];
            pb = [maxx,m_sl*maxx+b_sl];
            pc = [minx, m_sl*minx+b_sl];
            pd = [(miny-b_sl)/m_sl,miny];
            pA = [pa;pb;pc;pd];
            [ps,pind] = sort(pA(:,1));
            p1 = pA(pind(2),:);
            p2 = pA(pind(3),:);
            
            line_length(count) = sqrt(sum((p2-p1).^2));

            hold on
            plot([p1(1) p2(1)],[p1(2) p2(2)],'m-')
            count_i = 1;
            int_point = [];
            for i = [1:length(dense_jsets)]

                frac = dense_jsets{i};

                x_sl = frac(:,1);
                y_sl = (m_sl*x_sl)+b_sl;

                dy = y_sl-frac(:,2);

                el = find(abs(dy)<10);
                if isempty(el)==0
                    hold on
                    el = el(end);
                    plot(frac(el,1),frac(el,2),'ko')
                    int_point(count_i,:) = [frac(el,1),frac(el,2)];
                    count_i = count_i+1;
                end

            end

            count = count + 1;
            set_int{end+1}= int_point;

        end
    end

    axis equal
%     save([folder 'sl_pts_' num2str(theta) '_' setNum '.mat'], 'set_int', 'line_length')

end































