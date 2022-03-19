close all
clear variables
clc
%% Global Paramters
% here we can easily define\change parameters for all code
global time_record sample_rate realtime_data log_file
% record params
time_record = 400; sample_rate = 100;
realtime_data = 0; log_file = 'static_100m.mat';
%% Acquire data
if(realtime_data == 1)
    sensor_data = mobiledev;
end
if(realtime_data == 0)%if so, set sample_rate & time_record manually in app
    sensor_data = load(log_file);
end
[acc, t_acc, orient, t_orient] = Setup(sensor_data);

%% Allan variance
t0 = 1/sample_rate;
omega = acc(:,1);
theta = cumsum(omega, 1)*t0;
maxNumM = 100;
L = size(theta, 1);
maxM = 2.^floor(log2(L/2));
sensor_data = logspace(log10(1), log10(maxM), maxNumM).';
sensor_data = ceil(sensor_data); % m must be an integer.
sensor_data = unique(sensor_data); % Remove duplicates.

tau = sensor_data*t0;

avar = zeros(numel(sensor_data), 1);
for i = 1:numel(sensor_data)
    mi = sensor_data(i);
    avar(i,:) = sum( ...
        (theta(1+2*mi:L) - 2*theta(1+mi:L-mi) + theta(1:L-2*mi)).^2, 1);
end
avar = avar ./ (2*tau.^2 .* (L - 2*sensor_data));

adev = sqrt(avar);

figure
loglog(tau, adev, 'LineWidth',2)
title('Allan Deviation','FontSize',15)
xlabel('\tau','FontSize',15);
ylabel('\sigma(\tau)','FontSize',15)
grid on
axis equal
%% Angle Random Walk
% Find the index where the slope of the log-scaled Allan deviation is equal
% to the slope specified.
slope = -0.5;
logtau = log10(tau);
logadev = log10(adev);
dlogadev = diff(logadev) ./ diff(logtau);
[~, i] = min(abs(dlogadev - slope));

% Find the y-intercept of the line.
b = logadev(i) - slope*logtau(i);

% Determine the angle random walk coefficient from the line.
logN = slope*log(1) + b;
N = 10^logN;

% Plot the results.
tauN = 1;
lineN = N ./ sqrt(tau);
figure
loglog(tau, adev, tau, lineN, '--', tauN, N, 'o', 'LineWidth',2)
title('Allan Deviation with Angle Random Walk','FontSize',15)
xlabel('\tau','FontSize',15)
ylabel('\sigma(\tau)','FontSize',15)
legend('\sigma', '\sigma_N', 'LineWidth',2)
text(tauN, N, 'N', 'LineWidth',2)
grid on
axis equal
%% Rate Random Walk
% Find the index where the slope of the log-scaled Allan deviation is equal
% to the slope specified.
slope = 0.5;
logtau = log10(tau);
logadev = log10(adev);
dlogadev = diff(logadev) ./ diff(logtau);
[~, i] = min(abs(dlogadev - slope));

% Find the y-intercept of the line.
b = logadev(i) - slope*logtau(i);

% Determine the rate random walk coefficient from the line.
logK = slope*log10(3) + b;
K = 10^logK;

% Plot the results.
tauK = 3;
lineK = K .* sqrt(tau/3);
figure
loglog(tau, adev, tau, lineK, '--', tauK, K, 'o','LineWidth',2)
title('Allan Deviation with Rate Random Walk','FontSize',15)
xlabel('\tau','FontSize',15)
ylabel('\sigma(\tau)','FontSize',15)
legend('\sigma', '\sigma_K','LineWidth',2)
text(tauK, K, 'K','LineWidth',2)
grid on
axis equal
%% Bias Instability
% Find the index where the slope of the log-scaled Allan deviation is equal
% to the slope specified.
slope = 0;
logtau = log10(tau);
logadev = log10(adev);
dlogadev = diff(logadev) ./ diff(logtau);
[~, i] = min(abs(dlogadev - slope));

% Find the y-intercept of the line.
b = logadev(i) - slope*logtau(i);

% Determine the bias instability coefficient from the line.
scfB = sqrt(2*log(2)/pi);
logB = b - log10(scfB);
B = 10^logB;

% Plot the results.
tauB = tau(i);
lineB = B * scfB * ones(size(tau));
figure
loglog(tau, adev, tau, lineB, '--', tauB, scfB*B, 'o','LineWidth',2)
title('Allan Deviation with Bias Instability','FontSize',15)
xlabel('\tau','FontSize',15)
ylabel('\sigma(\tau)','FontSize',15)
legend('\sigma', '\sigma_B','LineWidth',2)
text(tauB, scfB*B, '0.664B','LineWidth',2)
grid on
axis equal
%% Allan variance with noise
tauParams = [tauN, tauK, tauB];
params = [N, K, scfB*B];
figure
loglog(tau, adev, tau, [lineN, lineK, lineB], '--', ...
    tauParams, params, 'o','LineWidth',2)
title('Allan Deviation with Noise Parameters','FontSize',15)
xlabel('\tau','FontSize',15)
ylabel('\sigma(\tau)','FontSize',15)
legend('\sigma', '\sigma_N', '\sigma_K', '\sigma_B','LineWidth',2)
text(tauParams, params, {'N', 'K', '0.664B'},'LineWidth',2)
grid on
axis equal
%% 


