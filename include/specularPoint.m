function [S, theta] = specularPoint(R, T)
% Modified from RT2S_Example1.m by Scott Gleason (2006)
% T: Transmitter position in WGS84
% R: Receiver position in WGS84
% S: Specular point in WGS84
% theta: Incident angle [deg]

% Elevation
e = 337;

% Use receiver projection on surface of earth as initial guess
r = earthProj(R);
Stemp = (r+e).*(R./norm(R));
S = Stemp;

% Iterate S
error = 10000;
iter = 1;
maxIter = 10000;
K = 5000;       % Gain
tol = 0.001;	% Tolerance [m]
errvec = zeros(1, maxIter);
while (error > tol)
    % Calculate S
    RS_unit = (R-S)./norm(R-S);
    TS_unit = (T-S)./norm(T-S);
    dXYZ = RS_unit + TS_unit;
    Stemp = S + K.*dXYZ;
    r = earthProj(Stemp);
    Stemp = (r+e).*(Stemp./norm(Stemp));
    
    % Calculate error
%     error = abs(norm(S-Stemp));
    error = norm(S-Stemp);
    if (error > 2000)
        K = 1000;
%         K = error / 2;
    else
%         K = 100;
        K = 80;
%         K = error;
    end
%     K = error / 2;
%     K = max([error/2, 50]);
    errvec(iter) = error;
    
    % Update S
    S = Stemp;
    
    % Update iteration count
    iter = iter + 1;
    if (iter > maxIter)
        warning('Iterations exceeded limit');
        figure(100)
        plot(errvec)
        break;
    end
end

% Calculate incident angle and test Snell's law
theta = snell(R, T, S);

end

