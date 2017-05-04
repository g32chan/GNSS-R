function S = specularPoint(R, T, e)
% Modified from RT2S_Example1.m by Scott Gleason (2006)
% R: Receiver position in WGS84
% T: Transmitter position in WGS84
% e: Elevation above sea level [m]
% S: Specular point in WGS84

% Use projection on surface of earth as initial guess
% r = earthProj(R);
r = earthProj(T);
Stemp = (r+e).*(R./norm(R));
S = Stemp;

% Iterate S
iter = 1;
% maxIter = 10000;
% error = 10000;
% K = 10;
% tol = 0.001;
maxIter = 20000;
error = 5000;
K = 10;       % Gain
tol = 0.005;	% Tolerance [m]
errvec = zeros(maxIter, 1);
dvec = zeros(maxIter, 3);
Svec = zeros(maxIter, 3);
while (error > tol)
    % Calculate S
    RS_unit = (R-S)./norm(R-S);
    TS_unit = (T-S)./norm(T-S);
    dXYZ = RS_unit + TS_unit;
    Stemp = S + K.*dXYZ;
    r = earthProj(Stemp);
    Stemp = (r+e).*(Stemp./norm(Stemp));
    
    % Calculate error
    error = norm(S-Stemp);
%     if (error > 10)
%         K = 10000;
%     else
%         K = 1000;
%     end
    if (error > 5)
        K = 10;
    else
        K = 1;
    end
%     if (error > 2000)
%         K = error / 2;
%     else
%         K = max([error, 0.01]);
%     end
    errvec(iter) = error;
    dvec(iter,:) = dXYZ;
    Svec(iter,:) = Stemp;
    
    % Update S
    S = Stemp;
    
    % Update iteration count
    iter = iter + 1;
    if (iter > maxIter)
        warning('Iterations exceeded limit');
        figure(100)
        plot(errvec)
        break
    end
end

end

