function plotKAGO(theta, sigma)
% theta: scattering angles
% sigma: scattering coefficients

nfloor = -20*ones(1,length(sigma));
figure; hold on
plot(theta,pow2db(sigma))
plot(theta,nfloor)
ylim([-100,100])
xlim([-100,100])
ax = gca;
ax.XTick = -100:50:100;
ax.YTick = -100:50:100;
ax.XMinorTick = 'on';
ax.YMinorTick = 'on';
ax.XAxis.MinorTickValues = -100:10:100;
ax.YAxis.MinorTickValues = -100:10:100;
grid on
grid minor
xlabel('Scattering Angle, \beta [deg]')
ylabel('Radar Cross Section, \sigma^0 [dB]')


end

