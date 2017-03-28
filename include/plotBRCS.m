function plotBRCS(S, R, target)
% S: specular data
% R: receiver location
% target: target location

brcs = pow2db(S.data(:,S.header.brcs));
Sxyz = S.data(:,S.header.X:S.header.Z);
S_lla = ecef2lla(Sxyz);
Rxyz = R.data(:, R.header.X:R.header.Z);
R_lla = ecef2lla(Rxyz);

% P = [S_lla(:,2), S_lla(:,1), brcs];
% P(brcs < 10, :) = [];

figure(2); hold on
set(gcf, 'units', 'normalized', 'outerposition', [0 0 1 1])
% xlim([-80.55,-80.53])
% ylim([43.472,43.482])
xlim([min(S_lla(:, 2)) max(S_lla(:, 2))])
ylim([min(S_lla(:, 1)) max(S_lla(:, 1))])
colormap('jet')
colorbar('eastoutside')
plot(target(2),target(1),'kx')
plot(mean(R_lla(:,2)),mean(R_lla(:,1)),'k*')
scatter(S_lla(:,2),S_lla(:,1),[],brcs,'filled')
% scatter(P(:,1),P(:,2),[],P(:,3),'filled')
xlabel('Longitude [deg]')
ylabel('Latitude [deg]')
legend('Target', 'Average', 'location', 'best')
set(gca, 'FontSize', 24)

end

