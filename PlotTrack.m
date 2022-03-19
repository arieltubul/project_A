function [] = PlotTrack(new_lable, orient, fixedlocs, stepLength, sessions)
global medfilter En_orient N_periods
heading_med = medfilt1(orient(:,1),medfilter); %filtering azimuth
heading = heading_med;
if (En_orient == 1)
    figure
    plot(heading)
end
new_lable(new_lable~=1) = -1; %Steps back multiplied by -1.15 ??
x = stepLength .* new_lable .* sind(heading(fixedlocs));
x = [0; cumsum(x)];
y = stepLength .* (new_lable) .* cosd(heading(fixedlocs));
y = [0; cumsum(y)];
sum_length = 1/100 * sum(abs(stepLength));
%subplot(211);
figure('Renderer', 'painters', 'Position', [40 50 900 600])
hold on
plot_dir(x/100,y/100); axis equal; grid on; %plotting in meters
Total_periods = N_periods;
period_num = Total_periods - sessions + 1;
title(sprintf('The walking route, period num: %d \n sum lenght: %.2f[meters]',...
    period_num, sum_length)); xlabel('x'); ylabel('y');
hold off
end

