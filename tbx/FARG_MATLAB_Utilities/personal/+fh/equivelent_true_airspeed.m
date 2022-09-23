function TAS = equivelent_true_airspeed(p,rho,p_0,rho_0,gamma,CAS)
%EQUIVELENT_TRUE_AIRSPEED Summary of this function goes here
%   Detailed explanation goes here
mu = (gamma-1)./gamma;
TAS = (1 + p_0./p.*((1+(mu./2.*rho_0./p_0.*CAS.^2)).^(1./mu) - 1)).^mu - 1;
TAS = sqrt(2./mu.*p./rho.*TAS);
end

