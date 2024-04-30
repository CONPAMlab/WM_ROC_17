function [NLL output] = VP_modelpred_ROC(pars, data)

% Weiji Ma, 20140601
% Weizhen Xie, 20170518

J1bar = pars(1);    % Mean precision at set size 1; typically in range 10-100
alpha = 1;%pars(2);    % Power in dependence of mean precision on set size
tau = pars(3);      % Scale parameter of precision distribution
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

Tvec = [0 1];
Ntrials = 8000; % Number of simulated trials used to construct the model predictions; unrelated to number of experimental trials

% Computing the predictions of the model for the probability of reporting a
% change in each of the (N,T) conditions
Phi = NaN(length(Nvec),length(crit));
Pfa = NaN(length(Nvec),length(crit));

for Nind = 1:length(Nvec)
    
    N = Nvec(Nind);
    Jbar = J1bar * N^-alpha;
    
    for Tind = 1:length(Tvec)
        T = Tvec(Tind);
        
        for ict=1:length(crit)
       
            J        = gamrnd(Jbar/tau, tau, Ntrials,1); % Since you are using a single-probe change detection task, everything becomes simpler. You don't need to simulate N items in lines 29-30, only one.
            x        = T + randn(Ntrials,1)./sqrt(J); % adding 1 for every target
            decision = mean(x > crit(ict));
            
            if T==0
                pfa(Nind,ict) = min(1-1/Ntrials, max(1/Ntrials,mean(decision==1)));
            elseif T==1
                phi(Nind,ict) = min(1-1/Ntrials, max(1/Ntrials,mean(decision==1)));
            end
        end
        
    end
    
end

output.phi= phi;
output.pfa= pfa;

LL =  sum(nhi .* log(phi)) + sum(nmi .* log(1-phi))  ...
    + sum(nfa .* log(pfa)) + sum(ncr .* log(1-pfa)) ;
NLL = -LL; % negative log likelihood of the parameters