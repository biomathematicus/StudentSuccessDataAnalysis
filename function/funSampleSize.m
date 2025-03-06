
function n = funSampleSize(i, alpha, par1, par2, par3)
    % Calculate size Sample 
    % Example: n = funSampleSize(2, alpha, par1, par2, par3)
    
    z_beta = 0.84; % Power = 0.95 = 1- beta, i.e. 95% sure of detecting the difference
    % One-sided test uses z_alpha, two-sided test uses z_(alpha/2)
    if alpha == 1
        z_alpha = 1.6449; % Level of significance of 5%, for one-sided test
        z_alpha = 1.9599; % Level of significance of 5%, for two-sided test
    else
        
    end    
    
    switch i
        case 1
            % CASE: Testing a mean value (same population)
            % Source: M. Woodward, "Epidemiology Study Design and
            % Analysis", Chapman & Hall, 1999, p. 338
            % This case arises often in cross-sectional epidemiological
            % sample surveys. This case is about determining the 
            % size of a sample when the subsequent data will be used to
            % test a hypothesis about the mean of the parent population. 
            % H_0: mu = mu_0 
            % H_1: mu = mu_1
            mu_0 = par1;
            mu_1 = par2;
            sigma = par3; 
            n = ([(z_alpha + z_beta)^2]*[sigma^2]) / (mu_1 - mu_0)^2;
        case 2
            % CASE: Testing a difference between means (different population)
            % Source: M. Woodward, "Epidemiology Study Design and 
            % Analysis", Chapman & Hall, 1999, p. 343  
            % This case is used in comparative studies to compare the
            % equality of two means. 
            % This case is likely to arise in cross-sectional or
            % intervention study. It also arises in a cohort study with a
            % fixed cohort (even though in this case the usual end-point 
            % of interst is a disease incidence). 
            % H_0: mu_1 = mu_2 
            % H_1: mu_1 - mu_2 = delta
            % r = n_1/n_2, n = n_1 + n_2
            r = par1;
            sigma = par2;
            
            n = (r+1)^2 * (z_alpha + z_beta)^2*sigma^2 / (delta^2*r);
        case 3
            % CASE: Testing a proportion
            % Source: M. Woodward, "Epidemiology Study Design and 
            % Analysis", Chapman & Hall, 1999, p. 348  
            % This case arises when we look at proportions
            % H_0: pi = pi_0 
            % H_1: pi = pi_1 = pi_0 + d
            % pi = true proportion
            % pi_0  = some specified value for this proportion which we 
            % whish to test for
            % pi_1 = alternative value wich we would like to identify
            % correctly with a probability (power) of 1-beta.
            % d = difference between proportions
            pi_1 = par1;
            pi_2 = par2;
            d = par3;            
            n = 1/d^2*(z_alpha*sqrt(pi_0*(1-pi_0))+z_beta*sqrt(pi_1*(1-pi_1)))^2;
        case 4
            % CASE: Testing a relative risk
            % Source: M. Woodward, "Epidemiology Study Design and
            % Analysis", Chapman & Hall, 1999, p. 350 
            % H_0: pi_1 = pi_2 
            % H_1: pi_1 - pi_2  = delta
            % or, alternatively
            % H_1: pi_1 / pi_2  = lambda
            % pi = pi_2, is the proportion for the reference group
            % pi_1 = proportion of populaiton 1.
            % p_c = common proportion over two groups. 
            % r = n1/n2
            pi = par1;
            r = par2;
            lambda = par3;
            p_c = pi*(r*lambda+1)/(lambda+1); 
            n = (r+1)/(r*(lambda-1)^2+pi^2)* ...
                (z_alpha*sqrt((r+1)*p_c*(1-p_c))+z_beta*sqrt(lambda*pi*(1-lambda*pi)+r*pi*(1-pi)));
            
        case 5
            % CASE: Case-control studies
            % Source: M. Woodward, "Epidemiology Study Design and
            % Analysis", Chapman & Hall, 1999, p. 354
            % A case control study typically aims to compare the disease
            % incidence or prevalence between two groups: those exposed to
            % some risk factor of interest, and those not exposed.
            % H_0: pi_1 = pi_2 
            % H_1: pi_1 / pi_2  = lambda
            % par1= Odds Ratio preliminary
            % par2= Frequency of exposure controls
            p1=(par1*par2)/((1-par2)+(par1*par2));
            P=(P1+par2)/2;
            Q=1-P;
            n=(z_alpha*sqrt(2*P*Q)+z_beta*sqrt(p1*(1-p1)+ par2*(1-par2)))^2/(p1-par2)^2;
            
            
           
