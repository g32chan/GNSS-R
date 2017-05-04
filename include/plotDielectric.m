function plotDielectric(brcs, R, e)
% brcs: Surface reflection coefficient
% R: Fresnel reflection coefficient
% e: Dielectric constant

figure
set(gcf, 'units', 'normalized', 'outerposition', [0 0 1 1])

subplot(3,1,1)
plot(brcs)
title('BRCS')
ylabel('\sigma^0 [dB]')

subplot(3,1,2)
plot(R)
title('Reflection Coefficient')
ylabel('\Re')

subplot(3,1,3)
plot(e)
title('Dielectric Constant')
ylabel('\epsilon')
xlabel('Time [sec]')

end

