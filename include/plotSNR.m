function plotSNR(dir, ref, prn)
% dir: Direct data
% ref: Reflected data
% prn: Satellite PRN

dirTime = dir.data(dir.data(:, dir.header.Satellite) == prn, dir.header.GPSTime);
dirSNR = dir.data(dir.data(:, dir.header.Satellite) == prn, dir.header.CNR);
refTime = ref.data(ref.data(:, ref.header.Satellite) == prn, ref.header.GPSTime);
refSNR = ref.data(ref.data(:, ref.header.Satellite) == prn, ref.header.CNR);

figure
set(gcf, 'units', 'normalized', 'outerposition', [0 0 1 1])
hold on
plot(dirTime, dirSNR)
plot(refTime, refSNR)
xlabel('Time of Week [sec]')
ylabel('CNR [dB-Hz]')
legend('Direct', 'Reflected')


end

