%%% this function is called on from analyze_sets to densify the lines that
%%% were created using imfreehand

function [output] = densify_lines(jset)
% clear all 
% close all
% [folder, subFolder, imgNum, setIn] = whatFolder()
% folderStr = [folder subFolder setIn]
% load(folderStr)
% % figure
% for kk = 1:length(s2)
% jset = s2{kk}


%% in this section you can find the repeated values, and if they are at the end then cut it off
d_js = jset(2:end,1)-jset(1:end-1,1)
eld = length(jset(:,1)) - find(d_js<0) 
% keyboard
if sum(eld<5)>1
    jset = jset(1:end-7,:)
end
% if sum(eld>(length(jset(:,1))-5))>1
%     jset = jset(5:end,:)
% end

if length(jset(:,1))<2
    output = jset;
    return    
end
[jset] = findUnique(jset);
if length(jset(:,1))<2
    output = jset;
    return    
end

[isu_x] = unique(jset(:,1)) ;

if length(isu_x) < length(jset(:,1))
    xx = linspace(min(jset(:,2)),max(jset(:,2)),length(jset(:,2))*4);
   
    for i = 1:length(jset(:,1))
        njset = jset(i,:)+(0.1*rand-(0.1/2));
        jset(i,:) = njset;
    end

    yy = pchip(jset(:,2),jset(:,1),xx);

    output = [yy',xx'];
    'yes, its the first loop'
    
else
    
    xx = linspace(min(jset(:,1)),max(jset(:,1)),length(jset(:,1))*4);

    for i = 1:length(jset(:,1))
        njset = jset(i,:)+(0.25*rand-0.125);
        jset(i,:) = njset;
    end
    yy = pchip(jset(:,1),jset(:,2),xx);

    output = [xx',yy'];

end

% close all
% figure
% plot(jset(:,1),jset(:,2),'r')
% hold on
% plot(output(:,1),output(:,2))
end
