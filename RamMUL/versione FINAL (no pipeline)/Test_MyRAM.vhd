library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Test_MyRAM is
-- Port ( );
end Test_MyRAM;

architecture Behavioral of Test_MyRAM is

component Usa_RAM is
    port( clka : IN STD_LOGIC; --segnale di clock in ingresso
          ena : IN STD_LOGIC; --segnale di abilitazione per controllare che il banco di memoria sia accessibile o meno
          wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0); --segnale di write enable attivo alto (singolo bit)
          addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0); --indirizzo di accesso alla memoria
          dina : IN STD_LOGIC_VECTOR(15 DOWNTO 0); --dato da scrivere
          douta : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0); --dato da leggere
          mul: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)); --risultato finale
    end component;

signal Iclka : STD_LOGIC := '0'; --inizializzato a 0 poiché il clock verrà utilizzato sui fronti di salita
signal Iena : STD_LOGIC;
signal Iwea : STD_LOGIC_VECTOR(0 DOWNTO 0); --singolo bit
signal Iaddra : STD_LOGIC_VECTOR(9 DOWNTO 0);
signal Idina : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal Odouta : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal Omul : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal TestMUL : STD_LOGIC_VECTOR(15 DOWNTO 0):=(others=>'0'); --per debug: moltiplica ad alto livello

constant Tclk: time:=10ns;
constant mdepth: integer:=1024;
constant naddr: integer:=10;
constant ndata: integer:=16;
begin
CUT: Usa_RAM port map(Iclka, Iena, Iwea, Iaddra, Idina, Odouta, Omul);

process
begin --tempistica per il segnale di clock
    wait for Tclk/2;
    Iclka<=not Iclka;
end process;

AccMem: process
begin
    --write data
    wait for Tclk+100ns;
    wait until falling_edge(Iclka);
    
    Iena<='1';
    Iwea<=(others=>'1');
    for i in 0 to mdepth-1 loop
        Iaddra<=conv_std_logic_vector(i,naddr);
        Idina<=conv_std_logic_vector(i*256+i,ndata);
        wait for Tclk;
    end loop;
--------------------------------------------------
    wait for 10*Tclk; --arbitrary waiting
--------------------------------------------------
    --read data
    Iwea<=(others=>'0');
    wait for 10*Tclk;
    for i in 0 to mdepth-1 loop
        Iaddra<=conv_std_logic_vector(i,naddr);
		TestMUL<=Odouta(15 downto 8)*Odouta(7 downto 0); --per debug
        wait for Tclk;
    end loop;
end process;
end Behavioral;