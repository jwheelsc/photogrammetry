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

f1 = figure(1)
f2 = figure(2)

% thetaA = [5:10:175];

close all
theta = '45'

setNumStr = {'s1','s2','s3'}   %% these are the joint sets that were created from analyze_sets.m

for j = 1:3
    
    setNum = setNumStr{j}
    %%% this is a .mat file with a variable called set_int (joint set
    %%% intersection), which is a call array, and a variable containing line_length
    %%%. There is a cell for each
    %%% scanline, and within that cell contains the coordinates of where
    %%% the scanline of a given angle (theta) intersects a joint set (j)
    load([folder 'sl_pts_' num2str(theta) '_' setNum '.mat'])  
    t_dist_bwp = []
    for i = 1:length(set_int)
        
        %%% in this section, i reorder the points to compute the spacing
        %%% between consecutive points
        if isempty(set_int{i})==0
            scat_jset = set_int{i};
            [dv,ia] = sort(scat_jset(:,1))
            jset = scat_jset(ia,:)
        end
        %%% then compute the distance between points
        dif1 = jset(2:end,:)-jset(1:end-1,:);
        dist_bwp = sqrt(sum(dif1.*dif1,2));
        %%% i create a massive cell where the distance between points is
        %%% appended onto the next scanline
        t_dist_bwp = [t_dist_bwp;dist_bwp];
        %%% here are the number of points for th egiven scanline
        np(i,j) = length(set_int{i})

    end
    
    % and here I have to scale it
    t_dist_bwp1{j} = t_dist_bwp*msf
    %%% compute a few stats
    spc_mean(j) = mean(t_dist_bwp1{j})
    spc_std(j) = std(t_dist_bwp1{j})
    %%% here im saying that the frequncy is the inverse of the mean
    %%% spacing
    fq = 1/spc_mean(j)
    %%% alternatively, we can compute a frequency based on the mean of the
    %%% number of points for a given line length (scaled)
    m_fq(j) = mean(np(:,j)./(line_length*msf)')
    
    figure(1)
        subplot(2,2,j)
        histogram(t_dist_bwp1{j},'normalization','probability')
%         hh = histogram(t_dist_bwp1{j})
%         bar(hh.Values/sum(np(:,j)))
        ylabel(['set ' num2str(j) ' probability'])
        xlabel('spacing between joints (m)')
        grid on        
        xlm = get(gca,'xlim')
        xx = linspace(xlm(1),xlm(2),20)
        yy = fq*exp(-fq*xx)
        hold on
        plot(xx,yy,'r')
        text(0.6, 0.8, ['\lambda = ' num2str(fq)],'units', 'normalized','color','r')
        ylim([0 0.5])
        hold on 
        plot([spc_mean(j) spc_mean(j)], get(gca,'ylim'),'r')
        
        yy2 = m_fq(j)*exp(-m_fq(j)*xx)
        hold on
        cm = [0.4 0 0.4]
        plot(xx,yy2,'color',cm)
        text(0.6, 0.7, ['\lambda = ' num2str(m_fq(j))],'units', 'normalized','color',cm)
        ylim([0 0.5])
        hold on 
        plot([1/m_fq(j) 1/m_fq(j)], get(gca,'ylim'),'color', cm)
        
    figure(2)
        subplot(2,2,j)
        plot(line_length*msf,np(:,j)./(line_length*msf)','-o')
        hold on
        plot(get(gca,'xlim'),[m_fq(j) m_fq(j)],'r')
        grid on
        text(0.7, 0.9, num2str(m_fq(j)),'units', 'normalized')
        
    
end


%% ok, this might get a little more complex, but I want to put the points 
%%% from all sets on a given scanline
    
s1 = load([folder 'sl_pts_' num2str(theta) '_' setNumStr{1} '.mat'])  
s2 = load([folder 'sl_pts_' num2str(theta) '_' setNumStr{2} '.mat']) 
s3 = load([folder 'sl_pts_' num2str(theta) '_' setNumStr{3} '.mat'])

t_dist_bwp = []
for i = 1:length(s1.set_int)
    all_pts = [s1.set_int{i};s2.set_int{i};s3.set_int{i}]
    if isempty(all_pts)==0
        [dv,ia] = sort(all_pts(:,1))
        jset = all_pts(ia,:)      
    end
    %%% then compute the distance between points
    dif1 = jset(2:end,:)-jset(1:end-1,:)
    dist_bwp = sqrt(sum(dif1.*dif1,2))
    %%% i create a massive cell where the distance between points is
    %%% appended onto the next scanline
    t_dist_bwp = [t_dist_bwp;dist_bwp]
    %%% here are the number of points for th egiven scanline
    np_t1(i) = length(s1.set_int{i})+length(s2.set_int{i})+length(s3.set_int{i})

end

t_dist_bwp1{4} = t_dist_bwp*msf
spc_mean(4) = mean(t_dist_bwp1{4})
spc_std(4) = std(t_dist_bwp1{4})
%%% here im saying that the frequncy is the inverse of the mean
%%% spacing
fq4 = 1/spc_mean(4)
%%% alternatively, we can compute a frequency based on the mean of the
%%% number of points for a given line length (scaled)
m_fq4 = mean(np_t1./(line_length*msf)')

figure(1)
    subplot(2,2,4)
    histogram(t_dist_bwp1{4},5,'normalization','probability')
    ylabel(['all sets probability'])
    xlabel('spacing between joints (m)')
    ylim([0 0.5])
    hold on 
    plot([spc_mean(4) spc_mean(4)], get(gca,'ylim'),'r')
    grid on
    text(0.6, 0.8, ['\lambda = ' num2str(1/spc_mean(4))],'units', 'normalized','color','r')
    xlm = get(gca,'xlim')
    xx = linspace(xlm(1),xlm(2),20)
    yy = fq4*exp(-fq4*xx)
    hold on
    plot(xx,yy,'r')
    
    suptitle(['Scanline angle ' theta '$$\rm{^o}$$, value = 1/(average spacing)'],'interpreter','latex')

figure(2) 
    subplot(2,2,4)
    np_t = sum(np,2)
    plot(line_length*msf,np_t./(line_length*msf)','-o')
    m_fqt = mean(np_t./(line_length*msf)')
    hold on
    plot(get(gca,'xlim'),[m_fqt m_fqt],'r')
    grid on
    text(0.7, 0.9, num2str(m_fqt),'units', 'normalized')
    suptitle('value = mean of number of points per line (mean fq)')
    
figure(1)
    yy2 = m_fqt*exp(-m_fqt*xx)
    hold on
    plot(xx,yy2,'color',cm)
    text(0.6, 0.7, ['\lambda = ' num2str(m_fqt)],'units', 'normalized','color',cm)
    ylim([0 0.5])
    hold on 
    plot([1/m_fqt 1/m_fqt], get(gca,'ylim'),'color',cm)
% figure(1)  
%     subplot(2,2,4)
fq = m_fqt
%     yy = fq*exp(-fq*xx)
%     hold on
%     plot(xx,yy)

tot_fq = sum(np_t)/(sum(line_length)*msf)

return
%% test of the binning size
% close all
figure(4)
subplot(1,2,1)
h20 = histogram(t_dist_bwp1{4},20,'normalization','probability')
subplot(1,2,2)
h10 = histogram(t_dist_bwp1{4},10,'normalization','probability')
