function [output] = DPSD2_modelpred_ROC_curve(pars, data)

% Weizhen Xie, 20170518

Ro = pars(1);    % Ro
d = pars(2);    % d
crit = linspace(-100, 100, 1000);


Nvec = data.N;
nhi = data.nhi;
nmi = data.nmi;
nfa = data.nfa;
ncr = data.ncr;

Phi = NaN(1,length(crit));
Pfa = NaN(1,length(crit));


for ict=1:length(crit)
    phi(1,ict) = Ro + ((1-Ro) * normcdf(crit(ict),-d,1));
    pfa(1,ict) =  normcdf(crit(ict),0,1);
end


output.phi= phi;
output.pfa= pfa;

% LL =  sum(nhi .* log(phi)) + sum(nmi .* log(1-phi))  ...
%     + sum(nfa .* log(pfa)) + sum(ncr .* log(1-pfa)) ;
% NLL = -LL; % negative log likelihood of the parameters