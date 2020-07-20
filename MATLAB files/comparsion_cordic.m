clear all;clc;close all;clc;
data=load('cordic_output.txt');
cos_values=data(:,1)';
sin_values=data(:,2)';

theta=linspace(0,2*pi,360);
actual_cos=cos(theta);
actual_sin=sin(theta);
error_cos=(actual_cos-cos_values);
error_sin=(actual_sin-sin_values);
subplot(211)
plot(theta,error_cos,'-');
title('error in cos');
subplot(212)
plot(theta,error_sin,'-');
title('error in sin');

power_actual_cos=(norm(actual_cos)^2)/length(actual_cos);
power_actual_sin=(norm(actual_sin)^2)/length(actual_sin);
power_noise_cos=(norm(error_cos)^2)/length(error_cos);
power_noise_sin=(norm(error_sin)^2)/length(error_sin);

snr_cos=power_actual_cos/power_noise_cos;
snr_sin=power_actual_sin/power_noise_sin;
disp(sprintf("snr of cos=%f or \n %f db",snr_cos,10*log10(snr_cos)));
disp(sprintf("snr of sin=%f or \n %f db",snr_sin,10*log10(snr_sin)));


