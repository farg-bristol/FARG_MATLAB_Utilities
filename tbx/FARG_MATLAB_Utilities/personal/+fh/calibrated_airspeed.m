function [cas] = calibrated_airspeed(Mach,P,P_s,a_s,gamma)
%CAS get the calibrated airspeed for a given Mach and pressure
%   INPUTS:
%   - Mach:  Mach number to calculate calibrated airspeed at
%   - P: ambient pressure to calculate airspeed at
%   - P_s: reference pressure (sea level)
%   - gamma: specfic heat ratio
p_ratio = (1+0.5.*(gamma-1).*Mach.^2).^(gamma/(gamma-1));
cas = a_s.*sqrt(2./(gamma-1).*((((p_ratio-1).*P)./P_s+1).^((gamma-1)./gamma)-1));
end

