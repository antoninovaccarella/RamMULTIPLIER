library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity AdderTree is
    Port ( A : in STD_LOGIC_VECTOR(15 downto 0);
           B : in STD_LOGIC_VECTOR(15 downto 0);
           C : in STD_LOGIC_VECTOR(15 downto 0);
           D : in STD_LOGIC_VECTOR(15 downto 0);
           E : in STD_LOGIC_VECTOR(15 downto 0);
           F : in STD_LOGIC_VECTOR(15 downto 0);
           G : in STD_LOGIC_VECTOR(15 downto 0);
           H : in STD_LOGIC_VECTOR(15 downto 0);
           clk : in STD_LOGIC;
           Prod : out STD_LOGIC_VECTOR(15 downto 0));
end AdderTree;

architecture Behavioral of AdderTree is

component Registro is
    generic(nb:integer);
    Port ( D : in STD_LOGIC_VECTOR(nb-1 downto 0); --ingresso del registro
           clk : in STD_LOGIC; --segnale di clock
           Q : out STD_LOGIC_VECTOR(nb-1 downto 0)); --uscita del registro
end component;

component CarrySave is
    generic (nb:integer);
    Port (   A : in STD_LOGIC_VECTOR(nb-1 downto 0); --ingresso A
             B : in STD_LOGIC_VECTOR(nb-1 downto 0); --ingresso B
             C : in STD_LOGIC_VECTOR(nb-1 downto 0); --ingresso C
             SP : out STD_LOGIC_VECTOR(nb-1 downto 0); --somma SP tra A, B e C
             VR : out STD_LOGIC_VECTOR(nb-1 downto 0)); --vettore di riporto
end component;

--Registri operandi
signal RA, RB, RC, RD, RE, RF, RG, RH : STD_LOGIC_VECTOR(15 downto 0);

--CarrySave
signal sp0,vr0,sp1,vr1: STD_LOGIC_VECTOR(15 downto 0); --CS del primo livello
signal Rsp0,Rvr0,Rsp1,Rvr1: STD_LOGIC_VECTOR(15 downto 0); --Registri del primo livello
signal sp2,vr2,sp3,vr3: STD_LOGIC_VECTOR(15 downto 0); --CS del secondo livello
signal Rsp2,Rvr2,Rsp3,Rvr3: STD_LOGIC_VECTOR(15 downto 0);  --Registri del secondo livello
signal sp4,vr4: STD_LOGIC_VECTOR(15 downto 0); --CS del terzo livello
signal Rsp4,Rvr4: STD_LOGIC_VECTOR(15 downto 0); --Registri del terzo livello
signal sp5, vr5: STD_LOGIC_VECTOR(15 downto 0); --CS del quarto livello
signal Rsp5, Rvr5: STD_LOGIC_VECTOR(15 downto 0); --Registri del quarto livello
signal Omul : STD_LOGIC_VECTOR(15 downto 0); --RIS FINALE



begin
 
		   RegRA : Registro
		       generic map(16)
		       port map(A,clk,RA);

		   RegRB : Registro
               generic map(16)
               port map(B,clk,RB);

           RegRC : Registro
               generic map(16)
               port map(C,clk,RC);

           RegRD : Registro
               generic map(16)
               port map(D,clk,RD);
                                                                                	   
           RegRE : Registro
               generic map(16)
               port map(E,clk,RE);		   
		     
		   RegRF: Registro
               generic map(16)
               port map(F,clk,RF);

           RegRG : Registro
               generic map(16)
               port map(G,clk,RG);  
                 
		   RegRH : Registro
               generic map(16)
               port map(H,clk,RH);
           
           
                                                            --ADDER TREE 
-----------------------------------------------------------	    	   	   
--PRIMO LIVELLO    
           CS0: CarrySave            
             generic map(16)
             port map(RA,RB,RC,sp0,vr0); 
           
           RegSP0 : Registro
             generic map(16)
             port map(sp0,clk,Rsp0);
               
           RegVR0 : Registro
             generic map(16)
             port map(vr0, clk, Rvr0);

		   CS1: CarrySave            
		      generic map(16)
		      port map(RD,RE,RF,sp1,vr1); 
		      
		   RegSP1 : Registro
              generic map(16)
              port map(sp1,clk,Rsp1);
                             
           RegVR1 : Registro
              generic map(16)
              port map(vr1, clk, Rvr1);			  
-----------------------------------------------------------	    	 
--SECONDO LIVELLO
		   CS2: CarrySave  
		      generic map(16)
		      port map(Rsp0,Rvr0,Rsp1,sp2,vr2); 
			  
		   RegSP2 : Registro
              generic map(16)
              port map(sp2,clk,Rsp2);
                             
           RegVR2 : Registro
              generic map(16)
              port map(vr2, clk, Rvr2);
		   
		   CS3: CarrySave   
             generic map(16)
             port map(Rvr1,RG,RH,sp3,vr3); 
		   
		   RegSP3 : Registro
              generic map(16)
              port map(sp3,clk,Rsp3);
                             
           RegVR3 : Registro
              generic map(16)
              port map(vr3, clk, Rvr3);
-----------------------------------------------------------	    	        
--TERZO LIVELLO
           CS4: CarrySave
              generic map(16)
              port map(Rsp2,Rvr2,Rsp3,sp4,vr4);
		    
		   RegSP4 : Registro
              generic map(16)
              port map(sp4,clk,Rsp4);
                             
           RegVR4 : Registro
              generic map(16)
              port map(vr4, clk, Rvr4);
-----------------------------------------------------------	    	              
-- QUARTO LIVELLO
		  CS5: CarrySave
            generic map(16)
            port map(Rsp4,Rvr4,Rvr3,sp5,vr5);
			
	      RegSP5 : Registro
              generic map(16)
              port map(sp5,clk,Rsp5);
                             
           RegVR5 : Registro
              generic map(16)
              port map(vr5, clk, Rvr5);
-----------------------------------------------------------	               
--QUINTO LIVELLO
           Prod<= Rsp5+Rvr5;
-----------------------------------------------------------	              


end Behavioral;
