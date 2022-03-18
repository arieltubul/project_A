function [] = DataPlot(axFilterd, ayFilterd, azFilterd,t_acc,orient,t_orient)
global En_Data
%plotting accelreation in 3 axis and orientation
acc_x = axFilterd - mean(axFilterd);
acc_y =  ayFilterd - mean(ayFilterd);
acc_z =  azFilterd - mean(azFilterd);
%numbers in brackets are Location and size of drawable area(position)
if(En_Data == 1)
figure('Renderer', 'painters', 'Position', [20 170 900 600])
hold on
subplot(3, 1, 1) % Z axis
plot(t_acc, acc_z);
xlim([0 inf]);
legend('a_z');
title('All filterd accelerations', 'FontSize', 15);
ylabel('a_z [m/s^2]', 'FontSize', 12);

subplot(3, 1, 2) % Y axis
plot(t_acc, acc_y, 'r');
xlim([0 inf]);
legend('a_y');
ylabel('a_y [m/s^2]', 'FontSize', 12);
 
subplot(3, 1, 3) % X axis
plot(t_acc, acc_x, 'g');
xlim([0 inf]);
legend('a_x');
xlabel('time [s]', 'FontSize', 15);
ylabel('a_x [m/s^2]', 'FontSize', 12);
hold off

%orientation
figure('Renderer', 'painters', 'Position', [850 270 700 500]);
plot(t_orient,orient);
xlim([0 inf]);
legend('Azimuth', 'Pitch', 'Roll');
title('Orientation');
ylabel('Degree');
xlabel('time[s]');

% for position We'll handle this later
%{
figure(5)
plot(tl,pos);
title('Position');
ylabel('Position');
xlabel('Absolute time(s)');
%}

% for Realtime We'll handle this later
%{
figure(2)
for i = 1:20
    [acc, tac] = accellog(m);
    x = acc(:,1);
    plot(tac, x);
    title('X Acceleration');
    xlabel('Relative time (s)');
    ylabel('a_z (m/s^2)');
    pause(0.2)

end
%}
end
end

