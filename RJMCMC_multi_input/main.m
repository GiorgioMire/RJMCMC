% Reversible Jump MCMC
% for NARMAX identification
function main(y,u)
close all
clc

Settings=Settings_by_GUI();
clc
InitializeChain();

[Process_all,Noise_all,Process.avaiable,...
    Noise.avaiable,Process.choosen,Noise.choosen]...
    =Initialize_sets();

% Global variables
cutInterval=[];
workInterval=[];
eestim=zeros(length(y),1);

for it=1:Settings.Miter
    
    Shift_window();
    Perform_process_move();
    Perform_noise_move();
    [Residual]=Compute_residual();
    UpdateEq();
end



% Funzioni  innestate nel main

    function []=InitializeChain()
        Process.k=0;
        Noise.q=0;
        Process.Pk=[];
        Noise.Eq=[];
        Process.ak=[];
        Noise.bq=[];
        Process.lambdaA=Settings.lambdaP;
        Noise.lambdaB=Settings.lambdaN;
        Process.sigmaA=Settings.sigmaP;
        Noise.sigmaB=Settings.sigmaN;
        Process.sigmaEP=Settings.sigmaEP;
        Noise.sigmaEN=Settings.sigmaEN;
    end

    function []=Shift_window()
        Pk=Process.Pk;
        Eq=Noise.Eq;
        
        t_base=Settings.dynamicOrder+it;
        t_end=t_base+Settings.windowSize-1;
        cutInterval=t_base:t_end;
        workInterval=it:t_end;
        %_______________________________________
        % Shift della matrice Pk
        if ~isempty(Process.)
            Process.Pk(1,:)=[];
        end
        aggiunta=[];
        
        for i=1:length(Process.choosen)
            
            pos=Process.choosen(i);
            T=Process_all{pos};
            aggiunta(1,i)=T(t_end,u,y);
        end
        
        Process.Pk=[Process.Pk;aggiunta];
        %_______________________________________
        % Shift della matrice Eq
        if ~isempty(Noise.Eq)
            Noise.Eq(1,:)=[];
        end
        aggiunta=[];
        
        for i=1:length(Noise.choosen)
            pos=Noise.choosen(i);
            T=Noise_all{pos};
            aggiunta(1,i)=T(t_end,u,y,eestim);
        end
        Noise.Eq=[Noise.Eq;aggiunta];
    end

    function Chain_move_process()
        
        z=rand();
        % Calcolo le probabilità di nascita e di morte
        if Process.n==0
            B=1;
        elseif Process.n==length(Process_all)
            B=0;
        else
            num=(Process.lambda^(Process.n+1))/factorial(Process.n+1);
            den=(Process.lambda^(Process.n))/factorial(Process.n);
            B=Settings.cc*min(1,(num/den)^1);
        end
        
        if Process.n>0
            num=(Process.lambda^(Process.n-1))/factorial(Process.n-1);
            den=(Process.lambda^(Process.n))/factorial(Process.n);
            D=Settings.cc*min(1,(num/den)^1);
        end
        
        % Estraggo la  mossa e la effetttuo
        
        if z<B
            %display('Nascita Processo')
            Birth_process()
        elseif z<(B+D)
            % display('Morte Processo')
            Death_process()
        else
            %  display('Aggiornamrento Processo')
            for i=1:Settings.repeat
                % Aggiorno la varianza dei termini di processo
                Sigma_update_process()
                % Aggiorno i coefficienti del processo
                Theta_update_process();
            end
            
        end
        
        % Funzioni innestate a Chain Move Process
        function Birth_process()
            
            %__ Estraggo da quelli disponibili il termine che verrà proposto
            
            New_pos=randi(length(Process.avaiable));
            
            New_T=Process_all{Process.avaiable(New_pos)};
            
            % Estraggo un nuovo termine da quelli disponibili
            
            New_n=Process.n+1;
            
            % Calcolo il regressore che si avrebbe se accettassi il nuovo termine
            
            [New_M]=compute_M_New();
            
            function [New_M]=compute_M_New()
                aggiunta=[];
                T=Process_all{Process.avaiable(New_pos)};
                t=cutInterval;
                for i=1:length(t);
                    aggiunta(i,1)=T(t(i),u,y);
                end
                New_M=[Process.M,aggiunta];
            end
            % Calcolo il rapporto di accettazione della mossa
            
            
            [rr,New_theta]=Compute_RA();
            
            
            gamma=min(1,rr);
            
            z=rand();
            
            % Decido se accettare o meno la modda
            
            if z<gamma
                
                % Mossa accettata
                
                %display('accettata')
                
                %Aggiorno il vettore dei termini scelti
                
                Process.choosen=[Process.choosen,Process.avaiable(New_pos)];
                
                % Elimino il termine accettato dal vettore dei termini disponibili
                
                Process.avaiable(New_pos)=[];
                
                % Aggiorno il numero di termini del processo
                
                Process.n=New_n;
                
                % Aggiorno il vettore dei coeffcienti
                
                Process.theta=New_theta;
                
                % Aggiorno la matrice di regressione del processo
                
                Process.M=New_M;
            else
                
                % Mossa rifiutata, dunque effettuo l'aggiornamento dei coefficienti
                %  display('rifiutata')
                
                for i=1:Settings.repeat
                    % Aggiorno la varianza dei coefficienti
                    Sigma_update_process()
                    
                    % Aggiorno i coefficienti
                    Process_update_process();
                end
                
                
            end
            function Sigma_update_process()
                theta=1/(Settings.betaA+0.5*eaz(Process.theta.'*Process.theta,1));
                pd=makedist('Gamma','a',alphaA+0.5*Process.n,'b',1/theta);
                Process.sigma=sqrt(1/random(pd));
            end
            
        end
        
         function [rr,New_theta]=Compute_RA()
             n=Process.n;
             theta=Process.theta;
             SE=Process.sigmaE;
             ST=Process.sigma;
             MM=Process.M;
                Slack=(y(cutInterval)-ezp(Noise.M,Noise.theta,y(cutInterval)));
                if New_n==0
                    invC=Process.sigmaE^(-2)*Process.M.'*Process.M+Process.sigma^(-2)*eye(Process.n);
                    %C=inv(invC);
                    
                    mu=Process.sigmaE^(-2)*invC\(Process.M.'*Slack);
                    New_theta=0;
                    f1=Process.sigma^(-(New_n-Process.n));
                    f2=sqrt(abs(det(invC))); %note : det(A^-1)=1/det(A)
                    f3=((Process.lambda^New_n/factorial(New_n))/(Process.lambda^Process.n/factorial(Process.n)));
                    f4=exp(-0.5*mu.'*invC*mu);
                    rr=f1*f2*f3*f4;
                    
                    
                    
                elseif Process.n==0
                    
                    invCNew=Process.sigmaE^(-2)*(New_M.')*New_M+Process.sigma^(-2)*eye(New_n);
                    muNew=Process.sigmaE^(-2)*invCNew\(New_M.'*Slack);
                    New_theta=muNew;
                    
                    f1=Process.sigma^(-(New_n-Process.n));
                    f2=sqrt(abs(1/det(invCNew)));
                    f3=((Process.lambda^New_n/factorial(New_n))/(Process.lambda^Process.n/factorial(Process.n)));
                    f4=exp(0.5*muNew.'*invCNew*muNew);
                    rr=f1*f2*f3*f4;
                else
                    
                    invC=Process.sigmaE^(-2)*Process.M.'*Process.M+Process.sigma^(-2)*eye(Process.n);
                    invCNew=Process.sigmaE^(-2)*(New_M.')*New_M+Process.sigma^(-2)*eye(New_n);
                    mu=Process.sigmaE^(-2)*invC\(Process.M.'*Slack);
                    muNew=Process.sigmaE^(-2)*invCNew\(New_M.'*Slack);
                    New_theta=muNew;
                    f1=Process.sigma^(-(New_n-Process.n));
                    f2=sqrt(abs(det(invCNew)/det(invC)));
                    f3=((Process.lambda^New_n/factorial(New_n))/(Process.lambda^Process.n/factorial(Process.n)));
                    f4=exp(0.5*muNew.'*invCNew*muNew-0.5*mu.'*invC*mu);
                    rr=f1*f2*f3*f4;
                    
                    if isnan(New_theta)
                        error('e')
                    end
                    
                end
                
                
            end
        
        function Theta_update_process()
            thetaOld=Process.theta;
            SE=Process.sigmaE;
            SA=Process.sigma;
            
            invC=SE^(-2)*(Process.M.')*Process.M+SA^(-2)*eye(Process.n);%;
            C=inv(invC);
            for m=1:Process.n
                ahat(m)=normrnd(Process.theta(m),sqrt(C(m,m)));
                %      display('diff')
                %     ahat(m)-ak(m)
                %PosteriorNew
                thetaNew=Process.theta;
                thetaNew(m)=ahat(m);
                % PosteriorNew
                epsilon=y(cutInterval)-ezp(Process.M,thetaNew,y(cutInterval))-ezp(Process.M,Process.theta,y(cutInterval));
                epsilonOld=y(cutInterval)-ezp(Process.M,thetaOld,y(cutInterval))-ezp(Process.M,Noise.theta,y(cutInterval));
                posteriorNew=prod(-exp(epsilon.^2/2/(SE^2)+epsilonOld.^2/2/(SE^2)))...
                    *mvnpdf(thetaNew,zeros(Process.n,1),SA^2*eye(Process.n));
                %PosteriorOld
                
                posterior=mvnpdf(thetaOld,zeros(Process.n,1),SA^2*eye(Process.n));
                
                %La proposal secondo me non va compensata a causa della simmetria
                %della gaussiana attorno al valor medio
                
                rate=(posteriorNew/posterior);
                
                if (~isfinite(posterior) && ~isfinite(posteriorNew)) || isnan(rate)
                    warning('not finite posterior or nan rate')
                    rate=1;
                end
                alpha=min(1,rate);
                z=rand();
                if z<alpha
                    Process.theta(m)=ahat(m);
                else
                    
                end
                
                
            end
            
            
        end
        
        
    end

    function [Residual]=Compute_residual()
        Pk=Process.M;
        ak=Process.theta;
        ycut=y(cutInterval);
        Eq=Noise.M;
        bq=Noise.theta;
        Residual=ycut-ezp(Pk,ak,ycut)-ezp(Eq,bq,ycut);
        % figure(5)
        % plot(residual)
        % pause(0.01)
        eestim(cutInterval)=Residual;
        eestim(abs(eestim)>100)=100;
        
    end

    function Chain_move_noise()
        
        z=rand();
        % Calcolo le probabilità di nascita e di morte
        if Noise.n==0
            B=1;
        elseif Noise.n==length(Noise_all)
            B=0;
        else
            num=(Noise.lambda^(Noise.n+1))/factorial(Noise.n+1);
            den=(Noise.lambda^(Noise.n))/factorial(Noise.n);
            B=Settings.cc*min(1,(num/den)^1);
        end
        
        if Noise.n>0
            num=(Noise.lambda^(Noise.n-1))/factorial(Noise.n-1);
            den=(Noise.lambda^(Noise.n))/factorial(Noise.n);
            D=Settings.cc*min(1,(num/den)^1);
        end
        
        % Estraggo la  mossa e la effetttuo
        
        if z<B
            %display('Nascita Noiseo')
            Birth_noise()
        elseif z<(B+D)
            % display('Morte Noiseo')
            Death_noise()
        else
            %  display('Aggiornamrento Noiseo')
            for i=1:Settings.repeat
                % Aggiorno la varianza dei termini di processo
                Sigma_update_noise()
                % Aggiorno i coefficienti del processo
                Theta_update_noise();
            end
            
        end
        
        % Funzioni innestate a Chain Move Noise
        function Birth_noise()
            
            %__ Estraggo da quelli disponibili il termine che verrà proposto
            
            New_pos=randi(length(Noise.avaiable));
            
            % Estraggo un nuovo termine da quelli disponibili
            
            New_n=Noise.n+1;
            
            % Calcolo il regressore che si avrebbe se accettassi il nuovo termine
            
            [New_M]=compute_M_New_noise();
            
            function [New_M]=compute_M_New_noise()
                aggiunta=[];
                T=Noise_all{Noise.avaiable(New_pos)};
                t=cutInterval;
                for i=1:length(t);
                    aggiunta(i,1)=T(t(i),u,y,eestim);
                end
                New_M=[Noise.M,aggiunta];
            end
            % Calcolo il rapporto di accettazione della mossa
            
            
            [rr,New_theta]=Compute_RB();
           
            
            gamma=min(1,rr);
            
            z=rand();
            
            % Decido se accettare o meno la mossa
            
            if z<gamma
                
                % Mossa accettata
                
                %display('accettata')
                
                %Aggiorno il vettore dei termini scelti
                
                Noise.choosen=[Noise.choosen,Noise.avaiable(New_pos)];
                
                % Elimino il termine accettato dal vettore dei termini disponibili
                
                Noise.avaiable(New_pos)=[];
                
                % Aggiorno il numero di termini del processo
                
                Noise.n=New_n;
                
                % Aggiorno il vettore dei coeffcienti
                
                Noise.theta=New_theta;
                
                % Aggiorno la matrice di regressione del processo
                
                Noise.M=New_M;
            else
                
                % Mossa rifiutata, dunque effettuo l'aggiornamento dei coefficienti
                %  display('rifiutata')
                
                for i=1:Settings.repeat
                    % Aggiorno la varianza dei coefficienti
                    Sigma_update_noise()
                    
                    % Aggiorno i coefficienti
                    Theta_update_noise();
                end
                
                
            end
            
            
        end
        function Death_noise()
            New_pos=randi(length(Noise.choosen));
            New_T=Noise_all(  Noise.choosen(New_pos));
            New_n=Noise.n-1;
            New_M=Noise.Eq;
            New_M(:,New_pos)=[];
            [rr,New_theta]=Compute_RB();
            gamma=min(1,rr);
            
            z=rand();
            if z<gamma
                %     display('accettata')
                Noise.avaiable=[Noise.avaiable,Noise.choosen(New_pos)];
                Noise.choosen(New_pos)=[];
                Noise.n=Noise.n-1;
                
                Noise.theta=New_theta;
                Noise.M=New_M;
                if Noise.n==0
                    Noise.theta=0;
                end
                
                
            else
                %         display('rifiutata')
                for i=1:Settings.repeat
                    Sigma_update_noise();
                    Theta_update_noise();
                end
            end
            
        end
         function [rr,New_theta]=Compute_RB()
                Slack=(y(cutInterval)-ezp(Process.M,Process.theta,y(cutInterval)));
                if New_n==0
                    invC=Noise.sigmaE^(-2)*Noise.M.'*Noise.M+Noise.sigma^(-2)*eye(Noise.n);
                    %C=inv(invC);
                    
                    mu=Noise.sigmaE^(-2)*invC\(Noise.M.'*Slack);
                    New_theta=0;
                    f1=Noise.sigma^(-(New_n-Noise.n));
                    f2=sqrt(abs(det(invC))); %note : det(A^-1)=1/det(A)
                    f3=((Noise.lambda^New_n/factorial(New_n))/(Noise.lambda^Noise.n/factorial(Noise.n)));
                    f4=exp(-0.5*mu.'*invC*mu);
                    rr=f1*f2*f3*f4;
                    
                    
                    
                elseif Noise.n==0
                    
                    invCNew=Noise.sigmaE^(-2)*(New_M.')*New_M+Noise.sigma^(-2)*eye(New_n);
                    muNew=Noise.sigmaE^(-2)*invCNew\(New_M.'*Slack);
                    New_theta=muNew;
                    
                    f1=Noise.sigma^(-(New_n-Noise.n));
                    f2=sqrt(abs(1/det(invCNew)));
                    f3=((Noise.lambda^New_n/factorial(New_n))/(Noise.lambda^Noise.n/factorial(Noise.n)));
                    f4=exp(0.5*muNew.'*invCNew*muNew);
                    rr=f1*f2*f3*f4;
                else
                    
                    invC=Noise.sigmaE^(-2)*Noise.M.'*Noise.M+Noise.sigma^(-2)*eye(Noise.n);
                    invCNew=Noise.sigmaE^(-2)*(New_M.')*New_M+Noise.sigma^(-2)*eye(New_n);
                    mu=Noise.sigmaE^(-2)*invC\(Noise.M.'*Slack);
                    muNew=Noise.sigmaE^(-2)*invCNew\(New_M.'*Slack);
                    New_theta=muNew;
                    f1=Noise.sigma^(-(New_n-Noise.n));
                    f2=sqrt(abs(det(invCNew)/det(invC)));
                    f3=((Noise.lambda^New_n/factorial(New_n))/(Noise.lambda^Noise.n/factorial(Noise.n)));
                    f4=exp(0.5*muNew.'*invCNew*muNew-0.5*mu.'*invC*mu);
                    rr=f1*f2*f3*f4;
                    
                    if isnan(New_theta)
                        error('e')
                    end
                    
                end
                
                
            end
        function Sigma_update_noise()
            theta=1/(Settings.betaB+0.5*eaz(Noise.theta.'*Noise.theta,1));
            pd=makedist('Gamma','a',Settings.alphaB+0.5*Noise.n,'b',1/theta);
            Noise.sigma=sqrt(1/random(pd));
        end
        function Theta_update_noise()
            thetaOld=Noise.theta;
            SE=Noise.sigmaE;
            SA=Noise.sigma;
            
            invC=SE^(-2)*(Noise.M.')*Noise.M+SA^(-2)*eye(Noise.n);%;
            C=inv(invC);
            for m=1:Noise.n
                bhat(m)=normrnd(Noise.theta(m),sqrt(C(m,m)));
                %      display('diff')
                %     ahat(m)-ak(m)
                %PosteriorNew
                thetaNew=Noise.theta;
                thetaNew(m)=bhat(m);
                % PosteriorNew
                epsilon=y(cutInterval)-ezp(Noise.M,thetaNew,y(cutInterval))-ezp(Process.M,Process.theta,y(cutInterval));
                epsilonOld=y(cutInterval)-ezp(Noise.M,thetaOld,y(cutInterval))-ezp(Process.M,Process.theta,y(cutInterval));
                posteriorNew=prod(-exp(epsilon.^2/2/(SE^2)+epsilonOld.^2/2/(SE^2)))...
                    *mvnpdf(thetaNew,zeros(Noise.n,1),SA^2*eye(Noise.n));
                
                %PosteriorOld
                posterior=mvnpdf(thetaOld,zeros(Noise.n,1),SA^2*eye(Noise.n));
                
                %La proposal secondo me non va compensata a causa della simmetria
                %della gaussiana attorno al valor medio
                
                rate=(posteriorNew/posterior);
                
                if (~isfinite(posterior) && ~isfinite(posteriorNew)) || isnan(rate)
                    warning('not finite posterior or nan rate')
                    rate=1;
                end
                alpha=min(1,rate);
                z=rand();
                if z<alpha
                    Noise.theta(m)=bhat(m);
                else
                    
                end
                
                
            end
            
            
        end
        
    end

    function UpdateEq()
        
        E=[];
        t=cutInterval;
        if Noise.n~=0
            for j=1:length(Noise.choosen)
                for i=1:Settings.windowSize
                    T=Noise_all{Noise.choosen(j)};
                    E(i,j)=T(t(i),u,y,eestim);
                end
            end
        end
        Noise.M=E;
        
        
    end




end

