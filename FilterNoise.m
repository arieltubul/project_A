function [axFilterd, ayFilterd, azFilterd] = FilterNoise(acc, t_acc)
%% FFT for accelerations
global cutoff En_Filt
L = length(t_acc);
f = 50;
freq = linspace(-f/2,f/2, L)';
%get an array with ones for frequencies which are lower than cutoff frequency
lpf = abs(freq) < cutoff;
a_x = acc(:,1);
a_y = acc(:,2);
a_z = acc(:,3);
axFFT_lpf = fftshift(fft(a_x)) .* lpf;
ayFFT_lpf = fftshift(fft(a_y)) .* lpf;
azFFT_lpf = fftshift(fft(a_z)) .* lpf;

axFilterd = real(ifft(ifftshift(axFFT_lpf)));
axFilterd = axFilterd(:,1);
ayFilterd = real(ifft(ifftshift(ayFFT_lpf)));
ayFilterd = ayFilterd(:,1);
azFilterd = real(ifft(ifftshift(azFFT_lpf)));
azFilterd = azFilterd(:,1);

if(En_Filt == 1)
    figure('Renderer', 'painters', 'Position', [20 170 900 600])
    hold on
    subplot(3, 1, 1) % Z axis
    plot(freq, real(azFFT_lpf), 'b', freq, lpf, 'k');
    xlim([-f/2 f/2]);
    legend('az fft', 'LPF');
    title('Real part of FFT of filtered accelerations', 'FontSize', 15);
    ylabel('az fft', 'FontSize', 12);
    
    subplot(3, 1, 2) % Y axis
    plot(freq, real(ayFFT_lpf), 'r', freq, lpf, 'k');
    xlim([-f/2 f/2]);
    legend('ay fft', 'LPF');
    ylabel('ay fft', 'FontSize', 12);
     
    subplot(3, 1, 3) % X axis
    plot(freq, real(axFFT_lpf), 'g', freq, lpf, 'k');
    xlim([-f/2 f/2]);
    legend('ax fft', 'LPF');
    xlabel('Frequency [Hz]', 'FontSize', 15);
    ylabel('ax fft', 'FontSize', 12);
    hold off
end
end

