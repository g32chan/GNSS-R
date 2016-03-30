clear; close all; clc

a = 6378137;
f = 1/298.257223563;
b = a*(1-f);

theta=deg2rad(0:1:360);
f=sqrt(a^2-b^2);
x=a.*cos(theta);
y=b.*sin(theta);

figure(1)
hold on
grid on
axis equal
plot(x,y,'b-')
plot(f,0,'k*')
plot(-f,0,'k*')
dy=-(x/a^2)./(y/b^2);

idx=45;
x0=x(idx);
y0=y(idx);
plot([f,x0],[0,y0],'r-')
plot([-f,x0],[0,y0],'r-')
plot([0,x0],[0,y0],'g-')
tangent=dy(idx);
yint=y0-tangent*x0;
refline(tangent,yint)
normal=-1/tangent;
yint=y0-normal*x0;
refline(normal,yint)
xint=-yint/normal;
ylim([-a,a])
title('Meridian cross section')

normal=-1./dy;
yint=y-normal.*x;
xint=-yint./normal;
figure(2)
plot(abs(xint))
title('Horizontal distance from centre [m]')

angle=rad2deg(atan(normal));
angle2=rad2deg(atan(y./x));
dangle=abs(angle-angle2);
figure(3)
plot(dangle)
title('Angle difference between normal and centre [deg]')

