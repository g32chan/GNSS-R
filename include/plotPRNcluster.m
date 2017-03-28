function plotPRNcluster(S, R, target)
% S: specular data
% R: receiver location
% target: target location

prns = unique(S.data(:, S.header.prn));
Sxyz = S.data(:, S.header.X:S.header.Z);
S_lla = ecef2lla(Sxyz);
Rxyz = R.data(:, R.header.X:R.header.Z);
R_lla = ecef2lla(Rxyz);

figure(3); hold on
% xlim([-80.55, -80.53])
% ylim([43.472, 43.482])
xlim([min(S_lla(:, 2)) max(S_lla(:, 2))])
ylim([min(S_lla(:, 1)) max(S_lla(:, 1))])
xlabel('Longitude [deg]')
ylabel('Latitude [deg]')
set(gcf, 'units', 'normalized', 'outerposition', [0 0 1 1])
set(gca, 'ColorOrder', colormap(jet(length(prns))))

for i = 1:length(prns)
    prn = prns(i);
    idx = S.data(:, S.header.prn) == prn;
    scatter(S_lla(idx, 2), S_lla(idx, 1), 'filled', 'DisplayName', ['PRN' num2str(prn)])
end
plot(target(2), target(1), 'kx', 'DisplayName', 'Target')
plot(mean(R_lla(:, 2), 'omitnan'), mean(R_lla(:, 1), 'omitnan'), 'k*', 'DisplayName', 'Average')

legend('show')
legend('location', 'best')
set(gca, 'FontSize', 24)

end

