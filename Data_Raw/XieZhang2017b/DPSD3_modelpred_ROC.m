function [NLL output] = DPSD2_modelpred_ROC(pars, data)

% Weizhen Xie, 20170518

Ro = pars(1);    % Ro
d = pars(2);    % d
Rn = pars(3);    % d
crit(1) = pars(4);
crit(2) = pars(5);
crit(3) = pars(6);
crit(4) = pars(7);
crit(5) = pars(8);

Nvec = data.N;
nhi = data.nhi;
nmi = data.nmi;
nfa = data.nfa;
ncr = data.ncr;

Phi = NaN(1,length(crit));
Pfa = NaN(1,length(crit));


for ict=1:length(crit)
    phi(1,ict) = Ro + ((1-Ro) * normcdf(crit(ict),-d,1));
    pfa(1,ict) =  (1-Rn)*normcdf(crit(ict),0,1);
end


output.phi= phi;
output.pfa= pfa;

LL =  sum(nhi .* log(phi)) + sum(nmi .* log(1-phi))  ...
    + sum(nfa .* log(pfa)) + sum(ncr .* log(1-pfa)) ;
NLL = -LL; % negative log likelihood of the parameters