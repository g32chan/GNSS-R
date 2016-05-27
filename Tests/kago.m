clear; close all; clc

N = 5000;       % number of points
L = 2000;       % rough surface length
h = 0.25;       % rms height
lc = 5.5;       % correlation length

lambda = 299792458/1.57542e9;  % wavelength
lam_eff = lambda/2;
k = 2*pi/lambda;

% checks
mss = 2*(h/lc)^2;
lim = 2*pi*h/lam_eff;
if lc/lam_eff < 10 || lc/h < 10
    warning('large surface curvature')
elseif k*h < 2
    warning('not within KAGO limit')
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

%% Isotropic
beta = -90:1:90;
beta0 = atan(sqrt(mss));
% beta0 = deg2rad(40);
cot = 1/tan(beta0)^2;
sigma = cot*exp(-(tand(beta)/tan(beta0)).^2);

plotKAGO(beta, sigma)

%% Belmonte
e = 4;
L1 = 5.5;
L2 = 5.5;   %0.5-5m
for h = [0.08 0.25]
    for inc = 0%[0 45 60]
        mss = 2*h^2/L1/L2;
        
        theta = -90:1:90;
        beta = abs(theta-inc)/2;    % angle to surface normal
        beta0 = abs(theta+inc)/2;   % angle to scattering vector
        
        [Rvv,Rhh] = fresnelCoeff(e,deg2rad(beta0));
        [~,Rcs] = cocross(Rvv,Rhh);
        
        dir = qdir(inc,theta);
        q = k*dir;
%         q = 2*pi/lam_eff*dir;
        qh = q(1,:);
        qz = q(2,:);
        qmag = sqrt(qh.^2+qz.^2);
        
        sigma = (Rcs.^2).*((qmag./qz).^4)/2/mss.*exp(-((-qh./qz).^2)/2/mss);
        
        plotKAGO(theta, sigma)
    end
end

%% Z-V
T = [-11178791.991294 -13160191.204988 20341528.127540];
R = [-4069896.7033860330 -3583236.9637350840 4527639.2717581640];
[S, theta] = specularPoint(R, T);
q = qvec(R, T, S);

e = 4;
[Rvv,Rhh] = fresnelCoeff(e,deg2rad(theta));
[~,Rcs] = cocross(Rvv,Rhh);

sigma = (Rcs^2)*((norm(q)/q(3))^4)/2/mss*exp(-((-q(1)/q(3))^2+(-q(2)/q(3))^2)/2/mss);
