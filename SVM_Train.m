function [] = SVM_Train(ayFilterd, fixedlocs, fixedPeaks, t_acc)
global SVM_train

% frequency
diff_ = diff(t_acc(fixedlocs));
diff_Time = [diff_ ; diff_(end)];
freq = 1./diff_Time;
% derivative +-3
k = 1;
d_ay = [];
d = 3;
for idz = fixedlocs
    d_ay(k) = ayFilterd(idz+d) - ayFilterd(idz-d);
    k = k+1;
end 
d_ay = d_ay';

% amplitude
amp_az = fixedPeaks';

%%  setting data_base
features = [d_ay,  amp_az, freq];
filename = append('./SVM_train/' , SVM_train , '_train');
save(filename, 'features');
end

