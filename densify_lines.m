function [output] = densify_lines(set)

    xx = linspace(min(set(:,1)),max(set(:,1)),length(set(:,1))*25);

    y = set(:,2);
    x = set(:,1);

    x_list = 0;
    for i = 2:length(x)-1

        if x(i-1)==x(i); 

            x_list(end+1) = i;

        end    

    end
    x_list = x_list(2:end);

    y_list = 0;
    for i = 2:length(y)-1

        if y(i-1)==y(i);

            y_list(end+1) = i;

        end    

    end
    y_list = y_list(2:end);
    e_list = sort([x_list,y_list]);
    e_list = unique(e_list);

    set(e_list,:) = [];
    set(end-1,:) = [];

    yy = spline(set(:,1),set(:,2),xx);

    output = [xx',yy'];


