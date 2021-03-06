clear all
close all

[folder, subFolder, imgNum, setIn] = whatFolder()
folderStr = [folder subFolder setIn]

load(folderStr)

%% scale
findSF = 0
if findSF == 1
    load D:\Field_data\2013\Summer\Images\JWC\GL1\Photogrammetry\July17\GL1PG1ST1\IMG_9030_analysis\scales_3d.mat
    %%% these scales lengths were generated from plot_ptCloud, and notes are
    %%% therin

    for i = 1:length(s4)
        sb = s4{i} %%% here s4 are the scales drawn on the 2d image
        l_sb(i) = sqrt(sum((sb(2,:)-sb(1,:)).^2,2))
    end

    scale_factor = scales(:,2)./l_sb'  %% scales are the line length on the 3d images
    msf = mean(scale_factor)
end
msf = 1/108
%%
% thetaA = [5:5:175];
thetaA = [5:10:175];
setNumStr = {'s1','s2','s3'};   %% these are the joint sets that were created from analyze_sets.m

jset = []

for ang = 1:length(thetaA)

    theta = num2str(thetaA(ang))

    for j = 1:3
    
        np = []
        setNum = setNumStr{j};
        %%% this is a .mat file with a variable called set_int (joint set
        %%% intersection), which is a call array, and a variable containing line_length
        %%%. There is a cell for each
        %%% scanline, and within that cell contains the coordinates of where
        %%% the scanline of a given angle (theta) intersects a joint set (j)
        load([folder subFolder 'sl_pts_' num2str(theta) '_' setNum '_sets.mat'])  ;
        t_dist_bwp = [];
        for i = 1:length(set_int)

            %%% in this section, i reorder the points to compute the spacing
            %%% between consecutive points
            if isempty(set_int{i})==0
                scat_jset = set_int{i};
                [dv,ia] = sort(scat_jset(:,1));
                jset = scat_jset(ia,:);
            end
            %%% then compute the distance between points
            dif1 = jset(2:end,:)-jset(1:end-1,:);
            dist_bwp = sqrt(sum(dif1.*dif1,2));
            %%% i create a massive cell where the distance between points is
            %%% appended onto the next scanline
            t_dist_bwp = [t_dist_bwp;dist_bwp];
            %%% here are the number of points for th egiven scanline
            np(i,j) = length(set_int{i});

        end

        % and here I have to scale it
        t_dist_bwp1{j} = t_dist_bwp*msf;
        %%% compute a few stats
        spc_mean(j) = mean(t_dist_bwp1{j});
        spc_std(j) = std(t_dist_bwp1{j});
        %%% here im saying that the frequncy is the inverse of the mean
        %%% spacing
        fq(ang,j) = 1/spc_mean(j);
        %%% alternatively, we can compute a frequency based on the mean of the
        %%% number of points for a given line length (scaled)
        m_fq(ang,j) = mean(np(:,j)./(line_length*msf)');

      
    end


    %% ok, this might get a little more complex, but I want to put the points 
    %%% from all sets on a given scanline

    s1 = load([folder subFolder 'sl_pts_' num2str(theta) '_' setNumStr{1} '_sets.mat']);  
    s2 = load([folder subFolder 'sl_pts_' num2str(theta) '_' setNumStr{2} '_sets.mat']); 
    s3 = load([folder subFolder 'sl_pts_' num2str(theta) '_' setNumStr{3} '_sets.mat']);

    t_dist_bwp = [];
    np_t1 = [];
    for i = 1:length(s1.set_int)
        all_pts = [s1.set_int{i};s2.set_int{i};s3.set_int{i}];
        if isempty(all_pts)==0
            [dv,ia] = sort(all_pts(:,1));
            jset = all_pts(ia,:)  ;    
        end
        %%% then compute the distance between points
        dif1 = jset(2:end,:)-jset(1:end-1,:);
        dist_bwp = sqrt(sum(dif1.*dif1,2));
        %%% i create a massive cell where the distance between points is
        %%% appended onto the next scanline
        t_dist_bwp = [t_dist_bwp;dist_bwp];
        %%% here are the number of points for th egiven scanline
        np_t1(i) = length(s1.set_int{i})+length(s2.set_int{i})+length(s3.set_int{i});

    end

    t_dist_bwp1{4} = t_dist_bwp*msf;
    spc_mean(4) = mean(t_dist_bwp1{4});
    spc_std(4) = std(t_dist_bwp1{4});
    
    fq(ang,4) = 1/spc_mean(4);
%     np_t = sum(np,2);
    m_fq(ang,4) = mean(np_t1'./(s1.line_length*msf)');


end
fs2 = 12
f1 = figure(1)
    js = 1
    h1 = plot(thetaA,m_fq(:,js),'r-o')
%         my = max(m_fq(:,js))
%         el = find(m_fq(:,js)==my)
%         mx = thetaA(el)
%         text(mx,my,num2str(my),'fontsize',fs2)
    hold on
    h1a = plot(thetaA,fq(:,js),'r--o')
        my = max(fq(:,js))
        el = find(fq(:,js)==my)
        mx = thetaA(el)
        text(mx,my,num2str(my),'fontsize',fs2)
    
    js = 2
    h2 = plot(thetaA,m_fq(:,js),'k-o')
%         my = max(m_fq(:,js))
%         el = find(m_fq(:,js)==my)
%         mx = thetaA(el)
%         text(mx,my,num2str(my),'fontsize',fs2)
    hold on
    h2a = plot(thetaA,fq(:,js),'k--o')
        my = max(fq(:,js))
        el = find(fq(:,js)==my)
        mx = thetaA(el)
        text(mx,my,num2str(my),'fontsize',fs2)

    js = 3
    h3 = plot(thetaA,m_fq(:,js),'b-o')
%         my = max(m_fq(:,js))
%         el = find(m_fq(:,js)==my)
%         mx = thetaA(el)
%         text(mx,my,num2str(my),'fontsize',fs2)
    hold on
    h3a = plot(thetaA,fq(:,js),'b--o')
        my = max(fq(:,js))
        el = find(fq(:,js)==my)
        mx = thetaA(el)
        text(mx,my,num2str(my),'fontsize',fs2)

    js = 4
    h4 = plot(thetaA,m_fq(:,js),'-o', 'color', [0 0.6 0])
%         my = max(m_fq(:,js))
%         el = find(m_fq(:,js)==my)
%         mx = thetaA(el)
%         text(mx,my,num2str(my),'fontsize',fs2)
    hold on
    h34 = plot(thetaA,fq(:,js),'--o', 'color', [0 0.6 0])
        my = max(fq(:,js))
        el = find(fq(:,js)==my)
        mx = thetaA(el)
        text(mx,my,num2str(my),'fontsize',fs2)
        my = min(fq(:,js))
        el = find(fq(:,js)==my)
        mx = thetaA(el)
        text(mx,my,num2str(my),'fontsize',fs2)


    ylabel('Joint frequency (\lambda)')
    xlabel('Scanline angle (\theta)')
    set(gca,'fontsize',16)
    grid on
    legend([h1 h1a h2 h3 h4], {'set 1 (mean spacing)^{-1}','set 1 (total points per line)','set 2','set 3','all sets'},...
        'location','northwest','fontsize',12)
    
%     savePDFfunction(f1,[folder 'figuresfrequency_angle'])
    
