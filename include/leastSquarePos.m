function [pos, dop] = leastSquarePos(satpos, obs, flag)
% Modified from leastSquarePos.m by Kai Borre (2006)
% Modified from Rcv_Pos_Compute.m by You Chong (2013)
% satpos: satellite positions in ECEF
% obs: pseudorange for each satellite
% pos: receiver position in ECEF
% dop: dilution of precision for receiver position
% flag: implementation selection

%% Calculate position and clock
if flag
    % Kai Borre Implementation
    c = 299792458;              % Speed of light [m/s]
    omega = 7.2921151467e-5;	% Earth rotation rate [rad/s]
    
    iter = 7;
    
    pos = zeros(4, 1);
    sats = size(satpos, 2);
    
    A = zeros(sats, 4);
    omc = zeros(sats, 1);
    
    for i = 1:iter
        for j = 1:sats
            % Correct for earth's rotation and troposphere
            if i == 1
                Rot_X = satpos(:,j);
                trop = 2;
            else
                theta = omega * dist3(satpos(:,j), pos) / c;
%                 R3 = [ cos(theta) sin(theta) 0;
%                       -sin(theta) cos(theta) 0;
%                        0          0          1];
                R3 = rotz(-rad2deg(theta));
                Rot_X = R3 * satpos(:,j);
                trop = tropo(Rot_X, pos(1:3));
%                 Rot_X = satpos(:,j);
%                 trop = 0;
            end
            
            omc(j) = obs(j) - norm(Rot_X - pos(1:3), 'fro') - pos(4) - trop;
            
            A(j,:) = [(-(Rot_X(1) - pos(1))) / obs(j) ...
                      (-(Rot_X(2) - pos(2))) / obs(j) ...
                      (-(Rot_X(3) - pos(3))) / obs(j) ...
                       1];
        end
        
        if rank(A) ~= 4
            error('Cannot find solution');
        end
        
        x = A\omc;
        
        pos = pos + x;
    end
    
    pos = pos';
    
    Q = inv(A'*A);
else
    % You Chong Implementation
    pos = zeros(1,3);
    clk = 0;
    iter = 10;
    
    for i = 1:iter
        G = G_Compute(satpos',pos);
        dRho = Delta_Rho_Compute(obs,satpos',pos,clk);
        Q = inv(G'*G);
        dX = Q*G'*dRho;
        pos = (pos' + dX(1:3))';
        clk = clk + dX(4);
    end
    
    pos = [pos clk];
end

%% Calculate DOP
dop = zeros(1,5);
dop(1) = sqrt(trace(Q));                % GDOP    
dop(2) = sqrt(Q(1,1)+Q(2,2)+Q(3,3));	% PDOP
dop(3) = sqrt(Q(1,1)+Q(2,2));           % HDOP
dop(4) = sqrt(Q(3,3));                  % VDOP
dop(5) = sqrt(Q(4,4));                  % TDOP

end

