function [tas] = true_airspeed(M,a,T,T_s)
%CAS get the true airspeed for a given Mach and pressure
%   INPUTS:
%   - Mach:  Mach number to calculate calibrated airspeed at
%   - T: ambient tempeture to calculate airspeed at
%   - T_s: reference temperature (sea level)
%   - gamma: specfic heat ratio
tas = a.*M.*sqrt(T./T_s);
end

