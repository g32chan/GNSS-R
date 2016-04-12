clear; close all; clc

N = 5000;       % number of points
L = 2000;       % rough surface length
h = 0.08;        % rms height
lc = 3.3;       % correlation length

lambda = 299792458/1.57542e9;  % wavelength
lam_eff = lambda/2;
k = 2*pi/lambda;

% checks
mss = 2*(h/lc)^2;
lim = 2*pi*h/lam_eff;
if lc/lam_eff < 10 || lc/h < 10
    warning('large surface curvature')
end

%% Tsang
nr = 1;         % number of surface realizations
g = 200;        % tapering parameter for incident wave
tid = 10;       % incident angle [deg]
nsa = 179;      % number of scattered angles

% [f,df,x] = rsgeng(N,L,h,lc);
% figure; plot(x,f)
[tsd,sig,sigka,sigspm] = rs1dg(lambda,nr,N,L,h,lc,g,tid,nsa);
figure; plot(tsd,10*log(sig))
figure; plot(tsd,10*log(sigka))
figure; plot(tsd,10*log(sigspm))

%% Bergstrom
bins = 20;
dim = 1;

% checks
if dim == 1
    r = 500;
end
if dim == 2
    r = 70;
end

if N/L < 2/lc
    warning('sampling frequency is too low')
end
if L/lc < r
    warning('ratio too low for gaussian stats')
end

if dim == 1
    [f,x] = rsgeng1D(N,L,h,lc);
    figure; plot(x,f)
    [acf,lc_hat,lags] = acf1D(f,x,'plot');
    [hdf,bc,h_hat] = hdf1D(f,bins,'hist');
end

if dim == 2
    [f,x,y] = rsgeng2D(N,L,h,lc);
    figure; surf(x,y,f,'EdgeColor','none')
    colormap jet
    colorbar
    [acfx,lcx,acfy,lcy,lags] = acf2D(f,x,y,'plot');
    [hdf,bc,h_hat] = hdf2D(f,bins,'hist');
end

%% Belmonte
e = 4;
L1 = 5.5;
L2 = 0.5;   %0.5-5m
mss = 2*(h/L1)^2;

theta = -90:1:90;
[Rvv,Rhh]=fresnelCoeff(e,deg2rad(theta));
[~,Rcs]=cocross(Rvv,Rhh);
