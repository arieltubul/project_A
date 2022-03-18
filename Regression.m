function [b, totalLength, stepLength] = Regression(features)
global En_linerReg
%% features data for linear regression
%% 40cm
%f stands for first measurement, s for second, and t for third
f40 = load ('./measurments/step_aprox/40_1NEW.mat');
s40 = load ('./measurments/step_aprox/40_2NEW.mat');
t40 = load ('./measurments/step_aprox/40_3NEW.mat');
all_40 = [f40.features(:,1), f40.features(:,2) ;
          s40.features(:,1), s40.features(:,2) ;
          t40.features(:,1), t40.features(:,2) ];
all_40(all_40(:,2) <= 0, :) = [];
%all_40(all_40(:,2) > 1, :) = [];
all_40(all_40(:,1) <= 0, :) = [];
%all_40(all_40(:,2) > 1, :) = [];
%% 50cm
f50 = load ('./measurments/step_aprox/50_1NEW.mat');
s50 = load ('./measurments/step_aprox/50_2NEW.mat');
t50 = load ('./measurments/step_aprox/50_3NEW.mat');
all_50 = [f50.features(:,1), f50.features(:,2) ;
          s50.features(:,1), s50.features(:,2) ;
          t50.features(:,1), t50.features(:,2) ];
all_50(all_50(:,2) <= 0, :) = [];
%all_50(all_50(:,2) > 10, :) = [];
all_50(all_50(:,1) <= 0, :) = [];
%all_50(all_50(:,2) > 1, :) = [];

%% 60cm
f60 = load ('./measurments/step_aprox/60_1NEW.mat');
s60 = load ('./measurments/step_aprox/60_2NEW.mat');
t60 = load ('./measurments/step_aprox/60_3NEW.mat');
all_60 = [f60.features(:,1), f60.features(:,2) ;
          s60.features(:,1), s60.features(:,2) ;
          t60.features(:,1), t60.features(:,2) ];
all_60(all_60(:,2) <= 0, :) = [];
%all_60(all_60(:,2) > 10, :) = [];
all_60(all_60(:,1) <= 0, :) = [];
%all_60(all_60(:,2) > 1, :) = [];

%% 70cm
f70 = load ('./measurments/step_aprox/70_1NEW.mat');
s70 = load ('./measurments/step_aprox/70_2NEW.mat');
t70 = load ('./measurments/step_aprox/70_3NEW.mat');
all_70 = [f70.features(:,1), f70.features(:,2) ;
          s70.features(:,1), s70.features(:,2) ;
          t70.features(:,1), t70.features(:,2) ];
all_70(all_70(:,2) <= 0, :) = [];
%all_70(all_70(:,2) > 10, :) = [];
all_70(all_70(:,1) <= 0, :) = [];
%all_70(all_70(:,2) > 1, :) = [];

%% 80cm
f80 = load ('./measurments/step_aprox/80_1NEW.mat');
s80 = load ('./measurments/step_aprox/80_2NEW.mat');
t80 = load ('./measurments/step_aprox/80_3NEW.mat');
all_80 = [f80.features(:,1), f80.features(:,2) ;
          s80.features(:,1), s80.features(:,2) ;
          t80.features(:,1), t80.features(:,2) ];
all_80(all_80(:,2) <= 0, :) = [];
%all_80(all_80(:,2) > 10, :) = [];
all_80(all_80(:,1) <= 0, :) = [];
%all_80(all_80(:,2) > 1, :) = [];

%% plotting means
mean_features = [mean(all_40(:,2)) , mean(all_40(:,1)) ;
                 mean(all_50(:,2)) , mean(all_50(:,1)) ;
                 mean(all_60(:,2)) , mean(all_60(:,1)) ;
                 mean(all_70(:,2)) , mean(all_70(:,1)) ;
                 mean(all_80(:,2)) , mean(all_80(:,1)) ;];
if (En_linerReg == 1)
    figure;
    hold on;
    grid on;
    scatter(mean_features(1,1),mean_features(1,2),'r', 'filled');
    scatter(mean_features(2,1),mean_features(2,2),'b', 'filled');
    scatter(mean_features(3,1),mean_features(3,2),'g', 'filled');
    scatter(mean_features(4,1),mean_features(4,2),'p', 'filled');
    scatter(mean_features(5,1),mean_features(5,2),'y', 'filled');
    legend('40cm', '50cm', '60cm', '70cm', '80cm');
    title('step length features mean');
    xlabel('σ_y + σ_z');
    ylabel('p2p_y + p2p_z');
    
    text(mean_features(1,1),mean_features(1,2), '(0.88, 2.01)');
    text(mean_features(2,1),mean_features(2,2), '(1.41, 3.27)');
    text(mean_features(3,1),mean_features(3,2), '(1.86, 4.36)');
    text(mean_features(4,1),mean_features(4,2), '(2.35, 5.73)');
    text(mean_features(5,1),mean_features(5,2), '(3.10, 7.66)');
    
    
    hold off;
end


%% finding coffiecents for linear regression
data = [ones([5,1]), mean_features(:,1), mean_features(:,2)];
prediction = [40; 50; 60; 70; 80];
b = regress(prediction, data);

%% plotting all together
if (En_linerReg == 1)
    figure;
    hold on;
    scatter(all_40(:,2),all_40(:,1),'r');
    scatter(all_50(:,2),all_50(:,1),'b');
    scatter(all_60(:,2),all_60(:,1),'g');
    scatter(all_70(:,2),all_70(:,1),'p');
    scatter(all_80(:,2),all_80(:,1),'y');
    
    legend('40cm', '50cm', '60cm', '70cm', '80cm');
    title('step length features');
    xlabel('σ_y + σ_z');
    ylabel('p2p_y + p2p_z');
end

%% plotting surface of linear regression
if(En_linerReg == 1)
    figure;
    [x,y] = meshgrid(mean_features(:,1),mean_features(:,2));
    z = b(1) + b(2)*x + b(3)*y;
    surf(x,y,z);
    zlim([30, 90]);
    title('step length regression [cm]');
    xlabel('σ_y + σ_z');
    ylabel('p2p_y + p2p_z');
    zlabel('step length');
    hold on
    plot3(mean_features(1,1),mean_features(1,2),40, 'o');
    plot3(mean_features(2,1),mean_features(2,2),50, 'o');
    plot3(mean_features(3,1),mean_features(3,2),60, 'o');
    plot3(mean_features(4,1),mean_features(4,2),70, 'o');
    plot3(mean_features(5,1),mean_features(5,2),80, 'o');
    text(mean_features(1,1),mean_features(1,2),40+0.5,'40cm mean')
    text(mean_features(2,1),mean_features(2,2),50+0.5,'50cm mean')
    text(mean_features(3,1),mean_features(3,2),60+0.5,'60cm mean')
    text(mean_features(4,1),mean_features(4,2),70+0.5,'70cm mean')
    text(mean_features(5,1),mean_features(5,2),80+0.5,'80cm mean')
    hold off
end
p2p_tot = features(:,1);
std_tot = features(:,2);

stepLength = b(1) + b(2)*(std_tot) + b(3)*(p2p_tot);
stepLength(stepLength>90) = 90;
stepLength(stepLength<30) = 30;
totalLength = sum(stepLength)/100;
end

