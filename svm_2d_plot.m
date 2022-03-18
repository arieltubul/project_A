function [] = svm_2d_plot(svmfit,dataVal,dataClass)
 global En_SVM2
 %Gather support vectors from ClassificationSVM struct
 sv =  svmfit.SupportVectors;
 %set step size for finer sampling
 d =0.05;
 %generate grid for predictions at finer sample rate
 [x, y] = meshgrid(min(dataVal(:,1)):d:max(dataVal(:,1)),...
                    min(dataVal(:,2)):d:max(dataVal(:,2)));
 xGrid = [x(:),y(:)];
 %get scores, f
 [ ~ , f] = predict(svmfit,xGrid);
 %reshape to same grid size as the input
 f = reshape(f(:,2), size(x));
 % Assume class labels are 1 and 0 and convert to logical
 t = logical(dataClass);
 %plot data points, color by class label
 if(En_SVM2 == 1)
 figure
 plot(dataVal(t, 1), dataVal(t, 2), 'r.');
 hold on
 plot(dataVal(~t, 1), dataVal(~t, 2), 'b.');
 hold on
 % load unscaled support vectors for plotting
 plot(sv(:, 1), sv(:, 2), 'go');
 xlabel('div_ay'); ylabel('amp_az');
 legend('forward','backward');
 %plot decision surface
 % [faces,verts,~] = isosurface(x, y, f, 0, x);
 % patch('Vertices', verts, 'Faces', faces, 'FaceColor','k','edgecolor',...
 % 'none', 'FaceAlpha', 0.2);
 grid on
 hold off
 end
 end