%             lambda = relative risk
            
        case 6
            % CASE: Sample sizes for estimating disease prevalence in large populations
            % Source: S.N.H. Putt, A.P.M. Shaw, A.J. Woods, L. Tyler and
            % A.D. James, "Veterinary epidemiology and economics in Africa 
            % - A manual for use in the design and appraisal of livestock health policy"
            % Department of Agriculture, University of Reading, Reading,
            % Berkshire, England, 1989
            % URL: http://www.fao.org/Wairdocs/ILRI/x5436E/x5436e06.htm
            % E = standard error of the estimated prevalence
            % P = True prevalence
            % N = Total size of the population
            p = par1; 
            E = par2;
            N = par3;
            n = p*(100-p)/(E^2+p*(100-p)/N);
        case 7
            % CASE: Estimating sample size for a prevalence study. Sample sizes for low-prevalence conditions
            % Source: WHO, "Manual of Epidemiology for District Health Management", 1989, Appendiz A
            % URL: http://helid.digicollection.org/es/d/Jwho31e/18.html
            % p is the maximum expected prevalence rate in percentage
            % E is the margin of sampling error tolerated
            p = par1; 
            E = par2;            
            n = p*(100-p)/(E/z_alpha);
            
        case 8
            %CASE:Estimating sample size for a prevalence
            % Source: "Epidemiological Research Methods",1996,
            %Pag:269
            %http://books.google.com.co/books?id=qrTWpm0u07AC&pg=PA1&dq=Epidemiological+Research+Methods&hl=es&sa=X&ei=G9pAUdqSHInU9QTJroDYAQ&ved=0CC4Q6AEwAA#v=onepage&q=sample%20size&f=false
            %p  is the value of the prevalence in the study
            %E is the margin of sampling error tolerated
            %N es total population
            p=par1;
            E=par2;
            N=par3;
            no=((z_alpha)^2)*((p*(1-p))/E^2);
            n=no/(1+(no/N));
            
        case 9 
            %Case: comparison of proportions
            P=(par1+par2)/2;
            Q=1-P;
            n1=(z_alpha*sqrt(2*P*Q)+z_beta*sqrt(par1*(1-par1)+ par2*(1-par2)))^2/(par1-par2)^2;
            n=(n1/4)*(1+sqrt(1+(4/(n1*(par2-par1)))))^2;
            
        case 10
            % CASE: Case-control studies (UNBALANCED SIZES )
            % Source: M. Woodward, "Epidemiology Study Design and
            % Analysis", Chapman & Hall, 1999, p. 354
            % A case control study typically aims to compare the disease
            % incidence or prevalence between two groups: those exposed to
            % some risk factor of interest, and those not exposed.
            % H_0: pi_1 = pi_2 
            % H_1: pi_1 / pi_2  = lambda
            % par1= Odds Ratio preliminary
            % par2= Frequency of exposure controls
            % par3= number of controls per case
            p1=(par1*par2)/((1-par2)+(par1*par2));
            P=(p1+par2)/2;
            Q=1-P;
            n=(z_alpha*sqrt((par3+1)*P*Q)+z_beta*sqrt(par3*p1*(1-p1)+ par2*(1-par2)))^2/par3*(p1-par2)^2;
        case 11
            %par1=Desciacion Estandar
            %par2= es el valor mínimo de la diferencia que se desea
            %detectar = D
            n=([2*(z_beta+z_alpha)*par1]/par2)^2;
            
            
            
    end
          
    %plot(E,n,'--rs','MarkerEdgeColor','b','MarkerSize',12);
    %title('Size Sample Case 6 -Buenaventura')
    %xlabel('Margin of sampling error tolerated')
    %ylabel('n','FontName','Arial','FontSize', 14)
end

