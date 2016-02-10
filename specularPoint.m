function [S, theta] = specularPoint(R, T)
% T: Transmitter position in WGS84
% R: Receiver position in WGS84
% S: Specular point in WGS84
% theta: Incident angle [deg]

% Use receiver projection on surface of earth as initial guess
r = earthProj(R);
Stemp = r*(R/norm(R));
S = Stemp;

% Iterate S
error = 10000;
iter = 1;
K = 10000;      % Gain
tol = 0.001;	% Tolerance [m]
while (error > tol)
    % Calculate S
    RS_unit = (R-S)./norm(R-S);
    TS_unit = (T-S)./norm(T-S);
    dXYZ = RS_unit + TS_unit;
    Stemp = S + K*dXYZ;
    r = earthProj(Stemp);
    Stemp = r*(Stemp/norm(Stemp));
    
    % Calculate error
    error = abs(norm(S-Stemp));
    if (error > 10)
        K = 10000;
    else
        K = 1000;
    end
    
    % Update S
    S = Stemp;
    
    % Update iteration count
    iter = iter + 1;
    if (iter > 10000)
        warning('Iterations exceeded limit');
        break;
    end
end

% Calculate incident angle and test Snell's law
try
    theta = snell(R,T,S);
catch
    warning('Specular point does not satisfy Snell''s law');
    theta = -90;
end

end

