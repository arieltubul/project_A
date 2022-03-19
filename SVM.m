function [new_lable] = SVM(ayFilterd, fixedlocs, fixedPeaks, t_acc)
global w En_classifySVM En_predictSVM
% calculate frequency
diff_ = diff(fixedlocs);
diff_Time = 0.01 * [diff_ diff_(end)];
freq = 1./diff_Time;
freq = freq';

% direvative +-3
k = 1;
div_ay = [];
d = 3;
for idz = fixedlocs
    div_ay(k) = ayFilterd(idz+d) - ayFilterd(idz-d);
    k = k+1;
end 
div_ay = div_ay';

% amplitude
amp_az = fixedPeaks';

%%  setting data_base
features = [div_ay, amp_az, freq];
db_backward = load('./SVM_train/backward_train.mat');
db_forward = load('./SVM_train/forward_train.mat');
% db_standing = load('./SVM_train/standing_train.mat');

db_backward = cell2mat(struct2cell(db_backward));
db_forward = cell2mat(struct2cell(db_forward));
% db_standing = cell2mat(struct2cell(db_standing));
% len = length(db_standing(:,1));
% half = len/2;
% db_walking = [db_backward(1:half, :); db_forward(1:(len-half), :)];

% draw db_Fw_Bw
if (En_classifySVM ==1)
figure;
grid on; hold on;
scatter3(db_forward(:,1),db_forward(:,2),db_forward(:,3),'r','filled','LineWidth',10);
scatter3(db_backward(:,1),db_backward(:,2),db_backward(:,3),'b','filled','LineWidth',10);

view(-30,10)

xlabel('div_ay'); ylabel('amp_az'); zlabel('frequency');
legend('forward','backward');
hold off;
end
%{
% draw db_Wa_St
figure;
grid on; hold on;
scatter3(db_walking(:,1),db_walking(:,2),db_walking(:,3),'p','filled','LineWidth',10);
scatter3(db_standing (:,1),db_standing(:,2),db_standing(:,3),'g','filled','LineWidth',10);

view(-30,10)

xlabel('div_ay'); ylabel('amp_az'); zlabel('frequency');
legend('walking', 'standing');
hold off;
%% setting SVM for Standing/Walking
walk = ones(length(db_walking),1);
stand = - ones(length(db_standing),1) * 0;
data_val_ = [db_walking(:,1), db_walking(:,2),db_walking(:,3); ...
    db_standing(:,1), db_standing(:,2),db_standing(:,3)];
data_class_ = [walk; stand];
svmfit_ = fitcsvm(data_val_, data_class_);
svm_3d_plot(svmfit_,data_val_,data_class_,0);

loss_train_data = loss(svmfit_, data_val_, data_class_);
%}
%% setting SVM for Backward/Forward
forward = ones(length(db_forward),1);
backward = - ones(length(db_backward),1) * 0;
data_val = [db_forward(:,1), db_forward(:,2),db_forward(:,3); ...
db_backward(:,1), db_backward(:,2),db_backward(:,3)];
data_class = [forward; backward];
svmfit = fitcsvm(data_val, data_class);
svm_3d_plot(svmfit,data_val,data_class,1);

loss_train_data = loss(svmfit, data_val, data_class);

%{
%% SVM prediction walking_standing
[lable_, score_] = predict(svmfit_, features);
score_ = score_(:,2);
figure;
subplot(211);
stem(t_acc(fixedlocs),lable_,'filled'); hold on;
stem(t_acc(fixedlocs),score_,'g'); hold off;
xlim([0,t_acc(end)]); grid on;
title('prediction for walking / standing');
legend('lable','score');
%}
%% SVM prediction Forward_Backward
[lable, score] = predict(svmfit, features);
score = score(:,2);
if (En_predictSVM == 1)
figure;
subplot(211);
stem(t_acc(fixedlocs),lable,'filled'); hold on;
stem(t_acc(fixedlocs),score,'g'); hold off;
xlim([0,t_acc(end)]); grid on;
title('prediction for forward / backward');
legend('lable','score');
end

%% SVM improvment
% find silnece period
% we assume that after silence period, walking direction has been changed
dif = diff(fixedlocs); % time diff between steps
sil = find(dif > 250); %find the steps which diff is long enough 
first_step = fixedlocs(sil+1); %first steps of opposite direction, if we didnt 
%change direction through walking so first step is the first step of our walking

first_step = [fixedlocs(1);first_step]; % till that step, same direction
%actually it makes vector of all first steps for each section we changed
%direction
new_lable = []; new_score = [];
k = 1;
for steps = fixedlocs % go through indexes
%if we are in the first step of a section so we dont have previous step to rely on    
    if(find(first_step==steps)) 
        new_lable(k) = lable(k);
        new_score(k) = score(k);
    
    else
        new_score(k) = (w*new_score(k-1)+score(k))/(w+1); %more weight to previous score
        if(new_score(k) > 0)
            new_lable(k) = 1;
        else
            new_lable(k) = 0;
        end 
    end 
    k = k+1;
end

if (En_predictSVM == 1)
subplot(212);
stem(t_acc(fixedlocs),new_lable,'filled'); hold on;
stem(t_acc(fixedlocs),new_score,'g'); hold off;
xlim([0,t_acc(end)]); grid on;
title('Improved prediction for forward / backward');
legend('new lable','new score');
end
new_lable = new_lable';



end

