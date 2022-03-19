function [numSteps, fixedlocs, fixedPeaks] = FindSteps(ayFilterd, azFilterd, t_acc)
global MinPeakD MinPeakH En_Steps
acc_z = azFilterd -mean (azFilterd);
acc_z = acc_z(:,1);
acc_y = ayFilterd -mean (ayFilterd);
acc_y = acc_y(:,1);
[pks, locs] = findpeaks(acc_z,  'MinPeakHeight',MinPeakH,...
                                          'MinPeakDistance',MinPeakD);
[fixedPeaks,fixedlocs] = fixLocs(t_acc,pks,locs,MinPeakD);

numSteps = numel(fixedPeaks);
if(En_Steps == 1)
    figure;
    plot(t_acc, acc_z,'b', t_acc(fixedlocs), fixedPeaks, 'or');
    xlim([0 inf]);
    legend('a_z');
    title('Steps at Z axis', 'FontSize', 15);
    ylabel('a_z [m/s^2]', 'FontSize', 12);
    xlabel('time[s]');
    grid on;
    
    figure;
    hold on;
    plot(t_acc, acc_y,'b', t_acc(fixedlocs), acc_y(fixedlocs),'or');
    plot(t_acc, zeros(size(t_acc)), 'black');
    xlim([0 inf]);
    legend('a_Y');
    title('Steps at Y axis', 'FontSize', 15);
    ylabel('a_y [m/s^2]', 'FontSize', 12);
    xlabel('time[s]');
    grid on;
end
end

