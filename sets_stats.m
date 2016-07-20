clear all
close all

folder = 'D:\Field_data\2013\Summer\Images\JWC\GL1\Photogrammetry\July17\GL1PG1ST1\IMG_9030_analysis\'
load([folder 'sets_2.mat'])

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
fs = 16

% thetaA = [5:10:175];

close all
theta = '65'

setNumStr = {'s1','s2','s3'}   %% these are the joint sets that were created from analyze_sets.m

jset = []

for j = 1:3

    np = []
    setNum = setNumStr{j}
    %%% this is a .mat file with a variable called set_int (joint set
    %%% intersection), which is a call array, and a variable containing line_length
    %%%. There is a cell for each
    %%% scanline, and within that cell contains the coordinates of where
    %%% the scanline of a given angle (theta) intersects a joint set (j)
    load([folder 'sl_pts_' num2str(theta) '_' setNum '_sets_2.mat'])  
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
        h1 = histogram(t_dist_bwp1{j},'normalization', 'pdf')
        ylabel(['set ' num2str(j) ' pdf'])
        xlabel('spacing between joints (m)')
        grid on        
        xlm = get(gca,'xlim')
        xx = linspace(xlm(1),xlm(2),100)
        yy = fq*exp(-fq*xx)
        hold on
        l1 = plot(xx,yy,'r')
        text(0.6, 0.8, ['\lambda = ' num2str(fq)],'units', 'normalized','color','r','fontsize',fs)
        hold on 
        plot([spc_mean(j) spc_mean(j)], get(gca,'ylim'),'r')
        paramhat = lognfit(t_dist_bwp1{j})
        yy3 = lognpdf(xx,paramhat(1),paramhat(2))
        hold on 
        l2 = plot(xx,yy3,'b-')
        
        yy2 = m_fq(j)*exp(-m_fq(j)*xx)
        hold on
        cm = [0.4 0 0.4]
        plot(xx,yy2,'color',cm)
        text(0.6, 0.7, ['\lambda = ' num2str(m_fq(j))],'units', 'normalized','color',cm,'fontsize',fs)
