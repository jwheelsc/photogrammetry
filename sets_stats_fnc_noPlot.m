clear all
close all

folder = 'D:\Field_data\2013\Summer\Images\JWC\GL1\Photogrammetry\July17\GL1PG1ST1\IMG_9030_analysis\'
load([folder 'sets.mat'])

%% scale
load D:\Field_data\2013\Summer\Images\JWC\GL1\Photogrammetry\July17\GL1PG1ST1\IMG_9030_analysis\scales_3d.mat
%%% these scales lengths were generated from plot_ptCloud, and notes are
%%% therin

for i = 1:length(s4)
    sb = s4{i} %%% here s4 are the scales drawn on the 2d image
    l_sb(i) = sqrt(sum((sb(2,:)-sb(1,:)).^2,2))
end

scale_factor = scales(:,2)./l_sb'  %% scales are the line length on the 3d images
msf = mean(scale_factor)

%%
thetaA = [5:10:175];
setNumStr = {'s1','s2','s3'};   %% these are the joint sets that were created from analyze_sets.m

for ang = 1:length(thetaA)

    theta = num2str(thetaA(ang))

    for j = 1:3

        setNum = setNumStr{j};
        %%% this is a .mat file with a variable called set_int (joint set
        %%% intersection), which is a call array, and a variable containing line_length
        %%%. There is a cell for each
        %%% scanline, and within that cell contains the coordinates of where
        %%% the scanline of a given angle (theta) intersects a joint set (j)
        load([folder 'sl_pts_' num2str(theta) '_' setNum '.mat'])  ;
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

    s1 = load([folder 'sl_pts_' num2str(theta) '_' setNumStr{1} '.mat']);  
    s2 = load([folder 'sl_pts_' num2str(theta) '_' setNumStr{2} '.mat']); 
    s3 = load([folder 'sl_pts_' num2str(theta) '_' setNumStr{3} '.mat']);

    t_dist_bwp = [];
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
    np_t = sum(np,2);
    m_fq(ang,4) = mean(np_t./(line_length*msf)');


end

