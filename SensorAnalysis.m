close all
clear variables
clc
%% Global Paramters
% here we can easily define\change parameters for all code
global MinPeakD MinPeakH N_periods cutoff sample_rate ...
    realtime_data log_file w medfilter SVM_train train_mode ...
    period_real_time En_Data En_Filt En_Steps En_peaks En_features En_SVM2 ...
    En_SVM3 En_linerReg En_predictSVM En_classifySVM

% enable data plots
En_Data = 0; En_Filt = 0; En_Steps = 0; En_peaks = 0; En_features = 0;
En_SVM2 = 0; En_SVM3 = 0; En_linerReg = 0; En_classifySVM = 0;
En_predictSVM = 0;

% type of sample - realtime or logfile
% Important !! make new sensorlog file inside a day (not pass 00:00) !
realtime_data = 0; log_file = './measurments/Forward/forward_5.mat';
% './measurments/Standing/in_place.mat'
% './measurments/Backward/backward_5.mat'
% './measurments/Forward/forward_5.mat'
% './measurments/Circular/fw_circle.mat'

% setup params, relevant for realtime = 1
N_periods = 3; sample_rate = 100; period_real_time = 10;

% data params
MinPeakD = 0.4; MinPeakH = 0.55; cutoff = 1.5;
% MinPeakH = 0.8 forward
% MinPeakH = 0.55 forward

% hyper params
w = 1.8; medfilter = 100;
% weight for previous step
% medfilter determines order of median filter for azimuth (for track)

% SVM_prep
% define name for file of SVM_prep
SVM_train = 'standing'; % 'forward' / 'backward' / 'standing'
train_mode = 0; % 1 for training, 0 for inference
%% Acquire data

% to make loop while only once
if(realtime_data == 0)
    N_periods = 1;
end
sessions = N_periods;


if(realtime_data == 1)
    m = mobiledev;
    m.AccelerationSensorEnabled = 1;
    m.OrientationSensorEnabled = 1;
    m.SampleRate = sample_rate;
    m.Logging = 1;
else
    m = 1;
end


start = 1;
while(sessions > 0)
    [acc, t_acc, orient, t_orient] = Setup(m);
    L = min(length(t_acc), length(t_orient));
    t_acc = t_acc(1:L,1); t_orient = t_orient(1:L,1);
    acc = acc(1:L,1:3); orient = orient(1:L,1:3);
    %% Filter noise
    [axFilterd, ayFilterd, azFilterd] = FilterNoise(acc, t_acc);

    %% Plot data
    DataPlot(axFilterd, ayFilterd, azFilterd, t_acc, orient, t_orient);

    %% Count & Plot steps taken
    [numSteps, fixedlocs, fixedPeaks] = FindSteps(ayFilterd, azFilterd, t_acc);

    %% SVM_train
    if(train_mode == 1)
        SVM_Train(ayFilterd, fixedlocs, fixedPeaks, t_acc);
    end
    
    %% SVM
    if(train_mode == 0)
        [new_lable] = SVM(ayFilterd, fixedlocs, fixedPeaks, t_acc);
    
        %% Data Process
        % extract std & p2p
        [features] = DataProcess(ayFilterd, azFilterd, fixedlocs, fixedPeaks, new_lable, t_acc);
    
        %%  linear regression
        % predict step size
        % Parameters studied using the linear regression estimator
        [b, totalLength, stepLength] = Regression(features);
    
        %% plot walk -        *********************        unfinished         *******************
        PlotTrack(new_lable, orient, fixedlocs, stepLength, sessions);
        sessions = sessions - 1;
    end 
end %while


%% Stop recording on phone
if (realtime_data == 1)
    m.Logging = 0;
end
   
