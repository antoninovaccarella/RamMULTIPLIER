library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
entity Usa_RAM is
  Port ( clka : IN STD_LOGIC; --segnale di clock in ingresso
         ena : IN STD_LOGIC; --segnale di abilitazione per controllare che il banco di memoria sia accessibile o meno
         wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0); --segnale di write enable attivo alto (singolo bit)
         addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0); --indirizzo di accesso alla memoria
         dina : IN STD_LOGIC_VECTOR(15 DOWNTO 0); --dato da scrivere
         douta : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0); --dato da leggere
         mul: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)); --risultato finale
end Usa_RAM;

architecture Behavioral of Usa_RAM is

component blk_mem_gen_0 is
    Port ( clka : IN STD_LOGIC;
           ena : IN STD_LOGIC;
           wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
           addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
           dina : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
           douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
end component;

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


signal v0,v1,v2,v3,v4,v5,v6,v7 : STD_LOGIC_VECTOR(7 DOWNTO 0); --estensione dell'i-esimo bit di LSB
signal PP0,PP1,PP2,PP3,PP4,PP5,PP6,PP7 : STD_LOGIC_VECTOR(7 DOWNTO 0); --moltiplicazione tra v(i) e MSB
signal R0,R1,R2,R3,R4,R5,R6,R7 : STD_LOGIC_VECTOR(15 DOWNTO 0);--somme parziali dopo l'operazione di shift

--ADDER TREE
signal sp0,vr0,sp1,vr1: STD_LOGIC_VECTOR(15 downto 0); --primo livello dell'AdderTree
signal sp2,vr2,sp3,vr3: STD_LOGIC_VECTOR(15 downto 0); --secondo livello dell'AdderTree
signal sp4,vr4: STD_LOGIC_VECTOR(15 downto 0); ---terzo livello dell'AdderTree
signal sp5, vr5: STD_LOGIC_VECTOR(15 downto 0); --quarto livello dell'AdderTree
signal Omul : STD_LOGIC_VECTOR(15 downto 0); --quinto livello dell'AdderTree

begin

  MEM: blk_mem_gen_0 port map(clka, ena, wea, addra, dina, douta);
 
		   v0<= (others => douta(0)); --il bit in posizione 0 di LSB viene esteso a 8 bit
		   PP0 <= v0 AND douta(15 downto 8); --v0 * MSB
		   R0<= ("00000000"&PP0); --shift della somma parziale
				   
		   v1<= (others => douta(1)); --il bit in posizione 1 di LSB viene esteso a 8 bit
		   PP1 <= v1 AND douta(15 downto 8); --v1 * MSB
		   R1<= ("0000000"&PP1& "0"); --shift della somma parziale
		   
						  
		   v2<= (others => douta(2)); --il bit in posizione 2 di LSB viene esteso a 8 bit
		   PP2 <= v2 AND douta(15 downto 8); --v2 * MSB
		   R2<= ("000000" &PP2& "00"); --shift della somma parziale

		   v3<= (others => douta(3)); --il bit in posizione 3 di LSB viene esteso a 8 bit
		   PP3 <= v3 AND douta(15 downto 8); --v3 * MSB
		   R3<=("00000"&PP3& "000"); --shift della somma parziale
														
		   v4<= (others => douta(4)); --il bit in posizione 4 di LSB viene esteso a 8 bit
		   PP4 <= v4 AND douta(15 downto 8); --v4 * MSB
		   R4<= ("0000"&PP4& "0000"); --shift della somma parziale
		   
		   
		   v5<= (others => douta(5)); --il bit in posizione 5 di LSB viene esteso a 8 bit
		   PP5 <= v5 AND douta(15 downto 8); --v5 * MSB
		   R5<= ("000"&PP5& "00000"); --shift della somma parziale
		   
		   v6<= (others => douta(6)); --il bit in posizione 6 di LSB viene esteso a 8 bit
           PP6 <= v6 AND douta(15 downto 8); --v6 * MSB
           R6<= ("00"&PP6& "000000"); --shift della somma parziale
                          
           v7<= (others => douta(7)); --il bit in posizione 7 di LSB viene esteso a 8 bit
           PP7 <= v7 AND douta(15 downto 8); --v7 * MSB
           R7<= ("0"&PP7& "0000000"); --shift della somma parziale
           
                                                                    --ADDER TREE 
--------------------------------------------------------------------------------------------------------------	    	   	   
--PRIMO LIVELLO    
           CS0: CarrySave            
             generic map(16)
             port map(R0,R1,R2,sp0,vr0); 

		   CS1: CarrySave            
		      generic map(16)
		      port map(R3,R4,R5,sp1,vr1); 			  
--------------------------------------------------------------------------------------------------------------	    	   	   
--SECONDO LIVELLO
		   CS2: CarrySave  
		      generic map(16)
		      port map(sp0,vr0,sp1,sp2,vr2); 
		   
		   CS3: CarrySave   
             generic map(16)
             port map(vr1,R6,R7,sp3,vr3); 
--------------------------------------------------------------------------------------------------------------	    	   	   
--TERZO LIVELLO
           CS4: CarrySave
              generic map(16)
              port map(sp2,vr2,sp3,sp4,vr4);
--------------------------------------------------------------------------------------------------------------	    	   	   
-- QUARTO LIVELLO
		  CS5: CarrySave
            generic map(16)
            port map(sp4,vr4,vr3,sp5,vr5);
--------------------------------------------------------------------------------------------------------------	    	   	   
--QUINTO LIVELLO
           Omul<= sp5+vr5;
          RegRis: Registro
            generic map(16)
            port map(Omul,clka,mul);
--------------------------------------------------------------------------------------------------------------	    	   	   

end Behavioral;