%         ylim([0 0.5])
        hold on 
        plot([1/m_fq(j) 1/m_fq(j)], get(gca,'ylim'),'color', cm)
        set(gca,'fontsize',fs)
        ylim([0 max(yy3)+0.1])


        
    figure(2)
        subplot(2,2,j)
        plot(line_length*msf,np(:,j)./(line_length*msf)','-o')
        hold on
        h1 = plot(get(gca,'xlim'),[m_fq(j) m_fq(j)],'r')
        grid on
        text(0.7, 0.9, num2str(m_fq(j)),'units', 'normalized','fontsize',fs)
        xlabel('line length(m)')
        ylabel('frequency')
        if j == 1
            legend(h1, 'mean frequency','location','southeast')
        end
        set(gca,'fontsize',fs)
        
    
end

figure(1)
subplot(2,2,1)
legend([l1 l2], {'negative exponential', 'lognormal'},'fontsize',12,'location','northwest')

%% ok, this might get a little more complex, but I want to put the points 
%%% from all sets on a given scanline
    
s1 = load([folder 'sl_pts_' num2str(theta) '_' setNumStr{1} '_sets_2.mat'])  
s2 = load([folder 'sl_pts_' num2str(theta) '_' setNumStr{2} '_sets_2.mat']) 
s3 = load([folder 'sl_pts_' num2str(theta) '_' setNumStr{3} '_sets_2.mat'])

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
    histogram(t_dist_bwp1{4},10,'normalization','pdf')
    ylabel(['all sets pdf'])
    xlabel('spacing between joints (m)')
%     ylim([0 0.5])
    hold on 
    grid on
    text(0.6, 0.8, ['\lambda = ' num2str(1/spc_mean(4))],'units', 'normalized','color','r','fontsize',fs)
    xlm = get(gca,'xlim')
    xx = linspace(xlm(1),xlm(2),100)
    yy = fq4*exp(-fq4*xx)
    hold on
    plot(xx,yy,'r')
    set(gca,'fontsize',fs)
    suptitle(['Scanline angle ' theta '$$\rm{^o}$$, value = 1/(average spacing)'],'interpreter','latex','fontsize',fs)
    paramhat = lognfit(t_dist_bwp1{4})
    yy3 = lognpdf(xx,paramhat(1),paramhat(2))
    hold on 
    l2 = plot(xx,yy3,'b-')

f2 = figure(2) 
    subplot(2,2,4)
%     np_t = sum(np,2)
    plot(line_length*msf,np_t1'./(line_length*msf)','-o')
    m_fqt = mean(np_t1'./(line_length*msf)')
    hold on
    plot(get(gca,'xlim'),[m_fqt m_fqt],'r')
    grid on
    text(0.7, 0.9, num2str(m_fqt),'units', 'normalized','fontsize',fs)
    suptitle('value = mean of number of points per line (mean fq)','fontsize',fs)
    xlabel('line length(m)')
    ylabel('frequency')
    set(gca,'fontsize',fs)
    
f1 = figure(1)
    yy2 = m_fqt*exp(-m_fqt*xx)
    hold on
    plot(xx,yy2,'color',cm)
    text(0.6, 0.7, ['\lambda = ' num2str(m_fqt)],'units', 'normalized','color',cm,'fontsize',fs)
%     ylim([0 0.5])
    hold on 
    plot([1/m_fqt 1/m_fqt], get(gca,'ylim'),'color',cm)
    set(gca,'fontsize',fs)
    ylim([0 max(yy3)+0.1])
    plot([spc_mean(4) spc_mean(4)], get(gca,'ylim'),'r')

fq = m_fqt
tot_fq = sum(np_t1')/(sum(line_length)*msf)

savePDFfunction(f1,'D:\Field_data\2013\Summer\Images\JWC\GL1\Photogrammetry\July17\GL1PG1ST1\IMG_9030_analysis\figures_2\meanFreq_vs_length')
savePDFfunction(f2,'D:\Field_data\2013\Summer\Images\JWC\GL1\Photogrammetry\July17\GL1PG1ST1\IMG_9030_analysis\figures_2\FreqDist')

return
%% test of the binning size
% % close all
% figure(4)
% subplot(1,2,1)
% h20 = histogram(t_dist_bwp1{4},20,'normalization','probability')
% subplot(1,2,2)
% h10 = histogram(t_dist_bwp1{4},10,'normalization','probability')

%% this section is to get the distriubtion of lengths of all the sets, and the first two section of this script should first be run
clear all

folder = 'D:\Field_data\2013\Summer\Images\JWC\GL1\Photogrammetry\July17\GL1PG1ST1\IMG_9030_analysis\'
load([folder 'sets_2.mat'])

msf = 0.009

close all
fL = figure
bins = 15
fs = 16

for j = 1:3
    
    if j == 1
        SN = s1
    elseif j == 2
        SN = s2
    elseif j == 3
        SN = s3
    end
    
    for i = 1:length(SN)
        lin = SN{i};
        diff = lin(2:end,:)-lin(1:end-1,:);
        d(i) = sum(sqrt((diff(:,1).^2)+(diff(:,2).^2)));
    end
    d_sc1 = d*msf;
    subplot(2,2,j)
    h = histogram(d_sc1,bins,'normalization','pdf')
%     keyboard
    text(0.5,0.7,['mean = ' num2str(mean(d_sc1)) 'm'],'units','normalized','fontsize',fs)
%     text(0.5,0.6,['mode = ' num2str(mode(d_sc1)) 'm'],'units','normalized','fontsize',fs)
    grid on
    xlabel('trace length (m)','fontsize',fs)
    ylabel(['set ' num2str(j) ' probability'],'fontsize',fs)
    xlim([0 25])
    xl = get(gca,'xlim')
    mean_l = mean(d_sc1)
    lambda = mean_l^-1
    xx = linspace(xl(1),xl(2),100)
    yy = lambda*exp(-lambda*xx)
    hold on 
    h1 = plot(xx,yy,'r','linewidth',2)
    lambdahat = lognfit(d_sc1)
    yy2 = lognpdf(xx,lambdahat(1),lambdahat(2))
    hold on
    h2 = plot(xx,yy2,'b','linewidth',2)
    xlim([0 25])
    set(gca,'fontsize',fs)
    hold on
    plot([mean_l mean_l],get(gca,'ylim'),'k')
    
end

subplot(2,2,1)
legend([h1 h2], {'negative exponential','lognormal'},'location','northeast','fontsize',12)

SN = [s1,s2,s3];
d = []
for i = 1:length(SN)
    lin = SN{i};
    diff = lin(2:end,:)-lin(1:end-1,:);
    d(i) = sum(sqrt((diff(:,1).^2)+(diff(:,2).^2)));
end
d_scT = d*msf;
subplot(2,2,4)
histogram(d_scT,bins,'normalization','pdf')
text(0.5,0.7,['mean = ' num2str(mean(d_scT)) 'm'],'units','normalized','fontsize',fs)
% text(0.5,0.6,['mode = ' num2str(mode(d_scT)) 'm'],'units','normalized','fontsize',fs)
grid on
mean_l = mean(d_scT)
lambda = mean_l^-1
yy = lambda*exp(-lambda*xx)
hold on 
h1 = plot(xx,yy,'r','linewidth',2)
lambdahat = lognfit(d_scT)
yy2 = lognpdf(xx,lambdahat(1),lambdahat(2))
hold on
h2 = plot(xx,yy2,'b','linewidth',2)
xlim([0 25])
grid on
xlabel('trace length (m)','fontsize',fs)
ylabel('set 4 probability','fontsize',fs)
set(gca,'fontsize',fs)
hold on
plot([mean_l mean_l],get(gca,'ylim'),'k')

savePDFfunction(fL,'D:\Field_data\2013\Summer\Images\JWC\GL1\Photogrammetry\July17\GL1PG1ST1\IMG_9030_analysis\figures_2\lengthDist')



