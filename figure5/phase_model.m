% phase_model.m
%
% written by Sungho Hong, Computational Neuroscience Unit, Okinawa Institute of Science and Technology
% July 5, 2020
%
% amp0: overall PRC amplitude
% amp1: relative PRC peak from 0 to 1
% amp2: synaptic conductance
% sigma0: noise amplitude
function [spike_data, theta_sample] = phase_model(rate, amp0, amp1, amp2, sigma0, T0)

N = 100;
p_connect = 0.75;

theta0 = rand(N, 1);

M = rand(N, N);
M = double(M<=p_connect)/(N*p_connect);
M = M - diag(diag(M));

dt = 0.025;

T = 1000/rate;
tau_del = 1.5;
n_del = tau_del/dt-1;

fDelta = @(q) amp0*(0.08 + amp1*scaled_rectfied_sin(q, T, T0));

L = 10000;
Ln = L/dt;
spikes = zeros(N, Ln);

Ns = 10;
theta_sample = zeros(Ns, Ln);

tau_ou = 3;
tau_syn = 3;

theta = theta0;

izeta = 0;
isyn = 0;

omega = 1/T;
omegadt = omega*dt;

for i=1:Ln
    theta_sample(:, i) = theta(1:Ns);
    izeta = (izeta + sigma0*randn(N, 1)*dt)/(1+dt/tau_ou);
    if i>n_del
        isyn = (isyn - amp2*M*spikes(:, i-n_del)*dt)/(1+dt/tau_syn);
    else
        isyn = 0;
    end
    theta = theta + omegadt + dt*fDelta(theta).*(isyn + izeta);

    ii = (theta>=1);
    spikes(ii, i) = 1;
    theta(ii) = theta(ii) - 1;
end

spike_data = [];
for i=1:N
    z = find(spikes(i,:)>0);
    if ~isempty(z)
        for j=1:numel(z)
            spike_data = [spike_data; [z(j)*dt i]];
        end
    end
end

end


function r = scaled_rectfied_sin(theta, T, tpos)

t = (1-theta)*T;
ii = (t<tpos);
r = zeros(size(t));
r(ii) = sin(t(ii)/tpos.*pi);

end