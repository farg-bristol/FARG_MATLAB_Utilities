function [cost,delta] = signal_damping(x,env_win,mean_win,Fs)
%SIGNAL_DAMPING Summary of this function goes here
%   Detailed explanation goes here
env = movmean(envelope(x,env_win,'rms'),mean_win);
[env_max,i] = max(env);
env = env(i:end)./env_max;
t = ((1:length(env))-1)*1/Fs;
% get idx where it is first below exp(-1) to get first estimate
t_1 = t(find(env<exp(-1),1));
figure(1);
clf;
subplot(2,1,1)
hold on
plot(t,env)
plot(t,exp(-t./t_1))
subplot(2,1,2)
plot(t,-t./log(env))
end

