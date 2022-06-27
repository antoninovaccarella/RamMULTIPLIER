library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
entity Usa_RAM is
  Port ( clka : IN STD_LOGIC; --segnale di clock in ingresso
         ena : IN STD_LOGIC; --segnale di abilitazione per controllare che il banco di memoria sia accessibile o meno
         wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0); --singolo bit
         addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
         dina : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
         douta : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
         mul: OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
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

component AdderTree is
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
end component;

signal v0,v1,v2,v3,v4,v5,v6,v7 : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal PP0,PP1,PP2,PP3,PP4,PP5,PP6,PP7 : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal R0,R1,R2,R3,R4,R5,R6,R7 : STD_LOGIC_VECTOR(15 DOWNTO 0); 
signal RR0, RR1, RR2, RR3, RR4, RR5, RR6, RR7 : STD_LOGIC_VECTOR(15 downto 0);
signal PP : STD_LOGIC_VECTOR(15 DOWNTO 0):=(others=>'0');

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

  MEM: blk_mem_gen_0 port map(clka, ena, wea, addra, dina, douta);
 
		   v0<= (others => douta(0));
		   PP0 <= v0 AND douta(15 downto 8);
		   R0<= ("00000000"&PP0);

		   	   
		   v1<= (others => douta(1));
		   PP1 <= v1 AND douta(15 downto 8);
		   R1<= ("0000000"&PP1& "0");
		   
						  
		   v2<= (others => douta(2));
		   PP2 <= v2 AND douta(15 downto 8);
		   R2<= ("000000" &PP2& "00");

		   v3<= (others => douta(3));
		   PP3 <= v3 AND douta(15 downto 8);
		   R3<=("00000"&PP3& "000");
                                        
		   v4<= (others => douta(4));
		   PP4 <= v4 AND douta(15 downto 8);
		   R4<= ("0000"&PP4& "0000");	   
		   
		   v5<= (others => douta(5));
		   PP5 <= v5 AND douta(15 downto 8);
		   R5<= ("000"&PP5& "00000");

		   v6<= (others => douta(6));
           PP6 <= v6 AND douta(15 downto 8);
           R6<= ("00"&PP6& "000000"); 
                 
           v7<= (others => douta(7));
           PP7 <= v7 AND douta(15 downto 8);
           R7<= ("0"&PP7& "0000000"); 

--ADDER TREE 
		  ALBERO : AdderTree
			port map(R0,R1,R2,R3,R4,R5,R6,R7,clka,Omul);
			
--Registro del risultato finale	 
          RegRis: Registro
            generic map(16)
            port map(Omul,clka,mul);
-----------------------------------------------------------	              

end Behavioral;